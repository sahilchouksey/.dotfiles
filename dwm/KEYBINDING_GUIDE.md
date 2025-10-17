# DWM Custom Keybinding Guide

## Current Issue: Super+Shift+L Not Working

The keybinding is configured but DWM needs to be restarted to load new keybindings.

### Quick Fix:
1. **Restart DWM**: Log out and log back in, or restart your X session
2. **Alternative**: Use the manual toggle command:
   ```bash
   /home/xix3r/dwm/dwm-status.sh toggle
   ```

## Adding Custom Keybindings to DWM

### Step 1: Edit config.h
```bash
cd /home/xix3r/dwm
nano config.h  # or your preferred editor
```

### Step 2: Add Your Command
In the commands section (around line 60), add:
```c
static const char *yourcmd[] = { "your-command", "arg1", "arg2", NULL };
```

### Step 3: Add Keybinding
In the `keys[]` array (around line 65), add:
```c
{ MODKEY|ShiftMask,             XK_yourkey,    spawn,          {.v = yourcmd } },
```

### Step 4: Compile and Install
```bash
cd /home/xix3r/dwm
make clean
make
sudo make install
```

### Step 5: Restart DWM
- Log out and log back in, OR
- Restart X server, OR
- Use: `Super+Ctrl+Shift+E` (quit DWM) then restart

## Key Modifiers Available:
- `MODKEY` = Super/Windows key
- `MODKEY|ShiftMask` = Super + Shift
- `MODKEY|ControlMask` = Super + Ctrl
- `MODKEY|ControlMask|ShiftMask` = Super + Ctrl + Shift

## Available Keys:
- `XK_a` through `XK_z` = Letters
- `XK_1` through `XK_9` = Numbers
- `XK_Return` = Enter
- `XK_space` = Spacebar
- `XK_Tab` = Tab
- `XK_Left`, `XK_Right`, `XK_Up`, `XK_Down` = Arrow keys

## Example Keybindings:
```c
// Launch Firefox
static const char *firefox[] = { "firefox", NULL };
{ MODKEY,                       XK_w,      spawn,          {.v = firefox } },

// Volume controls
static const char *volupcmd[] = { "amixer", "set", "Master", "5%+", NULL };
static const char *voldowncmd[] = { "amixer", "set", "Master", "5%-", NULL };
{ MODKEY,                       XK_equal,  spawn,          {.v = volupcmd } },
{ MODKEY,                       XK_minus,  spawn,          {.v = voldowncmd } },

// Screenshot
static const char *screenshot[] = { "scrot", "/home/xix3r/Pictures/screenshot.png", NULL };
{ MODKEY,                       XK_Print,  spawn,          {.v = screenshot } },
```

## Current Status Bar Keybinding:
- **Super+Shift+L**: Toggle between minimal and full status bar
- **Manual**: `/home/xix3r/dwm/dwm-status.sh toggle`

## Status Bar Modes:
- **Minimal**: Shows only time
- **Full**: Shows CPU, memory, storage, network, battery, and time