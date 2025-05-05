#!/bin/bash

# Get GPU usage from nvidia-smi
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n 1)

# Sanitize
usage=${usage:-0}

# Format usage with zero padding
usage_padded=$(printf "%02d" "$usage")

# Bar rendering
bar_len=4
filled=$((usage * bar_len / 100))
if (( filled > bar_len )); then filled=$bar_len; fi
bar=""
empty=""

if (( filled > 0 )); then
    bar=$(printf '█%.0s' $(seq 1 $filled))
fi

empty_count=$((bar_len - filled))
if (( empty_count > 0 )); then
    empty=$(printf '░%.0s' $(seq 1 $empty_count))
fi

bar_display="${bar}${empty}"

# Color class
if (( usage < 50 )); then
    class="low"
elif (( usage < 80 )); then
    class="medium"
else
    class="high"
fi

echo "{\"text\": \"GPU [$bar_display] ${usage_padded}%\", \"class\": \"$class\"}"
