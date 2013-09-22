#!/bin/bash
# A small simple script to start tor
# Eh, will work better and be prettier when iptables redirect works

#
NETWORK="192.168.1.0/24"
grep -v ^sshd: /etc/hosts.allow > /etc/hosts.allow.new
mv /etc/hosts.allow.new /etc/hosts.allow
echo "sshd: $NETWORK" >> /etc/hosts.allow

if [ -f /usr/local/bin/tor ]
then
  chown -R root /usr/local/etc/tor /usr/local/var/lib/tor
fi
#su - tor -c "/usr/local/bin/tor"
/usr/local/bin/tor -f /usr/local/etc/tor/torrc
exit 0
