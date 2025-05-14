#!/bin/bash

# Uhh, CPU Bar script

max_length=4 #You can change the character length

temp_raw=$(sensors 2>/dev/null | grep -m 1 'Package id 0:' | awk '{print $4}' | tr -d '+°C')
temp=${temp_raw%.*}

if [[ -z "$temp" ]]; then
    echo '{"text": "CPU N/A", "class": "unknown"}' # Default text if for some reason it didn't find the value of temp
    exit 1
fi

temp_padded=$(printf "%02d" "$temp")

max_temp=100

filled_length=$(( temp * max_length / max_temp ))
(( filled_length > max_length )) && filled_length=$max_length

bar=""
for ((i=0; i<max_length; i++)); do
    if (( i < filled_length )); then
        bar+="█"
    else
        bar+="░"
    fi
done

# Waybar CSS classes for different values
if (( temp < 60 )); then
    class="cool"
elif (( temp < 80 )); then
    class="warm"
else
    class="hot"
fi

# Final format for the CPU bar, you can change the text here as you like
echo "{\"text\": \"CPU [$bar] ${temp_padded}°C\", \"class\": \"$class\"}"
