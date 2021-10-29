#!/bin/bash

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get install nano
apt-get update -y
apt-get install bind9 -y
echo -e 'zone "franky.t11.com" {\n    type slave;\n    masters { 10.47.2.2; };\n    file "/var/lib/bind/franky.t11.com";\n};' >> /etc/bind/named.conf.local
sed -i "s_dnssec-validation auto;_//dnssec-validation auto;_g" /etc/bind/named.conf.options
sed -i "22i     allow-query{any;};" /etc/bind/named.conf.options
sed -i '8izone "mecha.franky.t11.com" {\n        type master;\n        file "/etc/bind/sunnygo/mecha.franky.t11.com";\n};' /etc/bind/named.conf.local
mkdir /etc/bind/sunnygo
cp /etc/bind/db.local /etc/bind/sunnygo/mecha.franky.t11.com
echo -e ';\n; BIND data file for local loopback interface\n;\n$TTL    604800\n@       IN      SOA     mecha.franky.t11.com. root.mecha.franky.t11.com. (\n                              2         ; Serial\n                         604800         ; Refresh\n                          86400         ; Retry\n                        2419200         ; Expire\n                         604800 )       ; Negative Cache TTL\n;\n@       IN      NS      mecha.franky.t11.com.\n@       IN      A       10.47.2.4\n@       IN      AAAA    ::1' > /etc/bind/sunnygo/mecha.franky.t11.com
sed -i "14iwww     IN      CNAME   mecha.franky.t11.com." /etc/bind/sunnygo/mecha.franky.t11.com
sed -i "15igeneral IN      A       10.47.2.4" /etc/bind/sunnygo/mecha.franky.t11.com
sed -i "16iwww.general     IN      CNAME   general.mecha.franky.t11.com." /etc/bind/sunnygo/mecha.franky.t11.com
service bind9 restart
