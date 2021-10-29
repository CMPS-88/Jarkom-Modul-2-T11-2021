#!/bin/bash

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.47.0.0/16
cat /etc/resolv.conf
apt-get install nano
