# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc file for zsh interactive shells.
# Modern, simplistic, and useful Zsh configuration

# ==================
# ZSH OPTIONS
# ==================
setopt autocd                   # change directory just by typing its name
setopt interactivecomments      # allow comments in interactive mode
setopt magicequalsubst          # enable filename expansion for arguments of the form 'anything=expression'
setopt nonomatch                # hide error message if there is no match for the pattern
setopt notify                   # report the status of background jobs immediately
setopt numericglobsort          # sort filenames numerically when it makes sense
setopt promptsubst              # enable command substitution in prompt

# Modern navigation options
setopt auto_pushd               # make cd push old directory to directory stack
setopt pushd_ignore_dups        # don't push duplicates on directory stack
setopt pushd_silent             # don't print directory stack after pushd/popd
setopt glob_dots                # include dotfiles in globbing
setopt extended_glob            # enable extended globbing

# Remove path separator from WORDCHARS
WORDCHARS=${WORDCHARS//[\/]}

# Hide EOL sign ('%')
PROMPT_EOL_MARK=""

# ==================
# HISTORY CONFIGURATION
# ==================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_expire_dups_first   # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups         # ignore duplicated commands history list
setopt hist_ignore_space        # ignore commands that start with space
setopt hist_verify              # show command with history expansion to user before running it
setopt hist_ignore_all_dups     # remove older duplicate entries from history
setopt hist_save_no_dups        # don't save duplicates to history file
setopt hist_reduce_blanks       # remove superfluous blanks from history
setopt inc_append_history       # append to history immediately

# Show the complete history
alias history="history 0"

# ==================
# KEY BINDINGS
# ==================
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action
bindkey "^[[A" up-line-or-search                  # Up arrow for history search
bindkey "^[[B" down-line-or-search                # Down arrow for history search
bindkey "^R" history-incremental-search-backward  # Ctrl+R for history search

# ==================
# COMPLETION SYSTEM
# ==================
autoload -Uz compinit
compinit -C  # Skip security check for faster startup

# Modern completion configuration
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Enhanced completion features
zstyle ':completion:*' squeeze-slashes true              # Normalize slashes
zstyle ':completion:*:cd:*' ignore-parents parent pwd    # Don't complete . or ..
zstyle ':completion:*:descriptions' format '[%d]'        # Format for completion groups
zstyle ':completion:*:warnings' format 'No matches for: %d'  # No match message

# ==================
# COLOR SUPPORT
# ==================
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# Configure less with better colors
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# ==================
# PLUGINS
# ==================
# Git completion support (disabled - obsolete script)
# Modern git completion is handled by zsh's built-in completion system
# if [ -f ~/.zsh/git-completion.bash ]; then
#     source ~/.zsh/git-completion.bash
# fi

# Zsh autosuggestions
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# Zsh syntax highlighting
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

    # Custom highlighting styles
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[path]='underline'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
fi

# ==================
# POWERLEVEL10K THEME
# ==================
# Load Powerlevel10k theme
if [ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source ~/powerlevel10k/powerlevel10k.zsh-theme
elif [ -f ~/.config/powerlevel10k/powerlevel10k.zsh-theme ]; then
    source ~/.config/powerlevel10k/powerlevel10k.zsh-theme
elif [ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Disable configuration wizard
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# ==================
# NAVIGATION ALIASES
# ==================
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias -- -='cd -'               # Go to previous directory
alias d='dirs -v'               # Show directory stack

# ==================
# LS/EXA ALIASES
# ==================
# Better ls (using exa if available, fallback to lsd, then regular ls)
if command -v exa > /dev/null 2>&1; then
    alias ls='exa --color=always --group-directories-first'
    alias la='exa -a --color=always --group-directories-first'
    alias ll='exa -l --color=always --group-directories-first'
    alias lla='exa -la --color=always --group-directories-first'
    alias lt='exa -aT --color=always --group-directories-first'
    alias l.='exa -a | egrep "^\."'
elif command -v lsd > /dev/null 2>&1; then
    alias ls='lsd --group-dirs=first'
    alias la='lsd -a --group-dirs=first'
    alias ll='lsd -lh --group-dirs=first'
    alias lla='lsd -lha --group-dirs=first'
    alias tree='lsd --tree'
else
    alias ls='ls --color=auto --group-directories-first'
    alias la='ls -A'
    alias ll='ls -l'
    alias lla='ls -la'
fi

# ==================
# EDITOR ALIASES
# ==================
# Editor aliases
if command -v nvim > /dev/null 2>&1; then
    alias vim='nvim'
    alias vi='nvim'
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v vim > /dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
fi

# Emacs aliases
alias em='/usr/bin/emacs -nw'
alias emacs="emacsclient -c -a 'emacs'"
alias doomsync="~/.emacs.d/bin/doom sync"
alias doomdoctor="~/.emacs.d/bin/doom doctor"
alias doomupgrade="~/.emacs.d/bin/doom upgrade"
alias doompurge="~/.emacs.d/bin/doom purge"

# ==================
# UTILITY ALIASES
# ==================
# Better defaults with colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias df='df -h'           # Human readable sizes
alias du='du -h'           # Human readable sizes
alias free='free -h'       # Human readable sizes
alias mkdir='mkdir -pv'    # Create parent directories and be verbose

# File operations with confirmation
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# Better cat if available
if command -v batcat > /dev/null 2>&1; then
    alias cat='batcat'
    alias bat='batcat'
elif command -v bat > /dev/null 2>&1; then
    alias cat='bat'
fi

# ==================
# GIT ALIASES
# ==================
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# ==================
# SYSTEM ALIASES
# ==================
# Process management
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# System information
alias jctl="journalctl -p 3 -xb"

# Package management (Arch/Pacman)
alias pacsyu='sudo pacman -Syyu'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null'

# Mirror management
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# ==================
# SPECIALIZED ALIASES
# ==================
# SSH fix for Kitty terminal
[[ "$TERM" == "xterm-kitty" ]] && alias ssh="kitty +kitten ssh"

# Tasks
alias tasks="calcurse"

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# GPG
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# YouTube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

# Shell switching
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

# Dotfiles management
alias config="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

# Utilities
alias tb="nc termbin.com 9999"
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# Privilege escalation
alias doas="doas --"

# ==================
# FUNCTIONS
# ==================
# Extract nmap information
function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
    echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
    echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
    echo $ports | tr -d '\n' | xclip -sel clip
    echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
    cat extractPorts.tmp; rm extractPorts.tmp
    PORTS=$ports
}

# Create directories for pentesting
function mkt(){
    mkdir -p {nmap,content,exploits,scripts}
}

# Target management functions
function starget(){
    /usr/bin/echo $1 > $HOME/.config/bspwm/scripts/target
    TARGET_IP=$1
}

function utarget(){
    /usr/bin/rm -rf $HOME/.config/bspwm/scripts/target
    TARGET_IP=""
}

# Extract various archive types
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick directory creation and navigation
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Search for a file and highlight matches
function search() {
    find . -name "*$1*" -type f 2>/dev/null | head -20
}

# Helper function to show useful commands
function help-zsh() {
    echo "📋 Useful Zsh functions and aliases:"
    echo "   extract <file>    - Extract various archive formats"
    echo "   mkcd <dir>        - Create directory and cd into it"
    echo "   search <pattern>  - Find files matching pattern"
    echo "   mkt               - Create pentesting directories"
    echo "   extractPorts <file> - Extract ports from nmap scan"
    echo "   ..                - Go up one directory"
    echo "   ...               - Go up two directories"
    echo "   ll                - List files in long format"
    echo "   la                - List all files including hidden"
    echo "   d                 - Show directory stack"
    echo "   -                 - Go to previous directory"
    echo "   help-zsh          - Show this help"
}

# ==================
# TERMINAL TITLE
# ==================
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    precmd() {
        print -Pn "\e]0;%n@%m: %~\a"
    }
    ;;
esac

# ==================
# COMMAND NOT FOUND
# ==================
if [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

# Configure time format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# ==================
# FINAL CLEANUP
# ==================
# Remove duplicates from PATH
typeset -U PATH path

# XIX3R Custom Aliases for Cyberpunk Rice Pomodoro
alias pomo='~/.config/bspwm/scripts/pomodoro_manager.sh'
alias pomodoro='~/.config/bspwm/scripts/pomodoro_manager.sh --menu'
alias pomo-add='~/.config/bspwm/scripts/pomodoro_manager.sh --add'
alias pomo-start='~/.config/bspwm/scripts/pomodoro_manager.sh --start'
alias pomo-stop='~/.config/bspwm/scripts/pomodoro_manager.sh --stop'
alias pomo-complete='~/.config/bspwm/scripts/pomodoro_manager.sh --complete'
alias pomo-status='~/.config/bspwm/scripts/pomodoro_manager.sh --status'

# Welcome message
ascii_art="
              .
             .=.    .
      ..     :+-    :-
     .=.     -+=.   :+:
     -+:    .=++:   :+=:
    :++:    :+++=.  :++=.
   .=++:   .=++++:  :+++=.
   -+++-   .=++++:  :++++-
  .=+++-   .-+++=.  .+++=.
   -+++-    -+++-.  .=++:
   .-++-    :+++:   .=+=.
    .=+=.   .=+=.   .==.
     :==.   .=+-    .=:
      :=.   .-+:     :
       .     -=.
             ::
"

echo "$ascii_art"

export PATH="$PATH:/home/xix3r/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/home/xix3r/.cargo/bin"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$PATH:$(go env GOPATH)/bin
function cursor() {
    /opt/cursor.appimage --no-sandbox "${@}" > /dev/null 2>&1 & disown
}


# opencode
export PATH=/home/xix3r/.opencode/bin:$PATH

# export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
#export GITHUB_TOKEN="YOUR_GITHUB_TOKEN"
#alias chromium="/usr/bin/chromium --enable-
#gpu-rasterization --enable-zero-copy --use-gl=desktop --
#enable-features=MemoryAblation,V8ContextSnapshot --disable-
#features=BackForwardCache --renderer-process-limit=4 --js-
#flags=\"--max-old-space-size=512\""
#alias chrome="/usr/bin/chromium --enable-
#gpu-rasterization --enable-zero-copy --use-gl=desktop --
#enable-features=MemoryAblation,V8ContextSnapshot --disable-
#features=BackForwardCache --renderer-process-limit=4 --js-
#flags=\"--max-old-space-size=512\""


export FIRECRAWL_API_KEY="YOUR_FIRECRAWL_API_KEY"
export EXA_API_KEY="YOUR_EXA_API_KEY"
export TAVILY_API_KEY="YOUR_TAVILY_API_KEY"
export PERPLEXITY_API_KEY="YOUR_PERPLEXITY_API_KEY"
export ANTHROPIC_API_KEY="YOUR_ANTHROPIC_API_KEY"

# Task Master aliases added on 8/12/2025
alias tm='task-master'
alias taskmaster='task-master'

alias op='opencode'

export AZURE_RESOURCE_NAME="YOUR_AZURE_RESOURCE_NAME"
export OPENAI_API_KEY="YOUR_OPENAI_API_KEY"

# ==================
# WAYLAND APPLICATION ALIASES
# ==================
# Added on 08/15/2025 - Fix for Hyprland Wayland applications
alias chromium='env -u DISPLAY XDG_CURRENT_DESKTOP=Hyprland chromium --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias chrome='env -u DISPLAY XDG_CURRENT_DESKTOP=Hyprland chromium --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias firefox='env -u DISPLAY MOZ_ENABLE_WAYLAND=1 firefox'
alias code='env -u DISPLAY code --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias discord='env -u DISPLAY discord --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias spotify='env -u DISPLAY spotify --enable-features=UseOzonePlatform --ozone-platform=wayland'
export ANDROID_HOME=~/Android/Sdk
# export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools


export CONTEXT7_API_KEY="YOUR_CONTEXT7_API_KEY"

# ==================
# IMAGE VIEWER & APPLICATION ALIASES
# ==================
# Native Wayland image viewer (recommended)
alias imv='imv-wayland'

# X11 applications with software rendering fallback
#alias nsxiv='LIBGL_ALWAYS_SOFTWARE=1 DISPLAY=:1 nsxiv'
#alias sxiv='LIBGL_ALWAYS_SOFTWARE=1 DISPLAY=:1 nsxiv'

# WezTerm with proper dual-GPU environment
alias wezterm='GBM_BACKEND=nvidia-drm __GLX_VENDOR_LIBRARY_NAME=nvidia WLR_NO_HARDWARE_CURSORS=1 wezterm start'
alias wezterm-fallback='LIBGL_ALWAYS_SOFTWARE=1 wezterm start'

export PATH=$HOME/.local/bin:$PATH
export PATH="$HOME/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/xix3r/google-cloud-sdk/path.zsh.inc' ]; then . '/home/xix3r/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/xix3r/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/xix3r/google-cloud-sdk/completion.zsh.inc'; fi

# For rendering Tauri Based application in my X11 twm
export LIBGL_ALWAYS_SOFTWARE=1
