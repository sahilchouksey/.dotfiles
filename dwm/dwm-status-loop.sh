#!/bin/bash

# DWM Status Bar Loop Script
# Continuously updates the status bar

SCRIPT_DIR="$(dirname "$0")"
STATUS_SCRIPT="$SCRIPT_DIR/dwm-status.sh"

# Kill any existing status loop (but not this one)
for pid in $(pgrep -f "dwm-status-loop.sh"); do
    if [ $pid -ne $$ ]; then
        kill $pid 2>/dev/null
    fi
done
pkill -f "dwm-status.sh" 2>/dev/null

# Start the status loop
while true; do
    "$STATUS_SCRIPT"
    sleep 2
done