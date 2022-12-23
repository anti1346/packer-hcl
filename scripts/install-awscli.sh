#!/bin/bash

os_distribution=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
if [ "$os_distribution" == "Amazon" ]; then
    sudo cd /home/ec2-user/
elif [ "$os_distribution" == "Ubuntu" ]; then
    sudo apt-get update
    sudo apt-get install -y unzip
    sudo -i
    cd /home/ubuntu/
else
    sudo echo "other operating system distribution"
fi

sudo curl -SsL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo rm -rf /home/ec2-user/awscliv2.zip /home/ec2-user/aws
sudo rm -rf /home/ubuntu/awscliv2.zip /home/ubuntu/aws
