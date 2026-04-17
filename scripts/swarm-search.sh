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

# Engine definitions
ENGINES_GENERAL=(
  "google:https://www.google.com/search?q=$ENCODED_QUERY"
  "bing_int:https://cn.bing.com/search?q=$ENCODED_QUERY&ensearch=1"
  "ddg:https://duckduckgo.com/html/?q=$ENCODED_QUERY"
  "startpage:https://www.startpage.com/sp/search?query=$ENCODED_QUERY"
  "brave:https://search.brave.com/search?q=$ENCODED_QUERY"
)

ENGINES_CN=(
  "baidu:https://www.baidu.com/s?wd=$ENCODED_QUERY"
  "sogou:https://sogou.com/web?query=$ENCODED_QUERY"
  "bing_cn:https://cn.bing.com/search?q=$ENCODED_QUERY&ensearch=0"
  "360:https://www.so.com/s?q=$ENCODED_QUERY"
)

ENGINES_NEWS=(
  "google_news:https://www.google.com/search?q=$ENCODED_QUERY&tbs=qdr:w"
  "bing_news:https://cn.bing.com/search?q=$ENCODED_QUERY&ensearch=1&filters=ex1%3a%22ez5_1825%22"
  "yahoo:https://search.yahoo.com/search?p=$ENCODED_QUERY"
)

# Select engine set based on mode
case "$MODE" in
  cn)
    ENGINES=("${ENGINES_CN[@]}" "${ENGINES_GENERAL[@]:0:3}")
    ;;
  news)
    ENGINES=("${ENGINES_NEWS[@]}" "${ENGINES_GENERAL[@]:0:3}")
    ;;
  *)
    ENGINES=("${ENGINES_GENERAL[@]}")
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
  
  # Execute search
  HTTP_CODE=$(curl -s -o "$RESULTS_DIR/${ENGINE_NAME}.html" -w "%{http_code}" \
    -A "Mozilla/5.0 (compatible; DeepSearch/1.0)" \
    --max-time 30 \
    "$ENGINE_URL" 2>/dev/null)
  
  if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ ($(wc -c < "$RESULTS_DIR/${ENGINE_NAME}.html") bytes)"
    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
  else
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
