#!/bin/bash

# This is a script that changes the wallpaper of all monitors, hyprlock and a very specific SDDM theme
# This SCRIPT REQUIRES MODIFICATION FOR IT TO WORK IN YOUR SYSTEM, as files locations may vary

WALLPAPER_DIR="$HOME/Pictures/Wallpapers" # Wallpaper images folder
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf" # hyprpaper config file location
HYPRLOCK_BG="$HOME/.config/hypr/Images/bg.png" # hyprlock wallpaper location

mapfile -t FILES < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

declare -A FILE_MAP
CHOICE_LIST=()

for FILE in "${FILES[@]}"; do
    BASENAME_NO_EXT="$(basename "${FILE%.*}")"
    FILE_MAP["$BASENAME_NO_EXT"]="$FILE"
    CHOICE_LIST+=("$BASENAME_NO_EXT")
done

# very specific catppuccin-mocha theming for wofi
CHOICE=$(printf "%s\n" "${CHOICE_LIST[@]}" | wofi --dmenu --prompt "Select Wallpaper" --allow-images --width 500 -b --conf ~/.config/wofi/wofi-main/config/config --style ~/.config/wofi/wofi-main/src/mocha/style.css)
[ -z "$CHOICE" ] && exit 1

SELECTED="${FILE_MAP[$CHOICE]}"

hyprctl hyprpaper unload all

# Preload and apply wallpaper with hyprpaper
hyprctl hyprpaper preload "$SELECTED"
for MON in DP-2 DP-3 DP-4 HDMI-A-3; do # This line includes your monitor IDs, CHANGE THIS
    hyprctl hyprpaper wallpaper "$MON, $SELECTED"
done

# Update hyprpaper.conf
sed -i "s|^preload = .*|preload = $SELECTED|" "$CONFIG_FILE"
sed -i "s|^wallpaper = .*|wallpaper = , $SELECTED|" "$CONFIG_FILE"

# Update Hyprlock background
ln -sf "$SELECTED" "$HYPRLOCK_BG"

# Update SDDM background (requires this FILE to have read and write permissions for the current user)
cp "$SELECTED" "/usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/black_hole.png" # MAKE SURE THIS PATH IS CORRECT AND YOU HAVE PERMISSIONS FOR THIS FILE ONLY
