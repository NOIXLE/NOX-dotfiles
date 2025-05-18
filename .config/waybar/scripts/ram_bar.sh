#!/bin/bash

max_length=4 #You can change the character length

mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_available))
usage=$((100 * mem_used / mem_total))
usage_padded=$(printf "%02d" $usage)

filled_length=$(( usage * max_length / 100 ))
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
if (( usage < 50 )); then
    class="low"
elif (( usage < 80 )); then
    class="medium"
else
    class="high"
fi

# Final format for the RAM bar, you can change the text here as you like
echo "{\"text\": \"RAM [$bar] ${usage_padded}%\", \"class\": \"$class\"}"
