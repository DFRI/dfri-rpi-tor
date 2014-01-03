dfri-rpi-tor
============

[DFRI's](https://www.dfri.se/) project for [Raspberry PI's](https://www.dfri.se/projekt/tor/rpi/), making them an appliance for Tor. Some of them can be seen here: https://atlas.torproject.org/#search/DFRIpi

#How to create a new relay
The script in this repo modifies an image file based on Raspbian. Steps to get started.

* su -
* mkdir scripts
* cd scripts
* wget https://raw.github.com/DFRI/dfri-rpi-tor/master/scripts/create-passwd-hash.pl
* wget https://raw.github.com/DFRI/dfri-rpi-tor/master/scripts/setup-image.sh
* cd ..
* wget https://www.dfri.se/files/dfri-pi-current.img.bz2
* bunzip2 dfri-pi-current.img.bz2 &nbsp;&nbsp;&nbsp;### filesize 934 MB --> 3.8 GB
* sha1sum dfri-pi-current.img &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;### should be 7a406aa630919adcd502dafec1bf715dbc8591cf
* scripts/setup-image.sh scripts/dfri-pi-current.img [hostname] [secretpassword] &nbsp;&nbsp;&nbsp;### hostname e.g. "DFRIpi123"
* Done. Now write the image to a SD card (minimum size 4GB).
* Insert the card into the Pi, connect a network cable and power.
* Wait and watch for your hostname to be listed at https://atlas.torproject.org/#search/[hostname]
