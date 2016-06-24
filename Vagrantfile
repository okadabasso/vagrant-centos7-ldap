# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
  config.vm.network "private_network", ip: "192.168.33.21"
  config.omnibus.chef_version = :latest
  
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
  end
  
  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = ["chef-repo/cookbooks", "chef-repo/site-cookbooks"]
    chef.nodes_path = ["chef-repo/nodes"]
    chef.node_name = "sample"
  end
end
