#!/bin/bash
set -e
set -o pipefail

# Backup is good, this requires a USB-key, trying to figure out where it is and doing the backup there

TARGET=$(mount | grep /dev/sd | awk '{ print $3 }')
DATE=$(date '+%Y%m%d')
TARGETDIR=${TARGET}/${DATE}-backup-dfri-rpi

if [ -d ${TARGET} ]
then
  mkdir ${TARGETDIR}
  cp -rp /etc/ssh/*key* ${TARGETDIR}  
  cp -rp /usr/local/var/lib/tor ${TARGETDIR}  
  cp -rp /usr/local/etc/tor/torrc ${TARGETDIR}  
fi
exit 0
