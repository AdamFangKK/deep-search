# Claude Code Adapter

This adapter explains how `deep-search` maps onto Claude Code style runtime behavior.

Machine-readable adapter manifest:

- `adapters/claude-code/adapter.json`

## Role

Claude Code is a supported host surface, not the core runtime definition.

The `deep-search` core still lives in:

- `contracts/`
- `config/`
- `scripts/plan-query.py`

This adapter only describes how Claude Code should consume that core.

## Mapping

### Planner

Primary entrypoint:

```bash
python3 scripts/plan-query.py "<query>" --pretty
```

### Execution Surface

Claude Code typically favors:

- shell commands
- local scripts
- tool calls available in the host environment
- staged reasoning over opaque prompt-only orchestration

### Search Execution

Current lowest-level search entrypoint:

```bash
bash scripts/swarm-search.sh --plan /path/to/plan.json
```

### Capability Mapping

- `broad_web_search` -> local search scripts or host search tools
- `community_discussion` -> community/news skill or fallback web search
- `academic_research` -> academic research skill or fallback broad search
- `code_intelligence` -> repository/code search surfaces or fallback broad search
- `document_processing` -> local extractors or parser tools

## Claude Code Guidance

- Prefer consuming planner output directly rather than re-deciding intent inline
- Prefer reproducible shell/script steps over prompt-only orchestration
- Keep host-specific tool syntax here rather than inside the core runtime contract

## Adapter Rule

If Claude Code introduces host-specific worker or tool syntax, document it here without changing:

- `contracts/runtime-contract.md`
- `contracts/output-contract.md`
- `contracts/evidence-schema.json`
- `config/*.json`
