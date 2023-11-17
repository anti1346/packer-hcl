#!/bin/bash

# 파일 경로 상수 정의
Initialize_Files="/tmp/Initialize_Files"
NGINX_CONF_DIR="/etc/nginx"
PHP_FPM_CONF_DIR="/etc/php-fpm.d"

# Nginx 설정 파일 복사
sudo cp -f $Initialize_Files/nginx/nginx.conf $NGINX_CONF_DIR/nginx.conf
sudo cp -f $Initialize_Files/nginx/fastcgi-php.conf $NGINX_CONF_DIR/fastcgi-php.conf
sudo cp -f $Initialize_Files/nginx/fastcgi.conf $NGINX_CONF_DIR/fastcgi.conf
sudo cp -f $Initialize_Files/nginx/conf.d/default.conf $NGINX_CONF_DIR/conf.d/default.conf

# PHP-FPM 설정 파일 복사
sudo cp -f $Initialize_Files/phpfpm/php.ini /etc/php.ini
sudo cp -f $Initialize_Files/phpfpm/php-fpm.conf /etc/php-fpm.conf
sudo cp -f $Initialize_Files/phpfpm/php-fpm.d/www.conf $PHP_FPM_CONF_DIR/www.conf
