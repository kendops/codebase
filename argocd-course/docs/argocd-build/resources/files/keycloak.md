# Kind, Keycloak and ArgoCD with SSO

In this story I’m going to deploy Keycloak (an identity provider) and ArgoCD (a GitOps continuous delivery tool for Kubernetes) together on a local Kubernetes cluster.

Keycloak will be configured by terraform and ArgoCD will use Keycloak to enable SSO authentication.

I’m going to cover the following topics:

Local Kubernetes cluster creation
Keycloak deployment (with helm)
Keycloak configuration (with terraform)
ArgoCD deployment (with helm)
Finally, deploy metrics-server through an ArgoCD application

Keycloak overview
Keycloak is an Open Source Identity and Access Management solution for modern Applications and Services.


Steps to integrate Okta and Argo CD
