dfri-rpi-tor
============

[DFRI's](https://www.dfri.se/) project for [Raspberry PI's](https://www.dfri.se/projekt/tor/rpi/), making them an appliance for Tor. Some of them can be seen here: https://atlas.torproject.org/#search/DFRIpi

#How to create a new relay
The script in this repo modifies an image file based on Raspbian. Steps to get started.

* wget https://www.dfri.se/files/dfri-pi-current.img.bz2 && bunzip dfri-pi-current.img.bz2
* sha1sum dfri-pi-current.img # (should match 7a406aa630919adcd502dafec1bf715dbc8591cf atm)
* scripts/setup-image.sh dfri-pi-current.img [hostname] [secretpassword]
* Write the image to a SD card (minimum size 4GB).
* Insert the card into the Pi, connect a network cable and the power.
* Wait and watch for your hostname to be listed at https://atlas.torproject.org/#search/[hostname]
