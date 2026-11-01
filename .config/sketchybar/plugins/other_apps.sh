#!/usr/bin/env bash

if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  if ! command -v jq >/dev/null 2>&1 || ! command -v aerospace >/dev/null 2>&1; then
    sketchybar --set pipe_separator label.drawing=off
    sketchybar --set other_apps label.drawing=off
    exit 0
  fi

  # Get all windows in the currently focused workspace
  if [ -n "$json" ]; then
    # Use provided json (for testing)
    workspace_json="$json"
  else
    # Get from aerospace
    workspace_json=$(aerospace list-windows --workspace focused --json)
  fi

  # Extract unique app names excluding the frontmost app
  other_apps=$(echo "$workspace_json" | jq -r '.[]["app-name"]' | grep -vFx "$INFO" | sort -u)

  # Join other apps with separator, limit to reasonable length
  if [ -n "$other_apps" ]; then
    label=$(echo "$other_apps" | head -5 | tr '\n' ' ' | sed 's/ $//; s/ / · /g')
  else
    label=""
  fi

  # Update the sketchybar label with only the other apps
  sketchybar --set "$NAME" label="$label"
  
  # Show/hide pipe separator and other_apps based on whether there are other apps
  if [ -n "$label" ]; then
    sketchybar --set pipe_separator label.drawing=on
    sketchybar --set other_apps label.drawing=on
  else
    sketchybar --set pipe_separator label.drawing=off
    sketchybar --set other_apps label.drawing=off
  fi
fi
