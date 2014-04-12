#!/bin/bash
# A small simple script to start tor
# Eh, will work better and be prettier when iptables redirect works

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

if [ -f /usr/bin/tor ]
then
  /usr/bin/tor -f /usr/local/etc/tor/torrc
else
  /usr/local/bin/tor -f /usr/local/etc/tor/torrc
fi
 
exit 0
