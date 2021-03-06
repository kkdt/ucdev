# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  config.ssh.forward_x11 = true
  config.ssh.insert_key = false
  config.ssh.keep_alive = true

  Dir.glob('servers/*.json') do |file|
    json = (JSON.parse(File.read(file)))['server']
    id = json.has_key?("id") ? json["id"] : "vagrant"
    hostname = json.has_key?("hostname") ? json["hostname"] : "vagrant"
    memory = json.has_key?("memory") ? json["memory"] : 512
    cpus = json.has_key?("cpus") ? json["cpus"] : 1

    config.vm.define id do |server|
      server.vm.box = json['box']
      server.vm.hostname = hostname
      server.vm.define id

      server.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.name = id
        vb.memory = memory
        vb.cpus = cpus
      end
    end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provision "sshd", type: "shell", inline: <<-SHELL
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart
  SHELL

  # Software to to provision with Vagrant but is default disabled

  # https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
  config.vm.provision "ansible", run: "never", type: "shell", inline: <<-SHELL
    apt install software-properties-common
    add-apt-repository --yes --update ppa:ansible/ansible
    apt install -y ansible
  SHELL

  config.vm.provision "virtualbox", run: "never", type: "shell", inline: <<-SHELL
    curl -fsSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) main"
    sudo apt-get update -y && sudo apt-get install -y virtualbox
  SHELL

  config.vm.provision "vagrant", run: "never", type: "shell", inline: <<-SHELL
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update -y && sudo apt-get install vagrant
  SHELL

end
