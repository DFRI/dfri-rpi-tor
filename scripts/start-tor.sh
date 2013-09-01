#!/bin/bash
# A small simple script to start tor

if [ -f /usr/local/bin/tor ]
then
  chown -R tor /usr/local/etc/tor /usr/local/var/lib/tor
fi
su - tor -c "/usr/local/bin/tor"
