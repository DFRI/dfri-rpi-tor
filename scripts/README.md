A small summary of the scripts in this folder

backup-rpi.sh
 - Called from /etc/rc.local, requires usb key connected

check-iptype.pl
 - Just a perl-script to verify if we're running behind a router or not

config-tor.sh
 - Fix tor, set it up the way we like it

create-passwd-hash.pl
 - This script is called from setup-image.sh, it will just create a passwd hash on supplied argument (the password)

initial-boot-setup-rpi.sh
 - Initial script run at boot, only executes at first boot, called from /etc/rc.local

restore-rpi.sh
 - Called from /etc/rc.local, only works within certain conditions. Requires usb key connected.

setup-image.sh
 - This is a script to run on the node when you want to setup a new image. Will fix things on it.

start-tor.sh
 - Start tor, how to start stuff

update-rpi.sh
 - Update the raspberry, called from cron.

update-scripts.sh
 - Update the scripts on the raspberry, this is the script that will fetch these scripts from github

wipe-rpi.sh
 - Wipe stuff from the rpi, just removing stuff we dont want there when setting up a new image
