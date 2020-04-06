# Ubuntu 16.04 Vagrant box with PHP 7.3 LAMP

Simple LAMP environment inside Vagrant box. Based on official `ubuntu/xenial64` box.

## In the box:

- Ubuntu 16.04
- Apache 2.4
- MySQL 5.7
- PHP 7.3
- Node.js 12.x (with NPM)

### Additionally installed:

- phpMyAdmin
- Git
- Composer
- Yarn

## Some other improvement:

- Themed web directory in index.php
- Improved php.ini (`upload_max_filesize, post_max_size, memory_limit, error_reporting, display_errors`)
- fixed bug phpMyAdmin on file plugin_interface.lib.php


## How to set up:

Assuming that VirtualBox (https://www.virtualbox.org/) and Vagrant (https://www.vagrantup.com/) are already installed on your computer.

1. Clone or download + unzip repository 
2. In your terminal go to the directory and type `vagrant up`
3. Wait for installation progress
4. Enjoy

## Credentials

`phpMyAdmin` is accessible at http://192.168.33.10/phpmyadmin/ Username is 'root', password - 'root'