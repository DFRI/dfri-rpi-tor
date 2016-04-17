#!/bin/bash
NETWORK="$(/root/scripts/check-ipsubnet.sh $(ifconfig eth0 | awk '$0 ~ /Bcast/ { print $2, $NF }' | sed -e 's/addr://g' -e 's/Mask://g'))"
grep -v ^sshd: /etc/hosts.allow > /etc/hosts.allow-new
mv /etc/hosts.allow-new /etc/hosts.allow
echo "sshd: $NETWORK" >> /etc/hosts.allow

rm -f /etc/apt/preferences

cat << EOF > /etc/apt/sources.list
deb http://archive.raspbian.org/raspbian jessie main contrib non-free rpi
EOF

export DEBIAN_FRONTEND=noninteractive
apt-get update

# remove old dirs and some packages to free space before upgrade
rm -rf /2013*-backup-dfri-rpi /2014*-backup-dfri-rpi /2015*-backup-dfri-rpi
rm -rf /usr/local/source/openssl*
rm -rf /usr/local/source/tor-*
rm -rf /usr/local/source/libevent*
apt-get purge -y scratch pypy-upstream smbclient xserver-* libx11* omxplayer desktop-base
apt-get autoremove -y
apt-get clean

if [ "$(ls -la /var/lib/dpkg/updates | wc -l)" -ge "1" ]
then
  dpkg --configure -a
fi

apt-get dist-upgrade -y
apt-get install tor -y
apt-get clean
apt-get autoremove
pkill tor
update-rc.d tor remove

egrep -v "/root/scripts/|exit 0" /etc/rc.local > /etc/rc.local-new
egrep "initial-boot|update-scripts" /etc/rc.local >> /etc/rc.local-new
egrep -v "initial-boot|update-scripts|start-tor" /etc/rc.local | grep "/root/scripts" >> /etc/rc.local-new
egrep "start-tor" /etc/rc.local >> /etc/rc.local-new
echo "exit 0" >> /etc/rc.local-new
mv /etc/rc.local-new /etc/rc.local
chmod u+x /etc/rc.local
