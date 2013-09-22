#!/bin/bash
IP=$1
NETMASK=$2
IFS=. read -r i1 i2 i3 i4 <<< "$IP"
IFS=. read -r m1 m2 m3 m4 <<< "$NETMASK"
printf "%d.%d.%d.%d" "$((i1 & m1))" "$(($i2 & m2))" "$((i3 & m3))" "$((i4 & m4))"
printf "/"$NETMASK
