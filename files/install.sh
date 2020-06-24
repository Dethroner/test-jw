#!/bin/bash
##################################################
# Install Jenkins                                #
# Author by Dethroner, 2020                      #
##################################################

### Vars
FQDN=test.lan
USER=admin
PASS=123

### Pre-Install postfix
debconf-set-selections <<< "postfix postfix/mailname string $FQDN"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt install --assume-yes postfix

### Install packages
apt update && apt upgrade -y
apt install -y apt-transport-https gnupg default-jre default-jdk unzip

### Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y jenkins
sleep 1m
cd /opt
wget http://10.50.10.10:8080/jnlpJars/jenkins-cli.jar
sudo echo "sudo echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount(\"$USER\", \"$PASS\")' | sudo java -jar /opt/jenkins-cli.jar -s http://localhost:8080/ -auth \"$USER:$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)\" groovy =" | sudo tee -a /tmp/1
sudo chmod +x /tmp/1 && sudo sh /tmp/1 && sudo rm -R /tmp/1
sleep 1m