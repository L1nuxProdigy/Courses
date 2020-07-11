#!/bin/bash
#### changing hostname
hostnamectl set-hostname jenkins_master

## installing java
apt update -y
apt install openjdk-8-jdk -y

# installing altest version
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get -y update
sudo apt-get -y install jenkins

# installing specific version
# wget https://pkg.jenkins.io/debian-stable/binary/jenkins_2.204.1_all.deb
# apt install ./jenkins_2.204.1_all.deb -y
# echo ""
# #dpkg -i jenkins_2.204.1_all.deb