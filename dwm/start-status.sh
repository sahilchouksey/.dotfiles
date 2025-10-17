#!/bin/bash

# DWM Status Bar Daemon
# Runs the status bar script continuously

SCRIPT_DIR="/home/xix3r/dwm"
STATUS_SCRIPT="$SCRIPT_DIR/dwm-status.sh"

# Kill any existing status bar processes
pkill -f "dwm-status.sh" 2>/dev/null

# Start the status bar loop
while true; do
    "$STATUS_SCRIPT"
    sleep 2
done