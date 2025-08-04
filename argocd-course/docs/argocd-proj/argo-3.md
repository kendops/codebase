kubectl create namespace argocd
kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable
kubectl apply -n argocd -f https://github.com/argoproj/argo-cd/blob/master/manifests/ha/install.yaml

Or
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml -n argocd

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml


kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

Creating Apps Via CLI¶

# First we need to set the current namespace to argocd running the following command:
kubectl config set-context --current --namespace=argocd

# Create the example guestbook application with the following command:
argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://172.29.0.22:6443 --dest-namespace default

argocd account update-password





  



################################

I have both ArgoCD and Keycloak installed in Kubernetes

Keycloak is running on http://127.0.0.1:8085/

Argopcd is running on https://localhost:8080/

My redirect on the "Log in via keycloak does not work"

for my Argocd

``
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
name: argocd-server
spec:
sso:
provider: keycloak
server:
ingress:
enabled: true
extraArgs:
- --auth-provider=keycloak
- --auth-mode=sso
- --auth-url=http://127.0.0.1:8085/
- --auth-client-id=argocd2354
- --auth-client-secret=2IXOxHNGMRe9h9w3N10DEAUIUFvJvqDw
- --auth-realm=master
- --auth-redirect-uri=https://localhost:8080/auth/

``
my ArgoCD configmap argocd-cm

KUBE_EDITOR="nano" kubectl edit configmap argocd-cm

``
apiVersion: v1
data:
admin.enabled: "true"
application.instanceLabelKey: argocd.argoproj.io/instance
exec.enabled: "false"
oidc.config: |
name: Keycloak
issuer: http://localhost:8085/admin
clientID: argocd2354w
clientSecret: $oidc.keycloak.clientSecret
server.rbac.log.enforce.enable: "false"
timeout.hard.reconciliation: 0s
timeout.reconciliation: 180s
url: https://localhost:8080/applications
kind: ConfigMap
metadata:
annotations:
meta.helm.sh/release-name: oxygen-repo
meta.helm.sh/release-namespace: default
creationTimestamp: "2023-07-10T05:34:03Z"
labels:
app.kubernetes.io/component: server
app.kubernetes.io/instance: oxygen-repo
app.kubernetes.io/managed-by: Helm
app.kubernetes.io/name: argocd-cm
app.kubernetes.io/part-of: argocd
app.kubernetes.io/version: v2.7.7
helm.sh/chart: argo-cd-5.37.1
name: argocd-cm
namespace: default
resourceVersion: "30393"
uid: ba14d9cc-fe60-4267-be82-4d7ee7adfded

``

my KUBE_EDITOR="nano" kubectl edit secret argocd-secret

``

apiVersion: v1
data:
admin.password: JDJhJDEwJEhNVlpxcy5OQU9uSWFMeFpvVUtvek8uMFFkRlZLNDJoMHBSWTVDUVdsd3dYVXU1ZDRReEEu
admin.passwordMtime: MjAyMy0wNy0xMFQwNTozNDoyOVo=
oidc.keycloak.clientSecret: MklYT3hITkdNUmU5aDl3M04xMERFQVVJVUZ2SnZxRHc=
server.secretkey: bXNDaHpnVk9aaWpvZ05zSUlOdDcyMzUvNCs4d3NQU0dLNTIzOC84bnJ0MD0=
tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURaVENDQWsyZ0F3SUJBZ0lRY1JXMWNoaDc5dUJuMERVN205T29LekFOQmdrcW$
tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBOFFEVERqcHdhcmEwQTljcTZXT2x3VFRpSzBoWG$
kind: Secret
metadata:
annotations:
meta.helm.sh/release-name: oxygen-repo
meta.helm.sh/release-namespace: default
creationTimestamp: "2023-07-10T05:34:03Z"
labels:
app.kubernetes.io/component: server
app.kubernetes.io/instance: oxygen-repo
app.kubernetes.io/managed-by: Helm
app.kubernetes.io/name: argocd-secret
app.kubernetes.io/part-of: argocd
app.kubernetes.io/version: v2.7.7
helm.sh/chart: argo-cd-5.37.1
name: argocd-secret
namespace: default
resourceVersion: "24680"
uid: f36ead68-e614-4c61-9e49-776c6fd0320b
type: Opaque

