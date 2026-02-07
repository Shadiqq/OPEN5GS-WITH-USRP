#!/bin/bash

# Interface internet (ubah sesuai punyamu, misal eth0 / wlan0 / enp0s3)
IFACE="eth0"

echo "Enable IP Forwarding..."
sysctl -w net.ipv4.ip_forward=1

echo "Flush iptables lama..."
iptables -F
iptables -t nat -F

echo "Set NAT internet sharing..."
iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE

echo "Allow forwarding trafik UE..."
iptables -A FORWARD -i ogstun -o $IFACE -j ACCEPT
iptables -A FORWARD -i $IFACE -o ogstun -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "Done. Iptables ready."

