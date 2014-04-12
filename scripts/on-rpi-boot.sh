#!/bin/bash
NETWORK="$(/root/scripts/check-ipsubnet.sh $(ifconfig eth0 | awk '$0 ~ /Bcast/ { print $2, $NF }' | sed -e 's/addr://g' -e 's/Mask://g'))"
grep -v ^sshd: /etc/hosts.allow > /etc/hosts.allow-new
mv /etc/hosts.allow-new /etc/hosts.allow
echo "sshd: $NETWORK" >> /etc/hosts.allow

if [ ! -f /etc/apt/preferences ]
then
  cat << EOF > /etc/apt/preferences
Package: *
Pin: release n=wheezy
Pin-Priority: 900

Package: *
Pin: release n=jessie
Pin-Priority: 300

Package: *
Pin: release o=Raspbian
Pin-Priority: -10
EOF
fi

if [ "$(grep -c "http://archive.raspbian.org/raspbian wheezy" /etc/apt/sources.list)" = 0 ]
then
  echo "deb http://archive.raspbian.org/raspbian wheezy main contrib non-free rpi" >> /etc/apt/sources.list
fi

if [ "$(grep -c "http://archive.raspbian.org/raspbian jessie" /etc/apt/sources.list)" = 0 ]
then
  echo "deb http://archive.raspbian.org/raspbian jessie main contrib non-free rpi" >> /etc/apt/sources.list
fi

apt-get update && apt-get upgrade
apt-get install -t jessie openssl tor
