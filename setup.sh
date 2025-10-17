#!/bin/bash

# Dotfiles Setup Script
# Safely sets up dotfiles with placeholder replacement

set -e

echo "🚀 Setting up dotfiles..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to prompt for sensitive values
prompt_for_value() {
    local placeholder="$1"
    local description="$2"
    local value=""
    
    echo -e "${YELLOW}Enter $description:${NC}"
    read -r value
    
    if [[ -z "$value" ]]; then
        echo -e "${RED}Warning: Empty value provided for $description${NC}"
        return 1
    fi
    
    echo "$value"
}

# Setup git configuration
setup_git_config() {
    echo "📧 Setting up Git configuration..."
    
    if [[ -f ".gitconfig.template" ]]; then
        cp .gitconfig.template .gitconfig
        
        # Prompt for git details
        email=$(prompt_for_value "YOUR_EMAIL_HERE" "your Git email address")
        name=$(prompt_for_value "YOUR_NAME_HERE" "your Git username")
        
        # Replace placeholders
        sed -i "s/YOUR_EMAIL_HERE/$email/g" .gitconfig
        sed -i "s/YOUR_NAME_HERE/$name/g" .gitconfig
        
        echo -e "${GREEN}✅ Git configuration updated${NC}"
    else
        echo -e "${RED}❌ .gitconfig.template not found${NC}"
    fi
}

# Setup API keys in both Zed and Zsh configurations
setup_api_keys() {
    echo "🔑 Setting up API keys..."
    echo "The following API keys are optional. Press Enter to skip any you don't have:"
    
    # Collect API keys
    echo -e "${YELLOW}Anthropic API Key (for Claude):${NC}"
    read -r anthropic_key
    
    echo -e "${YELLOW}Perplexity API Key:${NC}"
    read -r perplexity_key
    
    echo -e "${YELLOW}WakaTime API Key:${NC}"
    read -r wakatime_key
    
    echo -e "${YELLOW}Tavily API Key:${NC}"
    read -r tavily_key
    
    echo -e "${YELLOW}Exa API Key:${NC}"
    read -r exa_key
    
    echo -e "${YELLOW}Firecrawl API Key:${NC}"
    read -r firecrawl_key
    
    echo -e "${YELLOW}OpenAI API Key:${NC}"
    read -r openai_key
    
    echo -e "${YELLOW}Context7 API Key:${NC}"
    read -r context7_key
    
    # Update Zed configuration
    if [[ -f ".config/zed/settings.json" ]]; then
        [[ -n "$anthropic_key" ]] && sed -i "s/YOUR_ANTHROPIC_API_KEY/$anthropic_key/g" .config/zed/settings.json
        [[ -n "$perplexity_key" ]] && sed -i "s/YOUR_PERPLEXITY_API_KEY/$perplexity_key/g" .config/zed/settings.json
        [[ -n "$wakatime_key" ]] && sed -i "s/YOUR_WAKATIME_API_KEY/$wakatime_key/g" .config/zed/settings.json
        [[ -n "$tavily_key" ]] && sed -i "s/YOUR_TAVILY_API_KEY/$tavily_key/g" .config/zed/settings.json
        [[ -n "$exa_key" ]] && sed -i "s/YOUR_EXA_API_KEY/$exa_key/g" .config/zed/settings.json
        [[ -n "$firecrawl_key" ]] && sed -i "s/YOUR_FIRECRAWL_API_KEY/$firecrawl_key/g" .config/zed/settings.json
        echo -e "${GREEN}✅ Zed configuration updated${NC}"
    fi
    
    # Update Zsh configuration
    if [[ -f ".zshrc" ]]; then
        [[ -n "$anthropic_key" ]] && sed -i "s/YOUR_ANTHROPIC_API_KEY/$anthropic_key/g" .zshrc
        [[ -n "$perplexity_key" ]] && sed -i "s/YOUR_PERPLEXITY_API_KEY/$perplexity_key/g" .zshrc
        [[ -n "$tavily_key" ]] && sed -i "s/YOUR_TAVILY_API_KEY/$tavily_key/g" .zshrc
        [[ -n "$exa_key" ]] && sed -i "s/YOUR_EXA_API_KEY/$exa_key/g" .zshrc
        [[ -n "$firecrawl_key" ]] && sed -i "s/YOUR_FIRECRAWL_API_KEY/$firecrawl_key/g" .zshrc
        [[ -n "$openai_key" ]] && sed -i "s/YOUR_OPENAI_API_KEY/$openai_key/g" .zshrc
        [[ -n "$context7_key" ]] && sed -i "s/YOUR_CONTEXT7_API_KEY/$context7_key/g" .zshrc
        echo -e "${GREEN}✅ Zsh configuration updated${NC}"
    fi
}

# Create symlinks
create_symlinks() {
    echo "🔗 Creating symlinks..."
    
    # Backup existing files
    backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    # List of files to symlink
    files=(
        ".zshrc"
        ".p10k.zsh" 
        ".xinitrc"
        ".profile"
        ".zshenv"
        ".gitconfig"
        ".config/starship.toml"
        ".config/nvim"
        ".config/tmux"
        ".config/zed"
        ".config/ghostty"
        ".config/rofi"
        ".config/vifm"
        ".config/kitty"
        "dwm"
    )
    
    for file in "${files[@]}"; do
        if [[ -e "$HOME/$file" ]] && [[ ! -L "$HOME/$file" ]]; then
            echo "Backing up existing $file"
            mv "$HOME/$file" "$backup_dir/"
        fi
        
        if [[ -e "$file" ]]; then
            ln -sf "$PWD/$file" "$HOME/$file"
            echo -e "${GREEN}✅ Linked $file${NC}"
        fi
    done
    
    echo -e "${GREEN}✅ Symlinks created. Backup saved to: $backup_dir${NC}"
}

# Security verification
verify_security() {
    echo "🔒 Running security verification..."
    
    # Check for any remaining sensitive data
    if grep -r "sk-ant-\|pplx-\|tvly-dev-\|waka_[a-f0-9]\|fc-[a-f0-9]" . --exclude-dir=.git --exclude="SECURITY.md" --exclude="setup.sh" >/dev/null 2>&1; then
        echo -e "${RED}⚠️  Warning: Potential sensitive data still found!${NC}"
        echo "Please review the files manually."
        return 1
    else
        echo -e "${GREEN}✅ Security verification passed${NC}"
        return 0
    fi
}

# Main setup
main() {
    echo "🎯 Dotfiles Setup for DWM-based Environment"
    echo "=========================================="
    
    # Check if we're in the dotfiles directory
    if [[ ! -f "README.md" ]] || [[ ! -d ".config" ]]; then
        echo -e "${RED}❌ Please run this script from the dotfiles directory${NC}"
        exit 1
    fi
    
    # Setup configurations
    setup_git_config
    setup_api_keys
    create_symlinks
    verify_security
    
    echo ""
    echo -e "${GREEN}🎉 Dotfiles setup complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.zshrc"
    echo "2. Install DWM: cd ~/dwm && sudo make install"
    echo "3. Install required fonts and dependencies"
    echo "4. Review SECURITY.md for additional security notes"
    echo ""
    echo "🔒 Security Note: Your API keys have been configured."
    echo "   Remember to never commit the actual .zshrc and .config/zed/settings.json"
    echo "   files with real API keys to version control!"
}

# Run main function
main "$@"