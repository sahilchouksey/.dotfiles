#!/usr/bin/env bash

# Function to get volume percentage
get_volume() {
    # Replace with your command to retrieve volume (example uses amixer)
    volume=$(amixer sget Master | grep -oE '[0-9]{1,3}?%' | head -1 | tr -d '%')
    echo "$volume%"
}

# Function to get battery percentage
get_battery() {
    # Replace with your command to retrieve battery percentage (example uses upower)
    battery_percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep "percentage" | awk '{print $2}' | grep -v "^$" | tr -d ' ')
    echo "BAT=$battery_percentage%"
}

# Main script
volume=$(get_volume)
battery=$(get_battery)
echo "$volume - $battery"

