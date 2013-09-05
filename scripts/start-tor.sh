#!/bin/bash
# A small simple script to start tor
# Eh, will work better and be prettier when iptables redirect works

if [ -f /usr/local/bin/tor ]
then
  chown -R root /usr/local/etc/tor /usr/local/var/lib/tor
fi
#su - tor -c "/usr/local/bin/tor"
/usr/local/bin/tor -f /usr/local/etc/tor/torrc
exit 0
