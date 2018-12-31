Vagrant.configure("2") do |config|
end

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-18.04"
  config.vm.box_check_update = true
  config.ssh.password = 'vagrant'
  
  config.vm.define "virtualbox", autostart: true do |vb_vm|
    vb_vm.vm.provider :virtualbox do |v, override| 
      override.vm.network "forwarded_port", guest: 5000, host: 5000
    end
  end
 
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get --assume-yes install build-essential
    sudo apt-get --assume-yes install curl
    sudo apt-get --assume-yes install git
    cd /vagrant &&  sudo -E su vagrant -c 'make setup LOCALDIR=/var'
  SHELL
end
