#!/bin/sh

#Sets up a script and creates a launchdeamon that watches com.apple.airport.preferences.plist
#This changes whenever you join a network. If the Guest network is joined, then remove it and bop them off of it
# Richard Charbonneau Clicpomme 2019


##################
##CREATE SCRIPT###
##################
cat << EOF > /usr/local/removeLuneRougeGuest.sh
#!/bin/bash

#set interface name and network you're hunting for
interfaceName="Wi-Fi"
networkName="Lune Rouge – Guest"

Adapter=\$(networksetup -listallhardwareports | grep -A 1 "\$interfaceName" | grep Device | awk '{print \$2}')

if networksetup -listpreferredwirelessnetworks \$Adapter | grep "\$networkName"; then
    echo "Guest Found"
    ConnectedtoGuest=\$(networksetup -getairportnetwork \$Adapter | awk -F ":" '{ print \$2 }' | cut -c 2-)
    if [ "\$ConnectedtoGuest" == "\$networkName" ]; then
            #Gotta disconnect first to remove it
            networksetup -setairportpower \$Adapter off
            networksetup -removepreferredwirelessnetwork \$Adapter "\$networkName"
            networksetup -setairportpower \$Adapter on

    else
            networksetup -removepreferredwirelessnetwork \$Adapter "\$networkName"

    fi
fi

EOF

########################
##CREATE LAUNCHDAEMON###
########################

cat << EOF > /Library/LaunchDaemons/com.clicpomme.removeLuneRougeGuest.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.clicpomme.removeLuneRougeGuest</string>
    <key>ProgramArguments</key>
    <array>
        <string>sh</string>
        <string>-c</string>
        <string>/usr/local/removeLuneRougeGuest.sh</string>
    </array>
    <key>RunAtLoad</key>
	<true/>
    <key>WatchPaths</key>
    <array>
        <string>/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist</string>
    </array>
</dict>
</plist>
EOF

/usr/sbin/chown root:wheel /usr/local/removeLuneRougeGuest.sh
/bin/chmod 755 /usr/local/removeLuneRougeGuest.sh

/usr/sbin/chown root:wheel /Library/LaunchDaemons/com.clicpomme.removeLuneRougeGuest.plist
/bin/chmod 644 /Library/LaunchDaemons/com.clicpomme.removeLuneRougeGuest.plist

/bin/launchctl load -w /Library/LaunchDaemons/com.clicpomme.removeLuneRougeGuest.plist