#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/current-theme"

WIFI_DEVICE=$(networksetup -listallhardwareports | awk '
    /^Hardware Port: (Wi-Fi|AirPort)$/ { wifi = 1; next }
    wifi && /^Device:/ { print $2; exit }
')

ICON=󰖭
COLOR="$RED"
if [ -n "$WIFI_DEVICE" ]; then
    WIFI_POWER=$(networksetup -getairportpower "$WIFI_DEVICE" 2>/dev/null)
    if [[ "$WIFI_POWER" = *": On" ]]; then
        # Link status works even when macOS privacy settings hide the SSID.
        if ifconfig "$WIFI_DEVICE" 2>/dev/null | grep -q 'status: active'; then
            ICON=󰖩
            COLOR="$ICON_COLOR"
        else
            ICON=󰖪
            COLOR="$YELLOW"
        fi
    fi
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
