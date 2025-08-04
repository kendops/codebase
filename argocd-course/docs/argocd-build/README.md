          orgs:
          - name: orgname    # Name of the organization in Github
            teams:           # The list of authorized teams (optional)
            - devops
            - devops/seniors
            - devops/juniors  

https://www.studytonight.com/post/how-to-list-all-resources-in-a-kubernetes-namespace
## kubectl get all  -n argocd

data:
  url: http://argo.kendopz.com
  statusbadge.enabled: "true"
  admin.enabled: "true"
  accounts.admin.passwordMtime: Redhat123
  accounts.swilliams: login
  accounts.swilliams.enabled: "true"
  accounts.swilliams.passwordMtime: Redhat1234
  users.anonymous.enabled: "true"
  resource.compareoptions: |
    ignoreAggregatedRoles: true
    
- Dashboard: http://argo.kendopz.com

Argo CD has two predefined roles:

role:readonly — read-only access to all resources
role:admin — unrestricted access to all resources

https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/argocd-repo-creds.yaml
https://dexidp.io/docs/connectors/gitlab/
https://dexidp.io/docs/connectors/github/
https://dexidp.io/docs/connectors/ldap/
https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/keycloak/

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  policy.default: role:readonly
  policy.csv: |
    g, github-organization-name:devops-argo-org, role:admin
    g, github-organization-name:devops/seniors, role:org-admin
    p, role:argocd_users, applications, *, */*, allow
    p, role:argocd_users, clusters, get, *, allow
    p, role:argocd_users, repositories, get, *, allow
    p, role:argocd_users, repositories, create, *, allow
    p, role:argocd_users, repositories, update, *, allow
    p, role:argocd_users, repositories, delete, *, allow
    g, argocd_admin, role:admin

------------------------------------
# Manage users
argocd account list
argocd account get --account <username>

# if you are managing users as the admin user, <current-user-password> should be the current admin password.
argocd account update-password \
  --account <name> \
  --current-password <current-user-password> \
  --new-password <new-user-password>

---------------------------------
1a. New users should be defined in argocd-cm ConfigMap:

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
data:
  # add an additional local user with apiKey and login capabilities
  #   apiKey - allows generating API keys
  #   login - allows to login using UI
  accounts.alice: apiKey, login
  # disables user. User is enabled by default
  accounts.alice.enabled: "false"
# https://github.com/argoproj/argo-cd/blob/master/assets/builtin-policy.csv

0. Integrate Okta and Argo CD

Create Argo application in Okta account
1. Create okta account if you don’t have

https://developer.okta.com/login/

1b. Disable admin user

As soon as additional users are created it is recommended to disable admin user:

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
  labels:
    app.kubernetes.io/name: argocd-cm
    app.kubernetes.io/part-of: argocd
data:
  admin.enabled: "false"


2. Configure Argo CD for SSO
Edit the argocd-cm configmap:
kubectl edit configmap argocd-cm -n argocd

data:
  url: https://argocd.example.com

  dex.config: |
    connectors:
      # GitHub example
      - type: github
        id: github
        name: GitHub
        config:
          clientID: aabbccddeeff00112233
          clientSecret: $dex.github.clientSecret # Alternatively $<some_K8S_secret>:dex.github.clientSecret
          orgs:
          - name: your-github-org

3. OIDC Configuration with DEX¶

data:
  url: "https://argocd.example.com"
  dex.config: |
    connectors:
      # OIDC
      - type: oidc
        id: oidc
        name: OIDC
        config:
          issuer: https://example-OIDC-provider.com
          clientID: aaaabbbbccccddddeee
          clientSecret: $dex.oidc.clientSecret

# Requesting additional ID token claims

data:
  url: "https://argocd.example.com"
  dex.config: |
    connectors:
      # OIDC
      - type: OIDC
        id: oidc
        name: OIDC
        config:
          issuer: https://example-OIDC-provider.com
          clientID: aaaabbbbccccddddeee
          clientSecret: $dex.oidc.clientSecret
          insecureEnableGroups: true
          scopes:
          - profile
          - email
          - groups

4. Keycloak
Integrating Keycloak and ArgoCD
https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/keycloak/

Configuring ArgoCD OIDC¶
Let's start by storing the client secret you generated earlier in the argocd secret argocd-secret.

    First you'll need to encode the client secret in base64: $ echo -n '83083958-8ec6-47b0-a411-a8c55381fbd2' | base64
    Then you can edit the secret and add the base64 value to a new key called oidc.keycloak.clientSecret using $ kubectl edit secret argocd-secret.

Your Secret should look something like this:

apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
data:
  ...
  oidc.keycloak.clientSecret: ODMwODM5NTgtOGVjNi00N2IwLWE0MTEtYThjNTUzODFmYmQy   
  ...

Now we can configure the config map and add the oidc configuration to enable our keycloak authentication. You can use $ kubectl edit configmap argocd-cm.
Your ConfigMap should look like this:

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  url: https://argocd.example.com
  oidc.config: |
    name: Keycloak
    issuer: https://keycloak.example.com/realms/master
    clientID: argocd
    clientSecret: $oidc.keycloak.clientSecret
    requestedScopes: ["openid", "profile", "email", "groups"]

Make sure that:

    issuer ends with the correct realm (in this example master)
    issuer on Keycloak releases older than version 17 the URL must include /auth (in this example /auth/realms/master)
    clientID is set to the Client ID you configured in Keycloak
    clientSecret points to the right key you created in the argocd-secret Secret
    requestedScopes contains the groups claim if you didn't add it to the Default scopes

Configuring ArgoCD Policy¶

Now that we have an authentication that provides groups we want to apply a policy to these groups. We can modify the argocd-rbac-cm ConfigMap using $ kubectl edit configmap argocd-rbac-cm.

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  policy.csv: |
    g, ArgoCDAdmins, role:admin

In this example we give the role role:admin to all users in the group ArgoCDAdmins.
Login

You can now login using our new Keycloak OIDC authentication:


------------------------------------------------------------------

echo -n 'mqmMPK3zrsWIaq5VmrcLFC9HbG6iAyZG' | base64


apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
data:
  ...
  oidc.keycloak.clientSecret: bXFtTVBLM3pyc1dJYXE1Vm1yY0xGQzlIYkc2aUF5Wkc=   
  ...


kubectl edit configmap argocd-rbac-cm


---------------------------------------------------------------
# # https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/okta/#oidc-without-dex

# oidc.config: |
#   name: Okta
#   issuer: https://yourorganization.oktapreview.com
#   clientID: 0oaltaqg3oAIf2NOa0h3
#   clientSecret: ZXF_CfUc-rtwNfzFecGquzdeJ_MxM4sGc8pDT2Tg6t
#   requestedScopes: ["openid", "profile", "email", "groups"]
#   requestedIDTokenClaims: {"groups": {"essential": true}}



argocd repo add https://github.com/argoproj/argocd-example-apps --username <username> --password <password>
argocd repo add git@github.com:argoproj/argocd-example-apps.git --ssh-private-key-path ~/.ssh/id_rsa

# Managing TLS certificates using the CLI¶
argocd cert list --cert-type https
argocd repo add --insecure-skip-server-verification https://git.example.com/test-repo

argocd cert add-tls git.example.com --from ~/myca-cert.pem
argocd repo add https://git.example.com/test-repo
argocd cert list --cert-type ssh

Examples¶

  # Add a Git repository via SSH using a private key for authentication, ignoring the server's host key:
  argocd repo add git@git.example.com:repos/repo --insecure-ignore-host-key --ssh-private-key-path ~/id_rsa

  # Add a Git repository via SSH on a non-default port - need to use ssh:// style URLs here
  argocd repo add ssh://git@git.example.com:2222/repos/repo --ssh-private-key-path ~/id_rsa

  # Add a private Git repository via HTTPS using username/password and TLS client certificates:
  argocd repo add https://git.example.com/repos/repo --username git --password secret --tls-client-cert-path ~/mycert.crt --tls-client-cert-key-path ~/mycert.key

  # Add a private Git repository via HTTPS using username/password without verifying the server's TLS certificate
  argocd repo add https://git.example.com/repos/repo --username git --password secret --insecure-skip-server-verification

  # Add a public Helm repository named 'stable' via HTTPS
  argocd repo add https://charts.helm.sh/stable --type helm --name stable  

  # Add a private Helm repository named 'stable' via HTTPS
  argocd repo add https://charts.helm.sh/stable --type helm --name stable --username test --password test

  # Add a private Helm OCI-based repository named 'stable' via HTTPS
  argocd repo add helm-oci-registry.cn-zhangjiakou.cr.aliyuncs.com --type helm --name stable --enable-oci --username test --password test

## Configure Keycloak with terraform

https://medium.com/@charled.breteche/kind-keycloak-and-argocd-with-sso-9f3536dd7f61


## Steps to integrate Okta and Argo CD
## Enabling SSO Authentication in ArgoCD using Okta Integration

1. Create an application in your Okta account

2. Generate the SSO Url and X.509 certificates 

3. Make changes to configmap of argocd server 

4. Access Argo UI with Okta sign on

Create Argo application in Okta account
1. Create okta account if you don’t have
https://developer.okta.com/login/
https://www.opsmx.com/blog/enabling-sso-authentication-in-argocd-using-okta-integration/

Metadata URL:
https://trial-4272173.okta.com/app/exk793buf9cAmdINz697/sso/saml/metadata

Sign on URL: 
https://trial-4272173.okta.com/app/trial-4272173_argoapp_1/exk793buf9cAmdINz697/sso/saml

Sign out URL:
https://trial-4272173.okta.com

Issuer:
http://www.okta.com/exk793buf9cAmdINz697

3. Encode the ca file using  command line (ignore if you have done encoding the certificate)
# base64 okta.cert -w 0
https://www.base64encode.org/

ArgoCD CLI login
To use CLI with SSO, just add the  --sso option, and in the --username – specify your Okta’s login:
$ argocd login dev-1-18.argocd.example.com --sso --username solomon@solyspace.tech

kubectl logs -f pod/argocd-dex-server-656fd99f5-wr62f -n argocd

To login via CLI 
argocd login argo.kendopz.com --sso --username solomon@solyspace.tech

----------------------------------------------------------------------------

Connect Okta Groups to Argo CD Roles
Argo CD is aware of user memberships of Okta groups that match the Group Attribute Statements regex. The example above uses the argocd-.* regex, so Argo CD would be aware of a group named argocd-admin.

kubectl edit cm/argocd-rbac-cm -n argocd
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.csv: |
    p, role:readonly, applications, get, */*, allow
    p, role:readonly, certificates, get, *, allow
    p, role:readonly, clusters, get, *, allow
    p, role:readonly, repositories, get, *, allow
    p, role:readonly, projects, get, *, allow
    p, role:readonly, accounts, get, *, allow
    p, role:readonly, gpgkeys, get, *, allow

    p, role:admin, applications, create, */*, allow
    p, role:admin, applications, update, */*, allow
    p, role:admin, applications, delete, */*, allow
    p, role:admin, applications, sync, */*, allow
    p, role:admin, applications, override, */*, allow
    p, role:admin, applications, action/*, */*, allow
    p, role:admin, certificates, create, *, allow
    p, role:admin, certificates, update, *, allow
    p, role:admin, certificates, delete, *, allow
    p, role:admin, clusters, create, *, allow
    p, role:admin, clusters, update, *, allow
    p, role:admin, clusters, delete, *, allow
    p, role:admin, repositories, create, *, allow
    p, role:admin, repositories, update, *, allow
    p, role:admin, repositories, delete, *, allow
    p, role:admin, projects, create, *, allow
    p, role:admin, projects, update, *, allow
    p, role:admin, projects, delete, *, allow
    p, role:admin, accounts, update, *, allow
    p, role:admin, gpgkeys, create, *, allow
    p, role:admin, gpgkeys, delete, *, allow

    g, argocd-readonly, role:readonly
    g, argocd-admin, role:admin
  policy.default: role:readonly
  scopes: '[groups]'


...
data:
  admin.enabled: "false"
  policy.csv: |
    p, role:backend-app-admin, applications, *, Backend/*, allow
    p, role:web-app-admin, applications, *, Web/*, allow
    g, DevOps, role:admin
  policy.default: role:''
  scopes: '[email,groups]'
...

----------------

        userSearch:
          baseDN: "ou=users,dc=kendopz,dc=com"
          filter: ""
          username: sAMAccountName
          idAttr: distinguishedName
          emailAttr: mail
          nameAttr: displayName
        # Ldap group serch attributes
        groupSearch:
          baseDN: "ou=users,dc=kendopz,dc=com"
          filter: ""
          userAttr: distinguishedName
          groupAttr: member
          nameAttr: name

Original 
#########################          

      ### Active Directory Auth
      - type: ldap
        name: ActiveDirectory
        id: ad
        config:
          host: txaddc01.kendopz.com:636

          insecureNoSSL: false
          insecureSkipVerify: true

          bindDN: CN=VMADMIN,CN=Users,DC=kendopz,DC=com
          bindPW: Password1

          usernamePrompt: Email Address

          userSearch:
            baseDN: cn=Users,dc=kendopz,dc=com
            filter: "(objectClass=person)"
            username: userPrincipalName
            idAttr: DN
            emailAttr: userPrincipalName
            nameAttr: cn

          groupSearch:
            baseDN: CN=VMADMIN,CN=Users,DC=kendopz,DC=com
            filter: "(objectClass=group)"
            userMatchers:
            - userAttr: DN
              groupAttr: member
            nameAttr: cn


---------------------------


customresourcedefinition.apiextensions.k8s.io/applications.argoproj.io unchanged
customresourcedefinition.apiextensions.k8s.io/applicationsets.argoproj.io unchanged

## Remove the CRDs
Method 2: Remove the CRDs
kubectl delete crds --all

Method 3: Delete the Namespace
kubectl delete ns my-random-namespace
kubectl create ns my-random-namespace

Method 4: Only Delete Selected Custom Resources in One Specific Namespace
kubectl get crd | grep stackable | perl -anle 'print $F[0]' | xargs -I {} kubectl --namespace argocd delete {} --all
kubectl --namespace my-random-namespace delete crd-name-1 --all
kubectl get crd



##################

mkdir ssl
cat > ssl/req.cnf << EOF
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = argo.kendopz.com
EOF

openssl genrsa -out ssl/ca-key.pem 2048
openssl req -x509 -new -nodes -key ssl/ca-key.pem -days 10 -out ssl/ca.pem -subj "/CN=kube-ca"

openssl genrsa -out ssl/key.pem 2048
openssl req -new -key ssl/key.pem -out ssl/csr.pem -subj "/CN=kube-ca" -config ssl/req.cnf
openssl x509 -req -in ssl/csr.pem -CA ssl/ca.pem -CAkey ssl/ca-key.pem -CAcreateserial -out ssl/cert.pem -days 10 -extensions v3_req -extfile ssl/req.cnf


kubectl create -n argocd secret tls argocd-server-tls \
  --cert=/path/to/cert.pem \
  --key=/path/to/key.pem

  