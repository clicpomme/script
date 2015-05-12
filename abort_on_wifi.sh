#!/bin/sh
# Richard Charbonneau
# 12-05-2015
# clicpomme.com

# If you have renamed your Wi-Fi interface in the Network preference pane, 
# adjust the next line to match
wifi_name="Wi-Fi"

# An exit status of "89" will abort the task without error, as if 
# cancelled by the user. If you want this reported as an error, emails 
# sent, etc., change the exit status to any other non-zero value
exit_status=89


##### No edits required past this line #####

airport_active=`/usr/sbin/networksetup -getinfo "$wifi_name" | /usr/bin/grep -e "^IP address" | /usr/bin/wc -l | /usr/bin/awk '{print $1}'`
if [ "$airport_active" = "1" ]; then
	echo "The WiFi interface is active, aborting the backup task"
	exit $exit_status
fi

