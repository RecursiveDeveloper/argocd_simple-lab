#!/bin/bash

set -euo pipefail

NAMESPACE="argocd"

echo "Removing ArgoCD ingress..."
microk8s kubectl delete -f ./k8s-manifests/ingress.yml --ignore-not-found

echo "Removing ArgoCD manifests..."
microk8s kubectl delete \
    -n ${NAMESPACE} \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml \
    --ignore-not-found

echo "Deleting namespace ${NAMESPACE}..."
microk8s kubectl delete namespace ${NAMESPACE} --ignore-not-found

echo "ArgoCD lab destroyed successfully."
