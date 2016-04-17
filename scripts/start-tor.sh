#!/bin/bash
set -e

# A small simple script to start tor
# Eh, will work better and be prettier when iptables redirect works

# Ensure /usr/local/var/lib/tor exists
mkdir -p /usr/local/var/lib/tor

# Ensure tor owns all necessary files
chown -R tor:tor /usr/local/var/lib/tor /usr/local/etc/tor

if [ -x /usr/bin/tor ]
then
  /usr/bin/tor -f /usr/local/etc/tor/torrc
elif [ -x /usr/local/bin/tor ]
then
  /usr/local/bin/tor -f /usr/local/etc/tor/torrc
else
  echo 'No tor binary!' >&2
  exit 1
fi
 
exit 0
