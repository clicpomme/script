#!/bin/bash
# Script make default printer and set BW defaut color printing
# Richard Charbonneau Clicpomme 2019

# Variables. Edit these.
printername=$(/usr/bin/lpstat -p | grep -i versa | /usr/bin/awk '{print $2}')
option_1="XROutputColor=PrintAsGrayscale"

#Set color BW defaut
/usr/sbin/lpadmin -p "$printername" -o "$option_1"

#set default printer
/usr/bin/defaults write org.cups.PrintingPrefs UseLastPrinter -bool False
lpoptions -d "$printername"

exit 0