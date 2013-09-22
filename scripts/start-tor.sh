#!/bin/bash
# A small simple script to start tor
# Eh, will work better and be prettier when iptables redirect works

# Small fix for ssh, will be removed from this script
NETWORK="192.168.1.0/24"
grep -v ^sshd: /etc/hosts.allow > /etc/hosts.allow.new
mv /etc/hosts.allow.new /etc/hosts.allow
echo "sshd: $NETWORK" >> /etc/hosts.allow

# Make sure that /usr/local/var/lib/tor exists
if [ ! -d "/usr/local/var/lib/tor" ]
then
  mkdir -p /usr/local/var/lib/tor
fi

# Make sure we have the correct access rights
if [ "$(stat -c %U /usr/local/var/lib/tor)" != "tor" ]
then
  chown -R tor:tor /usr/local/var/lib/tor /usr/local/etc/tor
fi

/usr/local/bin/tor -f /usr/local/etc/tor/torrc
exit 0
