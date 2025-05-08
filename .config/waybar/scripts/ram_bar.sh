#!/bin/bash

mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_available))
usage=$((100 * mem_used / mem_total))

usage_padded=$(printf "%02d" $usage)

blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
index=$((usage * 8 / 100))
[[ $index -ge 8 ]] && index=7
block=${blocks[$index]}

if (( usage < 50 )); then
    class="low"
elif (( usage < 80 )); then
    class="medium"
else
    class="high"
fi

echo "{\"text\": \"RAM $block $usage_padded%\", \"class\": \"$class\"}"
