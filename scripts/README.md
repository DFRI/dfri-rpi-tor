A small summary of the scripts in this folder
backup-rpi.sh
 - Called from /etc/rc.local, requires usb key connected

check-iptype.pl
 - Just a perl-script to verify if we're running behind a router or not

config-tor.sh
 - Fix tor, set it up the way we like it

initial-boot-setup-rpi.sh
 - Initial script run at boot, only executes at first boot, called from /etc/rc.local

restore-rpi.sh
 - Called from /etc/rc.local, only works within certain conditions. Requires usb key connected.

update-rpi.sh
 - Update the raspberry, called from cron.

update-scripts.sh
 - Update the scripts on the raspberry, this is the script that will fetch these scripts from github
