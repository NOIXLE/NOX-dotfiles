#!/bin/bash

# CPU usage calculation using delta method
read cpu a b c d rest < /proc/stat
prev_idle=$d
prev_total=$((a + b + c + d))

sleep 0.5

read cpu a2 b2 c2 d2 rest < /proc/stat
idle=$d2
total=$((a2 + b2 + c2 + d2))

diff_idle=$((idle - prev_idle))
diff_total=$((total - prev_total))
usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))

# Pad to 2 digits
usage_padded=$(printf "%02d" $usage)

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

echo "{\"text\": \"CPU [$bar_display] ${usage_padded}%\", \"class\": \"$class\"}"
