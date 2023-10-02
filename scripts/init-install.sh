#!/bin/bash

echo "script ==> START"
sleep 5

### nginx 1.24
echo "script ==> amazon2 : nginx 1.24"
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/aws/al2023-nginx.sh | sudo bash
sleep 5

### php-fpm 8.1
echo "script ==> amazon2 : PHP 8.1"
curl -fsSL https://raw.githubusercontent.com/anti1346/zz/main/aws/al2023-phpfpm.sh | sudo bash
sleep 5

# /etc/nginx/nginx.conf
# /etc/nginx/conf.d/
#systemctl restart nginx php-fpm

sudo timedatectl set-timezone Asia/Seoul
