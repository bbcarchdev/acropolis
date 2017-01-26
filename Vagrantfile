# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  host = RbConfig::CONFIG['host_os']

  if host =~ /darwin/
    cpus = `sysctl -n hw.ncpu`.to_i
  elsif host =~ /linux/
    cpus = `nproc`.to_i
  else
    cpus = 1
  end

  config.vm.box = "debian/jessie64"

  #config.vm.synced_folder ".", "/home/vagrant/module", owner: 'vagrant', group: 'vagrant'

  config.ssh.forward_agent = true

  config.vm.provision :shell, :path => "vagrant/vagrant_install.sh"
  config.vm.provision :shell, :privileged => true, :path => "vagrant/module_install.sh"

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--cpus", cpus]
    virtualbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end
end
