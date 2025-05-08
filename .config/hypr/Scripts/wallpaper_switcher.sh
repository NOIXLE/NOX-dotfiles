#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_BG="$HOME/.config/hypr/Images/bg.png"

# Build list of filenames and store full path mapping
mapfile -t FILES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

# Extract filenames only
CHOICE=$(printf "%s\n" "${FILES[@]##*/}" | wofi --dmenu --prompt "Select Wallpaper" --allow-images --width 500 -b)

# Exit if none selected
[ -z "$CHOICE" ] && exit 1

# Reconstruct full path from selection
for FILE in "${FILES[@]}"; do
    if [[ "${FILE##*/}" == "$CHOICE" ]]; then
        SELECTED="$FILE"
        break
    fi
done

hyprctl hyprpaper unload all

# Preload and apply wallpaper via hyprpaper
hyprctl hyprpaper preload "$SELECTED"
for MON in DP-2 DP-3 DP-4 HDMI-A-3; do
    hyprctl hyprpaper wallpaper "$MON, $SELECTED"
done

# Update hyprpaper.conf file
sed -i "s|^preload = .*|preload = $SELECTED|" "$CONFIG_FILE"
sed -i "s|^wallpaper = .*|wallpaper = , $SELECTED|" "$CONFIG_FILE"

# Update Hyprlock background (overwrite or symlink)
ln -sf "$SELECTED" "$HYPRLOCK_BG"
