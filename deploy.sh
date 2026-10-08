#!/bin/bash

set -euo pipefail

NAMESPACE="argocd"

# Create namespace only if it does not already exist
if microk8s kubectl get namespace ${NAMESPACE} &>/dev/null; then
    echo "Namespace '${NAMESPACE}' already exists, skipping creation."
else
    echo "Creating namespace '${NAMESPACE}'..."
    microk8s kubectl create namespace ${NAMESPACE}
fi

# Apply ArgoCD manifests wait only when the argocd-server deployment does not exist yet
FRESH_INSTALL=false
if ! microk8s kubectl get deployment argocd-server -n ${NAMESPACE} &>/dev/null; then
    FRESH_INSTALL=true
fi

echo "Applying ArgoCD manifests..."
microk8s kubectl apply \
    -n ${NAMESPACE} --server-side --force-conflicts \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

if [ "${FRESH_INSTALL}" = true ]; then
    echo "Fresh install detected, waiting for ArgoCD to be ready..."
    for deploy in argocd-server argocd-repo-server argocd-application-controller argocd-dex-server argocd-redis; do
        echo "Waiting for ${deploy}..."
        microk8s kubectl rollout status deployment/${deploy} -n ${NAMESPACE} --timeout=5m 2>/dev/null || \
        microk8s kubectl rollout status statefulset/${deploy} -n ${NAMESPACE} --timeout=5m 2>/dev/null || true
    done
fi

#Let ArgoCD to run in "insecure" mode. Traefik will handle the SSL/TLS termination
CURRENT_INSECURE=$(microk8s kubectl get configmap argocd-cmd-params-cm -n ${NAMESPACE} -o jsonpath="{.data.server\.insecure}" 2>/dev/null || echo "")
if [ "${CURRENT_INSECURE}" != "true" ]; then
    echo "Configuring ArgoCD to run in insecure mode..."
    microk8s kubectl patch configmap argocd-cmd-params-cm \
        -n argocd \
        -p '{"data":{"server.insecure":"true"}}'
    echo "Restarting argocd-server to apply config changes..."
    microk8s kubectl rollout restart deployment argocd-server -n argocd
else
    echo "ArgoCD insecure mode already configured, skipping patch and restart."
fi

echo "Applying ingress..."
microk8s kubectl apply -f ./k8s-manifests/ingress.yml

admin_encoded_password=$(microk8s kubectl get secret argocd-initial-admin-secret -n ${NAMESPACE} -o jsonpath="{.data.password}")
admin_password=$(echo ${admin_encoded_password} | base64 --decode)
echo -e "\nTo access ArgoCD UI, visit https://localhost"
echo -e "\nArgoCD username: admin"
echo -e "ArgoCD password: ${admin_password}\n"
