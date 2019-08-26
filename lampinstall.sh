#!/bin/bash
# Check if user is Root
f_check_root () {
if (( $EUID == 0 )); then
    # If user is root, continue to function f_sub_main
    f_sub_main
else
    # If user not is root, print message and exit script
    echo "Please run this script by user root !"
    exit
fi
}

# Update OS
f_update_os () {
    echo "Starting update os ..."
    sleep 1
    apt-get update
    apt-get upgrade -y
    echo ""
    sleep 1
}
#Install Apache
apt update
apt install apache2 mysql-server php php-mysql libapache2-mod-php php-cli
systemctl enable apache2
systemctl start apache2
ufw allow in "Apache Full"
chmod -R 0755 /var/www/html/
sleep 1
#Install PHP7
apt-get install php7.0 php7.0-fpm php7.0-gd php7.0-mysql -y
# To enable PHP7.0 in Apache2
a2enmod proxy_fcgi setenvif
a2enconf php7.0-fpm
systemctl restart apache2
sleep 1
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
#Install MySQL
echo "mysql-server-5.5 mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password root" | debconf-set-selections
apt-get -y install mysql-server-5.5
sleep 1

f_sub_main () {
    f_update_os
    f_install_lamp
}

f_main () {
    f_check_root
}
f_main

exit