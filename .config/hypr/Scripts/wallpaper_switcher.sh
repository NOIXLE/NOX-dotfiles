#!/bin/bash

# This is a script that changes the wallpaper of all monitors, hyprlock and a very specific SDDM theme
# This SCRIPT REQUIRES MODIFICATION FOR IT TO WORK IN YOUR SYSTEM, as files locations may vary

WALLPAPER_DIR="$HOME/Pictures/Wallpapers" # Wallpaper images folder
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

# Set wallpaper with swww
swww img "$SELECTED" -t outer --transition-fps 100 --transition-duration 0.7

# Update Hyprlock background
ln -sf "$SELECTED" "$HYPRLOCK_BG"

# Update SDDM background (requires this FILE to have read and write permissions for the current user)
cp "$SELECTED" "/usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/black_hole.png" # MAKE SURE THIS PATH IS CORRECT AND YOU HAVE PERMISSIONS FOR THIS FILE ONLY
