#!/bin/sh
 
# (c) 2014 Richard Charbonneau Clicpomme
 
# Script to install and setup printers on a Mac OS X system in a "Friendly" way.
# Make sure to install the required drivers first!
 
# Variables. Edit these.
printername="OTTAWA_PHOTOCOPIEUR"
location="OTTAWA"
gui_display_name="OTTAWAL_PHOTOCOPIEUR"
address="lpd://192.168.1.120"
driver_ppd="/Library/Printers/PPDs/Contents/Resources/CNMCIRAC5250S2.ppd.gz"
# Populate these options if you want to set specific options for the printer. E.g. duplexing installed, etc.
# option_1="job-sheets-default=banner,banner"
# option_2=""
# option_3=""
 
### Printer Install ###
# In case we are making changes to a printer we need to remove an existing queue if it exists.
/usr/bin/lpstat -p $printername
if [ $? -eq 0 ]; then
        /usr/sbin/lpadmin -x $printername
fi
 
# Now we can install the printer
/usr/sbin/lpadmin \
        -p "$printername" \
        -L "$location" \
        -D "$gui_display_name" \
        -v "$address" \
        -P "$driver_ppd" \
        -o "$option_1" \
        -o printer-is-shared=false \
        -E
# Copy of the plist file for printer presets

/bin/cp -rf /private/tmp/com.apple.print.custompresets.forprinter.LAVAL_PHOTOCOPIEUR.plist ~/Library/Preferences/

# Enable and start the printers on the system (after adding the printer initially it is paused).
/usr/sbin/cupsenable $(lpstat -p | grep -w "printer" | awk '{print$2}')
 
# Create an uninstall script for the printer.
uninstall_script="/private/etc/cups/printers_deployment/uninstalls/$printername.sh"
mkdir -p /private/etc/cups/printers_deployment/uninstalls
echo "#!/bin/sh" > "$uninstall_script"
echo "/usr/sbin/lpadmin -x $printername" >> "$uninstall_script"
echo "/usr/bin/srm /private/etc/cups/printers_deployment/uninstalls/$printername.sh" >> "$uninstall_script"
 
# Permission the directories properly.
chown -R root:_lp /private/etc/cups/printers_deployment
chown -R root:_lp /private/etc/cups/ppd
chmod -R 700 /private/etc/cups/printers_deployment
 
exit 0