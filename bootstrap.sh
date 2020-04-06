#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='root'
PHP_INI_FILE=/etc/php/7.3/apache2/php.ini

# update / upgrade packages
apt-get update
apt-get upgrade

# install apache
apt-get install -y apache2

# install PPA 'ondrej/php'. The PPA is well known, and is relatively safe to use.
add-apt-repository -y ppa:ondrej/php
apt-get update

# installing php7.3 and php modules
apt-get install -y --allow-unauthenticated php7.3 php7.3-cli php7.3-common libapache2-mod-php7.3 php7.3-fpm php7.3-curl php7.3-gd php7.3-bz2 php7.3-json php7.3-tidy php7.3-mbstring php-redis php-memcached php7.3-sqlite3 php7.3-xml php7.3-zip php7.3-readline php7.3-intl php7.3-bcmath php7.3-xmlrpc php7.3-recode php7.3-imagick php7.3-mysql

# install mysql and give password to installer
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"

apt-get install -y mysql-server

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
apt-get install -y phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    <Directory /var/www/html>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
a2enmod rewrite

# restart apache
service apache2 restart

# restart mysql
service mysql restart

# install git
apt-get install -y git

# install Composer
apt-get install -y composer

# install NodeJS and NPM
# this line won't work without sudo, 
# so I decided to add sudo to rest of the commands begin on this line
sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# install yarn
sudo npm install -g yarn

# disable release-upgrade notification
sudo chmod -x /etc/update-motd.d/91-release-upgrade

# change some php.ini file
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" $PHP_INI_FILE
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" $PHP_INI_FILE
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" $PHP_INI_FILE
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL | E_STRICT/" $PHP_INI_FILE
sudo sed -i "s/display_errors = .*/display_errors = On/" $PHP_INI_FILE

# fix bug phpMyAdmin on file plugin_interface.lib.php
sudo sed -i '/if ($options != null && count($options) > 0)/c\if ($options != null && count((array)$options) > 0) {' /usr/share/phpmyadmin/libraries/plugin_interface.lib.php

# restart apache
sudo service apache2 restart