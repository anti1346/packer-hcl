#!/bin/bash

# Determine the Linux distribution
os_distribution=$(grep -oP '(?<=^PRETTY_NAME=")(.*)(?=")' /etc/os-release)

case "$os_distribution" in
  "Amazon Linux")
    home_dir="/home/ec2-user"
    ;;
  "Ubuntu")
    home_dir="/home/ubuntu"
    apt-get update
    apt-get install -y unzip
    ;;
  *)
    echo "Other operating system distribution"
    exit 1
    ;;
esac

# Install AWS CLI
curl -SsL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# Clean up
rm -rf "$home_dir/awscliv2.zip" "$home_dir/aws"
