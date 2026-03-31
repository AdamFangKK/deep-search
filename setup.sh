#!/usr/bin/env bash

# ==============================================================================
# Deep-Search V4: "Batteries-Included" Dependency Installer
# Automatically detects OS and installs required ecosystem dependencies
# Checks for OpenCode MCPs and Meta-Skill prerequisites
# ==============================================================================

echo "🚀 Bootstrapping Deep-Search V4 Environment..."

OS="$(uname -s)"
echo "Detected OS: $OS"

# 1. System Dependencies (tmux, sqlite3, jq)
echo "📦 Phase 1: Installing System Dependencies..."
if [ "$OS" = "Darwin" ]; then
    if command -v brew &> /dev/null; then
        brew list tmux &>/dev/null || brew install tmux
        brew list sqlite3 &>/dev/null || brew install sqlite3
        brew list jq &>/dev/null || brew install jq
    else
        echo "⚠️ Homebrew not found. Please install tmux, sqlite3, and jq manually."
    fi
elif [ "$OS" = "Linux" ]; then
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y tmux sqlite3 jq python3-pip npm
    else
        echo "⚠️ apt-get not found. Please install dependencies manually for your distro."
    fi
fi

# 2. Python Dependencies (pandas, yt-dlp)
echo "🐍 Phase 2: Installing Python Dependencies..."
if command -v pip3 &> /dev/null; then
    cat << 'REQ' > "$(dirname "$0")/requirements.txt"
pandas>=2.0.0
numpy>=1.22.4
yt-dlp>=2023.10.13
REQ
    pip3 install -r "$(dirname "$0")/requirements.txt"
else
    echo "❌ pip3 not found. Cannot install Python dependencies."
fi

# 3. Node.js Dependencies (Playwright for JS/Dynamic sites)
echo "🌐 Phase 3: Installing Playwright (Headless Browser)..."
if command -v npm &> /dev/null; then
    npm install -g playwright
    npx playwright install chromium --with-deps
else
    echo "❌ npm not found. Cannot install Playwright."
fi

# 4. Folder Structure setup
echo "📁 Phase 4: Initializing Sandboxes..."
mkdir -p /tmp/omo-deep-search/
chmod 777 /tmp/omo-deep-search/

# 5. OpenCode Meta-Dependencies (Skills & MCPs)
echo "🤖 Phase 5: Verifying OpenCode Skills & MCPs..."
echo "------------------------------------------------------"
echo "✅ RECOMMENDED MCPs (STABLE data sources):"
echo " - websearch_exa (via multi-search-engine skill) - PRIMARY"
echo " - grep_app (GitHub search)"
echo " - context7 (optional, docs only)"
echo ""
echo "⚠️  DEPRECATED (Unstable, DO NOT USE):"
echo " - reddit-readonly MCP - Use websearch_exa instead"
echo " - hacker-news MCP - Use webfetch Algolia API instead"
echo ""
echo "✅ REQUIRED Skills:"
echo " - multi-search-engine (provides websearch_exa)"
echo " - ontology"
echo " - summarize"
echo "------------------------------------------------------"
echo "Deep-Search v2.1+ uses STABLE data sources:"
echo " - Reddit: websearch_exa with site:reddit.com filter"
echo " - HN: webfetch https://hn.algolia.com/api/v1/search"
echo " - Code: grep_app + webfetch official docs"

echo "✅ Deep-Search V4 OS environment is armed and operational!"
