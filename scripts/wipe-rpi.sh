#!/bin/bash
set -e

declare -i is_failure=0

# This will remove the node-specific stuff from the rpi
rm -rf /etc/ssh/*key* /root /home/pi /usr/local/var/lib/tor /usr/local/var/lib/torrc || { is_failure=1; }
apt-get clean || { is_failure=1; }
mkdir /root /home/pi && cp -pr /etc/skel/.* /home/pi || { is_failure=1; }

if [ ${is_failure} -ne 0 ]
then
  exit 1
else
  exit 0
fi
