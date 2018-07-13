# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"
  
  config.vm.define "rabbitmq1" do |node|
    node.vm.hostname = "rabbitmq1"
    node.vm.network "private_network", ip: "192.168.56.11", name: "vboxnet0"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "rabbitmq1"
      vb.memory = "1024"
    end
  end

  config.vm.define "rabbitmq2" do |node|
    node.vm.hostname = "rabbitmq2"
    node.vm.network "private_network", ip: "192.168.56.12", name: "vboxnet0"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "rabbitmq2"
      vb.memory = "1024"
    end
  end

  config.vm.define "rabbitmq3" do |node|
    node.vm.hostname = "rabbitmq3"
    node.vm.network "private_network", ip: "192.168.56.13", name: "vboxnet0"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "rabbitmq3"
      vb.memory = "1024"
    end
  end

  config.vm.define "client1" do |node|
    node.vm.hostname = "client"
    node.vm.network "private_network", ip: "192.168.56.21", name: "vboxnet0"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "client1"
      vb.memory = "1024"
    end
  end

  config.vm.define "client2" do |node|
    node.vm.hostname = "client"
    node.vm.network "private_network", ip: "192.168.56.22", name: "vboxnet0"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "client2"
      vb.memory = "1024"
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo /bin/bash /vagrant/provision.sh
  SHELL
end
