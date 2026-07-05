#!/bin/bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
model=$(echo "$model" | sed 's/ *([^)]*)//g')
input_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$((input_tokens + output_tokens))

tokens_fmt=$(awk -v n="$total_tokens" 'BEGIN {
  if (n >= 1000) {
    printf "%.1fk", n / 1000
  } else {
    printf "%d", n
  }
}')

# Past ~100k tokens model precision starts to degrade noticeably; flag it in yellow.
if [ "$total_tokens" -ge 100000 ]; then
  tokens_fmt=$(printf '\033[33m%s\033[0m' "$tokens_fmt")
fi

printf "%s \xc2\xb7 %s" "$model" "$tokens_fmt"
