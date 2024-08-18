#!/usr/bin/env bash
battery_percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "percentage" | awk '{print $2}' | grep -v "^$" | tr -d ' ')
echo "$(~/.local/bin/volume) - BAT=$(echo "$battery_percentage")"
