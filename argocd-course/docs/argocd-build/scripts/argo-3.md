https://rderik.com/blog/setting-up-access-to-a-private-repository-in-argocd-with-ssm-parameter-store-and-external-secrets-operator/
argocd repo add git@github.com:argoproj/my-private-repository --insecure-ignore-host-key --ssh-private-key-path ~/.ssh/id_rsa

Declarative Approach using Kubernetes secret

Github Repo Using HTTPS:

apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: <https://github.com/argoproj/private-repo>
  password: <my-password/personal-access-token>
  username: <my-username/non-empty-string>

To skip certificate validation add insecure: true

apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: <https://github.com/argoproj/private-repo>
  password: <my-password/personal-access-token>
  username: <my-username/non-empty-string>
  insecure: true

Using SSH:

apiVersion: v1
kind: Secret
metadata:
  name: private-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: <git@github.com:argoproj/my-private-repository>
  sshPrivateKey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    ...
    -----END OPENSSH PRIVATE KEY-----
