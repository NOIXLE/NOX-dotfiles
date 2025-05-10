#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"
HYPRLOCK_BG="$HOME/.config/hypr/Images/bg.png"

# Build list of full file paths
mapfile -t FILES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

# Map base filenames (without extensions) to full paths using associative array
declare -A FILE_MAP
CHOICE_LIST=()

for FILE in "${FILES[@]}"; do
    BASENAME_NO_EXT="$(basename "${FILE%.*}")"
    FILE_MAP["$BASENAME_NO_EXT"]="$FILE"
    CHOICE_LIST+=("$BASENAME_NO_EXT")
done

# Display stripped filenames in Wofi
CHOICE=$(printf "%s\n" "${CHOICE_LIST[@]}" | wofi --dmenu --prompt "Select Wallpaper" --allow-images --width 500 -b --conf /home/noixle/.config/wofi/wofi-main/config/config --style /home/noixle/.config/wofi/wofi-main/src/mocha/style.css)

# Exit if nothing selected
[ -z "$CHOICE" ] && exit 1

# Get full path from map
SELECTED="${FILE_MAP[$CHOICE]}"

hyprctl hyprpaper unload all

# Preload and apply wallpaper
hyprctl hyprpaper preload "$SELECTED"
for MON in DP-2 DP-3 DP-4 HDMI-A-3; do
    hyprctl hyprpaper wallpaper "$MON, $SELECTED"
done

# Update hyprpaper.conf
sed -i "s|^preload = .*|preload = $SELECTED|" "$CONFIG_FILE"
sed -i "s|^wallpaper = .*|wallpaper = , $SELECTED|" "$CONFIG_FILE"

# Update Hyprlock background
ln -sf "$SELECTED" "$HYPRLOCK_BG"

# Update SDDM background (requires sudo)
cp "$SELECTED" "/usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/black_hole.png"
