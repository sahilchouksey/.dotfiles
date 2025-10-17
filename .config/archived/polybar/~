#!/bin/sh
# Source: https://github.com/x70b1/polybar-scripts

# Check updates for packages from the official Ubuntu repositories
if ! updates_apt=$(apt list --upgradable 2>/dev/null | grep -c '/'); then
    updates_apt=0
fi


updates=$updates_apt

if [ "$updates" -gt 0 ]; then
    echo " $updates"
else
    echo "0"
fi

