#!/usr/bin/env bash

# Resolve the script's Stow link so folded and existing config directories both
# update the theme in the repo without replacing Stow's current-theme link.
script_path="${BASH_SOURCE[0]}"
while [ -L "$script_path" ]; do
    script_dir="$(cd -P "$(dirname "$script_path")" && pwd)"
    script_path="$(readlink "$script_path")"
    [[ "$script_path" = /* ]] || script_path="$script_dir/$script_path"
done
CONFIG_DIR="$(cd -P "$(dirname "$script_path")" && pwd)"
THEME_DIR="$CONFIG_DIR/themes"

# Available themes
THEMES=("tokyonight-storm" "san-marino-blue" "catppuccin-mocha")

# Function to display usage
usage() {
    echo "Usage: $0 [theme-name]"
    echo "Available themes:"
    for theme in "${THEMES[@]}"; do
        echo "  - $theme"
    done
    echo ""
    echo "Current theme: $(get_current_theme)"
}

# Function to get current theme
get_current_theme() {
    if [ -L "$CONFIG_DIR/current-theme" ]; then
        basename "$(readlink "$CONFIG_DIR/current-theme")"
    else
        echo "tokyonight-storm"
    fi
}

# Function to switch theme
switch_theme() {
    local theme="$1"

    # Check if theme exists
    if [ ! -f "$THEME_DIR/$theme" ]; then
        echo "Error: Theme '$theme' not found!"
        usage
        exit 1
    fi

    # Create/update symlink to current theme
    ln -sfn "themes/$theme" "$CONFIG_DIR/current-theme"

    echo "Switched to theme: $theme"
    echo "Reloading sketchybar..."

    # Reload sketchybar
    sketchybar --reload
}

# Main logic
if [ $# -eq 0 ]; then
    usage
    exit 0
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    usage
    exit 0
else
    switch_theme "$1"
fi
