#!/bin/sh
 
# Richard Charbonneau
# http://www.clicpomme.com
# Updated 9/11/2016

#Grab Serial to Manifest Munki client
serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')
sudo defaults write /Library/Preferences/ManagedInstalls ClientIdentifier $serial
exit 0
