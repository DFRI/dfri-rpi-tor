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

if [ "$(grep -c "torproject.org" /etc/apt/sources.list)" -ge 1 ]
then
  grep -v "torproject.org" /etc/apt/sources.list >> /etc/apt/sources.list-new
  mv /etc/apt/sources.list-new /etc/apt/sources.list
fi

export DEBIAN_FRONTEND=noninteractive

if [ "$(ls -la /var/lib/dpkg/updates | wc -l)" -ge "1" ]
then
  dpkg --configure -a
fi

apt-get update && apt-get upgrade -y
apt-get install -t jessie libssl1.0.0 openssl tor -y
pkill tor
update-rc.d tor remove

egrep -v "/root/scripts/|exit 0" /etc/rc.local > /etc/rc.local-new
egrep "initial-boot|update-scripts" /etc/rc.local >> /etc/rc.local-new
egrep -v "initial-boot|update-scripts|start-tor" /etc/rc.local | grep "/root/scripts" >> /etc/rc.local-new
egrep "start-tor" /etc/rc.local >> /etc/rc.local-new
echo "exit 0" >> /etc/rc.local-new
mv /etc/rc.local-new /etc/rc.local
chmod u+x /etc/rc.local
