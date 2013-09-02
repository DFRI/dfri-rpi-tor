#!/bin/bash
# This will remove the node-specific stuff from the rpi
rm -rf /etc/ssh/*key*
rm -rf /root
rm -rf /home/pi
rm -rf /usr/local/var/lib/tor
rm -rf /usr/local/var/lib/torrc
apt-get clean
mkdir /root /home/pi
cp -pr /etc/skel/.* /home/pi
