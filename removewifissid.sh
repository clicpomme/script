#!/bin/bash
# Script to remove the Guest SSID from preffered networks within the fleet.
# Richard Charbonneau Clicpomme 2019

# Var array
{
  WiFiInt=$(networksetup -listallhardwareports | grep -A 1 "Wi-Fi" | tail -n 1 | cut -c 9-)
  SSID="Lune Rouge – Guest"
}

# Will check if the Wi-Fi interface is disabled or doesn't exist before trying to execute
if [[ -z $WiFiInt ]];
  then
    echo "Wi-Fi disabled or not present. Gracefully exiting."
    exit 0
  else
    echo "Wi-Fi found - removing SSID if present."
    networksetup -removepreferredwirelessnetwork "${WiFiInt}" "${SSID}"
  fi

exit 0