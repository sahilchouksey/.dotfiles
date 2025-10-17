# 🏠 Dotfiles - DWM-Based Linux Setup

Modern, minimalist dotfiles configuration featuring DWM window manager, Neovim with Lazy.nvim, and a curated development environment.

## 🚀 Quick Start

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

## 🎯 What's Included

### 🪟 Window Manager
- **DWM** - Suckless dynamic window manager with custom patches
- **Custom status bar** with system information
- **Picom** compositor for transparency and effects

### 🐚 Shell Environment  
- **Zsh** with Powerlevel10k theme
- **Starship** prompt for additional customization
- **Modern aliases** and productivity functions
- **Development environment** setup (Java, Android, Node.js)

### ⚡ Editor & Development
- **Neovim** with Lazy.nvim plugin manager (migrated from Packer)
- **Zed Editor** configuration with AI integrations
- **Tmux** with enhanced status bar and plugins
- **Git** configuration with GitHub CLI integration

### 🖥️ Terminal & Applications
- **Ghostty** - Modern terminal emulator
- **Kitty** - GPU-accelerated terminal
- **Rofi** - Application launcher and window switcher
- **Vifm** - Vi-like file manager

## 📁 Structure

```
.dotfiles/
├── .config/
│   ├── nvim/           # Neovim with Lazy.nvim
│   ├── tmux/           # Tmux with plugins
│   ├── zed/            # Zed editor (with secure placeholders)
│   ├── ghostty/        # Ghostty terminal
│   ├── rofi/           # Rofi launcher
│   ├── starship.toml   # Starship prompt
│   └── archived/       # Old configs (i3, waybar, etc.)
├── dwm/                # DWM source and configuration
├── .zshrc              # Zsh configuration
├── .p10k.zsh           # Powerlevel10k theme
├── .xinitrc            # X11 startup script
├── .gitconfig.template # Git config template
├── setup.sh            # Automated setup script
├── SECURITY.md         # Security guidelines
└── README.md           # This file
```

## 🔧 Installation

### Prerequisites

```bash
# Arch Linux / Manjaro
sudo pacman -S git zsh tmux neovim nodejs npm python pip

# Ubuntu / Debian  
sudo apt install git zsh tmux neovim nodejs npm python3 python3-pip

# Install additional tools
# - DWM dependencies: libx11-dev libxft-dev libxinerama-dev
# - Fonts: JetBrains Mono Nerd Font, FiraCode Nerd Font
# - Optional: picom, rofi, feh, dmenu
```

### Step-by-Step Setup

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the setup script:**
   ```bash
   ./setup.sh
   ```
   This will:
   - Prompt for API keys and personal information
   - Create secure configurations
   - Backup existing dotfiles
   - Create symlinks

3. **Install DWM:**
   ```bash
   cd ~/dwm
   sudo make clean install
   ```

4. **Install shell plugins:**
   ```bash
   # Oh My Zsh (if not installed)
   sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   
   # Powerlevel10k
   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
   ```

5. **Install Neovim plugins:**
   ```bash
   nvim  # Lazy.nvim will auto-install plugins
   ```

## 🔒 Security

This repository uses **placeholder values** for sensitive information:

- API keys are replaced with `YOUR_*_API_KEY` placeholders
- Personal information uses `YOUR_*_HERE` placeholders
- See `SECURITY.md` for detailed security guidelines

**⚠️ Never commit real API keys or sensitive data!**

## 🎨 Customization

### DWM Configuration
- Edit `dwm/config.h` for keybindings and appearance
- Rebuild with `sudo make clean install`

### Neovim Setup
- Configuration in `.config/nvim/lua/xix/`
- Uses Lazy.nvim for plugin management
- Includes LSP, treesitter, and modern editing features

### Zsh Customization
- Main config in `.zshrc`
- Powerlevel10k theme in `.p10k.zsh`
- Additional prompt customization via Starship

### Tmux Enhancement
- Custom status bar with system info
- Plugin management via TPM
- Catppuccin theme with wakatime integration

## 🔄 Migration Notes

### From Previous Setup
- **Window Manager**: Migrated from i3/waybar/hyprland to DWM
- **Neovim**: Migrated from Packer to Lazy.nvim
- **Shell**: Enhanced with Powerlevel10k and modern tools
- **Archived**: Old configs moved to `.config/archived/`

### Key Changes
- Simplified window management with DWM
- Faster plugin loading with Lazy.nvim
- Enhanced development environment
- Improved security with placeholder system

## 🛠️ Troubleshooting

### Common Issues

1. **DWM not starting:**
   ```bash
   # Check .xinitrc permissions
   chmod +x ~/.xinitrc
   
   # Verify DWM installation
   which dwm
   ```

2. **Zsh theme not loading:**
   ```bash
   # Source the configuration
   source ~/.zshrc
   
   # Check Powerlevel10k installation
   ls ~/powerlevel10k/
   ```

3. **Neovim plugins not loading:**
   ```bash
   # Check Lazy.nvim status
   nvim -c "Lazy"
   
   # Update plugins
   nvim -c "Lazy update"
   ```

### Getting Help

- Check individual config files for inline documentation
- Review `SECURITY.md` for security-related issues
- Ensure all dependencies are installed
- Verify file permissions and symlinks

## 📝 License

This configuration is provided as-is for personal use. Individual tools and plugins maintain their respective licenses.

## 🙏 Acknowledgments

- [DWM](https://dwm.suckless.org/) - Suckless dynamic window manager
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Modern Neovim plugin manager
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [Starship](https://starship.rs/) - Cross-shell prompt
- Various plugin authors and the open-source community

---

**Happy coding! 🚀**