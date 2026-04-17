#!/bin/bash
# check-tools.sh - Environment verification script for deep-search

echo "🔍 Deep-Search Environment Check"
echo "=================================="

# Check system dependencies
echo ""
echo "📦 System Dependencies:"
which curl &>/dev/null && echo "✅ curl" || echo "❌ curl - install: brew install curl"
which jq &>/dev/null && echo "✅ jq" || echo "❌ jq - install: brew install jq"
which git &>/dev/null && echo "✅ git" || echo "❌ git"
which gh &>/dev/null && echo "✅ gh CLI" || echo "⚠️ gh CLI - optional, install: brew install gh"

# Check Python dependencies
echo ""
echo "🐍 Python Dependencies:"
python3 -c "import bs4" 2>/dev/null && echo "✅ beautifulsoup4" || echo "❌ beautifulsoup4 - install: pip3 install beautifulsoup4"
python3 -c "import pdfplumber" 2>/dev/null && echo "✅ pdfplumber" || echo "❌ pdfplumber - install: pip3 install pdfplumber"
python3 -c "import openpyxl" 2>/dev/null && echo "✅ openpyxl" || echo "❌ openpyxl - install: pip3 install openpyxl"
python3 -c "import pandas" 2>/dev/null && echo "✅ pandas" || echo "⚠️ pandas - optional, install: pip3 install pandas"
python3 -c "import yt_dlp" 2>/dev/null && echo "✅ yt-dlp" || echo "⚠️ yt-dlp - optional, install: pip3 install yt-dlp"

# Check SkillHub skills
echo ""
echo "🛠️  SkillHub Skills:"
HOME_SKILLS_DIR="$HOME/.agents/skills"
WORKSPACE_SKILLS_DIR="$(pwd)/skills"

check_skill() {
    local skill_name="$1"
    local install_hint="$2"
    if [ -d "$HOME_SKILLS_DIR/$skill_name" ] || [ -d "$WORKSPACE_SKILLS_DIR/$skill_name" ]; then
        echo "✅ $skill_name"
    else
        echo "$install_hint"
    fi
}

check_skill "news-aggregator-skill" "⚠️  news-aggregator-skill - install: skillhub install news-aggregator-skill"
check_skill "academic-deep-research" "⚠️  academic-deep-research - install: skillhub install academic-deep-research"
check_skill "web-monitor" "⚠️  web-monitor - optional"
check_skill "pdf-text-extractor" "⚠️  pdf-text-extractor - optional"
check_skill "github" "⚠️  github - optional"

echo ""
echo "=================================="
echo "Check complete!"
