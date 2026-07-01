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

Set up and provision your own local ArgoCD environment using Vagrant to deploy an Ubuntu VM with MicroK8s cluster and ArgoCD for GitOps workflows. This lab provides a complete local development environment for learning and testing ArgoCD deployments.

![Simple_Ansible-lab_diagram](https://raw.githubusercontent.com/RecursiveDeveloper/static-media-content/refs/heads/main/Argocd_Simple-Diagram.png)

## Tech Stack 

- **Kubernetes:** MicroK8s (includes built-in container runtime and kubectl)
- **GitOps:** ArgoCD
- **Virtualization:** VirtualBox, Vagrant
- **OS:** Ubuntu 22.04 (Jammy)

## Prerequisites

1. Install VirtualBox as your virtual machine provider [Install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install Vagrant according to your operating system [Install Vagrant](https://developer.hashicorp.com/vagrant/downloads)
3. Ensure you have at least 4GB RAM available for the VM

## Deployment

To deploy this project run:

```bash
vagrant up
```

The provisioning process will:
1. Install and configure MicroK8s (includes built-in container runtime and `microk8s kubectl`)
2. Enable MicroK8s DNS and ingress add-ons
3. Deploy ArgoCD with ingress configuration

## Access ArgoCD

After successful deployment:
- **URL:** https://localhost
- **Username:** admin
- **Password:** Check the terminal output after `vagrant up` completes

## Project Structure

```
argocd-lab/
├── scripts/
│   ├── install_microk8s.sh     # MicroK8s setup (includes container runtime and kubectl)
│   └── install_argocd.sh       # ArgoCD deployment
├── k8s-manifests/
│   └── ingress.yml             # ArgoCD ingress configuration
├── Vagrantfile                 # VM configuration
└── README.md
```

For more information about Vagrant commands, check the [vagrant-cheat-sheet](https://gist.github.com/wpscholar/a49594e2e2b918f4d0c4)

## Authors

- [@RecursiveDeveloper](https://github.com/RecursiveDeveloper)

## License

[MIT](https://choosealicense.com/licenses/mit/)
