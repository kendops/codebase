Keycloak 
1. argo - https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/user-management/keycloak.md / https://www.youtube.com/watch?v=kMPikjvdKXg
2. rancher - https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config/configure-keycloak-oidc
3. gitlab 

kubectl get configmap -n argocd

HA:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.6.7/manifests/ha/install.yaml

HA:
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.7.0-rc1/manifests/ha/install.yaml

# Fetch all assigned metallb ips 
k get svc --all-namespaces --no-headers | awk '{print $5}' | grep -v none
k get po -n argocd 
sso: 
  provider: keycloak 

# Manage user
argocd account list

# Set user password
argocd account update-password \
  --account user
  --current-password K4dPkR6vR6 \
  --new-password Redhat123
K4dPkR6vR6


kubectl get configmap -n argocd
k get po -n argocd 

# Integrating Keycloak and ArgoCD
==================================================================

1. First you'll need to encode the client secret in base64
echo -n Redhat123' | base64

2. Then you can edit the secret and add the base64 value to a new key called oidc.keycloak.clientSecret
kubectl edit secret argocd-secret.

apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
data:
  ...
  oidc.keycloak.clientSecret: ODMwODM5NTgtOGVjNi00N2IwLWE0MTEtYThjNTUzODFmYmQy   
  ...

3. Configuring ArgoCD Policy
kubectl edit configmap argocd-rbac-cm

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  url: https://argocd.kenkopz.com
  oidc.config: |
    name: Keycloak
    issuer: http://172.29.0.223/realms/argo/account
    clientID: argo
    clientSecret: $oidc.keycloak.clientSecret
    requestedScopes: ["openid", "profile", "email", "groups"]

4. Configuring ArgoCD Policy
kubectl edit configmap argocd-rbac-cm.

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
data:
  policy.csv: |
    g, swilliams, role:admin
    g, solomon.williams, role:admin
    g, vmadmin, role:admin
    g, ArgoCDAdmins, role:admin


=======================================================
3/29/2023 

eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI3ZjJjNDNkMS0zZjY2LTRiN2MtOWE1Ny0wZDliYmU2MzU0YjEifQ.eyJleHAiOjE2ODAyMjc2NTIsImlhdCI6MTY4MDE0MTI1MiwianRpIjoiMGYwMDg5YzctOGZhMS00Yzg3LTk3NjMtMThmNDE0NmI3ZjcxIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrLmtlbmRvcHouY29tL3JlYWxtcy9hcmdvY2QiLCJhdWQiOiJodHRwOi8va2V5Y2xvYWsua2VuZG9wei5jb20vcmVhbG1zL2FyZ29jZCIsInR5cCI6IkluaXRpYWxBY2Nlc3NUb2tlbiJ9.IBX8ZJApU5enSSKvfK9GuuqlIVzaBO1-gq9F1LQA9Jk
0f0089c7-8fa1-4c87-9763-18f4146b7f71

dev 
argo_url: http://172.29.0.222/
username: admin
password: Redhat123 

----
helm pull bitnami/jupyterhub --untar                                           
helm install jupyterhub ./jupyterhub --namespace jupyterhub --create-namespace
kubectl get svc --namespace jupyterhub -w jupyterhub-proxy-public 

helm uninstall jupyterhub  --namespace jupyterhub; kubectl delete ns jupyterhub

  export SERVICE_IP=$(kubectl get svc --namespace jupyterhub jupyterhub-proxy-public --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
  echo "jupyterHub url: http://$SERVICE_IP/"
  echo admin user: user
  echo Password: $(kubectl get secret --namespace jupyterhub jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}')

keycloak
---------------------------------
helm pull bitnami/keycloak --untar                                           
helm install keycloak ./keycloak --namespace keycloak --create-namespace
kubectl get svc --namespace keycloak

  echo Username: user
  echo Password: $(kubectl get secret --namespace keycloak keycloak -o jsonpath="{.data.admin-password}" | base64 -d)
  export HTTP_SERVICE_PORT=$(kubectl get --namespace keycloak -o jsonpath="{.spec.ports[?(@.name=='http')].port}" services keycloak)

kubectl uninstall keycloak -n keycloak; kubectl delete ns keycloak

vwcDNwF3Gn7IQDxj

test 
argourl: http://172.29.0.247/
username: admin
password: RiHLHqexlnuBZm6i

#!/bin/bash

    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1
    export argourl=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | grep -v none)
    echo "argourl: http://$argourl/"
    echo username: "admin"
    echo password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

https://www.linkedin.com/pulse/automating-kubernetes-cluster-cicd-setup-terraform-argo-stephen-kuntz/

-------------------------------------------------------
# argocd login
argocd login argod1.kendopz.com --username admin --password qSV1JNovOd3DFXlg --insecure
argocd logout argod1.kendopz.com

#  Register A Cluster To Deploy Apps To (Optional)
use-context infra
argocd cluster add infra --insecure 
argocd cluster add infra 
argocd cluster list
argocd cluster rm

argocd proj create infra -d https://172.29.0.22:6443, * -s git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git

argocd proj edit infra
argocd proj get infra
argocd proj list infra


# Change the password using the command:
argocd account update-password

# First list all clusters contexts in your current kubeconfig:
kubectl config get-contexts -o name

#  Create An Application From A Git Repository

# Creating Apps Via CLI
First we need to set the current namespace to argocd running the following command:
kubectl config set-context --current --namespace=argocd
argocd app get guestbook
argocd app sync guestbook


# Create the example guestbook application with the following command:
https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app/
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default


Let’s push this now to our Git repo.

$ git add .
$ git commit -sam "updated configmap to version v1.2"
$ git push

Now that that’s pushed into Git, let’s have Argo CD sync our Application.
$ argocd app sync myapp

# Using Argo CD with Kustomize to create apps 
----------------------------------------------------------------------------------
# first app created by argo..

# Now, let’s create the application. Therefore, I am using the same example that I have used in the UI demo but with the different application name
https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app_set/
argocd app create [app-name] --project [name] --repo [git repo URL] --path [app folder] --dest-namespace [namespace] --dest-server [server URL]

-------------

cat namespace.yaml

apiVersion: v1
kind: Namespace
metadata:
  name: ldap
  labels:
    name: dev

----------------------------------


argocd app create argo-config-wordpress \
--repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
--path wordpress-1 \
--dest-namespace default \
--dest-server https://172.29.0.88:6443 \
--self-heal \
--project dev \
--sync-policy automated \
--sync-retry-limit 5 \
--revision main

argocd app create argo-config-ldap \
--repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
--path ldap/overlays/staging/ \
--dest-namespace default \
--dest-server https://172.29.0.22:6443 \
--self-heal \
--project dev \
--sync-policy automated \
--sync-retry-limit 5 \
--revision main

argocd app create argo-config-ldap \
--repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
--path ldap/base \
--dest-namespace ldap \
--dest-server https://172.29.0.22:6443 \
--self-heal \
--project infra \
--sync-policy automated \
--sync-retry-limit 5 \
--revision main

kustomize build ldap/overlays/staging |\
  kubectl apply -f -

osixia/openldap:1.1.11 
osixia/phpldapadmin:0.9.0

argocd app create argo-config-ingress-nginx \
--repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
--path ingress-nginx \
--dest-namespace ingress-nginx \
--dest-server https://172.29.0.88:6443 \
--project dev \
--self-heal \
--sync-policy automated \
--sync-retry-limit 5 \
--revision main

argocd app create argo-config-cert-manager \
--repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
--path cert-manager \
--dest-namespace cert-manager \
--dest-server https://172.29.0.88:6443 \
--project dev \
--self-heal \
--sync-policy automated \
--sync-retry-limit 5 \
--revision main

argocd app create argo-config-monitoring \
--repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
--path monitoring-1 \
--dest-namespace monitoring \
--dest-server https://172.29.0.22:6443 \
--self-heal \
--project infra \
--sync-policy automated \
--sync-retry-limit 5 \
--revision main


https://github.com/argoproj/argo-cd/tree/master/docs/operator-manual

kubectl get pods 
kubectl get svc 
argocd app sync wordpress
argocd app sync ldap
argocd app sync ingress-nginx


# let’s check the list of apps and the information of a particular app
argocd app list

# argocd app get [app-name]
argocd app get demo1

# Clone the repository and Create a YAML file

# 1. change context o argocd cluster 
use-context argo
-----------------------------------------------------------------------------------------

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: argo-application
  namespace: argocd
spec:
  project: wordpress
  source:
    repoURL: git@172.29.0.37:k8s-dev-team/argo-proj.git
    targetRevision: HEAD
    path: wordpress-1
  destination: 
    server: https://172.29.0.88:6443
    namespace: default
  syncPolicy:
    syncOptions:
    - CreateNamespace=false
    automated:
      selfHeal: true
      prune: true

argocd-app-config


# Now, apply this YAML using
kubectl apply -f [yaml file name]
kubectl apply -f wordpress-1.yaml
argocd app list 

# App Deletion
# Apps can be deleted with or without a cascade option. 
# A cascade delete, deletes both the app and its resources, rather than only the app.

# To perform a non-cascade delete:
argocd app delete APPNAME --cascade=false

#To perform a cascade delete:
argocd app delete APPNAME --cascade

argocd app delete argocd/wordpress --cascade
argocd app sync wordpress


or
argocd app delete APPNAME

# Deletion Using kubectl¶
To perform a non-cascade delete, make sure the finalizer is unset and then delete the app:


kubectl patch app APPNAME  -p '{"metadata": {"finalizers": null}}' --type merge
kubectl delete app APPNAME

# To perform a cascade delete set the finalizer, e.g. using kubectl patch:
kubectl patch app APPNAME  -p '{"metadata": {"finalizers": ["resources-finalizer.argocd.argoproj.io"]}}' --type merge
kubectl delete app APPNAME
About The Deletion Finalizer

metadata:
  finalizers:
    - resources-finalizer.argocd.argoproj.io

# KEY POINTS
___________________________________________
app-name- is the name you want to give your app(like demo1)
project- is the name of the project created or default
app folder- the path to the configuration for the application in the repository
git repo- it is the URL of the git repository where the configuration file is located
dest-namespace- the name of the target namespace in the cluster where the application is deployed
server URL- use https://kubernetes.default.svc to reference the same cluster where ArgoCD has been deployed

~/scripts/argo-ui.sh 
argourl: http://172.29.0.181/
username: admin
password: agdiMigz7qTwD0UF


----------------------------------------------------------------------------------
.
├── base
└── overlays
    └── dev
    └── stage
    └── prod


# add project, repo to a specific cluster
argocd proj create wordpress -d https://infra-master01.kendopz.com:6443,default -s git@gitlab1.kendopz.com:k8s-dev-team/argo-proj.git
argocd proj create wordpress -d https://infra-master01.kendopz.com:6443,default -s git@gitlab1.kendopz.com:k8s-dev-team/argo-proj.git

argocd proj create infra -d https://172.29.0.22:6443, * -s git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git

argocd repo add git@gitlab1.kendopz.com:swilliams/infra-proj.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa
argocd repo add git@gitlab1.kendopz.com:swilliams/argo-deploy.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa
argocd repo add git@172.29.0.37:k8s-dev-team/argocd-app-config.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa


argocd repo add git@github.com:kendops/wordpress.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa

-----------

(env) ?130 ~  get-contexts 
+ kubectl config get-contexts
CURRENT   NAME           CLUSTER        AUTHINFO       NAMESPACE
          argo           argo           argo
*         blockchain     blockchain     blockchain
          infra            infra            infra
          default        default        default
          dev            dev            dev
          dev-rancher    dev-rancher    dev-rancher
          infra          infra          infra
          nprod          nprod          nprod
          prod-rancher   prod-rancher   prod-rancher
          prod1          prod1          prod1
          test           test           test

(env) √ ~   ➤ argocd cluster add  default
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `default` with full cluster level privileges. Do you want to continue [y/N]? y
INFO[0002] ServiceAccount "argocd-manager" already exists in namespace "kube-system" 
INFO[0002] ClusterRole "argocd-manager-role" updated    
INFO[0002] ClusterRoleBinding "argocd-manager-role-binding" updated 
Cluster 'https://172.29.0.88:6443' added

----------------------------

kubectl get deployments,services --context argocd -n argocd
kubectl config get-contexts -o name
argocd cluster add docker-desktop

kubectl config set-context --current --namespace=argocd
argocd -n argocd admin export

kubectl get deployments,pods -n default


argocd app list
argocd app sync guestbook


Install Argo CD to the cluster  
_______________________________________________________________
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
watch kubectl get pods -n argocd

Install ArgoCd CLI 
_______________________________________________________________
To inter with the API Server we need to deploy the CLI:

sudo wget https://github.com/argoproj/argo-cd/releases/download/v2.5.4/argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd
sudo chmod +x /usr/local/bin/argocd
argocd 

Login via CLI 
_______________________________________________________________
export ARGO_SERVER=$(kubectl get svc -n argocd  | grep LoadBalancer | awk '{print $4}')
export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
argocd login $ARGO_SERVER --username admin --password $ARGO_PWD --insecure


Deploying an Example Application (Optional)
kubectl config get-contexts -o name
argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
argocd app sync helm-guestbook
kubectl port-forward svc/helm-guestbook 9090:80


Create application
Connect with ArgoCD CLI using our cluster context:

CONTEXT_NAME=`kubectl config view -o jsonpath='{.current-context}'`
argocd cluster add $CONTEXT_NAME

https://www.eksworkshop.com/intermediate/290_argocd/cleanup/
kubectl create namespace ecsdemo-nodejs
argocd app create ecsdemo-nodejs --repo https://github.com/GITHUB_USERNAME/ecsdemo-nodejs.git --path kubernetes --dest-server https://kubernetes.default.svc --dest-namespace ecsdemo-nodejs
argocd app get ecsdemo-nodejs
argocd app sync ecsdemo-nodejs

-----------------------------------------------------------------

https://www.digitalocean.com/community/tutorials/how-to-deploy-to-kubernetes-using-argo-cd-and-gitops
https://www.cloudsigma.com/deploying-applications-on-kubernetes-using-argo-cd-and-gitops/

Argo CD Working With Kustomize
https://kubebyexample.com/learning-paths/argo-cd/argo-cd-working-kustomize


git clone https://github.com/christianh814/kbe-apps.git

kbe-apps/blob/main/01-working-with-kustomize/base/kustomization.yaml

----------------------------------------------------------------------


# Accessing Cluster
pks login -a https://api.pks.dev.az.km.spaceforce.mil -u solomon.williams.ctr
pks get-credentials dataservices 
kubectl config use-context dataservices --> old argo 
kubectl config use-context aks-datasvc-dev-usgovva-argo --> new argo 
kubectl config get-contexts

az account set --subscription bf7a7fd5-0bad-4232-bbe1-a14a42c74412
az aks get-credentials --resource-group rg-datasvc-dev-usgovva-aks-argo --name aks-datasvc-dev-usgovva-argo
az login --use-device-code

# Checking argocd server
kubectl get nodes -o wide
kubectl -n argocd get all

# Fetching argo credentials 
alias argo-cred='kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d'
alias argo-login='argocd login argocd.pks.dev.az.km.spaceforce.mil --username admin'

# login to argocd instance using IP/URL
argocd login argocd.pks.dev.az.km.spaceforce.mil --username admin --password qSV1JNovOd3DFXlg
argocd logout argocd.pks.dev.az.km.spaceforce.mil --username admin --password qSV1JNovOd3DFXlg

# argo commands 
argo list -A
argocd cluster list
argocd cluster list -o json

# print only client and server core version strings in YAML format
argocd version --short -o yaml

# List all known clusters in JSON format:
argocd cluster list -o json

# List configured clusters
argocd cluster list 

# Add a target cluster configuration to ArgoCD. The context must exist in your kubectl config:
argocd cluster add <example-cluster? <example-cluster>  

# Get specific details about a cluster in plain text (wide) format:
argocd cluster get example-cluster -o wide

# Remove a target cluster context from ArgoCD
argocd cluster rm example-cluster

# Set a target cluster context from ArgoCD
argocd cluster set CLUSTER_NAME --name new-cluster-name --namespace '*'
argocd cluster set CLUSTER_NAME --name new-cluster-name --namespace namespace-one --namespace namespace-two

# argocd proj create
argocd proj create PROJECT [flags]

# rgocd proj list [flags]
argocd proj list 

# List configured repositories
argocd repo list [flags]

argocd repo add
Add git repository connection parameters

argocd repo add REPOURL [flags]
Examples
  # Add a Git repository via SSH using a private key for authentication, ignoring the server's host key:
  argocd repo add git@git.example.com:repos/repo --insecure-ignore-host-key --ssh-private-key-path ~/id_rsa
  argocd repo add git@gitlab1.kendopz.com:swilliams/infra-proj.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa

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

  # Add a private Git repository on GitHub.com via GitHub App
  argocd repo add https://git.example.com/repos/repo --github-app-id 1 --github-app-installation-id 2 --github-app-private-key-path test.private-key.pem

  # Add a private Git repository on GitHub Enterprise via GitHub App
  argocd repo add https://ghe.example.com/repos/repo --github-app-id 1 --github-app-installation-id 2 --github-app-private-key-path test.private-key.pem --github-app-enterprise-base-url https://ghe.example.com/api/v3

  # Add a private Git repository on Google Cloud Sources via GCP service account credentials
  argocd repo add https://source.developers.google.com/p/my-google-cloud-project/r/my-repo --gcp-service-account-key-path service-account-key.json

-------------------

argocd proj create myproject -d https://kubernetes.default.svc,mynamespace -s https://github.com/argoproj/argocd-example-apps.git


# Projects
https://argo-cd.readthedocs.io/en/stable/user-guide/projects/

Projects provide a logical grouping of applications, which is useful when Argo CD is used by multiple teams. Projects provide the following features:

restrict — what may be deployed (trusted Git source repositories)
restrict — where apps may be deployed to (destination clusters and namespaces)
restrict — what kinds of objects may or may not be deployed (e.g. RBAC, CRDs, DaemonSets, NetworkPolicy etc...)
defining — project roles to provide application RBAC (bound to OIDC groups and/or JWT tokens)

argocd proj create wordpress -d https://infra-master01.kendopz.com:6443,default -s git@gitlab1.kendopz.com:k8s-dev-team/argo-proj.git

# Managing Projects
Permitted source Git repositories are managed using commands:

argocd proj add-source <PROJECT> <REPO>
argocd proj remove-source <PROJECT> <REPO>

# We can also do negations of sources (i.e. do not use this repo).
argocd proj add-source <PROJECT> !<REPO>
argocd proj remove-source <PROJECT> !<REPO>

# Permitted destination clusters and namespaces are managed with the commands (for clusters always provide server, the name is not used for matching):
argocd proj add-destination <PROJECT> <CLUSTER>,<NAMESPACE>
argocd proj remove-destination <PROJECT> <CLUSTER>,<NAMESPACE>

# As with sources, we can also do negations of destinations (i.e. install anywhere apart from).
argocd proj add-destination <PROJECT> !<CLUSTER>,!<NAMESPACE>
argocd proj remove-destination <PROJECT> !<CLUSTER>,!<NAMESPACE>

# Permitted destination K8s resource kinds are managed with the commands. Note that namespaced-scoped resources are restricted via a deny list, whereas cluster-scoped resources are restricted via allow list.
argocd proj allow-cluster-resource <PROJECT> <GROUP> <KIND>
argocd proj allow-namespace-resource <PROJECT> <GROUP> <KIND>
argocd proj deny-cluster-resource <PROJECT> <GROUP> <KIND>
argocd proj deny-namespace-resource <PROJECT> <GROUP> <KIND>

# Assign Application To A Project
argocd app set guestbook-default --project myproject
argocd proj role list
argocd proj role get
argocd proj role create
argocd proj role delete
argocd proj role add-policy
argocd proj role remove-policy

# Configuring RBAC With Projects

# Project Roles

# To allow users to add project scoped repositories and admin would have to add the following RBAC rules:
p, proj:my-project:admin, repositories, create, my-project/*, allow
p, proj:my-project:admin, repositories, delete, my-project/*, allow
p, proj:my-project:admin, repositories, update, my-project/*, allow

# This provides extra flexibility so that admins can have stricter rules. e.g.:
p, proj:my-project:admin, repositories, update, my-project/https://github.my-company.com/*, allow

# Apps
argo app list
argo app get <name>
argo app get <name> --refresh            # Get with soft refresh
argo app get <name> --hard-refresh       # Get with hard refresh

argo app diff <name>
argo app sync <name>

# Change target branch
argo app patch <name> --patch '[{"op": "replace", "path": "/spec/source/targetRevision", "value": "<new branch name>"}]'

argo list                                # List workflows

argo submit [--watch] myworkflow.yaml    # Create workflow
argo submit myworkflow.yaml -p foo=bar   # Create workflow with parameters
argo submit myworkflow.yaml --parameter-file config.yaml
argo submit myworkflow.yaml --entry-point "my-command"

argo logs <pod>                          # Show workflow log
argo delete <pod>                        # Delete workflow
argo delete --all                        # Delete all workflows
 
Argo CLI 
https://github.com/argoproj/argo-cd/tree/master/docs/user-guide/commands

argo logs
https://argoproj.github.io/argo-workflows/cli/argo_logs/

Argocd app sync
https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app_sync/

# Sync an app
argocd app sync my-app

# Sync multiples apps
argocd app sync my-app other-app

# Sync apps by label, in this example we sync apps that are children of another app (aka app-of-apps)
argocd app sync -l app.kubernetes.io/instance=my-app
argocd app sync -l app.kubernetes.io/instance!=my-app
argocd app sync -l app.kubernetes.io/instance
argocd app sync -l '!app.kubernetes.io/instance'
argocd app sync -l 'app.kubernetes.io/instance notin (my-app,other-app)'

# Sync a specific resource
# Resource should be formatted as GROUP:KIND:NAME. If no GROUP is specified then :KIND:NAME
argocd app sync my-app --resource :Service:my-service
argocd app sync my-app --resource argoproj.io:Rollout:my-rollout
argocd app sync my-app --resource '!apps:Deployment:my-service'
argocd app sync my-app --resource apps:Deployment:my-service --resource :Service:my-service
argocd app sync my-app --resource '!*:Service:*'
# Specify namespace if the application has resources with the same name in different namespaces
argocd app sync my-app --resource argoproj.io:Rollout:my-namespace/my-rollout

-------------------------
Deploy the App Across Multiple Kubernetes Clusters with ArgoCD

# Adding an external cluster to ArgoCD

kind-dev-cluster-config.yaml

kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "192.168.1.123"
  apiServerPort: 8443

kind create cluster --name dev-cluster --config kind-dev-cluster-config.yaml
argocd cluster add kind-dev-cluster --name dev-cluster
argocd cluster list
kubectl config use-context kind-argocd1.7


kubectl get secrets

1. # Download the MySQL deployment configuration file.
curl -LO https://k8s.io/examples/application/wordpress/mysql-deployment.yaml

2. # Download the WordPress configuration file.
curl -LO https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml

3. # Add them to kustomization.yaml file.

cat <<EOF >>./kustomization.yaml
secretGenerator:
- name: mysql-pass
  literals:
  - password=YOUR_PASSWORD
resources:
  - mysql-deployment.yaml
  - wordpress-deployment.yaml
EOF

4. # Apply and Verify 
kubectl apply -k ./
kubectl get secrets
kubectl get pvc
kubectl get pods
kubectl get services wordpress
kubectl delete -k ./


Here is the command to increase WordPress to 10 containers:
kubectl scale deployment wordpress --replicas 10

-----------

# deploy jira

wget -O helmfile_linux_amd64 https://github.com/roboll/helmfile/releases/download/v0.135.0/helmfile_linux_amd64
chmod +x helmfile_linux_amd64
mv helmfile_linux_amd64 ~/.local/bin/helmfile

git clone https://github.com/hackmdio/docker-hackmd.git
helm install stable/hackmd

# https://argo-cd.readthedocs.io/en/stable/user-guide/commands/argocd_app_set/

  # Create a directory app
  argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --directory-recurse

  # Create a Jsonnet app
  argocd app create jsonnet-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path jsonnet-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --jsonnet-ext-str replicas=2

  # Create a Helm app
  argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --helm-set replicaCount=2

  # Create a Helm app from a Helm repo
  argocd app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc

  # Create a Kustomize app
  argocd app create kustomize-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path kustomize-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --kustomize-image gcr.io/heptio-images/ks-guestbook-demo:0.1

  # Create a app using a custom tool:
  argocd app create kasane --repo https://github.com/argoproj/argocd-example-apps.git --path plugins/kasane --dest-namespace default --dest-server https://kubernetes.default.svc --config-management-plugin kasane


-------------


https://docs.edgedelta.com/docs/argocd-application-definitions


#####################################################

# https://www.linkedin.com/pulse/kubernetes-practice-user-management-rbac-argocd-qu%C3%A2n-hu%E1%BB%B3nh

kubectl edit cm argocd-cm -n argocd

vi  argocd-rbac-cm.yaml  

apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.default: role:readonly
  policy.csv: |
    p, role:deployment-restart, applications, action/apps/Deployment/restart, default/*, allow


    g, hanli, role:deployment-restart
    g, natsu, role:deployment-restart
    g, lucy, role:deployment-restart

kubectl apply -f argocd-rbac-cm.yaml    

-----------------------------------------

kubectl edit cm argocd-rbac-cm -n argocd
data:
 policy.csv: |
   p, role:readwrite, applications, get, */*, allow
   p, role:readwrite, applications, create, */*, allow
   p, role:readwrite, applications, delete, *, allow
   p, role:readexecute, applications, get, */*, allow
   p, role:readexecute, applications, sync, */*, allow
   g, developer, role:readwrite
   g, qa-tester, role:readexecute
 policy.default: role:readonly

 