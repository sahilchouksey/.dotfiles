#!/bin/bash

# DWM Status Bar Script
# Toggle between minimal and full mode with Super+Shift+L

STATE_FILE="$HOME/.dwm-status-mode"

# Check current mode (default to minimal)
if [[ -f "$STATE_FILE" ]]; then
    MODE=$(cat "$STATE_FILE")
else
    MODE="minimal"
    echo "minimal" > "$STATE_FILE"
fi

get_battery() {
    local battery_path="/sys/class/power_supply/BAT1"
    if [[ -d "$battery_path" ]]; then
        local capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")
        local status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")

        # Battery icon based on level
        if [[ $capacity -ge 80 ]]; then
            icon="🔋"
        elif [[ $capacity -ge 60 ]]; then
            icon="🔋"
        elif [[ $capacity -ge 40 ]]; then
            icon="🔋"
        elif [[ $capacity -ge 20 ]]; then
            icon="🪫"
        else
            icon="🪫"
        fi

        # Charging indicator
        if [[ "$status" == "Charging" ]]; then
            icon="⚡"
        fi

        echo "$icon $capacity%"
    else
        echo "🔌 AC"
    fi
}

get_network() {
    # Check WiFi first - look for wireless interfaces
    for iface in /sys/class/net/wl*; do
        if [[ -d "$iface" ]]; then
            local ifname=$(basename "$iface")
            local operstate=$(cat "$iface/operstate" 2>/dev/null)
            if [[ "$operstate" == "up" ]]; then
                # Try to get SSID using iw or iwconfig
                local ssid=""
                if command -v iw &>/dev/null; then
                    ssid=$(iw dev "$ifname" info 2>/dev/null | grep "ssid" | sed 's/.*ssid //')
                elif [[ -x /sbin/iwconfig ]]; then
                    ssid=$(/sbin/iwconfig "$ifname" 2>/dev/null | grep "ESSID" | cut -d'"' -f2)
                fi

                if [[ -n "$ssid" && "$ssid" != "off/any" ]]; then
                    echo "📶 $ssid"
                    return
                else
                    echo "📶 WiFi"
                    return
                fi
            fi
        fi
    done

    # Check ethernet
    for iface in /sys/class/net/e{n,th}*; do
        if [[ -d "$iface" ]]; then
            local ifname=$(basename "$iface")
            local operstate=$(cat "$iface/operstate" 2>/dev/null)
            if [[ "$operstate" == "up" ]]; then
                echo "🌐 Ethernet"
                return
            fi
        fi
    done

    echo "❌ Disconnected"
}

get_storage() {
    local usage=$(df -B1 / | awk 'NR==2 {printf "%.1f GB free\n", $4/1000/1000/1000}')
    echo "💾 $usage"
}

get_memory() {
    local mem_info=$(awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%.1fG/%.1fG\n", (t-a)/1024/1024, t/1024/1024}' /proc/meminfo)
    echo "🧠 $mem_info"
}

get_cpu() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
    echo "⚡ $cpu_usage"
}

get_time() {
    date '+%H:%M %d/%m'
}

get_workspace() {
    # This will be handled by dwm itself, just placeholder
    echo ""
}

# Toggle function
toggle_mode() {
    if [[ "$MODE" == "full" ]]; then
        echo "minimal" > "$STATE_FILE"
    else
        echo "full" > "$STATE_FILE"
    fi
}

# Handle toggle command
if [[ "$1" == "toggle" ]]; then
    echo "$(date): Toggle command received" >> /tmp/dwm-toggle.log
    toggle_mode
    # Re-read the mode after toggling
    MODE=$(cat "$STATE_FILE")
    echo "$(date): Mode changed to $MODE" >> /tmp/dwm-toggle.log
fi

# Build status string based on mode
if [[ "$MODE" == "minimal" ]]; then
    # Minimal mode: just workspace (handled by dwm) + time
    status=" $(get_time)"
else
    # Full mode: all system info
    battery=$(get_battery)
    network=$(get_network)
    storage=$(get_storage)
    memory=$(get_memory)
    cpu=$(get_cpu)
    time=$(get_time)

    status=" $cpu | $memory | $storage | $network | $battery | $time"
fi

# Set the status
xsetroot -name "$status"
