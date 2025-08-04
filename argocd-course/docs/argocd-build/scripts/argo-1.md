
   # https://github.com/argoproj/argo-cd/blob/master/docs/user-guide/commands/argocd_proj_role_add-group.md

   # Register A Cluster To Deploy Apps To (Optional)
    kubectl config use-context dev
    kubectl config get-contexts
    argocd cluster add dev --insecure --name dev-cluster
    argocd cluster list
    argocd cluster list
    argocd proj create dev -d https://172.29.0.25:6443, * -s git@gitlab1.kendopz.com:k8s-dev-team/argocd-app-config.git
    argocd proj list dev

   # Set cluster 
    argocd cluster set dev --name https://172.29.0.25:6443 --namespace '*'
    argocd cluster set CLUSTER_NAME --name https://172.29.0.25:6443 --namespace namespace-one --namespace namespace-two

   # kubectl apply -f wordpress-1.yaml
    argocd app create argo-config-wordpress \
    --repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
    --path wordpress-1 \
    --dest-namespace default \
    --dest-server https://172.29.0.45:6443 \
    --self-heal \
    --project dev \
    --sync-policy automated \
    --sync-retry-limit 5 \
    --revision main

    argocd app create argo-config-ldap \
    --repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
    --path ldap/overlays/staging/ \
    --dest-namespace default \
    --dest-server https://172.29.0.45:6443 \
    --self-heal \
    --project dev \
    --sync-policy automated \
    --sync-retry-limit 5 \
    --revision main

argocd account list