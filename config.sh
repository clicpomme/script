#!/bin/bash
# Clicpomme-Config-Script-OSX-10.10
# Richard Charbonneau \# Date of Compile: 22/07/2015

# Remove the loginwindow delay by loading the com.apple.loginwindow
launchctl load /System/Library/LaunchDaemons/com.apple.loginwindow.plist

# Set the login window to name and password
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Turn off Automatic updates
sudo softwareupdate --schedule off

# Login message Banner
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "FAÉCUM"

# Rename boot drive to Macintosh HD
diskutil rename / "Macintosh HD"

#Diseable AppNAP
defaults write NSGlobalDomain NSAppSleepDisabled -bool YES


#Diseable DiskSleep
if [[ $shortModel == "MacBook" ]]; then

    pmset -b sleep 30 disksleep 0 displaysleep 15 halfdim 1

    pmset -c sleep 0 disksleep 0 displaysleep 30 halfdim 1

else    

    pmset sleep 0 disksleep 0 displaysleep 45 halfdim 1

fi

#Start up automatically after a power failure
pmset -a autorestart 1

#Allow Wake on LAN
pmset -a womp 1

# Screensaver Passwordturn it on
defaults write com.apple.screensaver askForPassword -bool true
#set the delay in seconds, 0 = immediate
defaults write com.apple.screensaver askForPasswordDelay 60
#set the screen saver delay in seconds, 900 = 15 minutes
defaults -currentHost write com.apple.screensaver idleTime 900

# modifier la langue du Système (loginscreen)
sudo languagesetup –langspec French

#Set language order preference
defaults write /Library/Preferences/.GlobalPreferences AppleLanguages "(fr, en, es, de, ja, it, nl, sv, nb, da, fi, pt, zh-Hans, zh-Hant, ko)"


#set the Language Preference order (make changes as required):
defaults write -g AppleLanguages "(fr, en, es, de, ja, it, nl, sv, nb, da, fi, pt, zh-Hans, zh-Hant, ko)"


# change computer name
sudo scutil --set ComputerName "FAECUM-XXXXXXXX"
#sudo scutil --set LocalHostName "newname"
#sudo scutil --set HostName "newname"

# Set the time zone
/usr/sbin/systemsetup -settimezone America/Montreal

# Disable default file sharing for guest
defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false

# Enable ARD, Remote Management, and Remote Login (SSH) \- 1. Removes Administrators Group from Remote login, 2 & 3. Creates xxxxxxxxx Membership, 4 & 5. Adds xxxxxxxxx User to Remotelogin then activates.
sudo dseditgroup -o edit -d admin -t group com.apple.access_ssh
sudo dscl . append /Groups/com.apple.access_ssh user ard
sudo dscl . append /Groups/com.apple.access_ssh GroupMembership ard
sudo dscl . append /Groups/com.apple.access_ssh groupmembers `dscl . read /Users/ard GeneratedUID | cut -d " " -f 2`
sudo systemsetup -setremotelogin on
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -users ard -access -on -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -activate -restart -console

# Configure Finder settings (List View, Show Status Bar, Show Path Bar)
defaults write /System/Library/User\ Template/Frecnch.lproj/Library/Preferences/com.apple.finder "AlwaysOpenWindowsInListView" -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write /System/Library/User\ Template/French.lproj/Library/Preferences/com.apple.finder ShowStatusBar -bool true
defaults write /System/Library/User\ Template/French.lproj/Library/Preferences/com.apple.finder ShowPathbar -bool true

#set default Wallpaper
#osascript -e "tell application \"System Events\" to set picture of every desktop to \"cd /Users/Shared/faecum.jpg\""

# Repair Disk Permissions with Disk Utility command line 
diskutil repairPermissions /

# Run Built-in Unix Maintenance Scripts (Rotate & delete log files)
sudo periodic daily weekly monthly

# Download and install all software update
sudo softwareupdate -iva
