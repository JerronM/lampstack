#!/bin/bash
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
systemctl restart apache2
sleep 1
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
#Install MySQL
sudo apt-get install mysql-server
ufw enable
ufw allow mysql
systemctl start mysql
systemctl enable mysql
#Change root password
mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('123') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF
sleep 1

xdg-open "http://localhost"
xdg-open "http://localhost/info.php"

f_sub_main () {
    f_update_os
}


exit



#To convert DOS line endings to UNIX if it wont run (^M bad interpreter error)
#sed -i -e 's/\r$//'
