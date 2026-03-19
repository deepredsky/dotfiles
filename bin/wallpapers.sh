#!/usr/bin/env bash

set -e

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)

# Apply the selected wallpaper
nohup swaybg -i $WALLPAPER &
