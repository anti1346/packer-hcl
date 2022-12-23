#!/bin/bash

os_distribution=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
if [ "$os_distribution" == "Amazon" ]; then
    sudo yum update
    echo "script ==> Amazon"
elif [ "$os_distribution" == "Ubuntu" ]; then
    sudo apt-get update
    echo "script ==> Ubuntu"
else
    sudo echo "other operating system distribution"
fi

sudo timedatectl set-timezone Asia/Seoul