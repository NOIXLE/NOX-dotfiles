#!/bin/bash

# This script just picks up the current player data so it's shown in the hyprlock screen
# It also has a very specific IF statement to display Spotify's logo when it's the current player
# Remove the IF statement and uncomment the last comment if you don't want the Spotify condition
current_player=$(playerctl metadata --format '{{playerName}}')
if [ "$current_player" == "spotify" ]; then
    song_info=$(playerctl metadata --format ' {{title}} - {{artist}}')
else
    song_info=$(playerctl metadata --format ' {{title}} - {{artist}}')
fi

# song_info=$(playerctl metadata --format ' {{title}} - {{artist}}')
echo "$song_info" 
