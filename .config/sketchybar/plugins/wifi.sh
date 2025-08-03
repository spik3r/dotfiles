#!/usr/bin/env bash

source "$HOME/.config/sketchybar/current-theme"

# Get WiFi status
WIFI_STATUS=$(networksetup -getairportpower en0 | awk '{print $4}')
WIFI_SSID=$(networksetup -getairportnetwork en0 | cut -d' ' -f4-)

if [ "$WIFI_STATUS" = "On" ]; then
    if [ "$WIFI_SSID" != "You are not associated with an AirPort network." ]; then
        # Connected to WiFi
        sketchybar --set "$NAME" \
                   icon=󰖩 \
                   icon.color="$ICON_COLOR"
    else
        # WiFi on but not connected
        sketchybar --set "$NAME" \
                   icon=󰖪 \
                   icon.color="$YELLOW"
    fi
else
    # WiFi off
    sketchybar --set "$NAME" \
               icon=󰖭 \
               icon.color="$RED"
fi