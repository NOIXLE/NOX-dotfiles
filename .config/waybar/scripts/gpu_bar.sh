#!/bin/bash

# This one only works if you use an nvidia card- sorry, if you can figure out how to change it for your card, yay!

max_length=4 #You can change the character length

usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)
usage=${usage:-0}
usage_padded=$(printf "%02d" "$usage")

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

# Final format for the GPU bar, you can change the text here as you like
echo "{\"text\": \"GPU [$bar] ${usage_padded}%\", \"class\": \"$class\"}"
