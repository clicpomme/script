#!/bin/sh
 
# Richard Charbonneau
# http://www.clicpomme.com
# Updated 06/05/2015
 
# Set New computerNAME manually
# Workstations (iMac) - LVL-WKS-XXXX <- Last 3 characters of SN 
# Servers - LVL-SRV-XXX <- Incremental Number 001 and up
# Laptops (MacBook) - LVL-LPT-XXXX <- Last 3 characters of SN 
# Printers - LVL-PRT-XXX <- Incremental Number 001 and up

#Set new computer name bas on 4 last digit serial
serial=`/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print substr($0,length-3)}'`


echo Hi, which user accont are you migrating ?
read varusr
 
echo Ok Great, will migrated user account $varusr

echo "Hit the <return> key to continue ... or ctl+c to quit"
  read input ##This cause a pause so we can read the output

echo Hi, are you running this script for a WKS or LPT ?
read vardsklpt 
echo Ok Great, this computer will be bind under this new computer name $vardsklpt

echo Hi, are you running this script to which location TO, OTT, LVL, or QC ?
read base 
echo Ok Great, this computer will be bind under this location name $base

echo New Computer name will be $base"-"$vardsklpt"-"$serial

echo "Hit the <return> key to continue ... or ctl+c to quit"
  read input ##This cause a pause so we can read the output
  #of the selection before the loop clear the screen


echo this Mac is rename to $base"-"$vardsklpt"-"$serial

/usr/sbin/scutil --set ComputerName $base"-"$vardsklpt"-"$serial
/usr/sbin/scutil --set LocalHostName $base"-"$vardsklpt"-"$serial
#/usr/sbin/scutil --set HostName $$base"-"$vardsklpt"-"$serial.tld

# These variables need to be configured for your env
odAdmin="*****" #enter your OD admin name between the quotes
odPassword="*****"  # Enter your OD admin password between the quotes
domain="server.domain.com" # FQDN of your OD domain
oldDomain="server.domain.com" # If moving from another OD, enter that FQDN here
oldODip="192.168.0.1" # Enter the IP of your old OD
 
# These variables probably don't need to be changed

computerName=`/usr/sbin/scutil --get LocalHostName`
nicAddress=`ifconfig en0 | grep ether | awk '{print $2}'`
check4OD=`dscl localhost -list /LDAPv3`
check4ODacct=`dscl /LDAPv3/${domain} -read Computers/${computerName} RealName | cut -c 11-`
#check4AD=`dscl localhost -list /Active\ Directory`
osversionlong=`sw_vers -productVersion`
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
 
# Check if on OD already
if [ "${check4OD}" == "${domain}" ]; then
	echo "This machine is joined to ${domain} already."
	odSearchPath=`defaults read /Library/Preferences/OpenDirectory/Configurations/Search.plist | grep $domain`
	if [ "${odSearchPath}" = "" ]; then
		echo "$domain not found in search path. Adding..."
		dscl /Search -append / CSPSearchPath /LDAPv3/$domain
		sleep 10
	fi
else if [ "${check4OD}" == "${oldDomain}" ]; then
	echo "Removing from ${oldDomain}"
	dsconfigldap -r "${oldDomain}"
	dscl /Search -delete / CSPSearchPath /LDAPv3/"${oldDomain}"
	dscl /Search/Contacts -delete / CSPSearchPath /LDAPv3/"${oldDomain}"
	echo "Binding to $domain"
	dsconfigldap -v -a $domain -n $domain
	dscl /Search -create / SearchPolicy CSPSearchPath
	killall DirectoryService
else if [ "${check4OD}" == "${oldODip}" ]; then
	echo "Removing from ${oldODip}"
		dsconfigldap -r "${oldODip}"
		dscl /Search -delete / CSPSearchPath /LDAPv3/"${oldODip}"
		dscl /Search/Contacts -delete / CSPSearchPath /LDAPv3/"${oldODip}"
		echo "Binding to $domain"
		dsconfigldap -v -a $domain -n $domain
		dscl /Search -create / SearchPolicy CSPSearchPath
		killall DirectoryService
else
	echo "No previous OD servers found, binding to $domain"
	dsconfigldap -v -a $domain -n $domain
	dscl /Search -create / SearchPolicy CSPSearchPath
	sleep 10
	dscl /Search -append / CSPSearchPath /LDAPv3/$domain
	echo "Killing DirectoryService"
#	killall DirectoryService
	fi
fi
fi
 
sleep 25 # Give DS a chance to catch up
 

# 	Apply userpermission on local Home folder for new OD domaine
echo réparation des permissions du répertoire utilisateur #varusr
chown -R $varusr:staff /Users/$varusr

# Repair diskpermission
echo "repair OSX disk Permission"
diskutil repairPermissions /

# reboot 
echo "reboot in 20 sec"
sleep 20
shutdown -r now

echo "done ... now rebooting"
exit 0