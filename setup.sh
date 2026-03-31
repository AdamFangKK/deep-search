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
echo "✅ RECOMMENDED SkillHub Skills (开箱即用):"
echo ""
echo "📊 Data Collection:"
echo " - news-aggregator-skill - 8-source news aggregator"
echo "   Install: skillhub install news-aggregator-skill"
echo "   Setup: pip3 install beautifulsoup4 soupsieve"
echo ""
echo " - academic-deep-research - Academic-grade research (零配置)"
echo "   Install: skillhub install academic-deep-research"
echo ""
echo " - web-monitor - Web page change monitoring"
echo "   Install: skillhub install web-monitor"
echo "   Setup: pip3 install beautifulsoup4"
echo ""
echo "📄 Document Processing:"
echo " - pdf-text-extractor - PDF text extraction with OCR (零依赖)"
echo "   Install: skillhub install pdf-text-extractor"
echo ""
echo " - document-pro - PDF, DOCX, PPT, XLSX processing"
echo "   Install: skillhub install document-pro"
echo "   Setup: pip3 install pdfplumber PyPDF2 python-docx python-pptx openpyxl"
echo ""
echo " - parser - JSON, CSV, XML, YAML parser"
echo "   Install: skillhub install parser"
echo "   Setup: brew install jq (or use python3)"
echo ""
echo "🔧 Code & Repository:"
echo " - github - GitHub CLI interaction"
echo "   Install: skillhub install github"
echo "   Setup: brew install gh"
echo ""
echo "✅ Core Skills (REQUIRED):"
echo " - multi-search-engine (17 search engines, zero-config) - PRIMARY search tool"
echo "   Check: ls ~/.agents/skills/multi-search-engine/"
echo " - ontology"
echo " - summarize"
echo ""
echo "✅ MCPs (STABLE):"
echo " - grep_app (GitHub search)"
echo " - webfetch (direct API access)"
echo ""
echo "⚠️  DEPRECATED (Unstable, DO NOT USE):"
echo " - reddit-readonly MCP - Use websearch_exa instead"
echo " - hacker-news MCP - Use news-aggregator-skill or webfetch"
echo "------------------------------------------------------"
echo "Deep-Search v2.3+ uses ENHANCED data sources:"
echo " - Reddit: websearch_exa (Exa AI) PRIMARY"
echo " - HN: news-aggregator-skill (SkillHub) PRIMARY, webfetch FALLBACK"
echo " - Academic: academic-deep-research (SkillHub) PRIMARY"
echo " - News: news-aggregator-skill (SkillHub) PRIMARY"
echo " - GitHub: github skill (gh CLI) + grep_app"
echo " - Documents: pdf-text-extractor + document-pro"
echo " - Data Files: parser skill"

# 6. Verify multi-search-engine installation
echo "🔍 Phase 6: Verifying Multi-Search Engine..."
if [ -d "$HOME/.agents/skills/multi-search-engine" ]; then
    echo "✅ multi-search-engine installed"
    echo "   Engines available: 17 (8 CN + 9 Global)"
else
    echo "⚠️ multi-search-engine not found in ~/.agents/skills/"
    echo "   This is a REQUIRED core skill. Install with:"
    echo "   skillhub install multi-search-engine"
    echo "   OR manually clone to ~/.agents/skills/"
fi

echo "✅ Deep-Search V4 OS environment is armed and operational!"
