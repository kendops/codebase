rgoCD Notifications
Recently the ArgoCD Notifications project became part of the main ArgoCD project. It supports Slack and other services as well. I actually wanted to see how to use slack with it. Some nice examples of the slack are seen here. So let’s install the controller first:

> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/v1.1.0/manifests/install.yaml
And let’s install the templates:

> kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-notifications/v1.1.0/catalog/install.yaml
After some time you should see the controller deployed:

> k get pods -l app.kubernetes.io/name=argocd-notifications-controller -n argocd

https://elatov.github.io/2021/12/deploying-and-using-argocd/