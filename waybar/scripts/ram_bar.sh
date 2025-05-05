#!/bin/bash

# Get memory values in kB
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')

# Calculate used memory (excluding buffers/cache)
mem_used=$((mem_total - mem_available))
usage=$((100 * mem_used / mem_total))

# Pad percentage to 2 digits
usage_padded=$(printf "%02d" $usage)

# ASCII bar rendering
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

# Output JSON
echo "{\"text\": \"RAM [$bar_display] ${usage_padded}%\", \"class\": \"$class\"}"
