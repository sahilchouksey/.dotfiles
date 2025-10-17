# Security Configuration Guide

## 🔒 Sensitive Information Handling

This dotfiles repository uses **placeholder values** for sensitive information like API keys. You need to replace these placeholders with your actual values after installation.

## 📋 Required API Keys

### Zed Editor Configuration
Replace the following placeholders in `.config/zed/settings.json`:

- `YOUR_ANTHROPIC_API_KEY` - Get from: https://console.anthropic.com/
- `YOUR_PERPLEXITY_API_KEY` - Get from: https://www.perplexity.ai/settings/api
- `YOUR_TAVILY_API_KEY` - Get from: https://tavily.com/
- `YOUR_EXA_API_KEY` - Get from: https://exa.ai/
- `YOUR_FIRECRAWL_API_KEY` - Get from: https://firecrawl.dev/
- `YOUR_WAKATIME_API_KEY` - Get from: https://wakatime.com/api-key

### Git Configuration
Replace the following placeholders in `.gitconfig.template`:

- `YOUR_EMAIL_HERE` - Your git email address
- `YOUR_NAME_HERE` - Your git username

## 🚀 Setup Instructions

1. **Copy template files:**
   ```bash
   cp .gitconfig.template .gitconfig
   ```

2. **Replace placeholders:**
   ```bash
   # Edit git config
   nano .gitconfig
   
   # Edit Zed config  
   nano .config/zed/settings.json
   ```

3. **Set environment variables (Alternative):**
   ```bash
   export ANTHROPIC_API_KEY="your-actual-key"
   export PERPLEXITY_API_KEY="your-actual-key"
   # ... etc
   ```

## ⚠️ Important Security Notes

- **NEVER** commit files with real API keys
- **ALWAYS** use placeholders in the repository
- **REVOKE** any accidentally committed keys immediately
- **USE** environment variables when possible

## 🔍 Verification

Before committing changes, run:
```bash
grep -r "sk-\|pplx-\|tvly-\|waka_\|fc-" . --exclude-dir=.git
```

This should return **NO RESULTS** if all sensitive data is properly handled.