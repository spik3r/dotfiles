#!/usr/bin/env bash

# Arguments come from AeroSpace like: ./workspace.sh 1 2 3 4 focused=2
#for sid in $(aerospace list-workspaces --all); do
# args=$(aerospace list-workspaces --all);
# focused="${args[-1]}"
# focused="${focused#focused=}"
# unset 'args[-1]' # Remove focused=...
#
# # Clean up existing workspace items
# sketchybar --remove '/workspace\..*/'
#
# # Loop through each workspace index
# for i in "${args[@]}"; do
#   sketchybar --add item "workspace.$i" left \
#              --set "workspace.$i" \
#                label="$i" \
#                script="$PLUGIN_DIR/workspace_click.sh $i" \
#                click_script="$PLUGIN_DIR/workspace_click.sh $i" \
#                icon.drawing=off \
#                label.padding_left=8 \
#                label.padding_right=8 \
#                background.corner_radius=6 \
#                background.height=24 \
#                background.drawing=on \
#                background.border_width=2 \
#                background.border_color=0xff888888 \
#                y_offset=0
sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.color=0x44ffffff \
    background.corner_radius=5 \
    background.height=20 \
    background.drawing=off \
    label="$sid" \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/plugins/aerospace.sh $sid"
  # Highlight active workspace
  if [[ "$i" == "$focused" ]]; then
    sketchybar --set "workspace.$sid" background.color=0xff4c566a
  else
    sketchybar --set "workspace.$sid" background.color=0x00000000
  fi
done

