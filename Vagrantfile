OWNER = "vagrant"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "argocd-lab"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 443, host: 443
  config.vm.synced_folder "k8s-manifests", "/opt/k8s-manifests"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "argocd-lab"
    vb.cpus = "3"
    vb.memory = "4096"
  end

  config.vm.provision "shell", path: "scripts/install_microk8s.sh", args: [OWNER]
  config.vm.provision "shell", path: "scripts/install_argocd.sh", args: [OWNER]
end