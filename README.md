# Test infrastructure Windows AD vs Jenkins

[![License](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)](https://opensource.org/licenses/MIT)

<img
src="https://cdn.imgbin.com/11/20/3/imgbin-vagrant-hashicorp-virtual-machine-software-developer-installation-vagrant-ywTTwLKhjrGBxXiPdJNgpkc9D.jpg"
height=48 width=48 alt="Vagrant Logo" /> <img
src="https://c7.hotpng.com/preview/180/365/308/jenkins-devops-continuous-integration-software-development-installation-selenium.jpg"
height=48 width=48 alt="Jenkins Logo" />

1. На хосте должны быть установлены [Vagrant](https://www.vagrantup.com/downloads.html) и [VirtualBOX](https://www.virtualbox.org/wiki/Downloads) c Oracle VM VirtualBox Extension Pack.<br>
2. После клонирования репозитория, перейти в него и запустить проект:<br>
PS. Для запуска проекта, нужно создать папку ***.sshkey*** по пути  ./files и в неё сгенерировать пару SSH ключей с именами ***appuser.pem*** и ***appuser.pub***.
```
git clone https://github.com/Dethroner/test-jw.git
cd test-jw
vagrant up
```