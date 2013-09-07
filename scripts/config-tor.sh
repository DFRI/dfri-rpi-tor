#!/bin/bash
# Description
# This script will do what we need to configure the tor-node

# Fetch 1MB-file to do a crude bandwitdh-test
SPEED=$(wget https://www.dfri.se/files/1Mb.file -O /dev/null 2>&1 | awk '$0 ~ /saved/ { print $3 }' | sed 's/(//g')
SPEED=$(perl -E "say ${SPEED}*1024/2.8/8" | sed 's/\..*$//g')

# Default port
MYPORT=443

# Check IP
MYIP=$(ifconfig | awk '$0 ~ /inet/ && $0 !~ /127\.0\.0\.1/ { print $2 }' | sed 's/addr://g' | head -1)

# Verify if its a private IP
if [ "$(/root/scripts/check-iptype.pl ${MYIP})" = "PRIVATE" ]
then 
  # Its a private IP, let's try to do some upnp-magic so we dont have to do portforwarding
  upnpc -a $MYIP $MYPORT $MYPORT TCP 2>&1 > /dev/null
fi

# Check so that config-directory exists
if [ ! -d /usr/local/etc/tor ]
then
  mkdir -p /usr/local/etc/tor
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
