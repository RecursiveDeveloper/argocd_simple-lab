#!/bin/bash

namespace="argocd"

microk8s kubectl create namespace ${namespace}
microk8s kubectl apply \
    -n ${namespace} --server-side --force-conflicts \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 240

#Let ArgoCD to run in "insecure" mode. Traefik will handle the SSL/TLS termination
microk8s kubectl patch configmap argocd-cmd-params-cm \
    -n argocd \
    -p '{"data":{"server.insecure":"true"}}'
microk8s kubectl rollout restart deployment argocd-server -n argocd
microk8s kubectl apply -f /opt/k8s-manifests/ingress.yml

admin_encoded_password=$(microk8s kubectl get secret argocd-initial-admin-secret -n ${namespace} -o jsonpath="{.data.password}")
admin_password=$(echo ${admin_encoded_password} | base64 --decode)
echo -e "\nTo access ArgoCD UI, visit https://localhost"
echo -e "\nArgoCD username: admin"
echo -e "ArgoCD password: ${admin_password}\n"