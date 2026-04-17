#!/bin/bash
# check-tools.sh - Environment verification script for deep-search

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CAPABILITY_FILE="$ROOT_DIR/config/capability-registry.json"

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
WORKSPACE_SKILLS_DIR="$ROOT_DIR/skills"

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
echo "🧭 Capability Summary:"
if [ -f "$CAPABILITY_FILE" ]; then
    python3 - "$CAPABILITY_FILE" "$HOME_SKILLS_DIR" "$WORKSPACE_SKILLS_DIR" <<'PY'
import json
import pathlib
import sys

capability_file = pathlib.Path(sys.argv[1])
home_skills = pathlib.Path(sys.argv[2])
workspace_skills = pathlib.Path(sys.argv[3])

data = json.loads(capability_file.read_text())

def installed(provider: str) -> bool:
    return (home_skills / provider).exists() or (workspace_skills / provider).exists()

for capability in data.get("capabilities", []):
    name = capability["name"]
    primary = capability["primary_provider"]
    fallbacks = capability.get("fallback_providers", [])
    required = capability.get("required", False)
    if installed(primary):
        status = "READY"
        detail = primary
    else:
        available_fallback = next((provider for provider in fallbacks if installed(provider)), None)
        if available_fallback:
            status = "FALLBACK"
            detail = available_fallback
        else:
            status = "MISSING"
            detail = primary
    marker = {
        "READY": "✅",
        "FALLBACK": "⚠️ ",
        "MISSING": "❌" if required else "⚠️ "
    }[status]
    print(f"{marker} {name}: {status} via {detail}")
PY
else
    echo "⚠️  capability-registry.json not found"
fi

echo ""
echo "=================================="
echo "Check complete!"
