apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
  namespace: argocd
type: Opaque
data:
...

stringData:
  # github webhook secret
  webhook.github.secret: wordpress

  # gitlab webhook secret
  webhook.gitlab.secret: wordpress

# k edit secret argocd-secret  -n argocd 
# https://argo-cd.readthedocs.io/en/stable/operator-manual/webhook/
# https://argo-cd.readthedocs.io/en/stable/operator-manual/webhook/
# http://argo-kendopz.com/api/webhook


