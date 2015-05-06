#!/bin/sh
 
# Richard Charbonneau
# http://www.clicpomme.com
# Updated 22/04/2015
 
# Set New computerNAME manually
# Workstations (iMac) - LVL-WKS-XXXX <- Last 3 characters of SN 
# Servers - LVL-SRV-XXX <- Incremental Number 001 and up
# Laptops (MacBook) - LVL-LPT-XXXX <- Last 3 characters of SN 
# Printers - LVL-PRT-XXX <- Incremental Number 001 and up

#Set new computer name bas on 4 last digit serial
serial=`/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print substr($0,length-3)}'`
#tld="***.com"

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
odAdmin="diradmin" #enter your OD admin name between the quotes
odPassword="cep2012"  # Enter your OD admin password between the quotes
domain="vmosxserver-od-test.lan" # FQDN of your OD domain
oldDomain="serveurcep.expcep.lan" # If moving from another OD, enter that FQDN here
oldODip="192.168.0.222" # Enter the IP of your old OD
#ADdomain="ad.compagny.com" # Enter your AD domain here
#computerGroup=computers  # Add appropriate computer group you want machines to be added to, case sensitive 
 
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
	echo "Restart DirectoryService"
	killall opendirectoryd
	sleep 30
	fi
fi
fi
#if [ "${check4ODacct}" == "${computerName}" ]; then
#	echo "This machine has a computer account on ${domain} already."
#else
#	echo "Adding computer account to ${domain}"
#	dscl -u "${odAdmin}" -P "${odPassword}" /LDAPv3/${domain} -create /Computers/${computerName} ENetAddress "$nicAddress"
#	dscl -u "${odAdmin}" -P "${odPassword}" /LDAPv3/${domain} -merge /Computers/${computerName} RealName ${computerName}
#	# Add computer to ComputerList
#	dscl -u "${odAdmin}" -P "${odPassword}" /LDAPv3/${domain} -merge /ComputerLists/${computerGroup} apple-computers ${computerName}		
#
#	# Set the GUID
#	GUID="$(dscl /LDAPv3/${domain} -read /Computers/${computerName} GeneratedUID | awk '{ print $2 }')"
#	# Add to computergroup
#	dscl -u "${odAdmin}" -P "${odPassword}" /LDAPv3/${domain} -merge /ComputerGroups/${computerGroup} apple-group-memberguid "${GUID}"
#	dscl -u "${odAdmin}" -P "${odPassword}" /LDAPv3/${domain} -merge /ComputerGroups/${computerGroup} memberUid ${computerName}
#fi
 
sleep 25 # Give DS a chance to catch up
 
# Fix DS search order

# echo "Checking DS search order..."
#if [ "${check4AD}" == "${adDomain}" ]; then
#	dsconfigad -alldomains enable
#	dscl /Search -delete / CSPSearchPath "/Active Directory/${adDomain}"
#	dscl /Search/Contacts -delete / CSPSearchPath "/Active Directory/${adDomain}"
#	dscl /Search -append / CSPSearchPath "/Active Directory/All Domains"
#	if [ $osvers -eq 6 ]; then
#		echo "OS detected as ${osversionlong}"
#		echo "Setting AD, then OD to search order..."
#		dscl localhost changei /Search CSPSearchPath 2 "/Active Directory/All Domains"
#		dscl localhost changei /Search CSPSearchPath 3 /LDAPv3/$domain
#		dscl /Search/Contacts -append / CSPSearchPath "/Active Directory/All Domains"
#	else if [[ ${osvers} -eq 7 || 8 || 9 || 10 ]]; then
#		echo "OS detected as ${osversionlong}"
#		echo "Setting OD, then AD to search order..."
#		dscl localhost changei /Search CSPSearchPath 3 "/Active Directory/All Domains"
#		dscl localhost changei /Search CSPSearchPath 2 /LDAPv3/$domain
#		dscl /Search/Contacts -append / CSPSearchPath "/Active Directory/All Domains"
#	fi
#fi
#	else if [ "${check4AD}" == "All Domains" ]; then
#	dscl /Search -append / CSPSearchPath "/Active Directory/All Domains"
#	sleep 15
#		if [ $osvers -eq 6 ]; then
#			echo "OS detected as ${osversionlong}"
#			echo "Setting AD, then OD to search order..."
#			dscl localhost changei /Search CSPSearchPath 1 "/Active Directory/All Domains"
#			dscl localhost changei /Search CSPSearchPath 2 /LDAPv3/$domain
#		else if [[ ${osvers} -eq 7 || 8 || 9 || 10 ]]; then
#			echo "OS detected as ${osversionlong}"
#			echo "Setting OD, then AD to search order..."
#			dscl localhost changei /Search CSPSearchPath 2 /LDAPv3/$domain
#			dscl localhost changei /Search CSPSearchPath 3 "/Active Directory/All Domains"
#			dscl /Search/Contacts -append / CSPSearchPath "/Active Directory/All Domains"
#		fi
#	fi
#fi
#fi

# 	Apply userpermission on local Home folder for new OD domaine
echo réparation des permissions du répertoire utilisateur #varusr
chown -R $varusr:staff /Users/$varusr

# Repair diskpermission
echo "OSX DISK PERMISSION REPAIR"
diskutil repairPermissions /

# reboot 
echo "System will reboot in 20 sec ...."
sleep 20
shutdown -r now
echo "done ... rebooting now."
exit 0