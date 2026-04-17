#!/usr/bin/env bash
# ==============================================================================
# Search Swarm Dispatcher
# Parallel search across 17 engines with rate limiting and failover
# ==============================================================================

PLAN_FILE=""
if [ "${1:-}" = "--plan" ]; then
  PLAN_FILE="${2:-}"
  shift 2
fi

QUERY="${1:-}"
MODE="${2:-general}"  # general, cn, news, tech
RESULTS_DIR="/tmp/omo-deep-search/swarm-$(date +%s)"
mkdir -p "$RESULTS_DIR"

if [ -n "$PLAN_FILE" ]; then
  if [ ! -f "$PLAN_FILE" ]; then
    echo "❌ plan file not found: $PLAN_FILE"
    exit 1
  fi
  if command -v python3 >/dev/null 2>&1; then
    PLAN_QUERY=$(python3 - "$PLAN_FILE" <<'PY'
import json, sys
with open(sys.argv[1]) as fh:
    data = json.load(fh)
print(data.get("query", ""))
PY
)
    PLAN_MODE=$(python3 - "$PLAN_FILE" <<'PY'
import json, sys
with open(sys.argv[1]) as fh:
    data = json.load(fh)
print(data.get("search_mode", "general"))
PY
)
    if [ -n "$PLAN_QUERY" ]; then
      QUERY="$PLAN_QUERY"
    fi
    if [ -n "$PLAN_MODE" ]; then
      MODE="$PLAN_MODE"
    fi
  fi
fi

if [ -z "$QUERY" ]; then
  echo "❌ usage: $0 [--plan plan.json] <query> [mode]"
  exit 1
fi

# URL encode query
ENCODED_QUERY=$(echo "$QUERY" | sed 's/ /+/g; s/:/%3A/g; s/\//%2F/g')
USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"

# Engine definitions
ENGINES_GENERAL=(
  "bing_int:https://cn.bing.com/search?q=$ENCODED_QUERY&ensearch=1"
  "ddg:https://html.duckduckgo.com/html/?q=$ENCODED_QUERY"
  "startpage:https://www.startpage.com/sp/search?query=$ENCODED_QUERY"
  "brave:https://search.brave.com/search?q=$ENCODED_QUERY"
  "yahoo:https://search.yahoo.com/search?p=$ENCODED_QUERY"
)

ENGINES_CN=(
  "baidu:https://www.baidu.com/s?wd=$ENCODED_QUERY"
  "sogou:https://sogou.com/web?query=$ENCODED_QUERY"
  "bing_cn:https://cn.bing.com/search?q=$ENCODED_QUERY&ensearch=0"
  "360:https://www.so.com/s?q=$ENCODED_QUERY"
)

ENGINES_NEWS=(
  "bing_news:https://cn.bing.com/search?q=$ENCODED_QUERY&ensearch=1&filters=ex1%3a%22ez5_1825%22"
  "yahoo:https://search.yahoo.com/search?p=$ENCODED_QUERY"
  "brave:https://search.brave.com/search?q=$ENCODED_QUERY"
  "startpage:https://www.startpage.com/sp/search?query=$ENCODED_QUERY"
)

fetch_engine() {
  local engine_name="$1"
  local engine_url="$2"
  local output_file="$3"
  local status_file="$4"
  local http_code=""
  local effective_url=""
  local attempt=1

  is_placeholder_page() {
    python3 - "$1" <<'PY'
from bs4 import BeautifulSoup
from pathlib import Path
import sys
text = BeautifulSoup(Path(sys.argv[1]).read_text(errors='ignore'), 'html.parser').get_text(' ', strip=True).lower()
phrases = [
    'please click here if you are not redirected',
    'enable javascript to continue',
]
raise SystemExit(0 if any(p in text for p in phrases) else 1)
PY
  }

  while [ "$attempt" -le 2 ]; do
    local response
    response=$(curl -sS -L --compressed \
      -A "$USER_AGENT" \
      -H "Accept-Language: en-US,en;q=0.9" \
      --connect-timeout 10 \
      --max-time 30 \
      -o "$output_file" \
      -w "%{http_code} %{url_effective}" \
      "$engine_url" 2>/dev/null || true)

    http_code=$(printf '%s' "$response" | awk '{print $1}')
    effective_url=$(printf '%s' "$response" | cut -d' ' -f2-)

    if [ "$http_code" = "200" ] && [ -s "$output_file" ]; then
      if is_placeholder_page "$output_file"; then
        http_code="302"
      else
        printf '{"http_code":"%s","effective_url":"%s","attempt":%s}\n' \
          "$http_code" "$effective_url" "$attempt" > "$status_file"
        return 0
      fi
    fi

    attempt=$((attempt + 1))
    sleep 1
  done

  printf '{"http_code":"%s","effective_url":"%s","attempt":%s}\n' \
    "${http_code:-000}" "${effective_url:-}" $((attempt - 1)) > "$status_file"
  return 1
}

unique_engines() {
  python3 - <<'PY' "$@"
import sys

seen = set()
for engine in sys.argv[1:]:
    name = engine.split(':', 1)[0]
    if name in seen:
        continue
    seen.add(name)
    print(engine)
PY
}

load_engines() {
  ENGINES=()
  while IFS= read -r line; do
    [ -n "$line" ] && ENGINES+=("$line")
  done < <(unique_engines "$@")
}

# Select engine set based on mode
case "$MODE" in
  cn)
    load_engines "${ENGINES_CN[@]}" "${ENGINES_GENERAL[@]:0:3}"
    ;;
  news)
    load_engines "${ENGINES_NEWS[@]}" "${ENGINES_GENERAL[@]:0:3}"
    ;;
  *)
    load_engines "${ENGINES_GENERAL[@]}"
    ;;
esac

echo "🔍 Search Swarm: '$QUERY'"
echo "📊 Mode: $MODE"
echo "🌐 Engines: ${#ENGINES[@]}"
echo "📁 Results: $RESULTS_DIR"
echo ""

# Launch searches with rate limiting
SUCCESS_COUNT=0
FAIL_COUNT=0

for engine_def in "${ENGINES[@]}"; do
  ENGINE_NAME=$(echo "$engine_def" | cut -d: -f1)
  ENGINE_URL=$(echo "$engine_def" | cut -d: -f2-)
  
  echo -n "  🚀 $ENGINE_NAME ... "
  
  # Rate limit delay
  case "$ENGINE_NAME" in
    google) sleep 3 ;;
    baidu|bing*) sleep 2 ;;
    *) sleep 1 ;;
  esac
  
  STATUS_FILE="$RESULTS_DIR/${ENGINE_NAME}.json"

  # Execute search with redirect handling and a lightweight validity check.
  if fetch_engine "$ENGINE_NAME" "$ENGINE_URL" "$RESULTS_DIR/${ENGINE_NAME}.html" "$STATUS_FILE"; then
    echo "✅ ($(wc -c < "$RESULTS_DIR/${ENGINE_NAME}.html") bytes)"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
    HTTP_CODE=$(python3 - "$STATUS_FILE" <<'PY'
import json, sys
with open(sys.argv[1]) as fh:
    print(json.load(fh).get("http_code", "000"))
PY
)
    echo "❌ (HTTP $HTTP_CODE)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    rm -f "$RESULTS_DIR/${ENGINE_NAME}.html"
  fi
done

echo ""
echo "📈 Results:"
echo "  ✅ Successful: $SUCCESS_COUNT"
echo "  ❌ Failed: $FAIL_COUNT"
echo "  📂 Output: $RESULTS_DIR/"

# Generate summary JSON
cat > "$RESULTS_DIR/summary.json" << EOF
{
  "query": "$QUERY",
  "mode": "$MODE",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "engines_total": ${#ENGINES[@]},
  "engines_success": $SUCCESS_COUNT,
  "engines_fail": $FAIL_COUNT,
  "results_dir": "$RESULTS_DIR"
}
EOF

echo ""
echo "✅ Swarm search complete"
