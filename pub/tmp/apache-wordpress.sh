# !/bin/sh

echo "installation php"
sudo apt -y install lsb-release apt-transport-https ca-certificates

sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

echo "ajout du repository"
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt update
sudo apt install php7.4

echo "version de php :"
php -v

echo "Installation apache et php"
sudo apt install apache2 php7.4 libapache2-mod-php7.4 php7.4-common php7.4-mbstring php7.4-xmlrpc php7.4-soap php7.4-gd php7.4-xml php7.4-intl php7.4-mysql php7.4-cli php7.4-ldap php7.4-zip php7.4-curl

sudo a2enmod proxy_fcgi setenvif
sudo a2enconf php7.4-fpm

echo "redemarrage de Apache"
sudo systemctl restart apache2

echo "creation de /var/www/html/test.php"
echo "<?php
phpinfo();
?>" > /var/www/html/test.php


