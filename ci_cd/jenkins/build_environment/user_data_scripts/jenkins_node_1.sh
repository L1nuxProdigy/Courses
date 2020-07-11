#!/bin/bash
#### changing hostname
hostnamectl set-hostname jenkins_node_1

## installing java
apt update -y
apt install openjdk-8-jdk -y