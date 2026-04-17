#!/bin/bash
# verify-contracts.sh - Validate deep-search architecture contract files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🧪 Deep-Search Contract Verification"
echo "=================================="

required_files=(
  "$ROOT_DIR/contracts/output-contract.md"
  "$ROOT_DIR/contracts/evidence-schema.json"
  "$ROOT_DIR/config/capability-registry.json"
  "$ROOT_DIR/config/execution-profiles.json"
  "$ROOT_DIR/config/query-routing.json"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ found: ${file#$ROOT_DIR/}"
    else
        echo "❌ missing: ${file#$ROOT_DIR/}"
        exit 1
    fi
done

echo ""
echo "📄 JSON Validation:"
python3 - <<PY
import json
from pathlib import Path

root = Path(r"$ROOT_DIR")
json_files = [
    root / "contracts/evidence-schema.json",
    root / "config/capability-registry.json",
    root / "config/execution-profiles.json",
    root / "config/query-routing.json",
]

for path in json_files:
    with path.open() as fh:
        json.load(fh)
    print(f"✅ valid json: {path.relative_to(root)}")
PY

echo ""
echo "🔗 Reference Checks:"
grep -q "contracts/output-contract.md" "$ROOT_DIR/SKILL.md" && echo "✅ SKILL.md references output contract" || { echo "❌ SKILL.md missing output contract reference"; exit 1; }
grep -q "config/capability-registry.json" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references capability registry" || { echo "❌ DEEP_SEARCH.md missing capability registry reference"; exit 1; }
grep -q "config/query-routing.json" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references query routing config" || { echo "❌ DEEP_SEARCH.md missing query routing reference"; exit 1; }
grep -q "contracts/evidence-schema.json" "$ROOT_DIR/DEEP_SEARCH_EXECUTOR.md" && echo "✅ DEEP_SEARCH_EXECUTOR.md references evidence schema" || { echo "❌ DEEP_SEARCH_EXECUTOR.md missing evidence schema reference"; exit 1; }

echo ""
echo "=================================="
echo "Contract verification complete!"
