#!/bin/bash

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get install nano
apt-get update
apt-get install bind9 -y
echo -e 'zone "franky.t11.com" {\n    type master;\n    notify yes;\n    also-notify { 10.47.2.3; };\n    allow-transfer { 10.47.2.3; };\n    file "/etc/bind/kaizoku/franky.t11.com";\n};' >> /etc/bind/named.conf.local 
mkdir /etc/bind/kaizoku
cp /etc/bind/db.local /etc/bind/kaizoku/franky.t11.com
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      franky.t11.com.\n@       IN      A       10.47.2.2\nwww       IN      CNAME       franky.t11.com.\nsuper       IN      A       10.47.2.4\nwww.super       IN      CNAME       super.franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/franky.t11.com
echo -e 'zone "2.47.10.in-addr.arpa" {\n\ttype master;\n\tfile "/etc/bind/kaizoku/2.47.10.in-addr.arpa";\n};' >> /etc/bind/named.conf.local
cp /etc/bind/db.local /etc/bind/kaizoku/2.47.10.in-addr.arpa
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL\t604800\n@       IN      SOA     franky.t11.com. root.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n2.47.10.in-addr.arpa.       IN      NS      franky.t11.com.\n2           IN      PTR franky.t11.com.\n@       IN      AAAA    ::1' > /etc/bind/kaizoku/2.47.10.in-addr.arpa
sed -i "17ins1             IN      A       10.47.2.3" /etc/bind/kaizoku/franky.t11.com
sed -i "18imecha           IN      NS      ns1" /etc/bind/kaizoku/franky.t11.com
sed -i "s_dnssec-validation auto;_//dnssec-validation auto;_g" /etc/bind/named.conf.options
sed -i "22i     allow-query{any;};" /etc/bind/named.conf.options
service bind9 restart
apt-get install apache2 -y
service apache2 start
apt-get install git -y
git config --global http.sslVerify false
git clone https://github.com/FeinardSlim/Praktikum-Modul-2-Jarkom.git
apt-get install unzip -y
unzip Praktikum-Modul-2-Jarkom/franky.zip
unzip Praktikum-Modul-2-Jarkom/general.mecha.franky.zip
unzip Praktikum-Modul-2-Jarkom/super.franky.zip
mkdir /var/www/franky.t11.com
mv franky/* /var/www/franky.t11.com
apt-get install libapache2-mod-php7.0 -y
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/franky.t11.com.conf
sed -i "s_DocumentRoot /var/www/html_DocumentRoot /var/www/franky.t11.com_g" /etc/apache2/sites-available/franky.t11.com.conf
sed -i "14iServerName franky.t11.com" /etc/apache2/sites-available/franky.t11.com.conf
sed -i "15iServerAlias www.franky.t11.com" /etc/apache2/sites-available/franky.t11.com.conf
sed -i '16iAlias "/home" "/var/www/franky.t11.com/index.php/home"' /etc/apache2/sites-available/franky.t11.com.conf
a2ensite franky.t11.com.conf
service apache2 restart
