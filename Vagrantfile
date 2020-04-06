# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	# Box Name
	config.vm.box = "ubuntu/xenial64"

	# Provider Settings
	config.vm.provider "virtualbox" do |vb|
		vb.name = "xenial-lampp"
		vb.memory = 2048
		vb.cpus = 2
	end

	# Network Settings
	config.vm.network "private_network", ip: "192.168.33.10"

	# Folder Settings
	config.vm.synced_folder "./html", "/var/www/html", :mount_options => ["dmode=777", "fmode=666"]

	# Provision Settings
	config.vm.provision "shell", path: "bootstrap.sh"
end
