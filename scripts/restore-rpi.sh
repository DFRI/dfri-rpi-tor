#!/bin/bash
TARGET=$(mount | grep /dev/sd | awk '{ print $3 }')
DATE=$(date '+%Y%m%d')
TARGETFILE=${TARGET}/${DATE}-RESTORE-DFRI-TOR

if [ -f $TARGETFILE ]
then
  echo doing restore etc
fi
