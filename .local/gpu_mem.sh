#!/bin/bash

# Fetch used and total GPU memory in MiB using nvidia-smi
USED_MEM=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
TOTAL_MEM=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)

# Function to convert MiB to GiB if over 999 MiB, and format with 1 decimal place
convert_to_gb_or_mb() {
  local mem_in_mb=$1

  # Use bc to compare values and handle arithmetic properly
  if (( $(echo "$mem_in_mb > 999" | bc -l) )); then
    # Convert to GiB and format with 1 decimal place
    echo "$(echo "scale=1; $mem_in_mb / 1024" | bc) GiB"
  else
    # Keep in MiB and format with 1 decimal place
    echo "${mem_in_mb} MiB"
  fi
}

# Convert used and total memory
USED_MEM_FORMATTED=$(convert_to_gb_or_mb $USED_MEM)
TOTAL_MEM_FORMATTED=$(convert_to_gb_or_mb $TOTAL_MEM)

# Output in "USED_MEM / TOTAL_MEM" format
echo "${USED_MEM_FORMATTED} / ${TOTAL_MEM_FORMATTED}"

