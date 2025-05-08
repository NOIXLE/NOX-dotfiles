#!/bin/bash
current_player=$(playerctl metadata --format '{{playerName}}')
if [ "$current_player" == "spotify" ]; then
    song_info=$(playerctl metadata --format ' {{title}} - {{artist}}')
else
    song_info=$(playerctl metadata --format ' {{title}} - {{artist}}')
fi

echo "$song_info" 
