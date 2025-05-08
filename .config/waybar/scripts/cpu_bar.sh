#!/bin/bash

temp_raw=$(sensors 2>/dev/null | grep -m 1 'Package id 0:' | awk '{print $4}' | tr -d '+°C')
temp=${temp_raw%.*}

if [[ -z "$temp" ]]; then
    echo '{"text": "CPU N/A", "class": "unknown"}'
    exit 1
fi

temp_padded=$(printf "%02d" $temp)

blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
index=$(( (temp - 30) * 8 / 70 ))
[[ $index -lt 0 ]] && index=0
[[ $index -ge 8 ]] && index=7
block=${blocks[$index]}

# Set class
if (( temp < 60 )); then
    class="cool"
elif (( temp < 80 )); then
    class="warm"
else
    class="hot"
fi

echo "{\"text\": \"CPU $block ${temp_padded}°C\", \"class\": \"$class\"}"
