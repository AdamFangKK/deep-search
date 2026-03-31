#!/bin/bash
# setup-env.sh - Quick environment setup for deep-search

echo "🚀 Setting up Deep-Search Environment..."

# Install system dependencies (macOS)
if command -v brew &>/dev/null; then
    echo "📦 Installing system dependencies..."
    brew list jq &>/dev/null || brew install jq
    brew list gh &>/dev/null || brew install gh
fi

# Install Python dependencies
echo "🐍 Installing Python dependencies..."
pip3 install beautifulsoup4 soupsieve pdfplumber PyPDF2 python-docx python-pptx openpyxl

# Install SkillHub skills
echo "🛠️  Installing SkillHub skills..."
skillhub install news-aggregator-skill
skillhub install academic-deep-research

# Optional skills
echo ""
echo "Optional skills (install as needed):"
echo "  skillhub install web-monitor"
echo "  skillhub install pdf-text-extractor"
echo "  skillhub install document-pro"
echo "  skillhub install parser"
echo "  skillhub install github"

echo ""
echo "✅ Setup complete! Run ./check-tools.sh to verify."
