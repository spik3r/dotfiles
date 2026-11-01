#!/usr/bin/env bash

# Format: "Mon 12 Jan • 14:30"
DATE_TIME=$(date '+%a %d %b • %H:%M')

sketchybar --set "$NAME" label="$DATE_TIME"

