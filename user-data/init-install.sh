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
