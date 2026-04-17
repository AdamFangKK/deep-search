# Codex Adapter

This adapter explains how `deep-search` maps onto Codex-style runtime behavior.

Machine-readable adapter manifest:

- `adapters/codex/adapter.json`

## Role

Codex consumes the same core planning and contract files as any other host.

The platform-specific part is how execution surfaces are expressed:

- shell scripts
- subagents where available
- MCP tools where available
- local file outputs

## Mapping

### Planner

Primary entrypoint:

```bash
python3 scripts/plan-query.py "<query>" --pretty
```

### Search execution

Current lowest-level search entrypoint:

```bash
bash scripts/swarm-search.sh --plan /path/to/plan.json
```

### Capability mapping

- `broad_web_search` -> local search scripts or host web tooling
- `community_discussion` -> platform-accessible news/community skill or fallback search
- `academic_research` -> academic research skill or fallback search
- `code_intelligence` -> local code search / GitHub surface / fallback broad search
- `document_processing` -> local parser or extractor tools

## Codex-Specific Guidance

- Prefer consuming the planner output instead of manually re-deciding intent
- Prefer shell or MCP execution surfaces that can be inspected and replayed
- Keep platform-specific orchestration instructions here rather than in the core runtime contract

## Adapter Rule

If Codex orchestration differs from OpenCode, Hermes, or OpenClaw, document that here without changing the core contracts.
