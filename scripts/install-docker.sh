#!/bin/bash

os_distribution=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
if [ "$os_distribution" == "Amazon" ]; then
    echo "docker ==> verser 20.10.17"
    sudo cd /home/ec2-user/
    sudo amazon-linux-extras install -y docker
    sudo systemctl --now enable docker
    sudo usermod -aG docker ec2-user
    sudo chmod 666 /var/run/docker.sock
elif [ "$os_distribution" == "Ubuntu" ]; then
    echo "docker ==> verser 20.10.22"
    sudo apt-get update
    sudo -i
    cd /home/ubuntu/
    sudo apt-get install -y curl apt-transport-https ca-certificates software-properties-common
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo systemctl --now enable docker
    sudo usermod -aG docker ubuntu
    sudo chmod 666 /var/run/docker.sock
else
    sudo echo "other operating system distribution"
fi