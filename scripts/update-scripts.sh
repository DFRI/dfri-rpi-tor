#!/bin/bash
cd /root
if [ -d /root/dfri-rpi-tor ]
then
  mv dfri-rpi-tor dfri-rpi-tor-saved
fi
git clone https://github.com/DFRI/dfri-rpi-tor.git
if [ $? -eq 0 ]
then
  rm -rf dfri-rpi-tor-saved
else
  mv dfri-rpi-tor-saved dfri-rpi-tor
fi
ln -sf /root/dfri-rpi-tor/scripts /root/scripts
