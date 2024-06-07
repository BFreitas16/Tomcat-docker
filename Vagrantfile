# -*- mode: ruby -*-
# vi: set ft=ruby :

# Configuration variables
# -------------------------------

$provider    = "virtualbox"
$vm_name     = "mgmt"
$vm_image    = "ubuntu/focal64"
$vm_cpu      = 1
$vm_memory   = "1024"
$sync_folder = "/home/vagrant/infrastructure"

# -------------------------------

# Ensure this Project is for Virtualbox Provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = $provider

# Ensure the required plugins are globally installed
VAGRANT_PLUGINS = [
  "vagrant-vbguest",
  "vagrant-reload",
]
VAGRANT_PLUGINS.each do |plugin|
  unless Vagrant.has_plugin?("#{plugin}")
    system("vagrant plugin install #{plugin}")
    exit system('vagrant', *ARGV)
  end
end

Vagrant.configure("2") do |config|
  # Create node
  config.vm.define $vm_name do |mgvb|
    mgvb.vm.box = $vm_image
    mgvb.vm.hostname = $vm_name

    # Network Configuration
    mgvb.vm.network "forwarded_port", guest: 8080, host: 80
    mgvb.vm.network "forwarded_port", guest: 4041, host: 443

    mgvb.vm.provider $provider do |vb|
      vb.name   = $vm_name
      vb.cpus   = $vm_cpu
      vb.memory = $vm_memory
    end

    # Shared folders
    mgvb.vm.synced_folder "infrastructure", $sync_folder,
      owner: "vagrant", group: "vagrant",
      mount_options: ["dmode=775","fmode=755"]
    
    # Basic Provisioning with reload (reboot)
    mgvb.vm.provision :shell, path: "scripts/bootstrap-mgmt.sh"
    mgvb.vm.provision :shell, path: "scripts/create-ca-certificate.sh"
    mgvb.vm.provision :shell, path: "scripts/create-signed-certificate.sh"
    mgvb.vm.provision :reload
    # Tomcat Provision
    #   1. It makes sure the tomcat ceritificates folder exists
    #   2. It copies all certificates to the previous folder
    #   3. It starts tomcat service 
    mgvb.vm.provision :shell, inline: "mkdir -p #{$sync_folder}/tomcat/certificates"
    mgvb.vm.provision :shell, inline: "yes | cp -f /certificates/* #{$sync_folder}/tomcat/certificates/"
    mgvb.vm.provision :shell, inline: "sh #{$sync_folder}/tomcat/tomcat-run.sh"
  end
end
