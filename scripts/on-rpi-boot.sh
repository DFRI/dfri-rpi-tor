#!/bin/bash
NETWORK="$(/root/scripts/check-ipsubnet.sh $(ifconfig eth0 | awk '$0 ~ /Bcast/ { print $2, $NF }' | sed -e 's/addr://g' -e 's/Mask://g'))"
grep -v ^sshd: /etc/hosts.allow > /etc/hosts.allow-new
mv /etc/hosts.allow-new /etc/hosts.allow
echo "sshd: $NETWORK" >> /etc/hosts.allow

