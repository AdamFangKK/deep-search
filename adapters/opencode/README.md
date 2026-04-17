# OpenCode Adapter

This adapter explains how `deep-search` maps onto OpenCode-style runtime concepts.

Machine-readable adapter manifest:

- `adapters/opencode/adapter.json`

## Role

OpenCode is one supported host, not the core architecture itself.

The `deep-search` core remains platform-neutral. This adapter only explains how to express the runtime contract using OpenCode surfaces.

## Mapping

### Planner

- Core planner: `python3 scripts/plan-query.py "<query>"`

### Parallel workers

OpenCode-specific expression:

- `task(...)`
- `category`
- `run_in_background`

These are adapter-layer concepts, not core runtime concepts.

### Provider loading

Typical mapping:

- `broad_web_search` -> `multi-search-engine`
- `community_discussion` -> `news-aggregator-skill`
- `academic_research` -> `academic-deep-research`
- `code_intelligence` -> `github` or fallback broad search
- `document_processing` -> `pdf-text-extractor`

### Runtime note

If OpenCode requires `task(category=...)` or similar platform syntax, keep that instruction here rather than in the core runtime contract.

## Adapter Rule

Do not move OpenCode-specific invocation syntax back into:

- `contracts/runtime-contract.md`
- `config/*.json`
- `contracts/*.json|md`

Those files must stay platform-neutral.
