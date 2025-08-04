    #!/bin/bash

    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' > /dev/null 2>&1 
    export argo_url=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | grep -v none)
    echo "argo_url: http://$argo_url/"
    echo username: "admin"
    echo password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

    export ARGO_URL=$(kubectl get svc -n argocd | grep argocd-server | awk '{print $4}' | grep -v none)
    export ARGO_USERNAME=admin
    export ARGO_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    
    argocd login $ARGO_URL --username $ARGO_USERNAME --password Redhat123 --insecure
    argocd cluster list

   # Register A Cluster To Deploy Apps To (Optional)
    kubectl config use-context dev
    kubectl config get-contexts
    argocd cluster add developer --insecure 
    argocd cluster list
    argocd proj create developer -d https://dev1.kendopz.com:6443, * -s git@github.com:kendops/wordpress.git
    argocd proj list developer

   # kubectl apply -f wordpress.yaml
    argocd app create argo-config-wordpress \
    --repo git@172.29.0.37:k8s-dev-team/argocd-app-config.git \
    --path wordpress-1 \
    --dest-namespace default \
    --dest-server https://dev1.kendopz.com:6443 \
    --self-heal \
    --project developer \
    --sync-policy automated \
    --sync-retry-limit 5 \
    --revision main

    argocd app create argo-config-wordpress \
    --repo https://github.com/kendops/wordpress.git \
    --path wordpress \
    --dest-namespace default \
    --dest-server https://dev1.kendopz.com:6443 \
    --self-heal \
    --project developer \
    --sync-policy automated \
    --sync-retry-limit 5 \
    --revision main

#   argocd repocreds add https://github.com/repos/ --github-app-id 1 --github-app-installation-id 2 --github-app-private-key-path test.private-key.pem

  argocd repocreds add https://github.com/kendops/wordpress.git --username kendops --password H)%#?fsGsj1
