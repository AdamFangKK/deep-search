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
pip3 install beautifulsoup4>=4.14.0 soupsieve>=2.8.0 pdfplumber>=0.11.0 python-docx>=1.2.0 python-pptx>=1.0.0 openpyxl>=3.1.0

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
