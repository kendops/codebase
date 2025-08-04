
# Add a Git repository via SSH using a private key for authentication, ignoring the server's host key:
argocd repo add git@git.example.com:repos/repo --insecure-ignore-host-key --ssh-private-key-path ~/id_rsa
argocd repo add git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa

argocd proj create dev -d https://kubernetes.default.svc,* -s git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git
url:
---------------------------------------------------------------------------

 # Set cluster 
 argocd cluster set CLUSTER_NAME --name new-cluster-name --namespace '*'
 argocd cluster set CLUSTER_NAME --name new-cluster-name --namespace namespace-one --namespace namespace-two

# Connect Public, Private and Organization GitHub Repositories to ArgoCD

git@gitlab1.kendopz.com:k8s-dev-team/wordpress.git

# HTTPS Username And Password Credential
argocd repo add https://github.com:kendops/wordpress.git --username <username> --password <password>
argocd repo add git@gitlab1.kendopz.com:k8s-dev-team/wordpress.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa

# Add a Git repository via SSH using a private key for authentication, ignoring the server’s host key:
argocd repo add git@github.com:kendops/wordpress.git --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa
argocd repo add https://git.example.com/repos/repo --username git --password secret --insecure-skip-server-verification

# List configured repositories
argocd repo list
argocd repo list -o json
argocd repo list -o yaml

argocd account list

# 0. Github Repo Using HTTPS:

apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/kendops/wordpress.git
  password: <my-password/personal-access-token>
  username: <my-username/non-empty-string>
  insecure: true

# 1. Github Repo Using SSH:

apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: git@github.com:kendops/wordpress.git
  sshPrivateKey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
	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
    -----END OPENSSH PRIVATE KEY-----

apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: private-repo-ssh-key
  namespace: argocd
spec:
  # SecretStoreRef defines which SecretStore to use when fetching the secret data
  secretStoreRef:
    name: my-aws-secret-store
    kind: SecretStore  # or ClusterSecretStore
    # Specify a blueprint for the resulting Kind=Secret
  target:
    name: my-aws-secret-repo-ssh-key
    template:
      metadata:
        labels:
          argocd.argoproj.io/secret-type: repository
      # Use inline templates to construct your desired config file that contains your secret
      data:
        type: git
        url: git@github.com:kendops/wordpress.git
        sshPrivateKey: |
          {{ .sshPrivateKey | toString }}
  data:
  - secretKey: sshPrivateKey
    remoteRef:
      key: /argo-cd/github-repo/ssh-key


# With that out of the way, we can apply the two templates:

kubectl apply -f secret-store.yaml
kubectl apply -f external-secret.yaml

# If we get any errors and need to review what is going on, we can use the following command:

kubectl describe SecretStore my-aws-secret-store -n argocd
kubectl describe ExternalSecret private-repo-ssh-key -n argocd

# And if we want to check if the secret created in Kubernetes matches our SSH key:
kubectl get secret my-aws-secret-repo-ssh-key \
  -n argocd -o jsonpath="{.data.sshPrivateKey}" | base64 -d


---------------------------------------------------------------------------

Managing Projects 
argocd proj add-source dev git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git
argocd proj remove-source dev git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git


Permitted destination clusters and namespaces are managed with the commands 
argocd proj add-destination dev https://kubernetes.default.svc,*
argocd proj remove-destination dev https://kubernetes.default.svc,*

argocd proj allow-cluster-resource dev <GROUP> <KIND>
argocd proj allow-namespace-resource dev <GROUP> <KIND>
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

# Apps
argo app list
argo app get <name>
argo app get <name> --refresh            
argo app get <name> --hard-refresh      

The following commands can be used to manage a role.
argocd proj role list
argocd proj role get
argocd proj role create
argocd proj role delete
argocd proj role add-policy
argocd proj role remove-policy

The following commands are used to manage the JWT tokens.
argocd proj role create-token PROJECT ROLE-NAME
argocd proj role delete-token PROJECT ROLE-NAME ISSUED-AT


For the declarative setup both repositories and clusters are stored as Kubernetes Secrets, and 
so a new field is used to denote that this resource is project scoped:

apiVersion: v1
kind: Secret
metadata:
  name: argocd-example-apps
  labels:
    argocd.argoproj.io/secret-type: repository
type: Opaque
stringData:
  project: my-project1                                     # Project scoped 
  name: argocd-example-apps
  url: https://github.com/argoproj/argocd-example-apps.git
  username: ****
  password: ****

---------------------------------------------------------------------------

argocd repo get https://github.com/foxutech/kubernetes.git
argocd repo get https://github.com/foxutech/kubernetes.git -o json
argocd repo get https://github.com/foxutech/kubernetes.git -o yaml

Helm app
argocd app create helm-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path helm-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --helm-set replicaCount=2

Helm app from a Helm repo
argocd app create nginx-ingress --repo https://charts.helm.sh/stable --helm-chart nginx-ingress --revision 1.24.3 --dest-namespace default --dest-server https://kubernetes.default.svc

Kustomize app
argocd app create kustomize-guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path kustomize-guestbook --dest-namespace default --dest-server https://kubernetes.default.svc --kustomize-image gcr.io/heptio-images/ks-guestbook-demo:0.1

---------------------------------------------------------------------------

# Create the ArgoCD Project and application
# The project:

apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: server-proj
  namespace: argocd
  # Finaliser that ensures that the project is not deleted until any application does not reference it
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  # Project description
  description: Server Project
  destinations:
    # Update your namespace
    - namespace: my-namespace
      server: https://kubernetes.default.svc
  sourceRepos:
    # Make sure to add your repository here
    - https://github.com/rderik/slartybartfast.git
  clusterResourceWhitelist:
  - group: ''
    kind: '*'

# The application:

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: server
  namespace: argocd
spec:
  destination:
    namespace: my-namespace
    server: https://kubernetes.default.svc
  project: server-proj
  source:
    # Change the repository to your repository
    repoURL: https://github.com/rderik/slartybartfast.git
    # point the path to the path where your Kubernetes templates are
    path: server
  syncPolicy:
    automated: # automated sync by default retries failed attempts 5 times with following delays between attempts ( 5s, 10s, 20s, 40s, 80s ); retry controlled using `retry` field.
      prune: false # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: false # Specifies if partial app sync should be executed when resources are changed only in target Kubernetes cluster and no git change detected ( false by default ).
      allowEmpty: true # Allows deleting all application resources during automatic syncing ( false by default ).

kubectl apply -f project.yaml
kubectl apply -f application.yaml

# ArgoCD for private repositories

apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: git@github.com:argoproj/my-private-repository
  sshPrivateKey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    ...
    -----END OPENSSH PRIVATE KEY-----


-------------------------------

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: maestro
spec:
  destination:
    name: ''
    namespace: mchisa
    server: 'https://kubernetes.default.svc'
  source:
    path: charts/oasis/maestro
    repoURL: 'ssh://git@vault.idirect.net/stl/helm.git'
    targetRevision: feature/mchisa
    helm:
      valueFiles:
        - values.yaml
        - dev.yaml
  project: mchisa
  syncPolicy:
    automated: null
    syncOptions:
      - CreateNamespace=true

  rbac:
    create: true
    policy.default: role:none
    policy.csv: |
      p, role:none, *, *, */*, deny
      p, role:xxxadmin, applications, *, */*, allow
      p, role:xxxadmin, clusters, get, *, allow
      p, role:xxxadmin, repositories, get, *, allow
      p, role:xxxadmin, repositories, create, *, allow
      p, role:xxxadmin, repositories, update, *, allow
      p, role:xxxadmin, repositories, delete, *, allow
      g, xxx-admin, role:admin
      g, xxx-developer, role:readonly
      g, xxxorg:devops, role:admin
      g, xxxorg:engineering, role:admin
      g, xxxorg:app, role:readonly
      g, xxxorg:automation, role:readonly
      g, xxxorg:automation-qa, role:readonly
      g, xxxorg:de, role:readonly

kubectl edit configmap argocd-cm            