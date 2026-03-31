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
python3 -c "import beautifulsoup4" 2>/dev/null && echo "✅ beautifulsoup4" || echo "❌ beautifulsoup4 - install: pip3 install beautifulsoup4"
python3 -c "import pdfplumber" 2>/dev/null && echo "✅ pdfplumber" || echo "❌ pdfplumber - install: pip3 install pdfplumber"
python3 -c "import openpyxl" 2>/dev/null && echo "✅ openpyxl" || echo "❌ openpyxl - install: pip3 install openpyxl"

# Check SkillHub skills
echo ""
echo "🛠️  SkillHub Skills:"
SKILLS_DIR="$HOME/.agents/skills"
[ -d "$SKILLS_DIR/news-aggregator-skill" ] && echo "✅ news-aggregator-skill" || echo "⚠️  news-aggregator-skill - install: skillhub install news-aggregator-skill"
[ -d "$SKILLS_DIR/academic-deep-research" ] && echo "✅ academic-deep-research" || echo "⚠️  academic-deep-research - install: skillhub install academic-deep-research"
[ -d "$SKILLS_DIR/web-monitor" ] && echo "✅ web-monitor" || echo "⚠️  web-monitor - optional"
[ -d "$SKILLS_DIR/pdf-text-extractor" ] && echo "✅ pdf-text-extractor" || echo "⚠️  pdf-text-extractor - optional"
[ -d "$SKILLS_DIR/github" ] && echo "✅ github" || echo "⚠️  github - optional"

echo ""
echo "=================================="
echo "Check complete!"
