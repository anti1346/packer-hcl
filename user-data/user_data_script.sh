#!/bin/bash

os_distribution=$(grep "PRETTY_NAME" /etc/os-release | sed 's/PRETTY_NAME=//g; s/["]//g' | awk '{print $1}')

case "$os_distribution" in
  Amazon)
    #sudo yum update
    echo "Script ==> Amazon"
    ;;
  Ubuntu)
    sudo apt-get update
    echo "Script ==> Ubuntu"
    ;;
  *)
    echo "Other operating system distribution"
    ;;
esac

sudo timedatectl set-timezone Asia/Seoul

sudo systemctl restart chronyd.service

sudo systemctl restart zabbix-agent

sudo systemctl restart nginx.service
sudo systemctl restart php-fpm.service

sudo systemctl restart amazon-cloudwatch-agent.service
sudo systemctl restart codedeploy-agent.service
