HOSTNAME   = "pdc"
$adminpass = "P@ssw0rd"
$FQDN      = "test.lan"
$NetBIOS   = "TEST"

required_plugins = %w( vagrant-reload vagrant-vbguest )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure("2") do |config|

    config.vm.define HOSTNAME do |master|

        master.vm.provider "virtualbox" do |vb, override|
          vb.name = HOSTNAME
          vb.customize ["modifyvm", :id, "--memory", 4096]
          vb.customize ["modifyvm", :id, "--cpus", 2]
          vb.customize ["modifyvm", :id, "--vram", "32"]
          vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
          vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
        end

        master.vm.box = "detectionlab/win2016"
        master.vm.hostname = HOSTNAME
        master.vm.guest = :windows
        master.vm.boot_timeout = 600
        master.vm.communicator = "winrm"
        master.winrm.transport = :plaintext
        master.winrm.basic_auth_only = true
        master.winrm.username = "vagrant"
        master.winrm.password = "vagrant"
        master.winrm.timeout = 300
        master.winrm.retry_limit = 20

        master.vm.network :private_network, ip: "10.50.10.100", gateway: "10.50.10.1", dns: "10.50.10.100"
        master.vm.provision "shell", path: "files/fix-second-network.ps1", privileged: true, args: "-ip 10.50.10.100 -dns 10.50.10.100"
        master.vm.provision "shell", path: "files/pre-install.ps1", privileged: true, args: $adminpass
        master.vm.provision "shell", path: "files/bootstrap.ps1", privileged: true, args: [$adminpass, $FQDN, $NetBIOS]
        master.vm.provision :reload
    end

	config.vm.define "jenkins" do |node|
		node.vm.provider "virtualbox" do |v|
			v.name = "jenkins"
			v.memory = 2048
			v.cpus = 2
		end
		node.vm.box = "generic/debian10"
		node.vm.network "private_network", ip: "10.50.10.10", gateway: "10.50.10.1", dns: "10.50.10.100"
		node.vm.hostname = "jenkins"
		node.vm.synced_folder ".", "/vagrant", type: "virtualbox"
		node.vm.provision :shell, path: "./files/user.sh", args: "appuser"
		node.vm.provision :shell, privileged: true, path: "./files/vm-route.sh"
		node.vm.provision :shell, path: "./files/install.sh"
		node.vm.provision :shell, privileged: true, inline: <<-SHELL
				mkdir -p /var/lib/jenkins/init.groovy.d
				cp /vagrant/files/conf/* /var/lib/jenkins/init.groovy.d/
				chown jenkins:jenkins -R /var/lib/jenkins/init.groovy.d
				service jenkins force-reload				
		SHELL
		node.vm.provision :shell, privileged: true, path: "./files/post-install.sh"
	end

end