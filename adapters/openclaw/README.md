# OpenClaw Adapter

This adapter explains how `deep-search` maps onto OpenClaw-style runtime behavior.

Machine-readable adapter manifest:

- `adapters/openclaw/adapter.json`

## Role

OpenClaw is a supported host surface for the `deep-search` core.

The core architecture should stay portable. OpenClaw-specific execution details belong here.

## Mapping

### Planner

Primary entrypoint:

```bash
python3 scripts/plan-query.py "<query>" --pretty
```

### Execution Surface

OpenClaw typically favors:

- skill-based execution
- local scripts
- host-provided tools and connectors
- explicit workflow stages

### Search Execution

Current lowest-level search entrypoint:

```bash
bash scripts/swarm-search.sh --plan /path/to/plan.json
```

### Capability Mapping

- `broad_web_search` -> OpenClaw-accessible search tools or local scripts
- `community_discussion` -> OpenClaw social/news skill or fallback broad search
- `academic_research` -> OpenClaw research skill or fallback broad search
- `code_intelligence` -> repository tooling / connector / fallback broad search
- `document_processing` -> local or host-provided extractors

## OpenClaw Guidance

- Keep runtime stages aligned with `contracts/runtime-contract.md`
- Resolve host-specific connectors and tool names in this adapter only
- Do not redefine routing, evidence policy, or output contract here

## Adapter Rule

If OpenClaw needs special invocation syntax, keep that syntax here and preserve the platform-neutral core.
