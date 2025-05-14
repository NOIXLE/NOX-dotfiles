#!/bin/bash

# Base names for sinks
# Change these to your own devices, if you want them to work lol
SINK_HDMI_BASE="alsa_output.pci-0000_01_00.1"
SINK_HEADPHONES="alsa_output.usb-1532_Razer_Barracuda_X_R002000000-01.analog-stereo"

# YOU CAN GET RID OF THIS WHOLE SECTION PROBABLY
# START OF SECTION
HDMI_SINK=$(pactl list short sinks | grep "$SINK_HDMI_BASE" | awk '{print $2}')

CURRENT_SINK=$(pactl info | grep "Default Sink" | awk '{print $3}')

set_hdmi_profile() {
    CARD=$(pactl list sinks | grep -A20 "$HDMI_SINK" | grep "alsa.card_name" | head -n1 | cut -d\" -f2)
    CARD_NAME=$(pactl list cards short | grep "$CARD" | cut -f1)

    pactl set-card-profile "$CARD_NAME" "hdmi-stereo" 2>/dev/null || pactl set-card-profile "$CARD_NAME" "hdmi-stereo-extra1"
}
# END OF SECTION

if [[ "$CURRENT_SINK" == "$SINK_HEADPHONES" ]]; then
    # Switch to HDMI
    set_hdmi_profile # Can get rid of this line if you removed the previous section
    pactl set-default-sink "$HDMI_SINK"
    notify-send -i audio-volume-low-symbolic "Audio Output" "Switched to: Speakers"
else
    # Switch to Headphones
    pactl set-default-sink "$SINK_HEADPHONES"
    notify-send -i audio-headphones-symbolic "Audio Output" "Switched to: Headphones"
fi
