# xinitrc - X11 initialization script
# This file is executed when starting X11 session

# Load custom key mappings
xmodmap ~/.Xmodmap &

# Start compositor for transparency and effects
picom --backend glx --blur-method dual_kawase --blur-strength 5 &

# Start DWM status bar
~/dwm/start-status.sh &

# Execute DWM window manager
exec dwm