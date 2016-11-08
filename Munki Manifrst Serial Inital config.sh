#!/bin/sh
 
# Richard Charbonneau
# http://www.clicpomme.com
# Updated 18/11/2015


#Grab Serial to Manifest Munki
serial=`/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print substr($0,length-11)}'`

sudo defaults write /Library/Preferences/ManagedInstalls ClientIdentifier $serial
