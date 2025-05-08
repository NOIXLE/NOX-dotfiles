#!/bin/bash

usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)
usage=${usage:-0}
usage_padded=$(printf "%02d" "$usage")

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

echo "{\"text\": \"GPU $block $usage_padded%\", \"class\": \"$class\"}"
