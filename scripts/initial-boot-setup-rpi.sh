#!/bin/bash
# Check if this has already been run
if [ -f /etc/dfri-setup-done ]
then
  exit 0
fi

# Generate ssh-keys
cd /etc/ssh
rm -f *key*
ssh-keygen -t dsa -f ssh_host_dsa_key -N ""
ssh-keygen -t rsa -f ssh_host_rsa_key -N ""
ssh-keygen -t ecdsa -f ssh_host_ecdsa_key -N ""
/etc/init.d/ssh restart

# Update sources
apt-get update

# Install packages we want in place
apt-get install zlib1g-dev ntpdate git rpi-update -y

# Dont forget perl-modules we use in scripts
if [ ! -f /usr/local/share/perl/5.14.2/Net/IP.pm ]
then
  cpan -fi Net::IP 
fi

# Fix hosts.deny
echo "ALL: ALL" >> /etc/hosts.deny

# Fix hosts.allow
NETWORK="$(/root/scripts/check-ipsubnet.sh $(ifconfig eth0 | awk '$0 ~ /Bcast/ { print $2, $NF }' | sed -e 's/addr://g' -e 's/Mask://g'))"
grep -v ^sshd: /etc/hosts.allow > /etc/hosts.allow-new
mv /etc/hosts.allow-new /etc/hosts.allow
echo "sshd: $NETWORK" >> /etc/hosts.allow

# Set time
/etc/init.d/ntp stop
/usr/sbin/ntpdate 0.se.pool.ntp.org
/etc/init.d/ntp start

# Setup tor user
useradd -d /usr/local/var/lib/tor -s /bin/sh -m tor

# setup empty crontab, just so that we can assume that a crontab already exists
if [ ! -f /var/spool/cron/crontabs/root ]
then
  echo "" > /tmp/root-crontab
  crontab /tmp/root-crontab
fi

# Setup cronjob, just in case, time is important
RANDOM_MINUTE=$[ ( $RANDOM % 60 ) ]
crontab -l > /tmp/root-crontab
echo "# ntpdate, set time, its important" >> /tmp/root-crontab
echo "${RANDOM_MINUTE} 1 * * * ( /etc/init.d/ntp stop ; /usr/sbin/ntpdate 0.se.pool.ntp.org ; /etc/init.d/ntp start ) > /dev/null 2>&1" >> /tmp/root-crontab
crontab /tmp/root-crontab

# Add another cronjob, update-rpi.sh
RANDOM_MINUTE=$[ ( $RANDOM % 60 ) ]
RANDOM_HOUR=$[ ( $RANDOM % 24 ) ]
RANDOM_MONTHDAY=$[ ( $RANDOM % 24 ) + 1 ]
crontab -l > /tmp/root-crontab
echo "# Update! RPI" >> /tmp/root-crontab
echo "${RANDOM_MINUTE} ${RANDOM_HOUR} ${RANDOM_MONTHDAY} * * /root/scripts/update-rpi.sh > /dev/null 2>&1" >> /tmp/root-crontab
crontab /tmp/root-crontab

# Add another cronjob, update-rpi.sh
RANDOM_MINUTE=$[ ( $RANDOM % 60 ) ]
RANDOM_HOUR=$[ ( $RANDOM % 24 ) ]
crontab -l > /tmp/root-crontab
echo "# Update! Scripts" >> /tmp/root-crontab
echo "${RANDOM_MINUTE} ${RANDOM_HOUR} * * * /root/scripts/update-scripts.sh > /dev/null 2>&1" >> /tmp/root-crontab
crontab /tmp/root-crontab

# Set up autoremove and autoclean with apt-get
apt-get autoremove
apt-get clean

# Check CPU frequency, and set it to 800
if [ "$(grep -c arm_freq /boot/config.txt)" -eq 1 ]
then
  sed -i 's/arm_freq=.*$/arm_freq=800/g' /boot/config.txt
else
  echo "arm_freq=800" >> /boot/config.txt
fi

# Fix rc.local
egrep -v "/root/scripts|exit 0" /etc/rc.local > /etc/rc.local-new
echo "/root/scripts/initial-boot-setup-rpi.sh" >> /etc/rc.local-new
echo "/root/scripts/on-rpi-boot.sh" >> /etc/rc.local-new
echo "/root/scripts/config-tor.sh" >> /etc/rc.local-new
echo "/root/scripts/backup-rpi.sh" >> /etc/rc.local-new
echo "/root/scripts/start-tor.sh" >> /etc/rc.local-new
echo "exit 0" >> /etc/rc.local-new
mv /etc/rc.local-new /etc/rc.local
chmod u+x /etc/rc.local

if [ ! -f /usr/local/bin/tor ]
then
  # Setup directories and navigate
  mkdir /root/source
  cd /root/source
  
  # Download stuff
  wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
  wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz.asc
  wget https://www.openssl.org/source/openssl-1.0.1e.tar.gz
  wget https://www.openssl.org/source/openssl-1.0.1e.tar.gz.asc
  wget https://www.torproject.org/dist/tor-0.2.4.17-rc.tar.gz
  wget https://www.torproject.org/dist/tor-0.2.4.17-rc.tar.gz.asc
  wget http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.8.20130801.tar.gz -O miniupnpc-1.8.20130801.tar.gz
  
  # Unpack downloaded files
  tar zxf libevent-2.0.21-stable.tar.gz
  tar zxf openssl-1.0.1e.tar.gz 
  tar zxf tor-0.2.4.17-rc.tar.gz
  tar zxf miniupnpc-1.8.20130801.tar.gz
  
  # build and install stuff
  cd miniupnpc-1.8.20130801/
  make
  make install
  cd ..
  
  cd libevent-2.0.21-stable/
  ./configure --prefix=/usr/local
  make -j2
  make install
  cd ..
  
  cd openssl-1.0.1e/
  ./Configure dist --prefix=/usr/local
  make -j2
  make install
  cd ..
  
  cd tor-0.2.4.17-rc/
  ./configure --with-libevent-dir=/usr/local --with-openssl-dir=/usr/local --prefix=/usr/local
  make -j2
  make install
  cd ..
fi
  
# Make sure /etc/dfri-setup-done exists
touch /etc/dfri-setup-done

# And, as a final thing, just make sure the device is updated
/root/scripts/update-rpi.sh
