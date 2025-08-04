# GitOps with ArgoCD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

It follows the GitOps pattern of using Git repositories as the source for defining the desired application state.

It automates the deployment of the desired application states in the specified target environments. Application deployments can track updates to branches, tags, or be pinned to a specific version of manifests at a Git commit.

![argocd](../images/image-1.png)

### GitOps 

GitOps is a set of practices that leverages Git workflows to manage infrastructure and application configurations. By using Git repositories as the source, it allows the DevOps team to store the entire state of the cluster configuration in Git so that the trail of changes are visible and auditable.

GitOps simplifies the propagation of infrastructure and application configuration changes across multiple clusters by defining your infrastructure and applications definitions as “code”.

- Ensure that the clusters have similar states for configuration, monitoring, or storage.

- Recover or recreate clusters from a known state.

- Create clusters with a known state.

- Apply or revert configuration changes to multiple clusters.

- Associate templated configuration with different environments.

### ArgoCD 

ArgoCD is one of the world’s most popular open-source GitOps tools today, and it automates the deployment of the desired applications in the specified Kubernetes target environments.

What you will learn in this course: 

1. GitOps Methodology
1. DevOps vs GitOps Deployment Models.
1. What/Why/How ArgoCD?
1. ArgoCD Concepts, Features, Terminology.
1. Detailed ArgoCD Architecture & Core Components.
1. Reconciliation Loop Options.
1. Custom Application Health Checks.
1. Synchronization Strategies.
1. Imperative vs declarative approach.
1. User Management with RBAC.
1. Secret management using HashiCorp Vault & Sealed Secrets.
1. SSO with Okta.
1. Metrics with Prometheus, Grafana & Alertmanager.
1. Custom Slack Notification.


