
Vagrant.configure(2) do |config|

  # Shared configuration
  config.vm.box = "jjn1056/perl-tictactoe"
  config.vm.network "forwarded_port", guest:5000, host:5000
  config.ssh.forward_agent = true

  # Specific to the virtualbox provider
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 4
  end

  # Provisioning info
  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant
    sudo -E su vagrant -c 'make installdevelop'
  SHELL

end
