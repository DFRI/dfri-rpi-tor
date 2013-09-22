#!/bin/bash
NETWORK="$(/root/scripts/check-ipsubnet.sh $(ifconfig eth0 | awk '{ print $2, $NF }' | sed -e 's/addr://g' -e 's/Mask://g')"
echo "sshd: $NETWORK" >> /etc/hosts.allow

