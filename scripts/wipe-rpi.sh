#!/bin/bash
# This will remove the node-specific stuff from the rpi
rm -rf /etc/ssh/*key*
rm -rf /root
rm -rf /usr/local/var/lib/tor
rm -rf /usr/local/var/lib/torrc
mkdir /root
