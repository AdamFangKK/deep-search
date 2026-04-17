# Hermes Adapter

This adapter explains how `deep-search` maps onto Hermes-style runtime behavior.

## Role

Hermes is one supported skill-capable host.

The `deep-search` core remains platform-neutral. Hermes-specific orchestration belongs here, not in the core runtime contract.

## Mapping

### Planner

Primary entrypoint:

```bash
python3 scripts/plan-query.py "<query>" --pretty
```

### Execution Surface

Hermes typically favors:

- CLI-driven skills
- reusable local command surfaces
- tool invocation through Hermes-managed runtime paths

### Search Execution

Current lowest-level search entrypoint:

```bash
bash scripts/swarm-search.sh --plan /path/to/plan.json
```

### Capability Mapping

- `broad_web_search` -> Hermes-accessible search capability or local search scripts
- `community_discussion` -> Hermes skill or fallback broad search
- `academic_research` -> Hermes academic research surface or fallback broad search
- `code_intelligence` -> local repository tooling / GitHub surface / fallback broad search
- `document_processing` -> Hermes-accessible parser or local extractors

## Hermes Guidance

- Use the planner output as the single source for intent, profile, and capability routing
- Keep Hermes-specific tool names or execution wrappers here
- Treat the core config and contracts as the host-independent source of truth

## Adapter Rule

Do not move Hermes-specific command syntax back into the core runtime docs.
