# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbguest vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  ##
  ##  terraform
  ##
  # The "terraform" string is the name of the box. hence you can do "vagrant up terraform"
  config.vm.define "terraform" do |terraform_config|
    terraform_config.vm.box = "CodingBee/centos7"

    # this set's the machine's hostname.
    terraform_config.vm.hostname = "terraform.local"


    # This will appear when you do "ip addr show". You can then access your guest machine's website using "http://192.168.50.4"
    terraform_config.vm.network "private_network", ip: "192.168.60.100"
    # note: this approach assigns a reserved internal ip addresses, which virtualbox's builtin router then reroutes the traffic to,
    #see: https://en.wikipedia.org/wiki/Private_network

    terraform_config.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      vb.gui = true
      # For common vm settings, e.g. setting ram and cpu we use:
      vb.memory = "2048"
      vb.cpus = 2
      # However for more obscure virtualbox specific settings we fall back to virtualbox's "modifyvm" command:
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      # name of machine that appears on the vb console and vb consoles title.
      vb.name = "terraform"
    end

    terraform_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = "cp -f ${HOME}/.gitconfig ./personal-data/.gitconfig"
    end

    terraform_config.vm.provision "shell" do |s|
      s.inline = '[ -f /vagrant/personal-data/.gitconfig ] && runuser -l vagrant -c "cp -f /vagrant/personal-data/.gitconfig ~"'
    end

    ## Copy the public+private keys from the host machine to the guest machine
    terraform_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = "[ -f ${HOME}/.ssh/id_rsa ] && cp -f ${HOME}/.ssh/id_rsa* ./personal-data/"
    end
    terraform_config.vm.provision "shell", path: "scripts/import-ssh-keys.sh"

    terraform_config.vm.provision "shell", path: "scripts/install-terraform.sh"
    terraform_config.vm.provision "shell", path: "scripts/update-git.sh"
    terraform_config.vm.provision "shell", path: "scripts/install-vim-terraform-plugins.sh", privileged: false
    # for some reason I have to restart network, but this needs more investigation
    terraform_config.vm.provision "shell" do |remote_shell|
      remote_shell.inline = "systemctl restart network"
    end

    # this takes a vm snapshot (which we have called "basline") as the last step of "vagrant up".
    terraform_config.vm.provision :host_shell do |host_shell|
      host_shell.inline = 'vagrant snapshot take puppet4master baseline'
    end

  end

end
