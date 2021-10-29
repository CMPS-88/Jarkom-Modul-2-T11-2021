#!/bin/bash

echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get install nano
sed -i "1inameserver 10.47.2.2" /etc/resolv.conf
apt-get update -y
apt-get install dnsutils -y
host -t PTR 10.47.2.2
sed -i "2inameserver 10.47.2.3" /etc/resolv.conf
apt-get install lynx -y
