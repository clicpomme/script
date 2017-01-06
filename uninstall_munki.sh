#!/bin/bash
#  2016 Clicpomme
# services@clicpomme.com

launchctl unload /Library/LaunchDaemons/com.googlecode.munki.*

rm -rf "/Applications/Utilities/Managed Software Update.app"
rm -rf "/Applications/Managed Software Center.app"

rm -f /Library/LaunchDaemons/com.googlecode.munki.*
rm -f /Library/LaunchAgents/com.googlecode.munki.*
rm -rf "/Library/Managed Installs"
rm -f /Library/Preferences/ManagedInstalls.plist
rm -rf /usr/local/munki
rm /etc/paths.d/munki

pkgutil --forget com.googlecode.munki.admin
pkgutil --forget com.googlecode.munki.app
pkgutil --forget com.googlecode.munki.core
pkgutil --forget com.googlecode.munki.launchd