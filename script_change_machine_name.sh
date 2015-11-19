#!/bin/sh
 
# Richard Charbonneau
# http://www.clicpomme.com
# Updated 18/11/2015

mb="MacBook"

#Set new computer name bas on 6 last digit serial and if Laptop of Desotop base in Montréal ML=Mac Laptop M=MAC MTL-ML-serial
serial=`/usr/sbin/system_profiler SPHardwareDataType | /usr/bin/awk '/Serial\ Number\ \(system\)/ {print substr($0,length-5)}'`
base="MTL"
model=`system_profiler SPHardwareDataType | awk '/Model Name/ {print $3}'`

# 	DELETE USER mobile Account Localcache  not removing userhomefolder
# echo "Deleting Users for $varusr but keeping user home folder"
if [ "${model}" == "${mb}" ]; then
	vardsklpt="ML"
else
	vardsklpt="M"
	exit $exit_status
fi

/usr/sbin/scutil --set ComputerName $base"-"$vardsklpt"-"$serial
/usr/sbin/scutil --set LocalHostName $base"-"$vardsklpt"-"$serial
#/usr/sbin/scutil --set HostName $$base"-"$vardsklpt"-"$serial.tld