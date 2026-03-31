# Web Monitoring Tools

**SkillHub Skill**: `web-monitor`

---

## Installation

```bash
# Install skill
skillhub install web-monitor

# Install dependency
pip3 install beautifulsoup4
```

---

## Usage

```bash
# Add URL to watch
uv run --with beautifulsoup4 python \
  ~/.agents/skills/web-monitor/scripts/monitor.py add \
  "https://example.com" --name "Example"

# Add with CSS selector (monitor specific section)
uv run --with beautifulsoup4 python \
  ~/.agents/skills/web-monitor/scripts/monitor.py add \
  "https://example.com/pricing" -n "Pricing" -s ".pricing-table"

# Check all watched URLs for changes
uv run --with beautifulsoup4 python \
  ~/.agents/skills/web-monitor/scripts/monitor.py check

# View last diff
uv run --with beautifulsoup4 python \
  ~/.agents/skills/web-monitor/scripts/monitor.py diff "Example"

# List watched URLs
uv run --with beautifulsoup4 python \
  ~/.agents/skills/web-monitor/scripts/monitor.py list
```

---

## Use Cases for Deep Search

1. **Track documentation updates** - Monitor API docs for changes
2. **Monitor competitor pricing** - Track pricing page changes
3. **Watch for new releases** - Monitor GitHub releases or blog posts
4. **Detect policy changes** - Monitor ToS or privacy policy updates
