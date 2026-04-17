#!/bin/bash
# verify-contracts.sh - Validate deep-search architecture contract files

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🧪 Deep-Search Contract Verification"
echo "=================================="

required_files=(
  "$ROOT_DIR/contracts/runtime-contract.md"
  "$ROOT_DIR/contracts/output-contract.md"
  "$ROOT_DIR/contracts/execution-artifact-schema.json"
  "$ROOT_DIR/contracts/evidence-schema.json"
  "$ROOT_DIR/config/capability-registry.json"
  "$ROOT_DIR/config/evidence-policy.json"
  "$ROOT_DIR/config/execution-profiles.json"
  "$ROOT_DIR/config/query-routing.json"
  "$ROOT_DIR/scripts/plan-query.py"
  "$ROOT_DIR/scripts/strict-run.py"
  "$ROOT_DIR/adapters/opencode/README.md"
  "$ROOT_DIR/adapters/opencode/adapter.json"
  "$ROOT_DIR/adapters/codex/README.md"
  "$ROOT_DIR/adapters/codex/adapter.json"
  "$ROOT_DIR/adapters/claude-code/README.md"
  "$ROOT_DIR/adapters/claude-code/adapter.json"
  "$ROOT_DIR/adapters/hermes/README.md"
  "$ROOT_DIR/adapters/hermes/adapter.json"
  "$ROOT_DIR/adapters/openclaw/README.md"
  "$ROOT_DIR/adapters/openclaw/adapter.json"
  "$ROOT_DIR/docs/archive/README.md"
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
    root / "contracts/execution-artifact-schema.json",
    root / "config/capability-registry.json",
    root / "config/evidence-policy.json",
    root / "config/execution-profiles.json",
    root / "config/query-routing.json",
    root / "adapters/opencode/adapter.json",
    root / "adapters/codex/adapter.json",
    root / "adapters/claude-code/adapter.json",
    root / "adapters/hermes/adapter.json",
    root / "adapters/openclaw/adapter.json",
]

for path in json_files:
    with path.open() as fh:
        json.load(fh)
    print(f"✅ valid json: {path.relative_to(root)}")
PY

echo ""
echo "🧠 Semantic Validation:"
python3 - <<PY
import json
import subprocess
import sys
from pathlib import Path

root = Path(r"$ROOT_DIR")
registry = json.loads((root / "config/capability-registry.json").read_text())
home_skills = Path.home() / ".agents" / "skills"
workspace_skills = root / "skills"

def provider_exists(name: str) -> bool:
    return (home_skills / name).exists() or (workspace_skills / name).exists()

for item in registry["capabilities"]:
    provider = item["primary_provider"]
    exists = provider_exists(provider)
    if exists:
        print(f"✅ provider available: {item['name']} -> {provider}")
        continue
    if item.get("optional_external"):
        print(f"✅ optional external provider documented: {item['name']} -> {provider}")
        continue
    if item.get("fallback_providers"):
        print(f"✅ provider has fallback path: {item['name']} -> {provider}")
        continue
    print(f"❌ undeclared missing provider: {item['name']} -> {provider}")
    sys.exit(1)

def build_plan(query: str) -> dict:
    output = subprocess.check_output(
        [sys.executable, str(root / "scripts/plan-query.py"), query],
        text=True,
    )
    return json.loads(output)

community_plan = build_plan("reddit complaints about claude opus 4.7")
if community_plan["search_mode"] != "news":
    print(f"❌ community query routed to wrong search mode: {community_plan['search_mode']}")
    sys.exit(1)
print("✅ community query routes to news mode")

legal_plan = build_plan("analyze legal compliance risks of a startup fundraising memo")
if legal_plan["search_mode"] != "general":
    print(f"❌ english legal query routed to wrong search mode: {legal_plan['search_mode']}")
    sys.exit(1)
print("✅ english legal query stays on general mode")

cn_plan = build_plan("分析中国AI芯片行业趋势")
if cn_plan["search_mode"] != "cn":
    print(f"❌ CJK query routed to wrong search mode: {cn_plan['search_mode']}")
    sys.exit(1)
print("✅ CJK query routes to cn mode")

strict_plan = json.loads(
    subprocess.check_output(
        [sys.executable, str(root / "scripts/plan-query.py"), "strict audit query", "--strict"],
        text=True,
    )
)
if not strict_plan.get("strict"):
    print("❌ strict planner output did not set strict=true")
    sys.exit(1)
if not strict_plan.get("required_artifacts"):
    print("❌ strict planner output missing required_artifacts")
    sys.exit(1)
print("✅ strict planner output includes artifact requirements")
PY

echo ""
echo "🔗 Reference Checks:"
grep -q "contracts/runtime-contract.md" "$ROOT_DIR/SKILL.md" && echo "✅ SKILL.md references runtime contract" || { echo "❌ SKILL.md missing runtime contract reference"; exit 1; }
grep -q "contracts/output-contract.md" "$ROOT_DIR/SKILL.md" && echo "✅ SKILL.md references output contract" || { echo "❌ SKILL.md missing output contract reference"; exit 1; }
grep -q "adapters/opencode/README.md" "$ROOT_DIR/SKILL.md" && echo "✅ SKILL.md references adapter docs" || { echo "❌ SKILL.md missing adapter doc reference"; exit 1; }
grep -q "platform_providers" "$ROOT_DIR/config/capability-registry.json" && echo "✅ capability registry includes platform provider mapping" || { echo "❌ capability registry missing platform provider mapping"; exit 1; }
grep -q "config/capability-registry.json" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references capability registry" || { echo "❌ DEEP_SEARCH.md missing capability registry reference"; exit 1; }
grep -q "config/evidence-policy.json" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references evidence policy" || { echo "❌ DEEP_SEARCH.md missing evidence policy reference"; exit 1; }
grep -q "config/query-routing.json" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references query routing config" || { echo "❌ DEEP_SEARCH.md missing query routing reference"; exit 1; }
grep -q "adapters/" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md defers host syntax to adapters" || { echo "❌ DEEP_SEARCH.md missing adapter deferral"; exit 1; }
grep -q "contracts/evidence-schema.json" "$ROOT_DIR/DEEP_SEARCH_EXECUTOR.md" && echo "✅ DEEP_SEARCH_EXECUTOR.md references evidence schema" || { echo "❌ DEEP_SEARCH_EXECUTOR.md missing evidence schema reference"; exit 1; }
grep -q "scripts/plan-query.py" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references planner entrypoint" || { echo "❌ DEEP_SEARCH.md missing planner entrypoint"; exit 1; }
grep -q "scripts/strict-run.py" "$ROOT_DIR/DEEP_SEARCH.md" && echo "✅ DEEP_SEARCH.md references strict runner" || { echo "❌ DEEP_SEARCH.md missing strict runner reference"; exit 1; }
grep -q -- "--platform" "$ROOT_DIR/scripts/swarm-search.sh" && echo "✅ swarm-search supports platform-aware execution" || { echo "❌ swarm-search missing platform-aware execution"; exit 1; }
if rg -q "Deep Search Executor v6.0|5-Agent Swarm|Adaptive Agent Scaling|websearch_exa|news-aggregator-skill" "$ROOT_DIR/DEEP_SEARCH.md" "$ROOT_DIR/references/vertical-enhancers"; then
    echo "❌ found stale host-specific or versioned wording in contract/reference docs"
    exit 1
else
    echo "✅ contract/reference docs avoid stale host-specific wording"
fi

echo ""
echo "🧪 Python Tests:"
python3 -m unittest discover -s "$ROOT_DIR/tests" -p 'test_*.py'

echo ""
echo "=================================="
echo "Contract verification complete!"
