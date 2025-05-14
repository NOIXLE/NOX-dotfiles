#!/bin/bash

# Honestly, I won't explain this, just trust you probably don't need this
# It's for a very specific problem I have with my multi monitor setup
# Contact me directly through discord if for some reason you want this-

CARD_NAME="alsa_card.pci-0000_01_00.1"
PROFILE_1="output:hdmi-stereo"
PROFILE_2="output:hdmi-stereo-extra1"

CARD_INDEX=$(pactl list cards short | awk -v name="$CARD_NAME" '$2 == name {print $1}')

if [[ -z "$CARD_INDEX" ]]; then
    notify-send -u critical "Audio Profile Switch" "Could not find card: $CARD_NAME"
    exit 1
fi

CURRENT_PROFILE=$(pactl list cards | awk -v card="Card #$CARD_INDEX" '
  $0 == card {found=1}
  found && /Active Profile:/ {print $3; exit}
')

if [[ "$CURRENT_PROFILE" == "$PROFILE_1" ]]; then
    NEXT_PROFILE="$PROFILE_2"
    PROFILE_NAME="HDMI Extra1"
elif [[ "$CURRENT_PROFILE" == "$PROFILE_2" ]]; then
    NEXT_PROFILE="$PROFILE_1"
    PROFILE_NAME="HDMI"
else
    notify-send -u critical "Audio Profile Switch" "Unknown current profile: $CURRENT_PROFILE"
    exit 1
fi

if pactl set-card-profile "$CARD_INDEX" "$NEXT_PROFILE"; then
    notify-send -i audio-card-symbolic "Audio Output" "Switched to: $PROFILE_NAME"
else
    notify-send -u critical "Audio Profile Switch" "Failed to switch to: $NEXT_PROFILE"
    exit 1
fi
