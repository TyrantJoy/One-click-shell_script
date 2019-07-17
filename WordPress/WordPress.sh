#!/bin/bash

#配置Apache
yum install -y httpd
echo "DirectoryIndex index.php index.html" >> /etc/httpd/conf/httpd.conf
chown -Rf apache:apache /var/www/html/
systemctl start httpd && systemctl enable httpd


#配置Mysql/MariaDB
yum install -y mariadb-server mariadb
systemctl start mariadb && systemctl enable mariadb
mysql_secure_installation
mysql -u root -p -e "
create database wordpress;
grant all privileges on wordpress.* to 'wordpress'@'localhost' identified by 'wordpress';
grant all privileges on wordpress.* to 'wordpress'@'%' identified by 'wordpress';
show databases;
"


#配置PHP环境
yum install -y epel-release && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install php70w.x86_64 php70w-cli.x86_64 php70w-common.x86_64 php70w-gd.x86_64 php70w-ldap.x86_64 php70w-mbstring.x86_64 php70w-mcrypt.x86_64 php70w-mysql.x86_64 php70w-pdo.x86_64 -y


#下载安装wordpress
wget https://wordpress.org/latest.zip 
unzip latest.zip
cp -r wordpress/* /var/www/html/
chown -Rf apache:apache /var/www/html/
systemctl restart httpd
