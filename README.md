## 🚀 About Me
I'm a junior DevOps engineer with some expertise in BackEnd development using Java and Node.js; scripting skills with Python, Bash and JavaScript; besides CI/CD and cloud knowledge of AWS and Azure DevOps tools ...

<p align="center">
<img src="https://c4.wallpaperflare.com/wallpaper/694/164/1000/digital-art-animals-eagle-bird-of-prey-birds-hd-wallpaper-preview.jpg" alt="Logo" width="400" height="230">
</p>

![linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![javascript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![nodejs](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![mysql](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white)
![aws](https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![azuredevops](https://img.shields.io/badge/Azure_DevOps-0078D7?style=for-the-badge&logo=azure-devops&logoColor=white)

## 🔗 Portfolio
[![portfolio](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/RecursiveDeveloper)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/jhoan-jesus-ortiz-sandoval-a66152198/)

# ArgoCD Lab with MicroK8s

Set up a local ArgoCD environment for GitOps workflows on a MicroK8s cluster using two simple Bash scripts. This lab is meant for learning and testing ArgoCD deployments in a local development environment.

![ArgoCD_Simple-Lab_diagram](https://raw.githubusercontent.com/RecursiveDeveloper/static-media-content/refs/heads/main/Argocd_Simple-Diagram.png)

## Tech Stack

- **Kubernetes:** MicroK8s (includes built-in container runtime, `kubectl`, and the Traefik ingress controller)
- **GitOps:** ArgoCD (official stable manifests)
- **Ingress/TLS:** Traefik (MicroK8s `ingress` add-on) terminates SSL/TLS, ArgoCD runs in insecure mode

## Folder Structure

```
argocd_simple-lab/
├── deploy.sh              # Install and configure ArgoCD on the cluster
├── destroy.sh             # Remove ArgoCD and its namespace from the cluster
├── k8s-manifests/
│   └── ingress.yml        # ArgoCD server ingress (routes / to argocd-server:80)
├── README.md
└── .gitignore
```

## Prerequisites

1. A Linux machine (or VM) where MicroK8s runs, with at least 2 CPUs and 4GB of RAM
2. MicroK8s installed and ready — follow the steps below
3. The `dns` and `ingress` MicroK8s add-ons enabled

## Environment Setup

Install MicroK8s and enable the required add-ons:

```bash
sudo snap install microk8s --classic
sudo usermod -aG microk8s $USER   # then log out and back in
microk8s status --wait-ready
microk8s enable dns
microk8s enable ingress
```

Verify the cluster is healthy:

```bash
microk8s kubectl get node
```

> This lab uses `microk8s kubectl` for all cluster commands. No separate `kubectl` or `Docker` installation is required — MicroK8s bundles its own container runtime and CLI tools.

## Deployment

From the repository root, run:

```bash
./deploy.sh
```

The script is idempotent and performs the following:

1. Creates the `argocd` namespace if it does not already exist
2. Applies the official ArgoCD installation manifest (server-side apply with force-conflicts)
3. On a fresh install, waits for ArgoCD to become ready
4. Configures ArgoCD to run in `insecure` mode (`server.insecure=true`) and restarts `argocd-server` — Traefik handles SSL/TLS termination
5. Applies the ingress to route traffic to the ArgoCD server
6. Prints the admin credentials for the ArgoCD UI

## Access ArgoCD

After a successful deployment:

| Parameter | Value |
| --- | --- |
| URL | `https://localhost` |
| Username | `admin` |
| Password | Printed in the terminal output (decoded from the `argocd-initial-admin-secret`) |

> Running MicroK8s inside WSL? The ArgoCD UI won't be reachable from outside WSL until you forward the service ports — see [Accessing from Outside WSL](#accessing-from-outside-wsl-port-forwarding).

## Accessing from Outside WSL (Port Forwarding)

If MicroK8s is running inside WSL (or another VM) and you want to reach the ArgoCD UI from outside WSL, port-forward the ArgoCD server service to a local port:

```bash
microk8s kubectl port-forward svc/argocd-server <HOST_PORT>:80 -n argocd
```

For example:

```bash
microk8s kubectl port-forward svc/argocd-server 8080:80 -n argocd
```

Then open `http://localhost:8080` in your browser.

> **Notes**
> - Since ArgoCD runs in `insecure` mode, the UI is served over plain HTTP on the forwarded port — no self-signed certificate warning.
> - The command is blocking: it keeps the port open until you stop it with `Ctrl+C`.
> - Pick any free port for `<HOST_PORT>` (e.g. `8080`), and access it from the Windows side too — WSL2 forwards localhost ports to the Windows host automatically.

## Teardown

To remove ArgoCD and its namespace from the cluster:

```bash
./destroy.sh
```

This deletes the ingress, the ArgoCD installation manifests, and the `argocd` namespace.

## How It Works

```
Browser ──(HTTPS)──> Traefik ingress (MicroK8s, TLS termination)
                          │
                          ▼
                     argocd-server:80 (insecure mode)
```

- Traefik exposes the ArgoCD UI on `https://localhost`.
- ArgoCD runs with `server.insecure=true` because TLS is terminated upstream by the ingress controller.

## Authors

- [@RecursiveDeveloper](https://github.com/RecursiveDeveloper)

## License

[MIT](https://choosealicense.com/licenses/mit/)