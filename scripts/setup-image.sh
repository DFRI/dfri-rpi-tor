#!/bin/bash
# This is a script, not inteded to run on the PI, this will run on a host where you want to prepare a new image

# Some simple checks that are required
function check_binary_exists {
  which $1 > /dev/null 2>&1
  if [ $? -ne 0 ]
  then
    echo "I need $1 to function. Please install. Bailing."
    exit 1
  fi
}
check_binary_exists fdisk
check_binary_exists losetup
check_binary_exists whoami
check_binary_exists pwgen
check_binary_exists dirname

# Am i root?
if [ $(whoami) != "root" ]
then
  echo "Uh, run me as root, bailing."
  exit 2
fi

# Some variables
PIHOSTNAME=Rydepitest
PIIMAGE=$1
MOUNTDIR=/mnt
if [ ! -f "${PIIMAGE}" ]
then
  echo "Hmm, cannot find that image, sure you meant this one?: ${PIIMAGE}" 
  exit 3
fi

# Mount image
LOOPDEV1=$(losetup -f --show ${PIIMAGE})

# Examine image on loopdevice above
SECTORSIZE=$(fdisk -l ${LOOPDEV1} | awk '$0 ~ /^Sector size/ { print $7 }')
STARTOFFSET=$(fdisk -l ${LOOPDEV1} | tail -1 | awk '{ print $2 }')

# Need to check sector from above output, then calculate
# start offset from second partitons start times sector size, like so:
LOOPOFFSET=$(echo ${SECTORSIZE}*${STARTOFFSET} | bc)

# Create loop with offset from above calculation
LOOPDEV2=$(losetup -f --show -o ${LOOPOFFSET} ${PIIMAGE})

# Mount above loop
mount ${LOOPDEV2} ${MOUNTDIR}

# Start editing image

# remove files
rm -f ${MOUNTDIR}/etc/ssh/*key* ${MOUNTDIR}/usr/local/etc/tor/torrc

# remove directories
rm -rf ${MOUNTDIR}/usr/local/var/lib/tor ${MOUNTDIR}/root

# recreate directories
mkdir ${MOUNTDIR}/root

# Fetch from git
cd ${MOUNTDIR}/root
git clone https://github.com/DFRI/dfri-rpi-tor.git > /dev/null 2>&1

# Create symlink 
cd ${MOUNTDIR}/root
ln -sf dfri-rpi-tor/scripts scripts

# Change hostname
echo ${PIHOSTNAME} > ${MOUNTDIR}/etc/hostname 

# Random password
PASSWORD=$(pwgen -B -s 12 1)
PASSWDCMD=$(dirname $0)/create-passwd-hash.pl
PASSWDHASH=$($PASSWDCMD $PASSWORD)
echo "Setting ${PIHOSTNAME} and giving pi-user the password: ${PASSWORD}"

# Set pi users password
grep -v ^pi: ${MOUNTDIR}/etc/shadow > ${MOUNTDIR}/etc/shadow-new
echo "pi:${PASSWDHASH}:15948:0:99999:7:::" >> ${MOUNTDIR}/etc/shadow-new
mv ${MOUNTDIR}/etc/shadow-new ${MOUNTDIR}/etc/shadow

# Fix rc.local so that initial work happens
egrep -v "/root/scripts|exit 0" ${MOUNTDIR}/etc/rc.local > ${MOUNTDIR}/etc/rc.local-new
echo "/root/scripts/initial-boot-setup-rpi.sh" >> ${MOUNTDIR}/etc/rc.local-new
echo "exit 0" >> ${MOUNTDIR}/etc/rc.local-new
mv ${MOUNTDIR}/etc/rc.local-new ${MOUNTDIR}/etc/rc.local
chmod u+x ${MOUNTDIR}/etc/rc.local

# Remove file that stops initial-boot-setup-rpi.sh from running
rm -f ${MOUNTDIR}/etc/dfri*

# Clean up /var/log
find ${MOUNTDIR}/var/log -type f -exec rm {} \;

# Sleeping just to make stuff above to unmount
cd
sleep 1

# Done editing

# Umount image
#umount ${MOUNTDIR}

# Remove loops
#losetup -d ${LOOPDEV1} ${LOOPDEV2}
