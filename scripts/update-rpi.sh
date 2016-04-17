#!/bin/bash
set -e

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
rpi-update
apt-get clean
reboot
