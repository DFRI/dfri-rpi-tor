#!/bin/bash
# Description
# This script will do what we need to configure the tor-node

set -eu
set -o pipefail

# Small temporary addition to make sure that we're running "update-scripts.sh" every time we boot the rpi
if [ "$(grep -c update-scripts.sh /etc/rc.local)" != "1" ]
then
  echo "/root/scripts/update-scripts.sh" >> /etc/rc.local
  /root/scripts/update-scripts.sh
  sleep 10
fi

# Fetch 1MB-file to do a crude bandwitdh-test
SPEED=$(perl -E "say $(wget https://www.dfri.se/files/1Mb.file -O /dev/null 2>&1 | awk '$0 ~ /saved/ { print $3 }' | sed 's/(//g')*1024/2.8" | sed 's/\..*$//g' || echo 1024)
if [ -z "$SPEED" ]
then
  SPEED=1024
fi
declare -ri SPEED

# Default port
declare -ri MYPORT=443

# Check IP
MYIP=$(ifconfig | awk '$0 ~ /inet/ && $0 !~ /127\.0\.0\.1/ { print $2 }' | sed 's/addr://g' | head -1)
declare -r MYIP

# Verify if its a private IP
if [ "$(/root/scripts/check-iptype.pl ${MYIP})" = 'PRIVATE' ]
then 
  # Its a private IP, let's try to do some upnp-magic so we dont have to do portforwarding
  upnpc -a "$MYIP" "$MYPORT" "$MYPORT" TCP 2>&1 > /dev/null
fi

# Ensure config-directory exists
mkdir -p /usr/local/etc/tor

# If a local config-file exist, source it and let its variables override our own settings
if [ -f /home/pi/.dfripi/tor-config ]
then
  source /home/pi/.dfripi/tor-config
fi

# Setup config
cat > /usr/local/etc/tor/torrc <<EOF
RunAsDaemon 1
Nickname $HOSTNAME
User tor
ORPort $MYPORT
BandwidthRate $SPEED KB 
BandwidthBurst $SPEED KB
ContactInfo DFRI <rpitor AT dfri dot se>
DataDirectory /usr/local/var/lib/tor
AvoidDiskWrites 1
ExitPolicy reject *:* # no exits allowed
EOF
exit 0
