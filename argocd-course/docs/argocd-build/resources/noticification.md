https://elatov.github.io/2021/12/deploying-and-using-argocd/

Next let’s add the slack token as a secret:

export TOKEN="xoxb-xxxxx"
kubectl apply -n argocd -f - << EOF
apiVersion: v1
kind: Secret
metadata:
  name: argocd-notifications-secret
stringData:
  slack-token: ${TOKEN}
type: Opaque
EOF

Now let’s register the slack service:

> kubectl patch cm argocd-notifications-cm -n argocd --type merge -p '{"data": {"service.slack": "{ token: $slack-token }" }}'
Now let’s enable the notification on one of the apps:

> kubectl patch app prometheus -n argocd -p '{"metadata": {"annotations": {"notifications.argoproj.io/subscribe.on-sync-succeeded.slack":"general"}}}' --type merge
application.argoproj.io/prometheus patched

You can also enable them globally as described in Default Subscriptions. So I created the following to config to enable all the triggers:

> cat argocd-notifications-cm-merge.yaml
data:
  # Contains centrally managed global application subscriptions
  subscriptions: |
    # subscription for on-sync-status-unknown trigger notifications
    - recipients:
      - slack:general
      triggers:
      - on-sync-status-unknown
      - on-created
      - on-deleted
      - on-deployed
      - on-health-degraded
      - on-sync-failed
      - on-sync-running
      - on-sync-succeeded
And then for the merge:

> kubectl patch cm argocd-notifications-cm -n argocd --type merge -p "$(cat argocd-notifications-cm-merge.yaml)"
configmap/argocd-notifications-cm patched