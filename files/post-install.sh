#!/bin/bash
##################################################
# Install Jenkins                                #
# Author by Dethroner, 2020                      #
##################################################

### Add private key into GitLab
cp /home/appuser/.ssh/appuser /var/lib/jenkins/secrets/
chown jenkins:jenkins /var/lib/jenkins/secrets/appuser

### Fix maven repository
mkdir /var/lib/jenkins/.m2
cat <<EOF | tee /var/lib/jenkins/.m2/settings.xml
<settings>
	<mirrors>
		<mirror>
			<id>mavenCentralHttps</id>
			<mirrorOf>central</mirrorOf>
			<name>Maven central https</name>
			<url>https://repo1.maven.org/maven2</url>
		</mirror>
	</mirrors>
</settings>
EOF
chown jenkins:jenkins -R /var/lib/jenkins/.m2

### JDK install
mkdir -p /var/lib/jenkins/tools/hudson.model.JDK/jdk7
mkdir -p /var/lib/jenkins/tools/hudson.model.JDK/jdk8
mkdir -p /var/lib/jenkins/tools/hudson.model.JDK/jdk11
cd /var/lib/jenkins/tools/hudson.model.JDK/jdk7
wget https://mirrors.huaweicloud.com/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz
tar xzf jdk-7u80-linux-x64.tar.gz && rm -rf *.tar.gz
cd /var/lib/jenkins/tools/hudson.model.JDK/jdk8
wget http://ghaffarian.net/downloads/Java/jdk-8u202-linux-x64.tar.gz
tar xzf jdk-8u202-linux-x64.tar.gz && rm -rf *.tar.gz
cd /var/lib/jenkins/tools/hudson.model.JDK/jdk11
wget https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
tar xzf openjdk-11.0.1_linux-x64_bin.tar.gz && rm -rf *.tar.gz
chown jenkins:jenkins -R /var/lib/jenkins/tools

### NGINX
apt install -y nginx
cp /vagrant/files/jenkins /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
systemctl enable nginx
systemctl restart nginx 
