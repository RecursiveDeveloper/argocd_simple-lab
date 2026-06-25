#!/bin/bash

owner=$1

sudo apt update -y
sudo apt install -y snapd

echo -e "\nInstalling MicroK8s...\n"
sudo snap install microk8s --classic
microk8s status --wait-ready

sudo usermod -aG microk8s $owner
sudo chown -f -R $owner ~/.kube

sudo microk8s enable dns
sudo microk8s enable ingress