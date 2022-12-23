#!/bin/bash

echo "script ==> amazon2 : nginx 1.22.0, PHP 8.1.12"

sudo yum update -y

sudo amazon-linux-extras install -y nginx1
sudo systemctl --now enable nginx

sudo amazon-linux-extras enable php8.1
sudo yum clean metadata
sudo yum install -y php-cli php-fpm php-common php-pdo php-json php-mysqlnd
sudo yum install -y php-gd php-mbstring php-xml php-intl
sudo systemctl --now enable php-fpm


#echo "<?php phpinfo(); ?>" > /usr/share/nginx/html/phpinfo.php

#systemctl restart nginx php-fpm