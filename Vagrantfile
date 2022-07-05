$base = <<-SCRIPT
# clean up
yum clean all

# setup hashi repo
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# install nomad and python
yum -y install nomad python39 nmap-ncat tree

# setup nomad
rm -fr /etc/nomad.d/*
mkdir -p /opt/nomad/{server,alloc,client}

# setup ansible
pip3 install ansible-core
SCRIPT

$server = <<-SCRIPT
cp /vagrant/nomad.server.service /etc/systemd/system/nomad.service
cp /vagrant/nomad.server.hcl /etc/nomad.d/nomad.hcl
systemctl daemon-reload
systemctl start nomad.service
SCRIPT

$client = <<-SCRIPT
cp /vagrant/nomad.client.service /etc/systemd/system/nomad.service
cp /vagrant/nomad.client.hcl /etc/nomad.d/nomad.hcl
systemctl daemon-reload
systemctl start nomad.service
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.define "server" do |s|
    s.vm.box = "bento/rockylinux-8"
    s.vm.hostname = "server"

    s.vm.provider "parallels" do |v|
      v.memory = 2048
      v.cpus = 1
    end

    s.vm.network :private_network, ip: "192.168.10.10"
    s.vm.network "forwarded_port", guest: 4646, host: 4646

    s.vm.provision "shell", inline: $base
    s.vm.provision "shell", inline: $server
  end

  config.vm.define "client" do |c|
    c.vm.box = "bento/rockylinux-8"
    c.vm.hostname = "client"

    c.vm.provider "parallels" do |v|
      v.memory = 2048
      v.cpus = 1
    end

    c.vm.network :private_network, ip: "192.168.10.20"
    c.vm.network "forwarded_port", guest: 4646, host: 5646

    c.vm.provision "shell", inline: $base
    c.vm.provision "shell", inline: $client
  end
end