---
name: deep-search-contract
description: Stable execution contract for deep-search
version: 8.0.0
---

# Deep Search Stable Contract

## Ownership

This file defines the stable execution contract for `deep-search`.

It owns:
- contract boundaries
- planner-first execution order
- capability and evidence policy authority
- required user-facing report guarantees

It does not own:
- concrete agent counts
- timeout tuning
- host-specific task syntax
- temporary execution heuristics

Those belong in:
- `DEEP_SEARCH_EXECUTOR.md`
- `adapters/<platform>/README.md`

Strict execution entrypoint:
- `scripts/strict-run.py`

## Source Of Truth

The stable contract layer is:

- `SKILL.md`
- `contracts/runtime-contract.md`
- `contracts/output-contract.md`
- `contracts/evidence-schema.json`
- `config/query-routing.json`
- `config/execution-profiles.json`
- `config/capability-registry.json`
- `config/evidence-policy.json`
- `scripts/plan-query.py`

If examples elsewhere disagree with these files, the contract/config files win.

## Execution Order

Every deep-search run should follow this sequence:

1. Normalize the user request.
2. Build a machine-readable plan with:
   - `python3 scripts/plan-query.py "<query>"`
3. Resolve intent and thresholds from:
   - `config/query-routing.json`
   - `config/execution-profiles.json`
4. Resolve capability providers and fallback order from:
   - `config/capability-registry.json`
5. Collect evidence according to:
   - `contracts/evidence-schema.json`
   - `config/evidence-policy.json`
6. Execute host/runtime search helpers using the generated plan.
7. Synthesize the final report while preserving:
   - `contracts/output-contract.md`

For strict runs, the runtime must also emit the execution artifacts defined by:
- `contracts/execution-artifact-schema.json`

## Planner Contract

The planner is the required front door for execution decisions.

Minimum planner outputs:
- `intent`
- `primary_agent`
- `profile`
- `min_sources`
- `min_domains`
- `search_mode`
- `capabilities`
- `evidence_policy`
- `report_contract`

The planner decides route and search mode.
Narrative docs must not override planner output ad hoc.

## Capability Contract

Deep-search should describe work in capability terms first.

Core capabilities:
- `broad_web_search`
- `community_discussion`
- `academic_research`
- `code_intelligence`
- `document_processing`

Rules:
- Capability selection comes from `config/capability-registry.json`.
- A provider may be bundled, host-provided, fallback-only, or optional external.
- Optional external providers must be documented as optional, not assumed.
- When a primary provider is unavailable, the runtime should use a declared fallback or surface the capability as unavailable.

## Host Boundary

Host-specific worker primitives must stay out of this file.

Allowed here:
- planner entrypoints
- config authority
- capability rules
- report guarantees

Not allowed here:
- host-specific `task(...)` syntax
- platform-only agent categories
- stale versioned swarm counts
- execution pseudocode tied to one runtime

Those belong in:
- `DEEP_SEARCH_EXECUTOR.md`
- `adapters/codex/README.md`
- `adapters/opencode/README.md`
- `adapters/claude-code/README.md`
- `adapters/hermes/README.md`
- `adapters/openclaw/README.md`

## Evidence Contract

Evidence handling must preserve:
- URL provenance
- timestamps when available
- explicit confidence
- separation between evidence and synthesis
- limitations and unresolved conflicts

Minimum evidence expectations are defined by:
- route thresholds in `config/query-routing.json`
- profile thresholds in `config/execution-profiles.json`
- conflict/dedupe rules in `config/evidence-policy.json`

## Required Behavioral Guarantees

Every complete deep-search run must:
- remain multi-source
- preserve uncertainty instead of hiding it
- separate direct evidence from inference
- expose source diversity and limitations
- produce the 8-section report shape from `contracts/output-contract.md`

## Vertical Enhancers

Vertical enhancer references under `references/vertical-enhancers/` are explanatory overlays.

They may:
- explain domain-specific search strategy
- suggest useful source classes
- describe collaboration patterns

They must not:
- redefine capability authority
- assume unavailable providers are guaranteed
- override planner routing
- introduce host-specific task syntax as contract truth

## Recommended Entrypoints

Planner:

```bash
python3 scripts/plan-query.py "<query>"
```

Plan-aware search helper:

```bash
bash scripts/swarm-search.sh --plan /path/to/plan.json
```

Direct platform-aware execution:

```bash
bash scripts/swarm-search.sh --platform codex "<query>" general
```

## Verification Requirements

Before claiming contract integrity:
- required files must exist
- JSON config must parse
- planner route samples must pass
- optional external providers must be explicitly declared
- tests for planner behavior must pass

`scripts/verify-contracts.sh` is the minimum verification surface.

Strict runs must additionally leave machine-readable artifacts under the chosen output directory.

## Change Policy

Change this file only when you are changing stable contract semantics.

Do not edit this file for:
- agent-count tuning
- benchmark marketing
- temporary host observations
- implementation examples better placed in executor docs

If you need to change runtime strategy without changing the public contract, edit `DEEP_SEARCH_EXECUTOR.md` instead.
