#!/bin/bash

echo "script ==> ubuntu : nginx 1.23.3, PHP 8.1.13"

sudo apt-get update
sudo apt-get install -y curl wget gnupg2 apt-transport-https ca-certificates lsb-release ubuntu-keyring software-properties-common

sudo curl -fSsL https://nginx.org/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
sudo echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl --now enable nginx

sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php8.1 php8.1-fpm php8.1-common php8.1-cli
sudo apt-get install -y php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-imap php8.1-mbstring php8.1-soap php8.1-zip php8.1-redis php8.1-intl
sudo systemctl --now enable php8.1-fpm


# sudo echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/phpinfo.php

# sudo systemctl restart nginx php8.1-fpm