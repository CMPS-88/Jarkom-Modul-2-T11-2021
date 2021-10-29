#!/bin/bash

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get install nano
apt-get install apache2 -y
service apache2 start
apt-get install git -y
git config --global http.sslVerify false
git clone https://github.com/FeinardSlim/Praktikum-Modul-2-Jarkom.git
apt-get install unzip -y
unzip Praktikum-Modul-2-Jarkom/franky.zip
unzip Praktikum-Modul-2-Jarkom/general.mecha.franky.zip
unzip Praktikum-Modul-2-Jarkom/super.franky.zip
mkdir /var/www/super.franky.t11.com
mv super.franky/* /var/www/super.franky.t11.com
apt-get install libapache2-mod-php7.0 -y
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/super.franky.t11.com_g" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "14iServerName super.franky.t11.com" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "15iServerAlias www.super.franky.t11.com" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "16i<Directory /var/www/super.franky.t11.com/public>\n    Options +Indexes\n</Directory>" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "19i<Directory /var/www/super.franky.t11.com/error>\n    Options -Indexes\n</Directory>" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i "22iErrorDocument 404 /error/404.html" /etc/apache2/sites-available/super.franky.t11.com.conf
sed -i '23iAlias "/js" "/var/www/super.franky.t11.com/public/js"' /etc/apache2/sites-available/super.franky.t11.com.conf
a2ensite super.franky.t11.com.conf
mkdir /var/www/general.mecha.franky.t11
mkdir /var/www/general.mecha.franky.t11/file
mv general.mecha.franky/* /var/www/general.mecha.franky.t11/file
echo -e '<?php\nif (isset($_POST["submit"])) {\n$username = $_POST["username"];\n$password = $_POST["password"];\nif ($username == "luffy" && $password == "onepiece"){\nheader("Location: http://www.general.mecha.franky.t11.com:15000/file");\ndie();\n}\nelse {\necho "salah";\n}\n}\n?>\n<!DOCTYPE html>\n<html>\n<head>\n<title>Form</title>\n</head>\n<body>\n<form action = "" method = "post">\nusername : <input type = "text" name = "username"/>\n<br><br>\npassword : <input type = "password" name = "password"/>\n<br><br>\n<input type = "submit" name = "submit" value = "Submit">\n</form>\n</body>\n</html>' > /var/www/general.mecha.franky.t11/index.php
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/general.mecha.franky.t11_g" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i 1d /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "1i<VirtualHost *:15000>" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "14iServerName general.mecha.franky.t11.com" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
sed -i "15iServerAlias www.general.mecha.franky.t11.com" /etc/apache2/sites-available/15000-general.mecha.franky.t11.com.conf
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/general.mecha.franky.t11_g" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i 1d /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "1i<VirtualHost *:15500>" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "14iServerName general.mecha.franky.t11.com" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "15iServerAlias www.general.mecha.franky.t11.com" /etc/apache2/sites-available/15500-general.mecha.franky.t11.com.conf
sed -i "6iListen 15000" /etc/apache2/ports.conf
sed -i "7iListen 15500" /etc/apache2/ports.conf
a2ensite 15000-general.mecha.franky.t11.com.conf
a2ensite 15500-general.mecha.franky.t11.com.conf
echo -e "<VirtualHost *:80>\nServerName 10.47.2.4\nRedirect permanent / http://www.franky.t11.com/\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf
a2enmod rewrite
service apache2 restart
touch /var/www/super.franky.t11.com/.htaccess
echo -e "RewriteEngine On\nRewriteCond %{REQUEST_URI} !^/public/images/franky.png$\nRewriteCond %{REQUEST_FILENAME} !-d \nRewriteRule ^(.*)franky(.*)$ http://super.franky.t11.com/public/images/franky.png [R=301,L]" > /var/www/super.franky.t11.com/.htaccess
sed -i "22i<Directory /var/www/super.franky.t11.com>\n     Options +FollowSymLinks -Multiviews\n     AllowOverride All\n </Directory>" /etc/apache2/sites-available/super.franky.t11.com.conf
service apache2 restart
