# Deep Search Architecture Stabilization Spec

## Goal

Stabilize the `deep-search` architecture without changing the user-facing report contract.

This refactor is intentionally non-breaking at the output layer. The purpose is to make execution behavior more predictable, dependencies more explicit, and future extensions easier to add without rewriting the whole skill.

## Non-Negotiable Rules

1. Do not change the final report shape as part of this refactor.
2. Do not change the top-level trigger behavior in `SKILL.md`.
3. Do not remove existing provider concepts unless they are replaced by an explicit registry entry.
4. Do not merge architecture notes and executor strategy back into one document.
5. Do not claim better research conclusions unless the baseline comparison shows equivalent or improved evidence quality.

## Frozen Output Contract

The user-facing report must continue to expose the same 8-section structure defined in:

- `contracts/output-contract.md`
- `references/schemas/report-format.md`

Allowed changes:

- internal routing
- provider detection
- fallback ordering
- evidence normalization
- execution notes

Not allowed in this refactor:

- changing the section count
- removing confidence reporting
- changing the overall report intent from deep research report
- replacing the current report with a different style or tone

## Baseline Verification Protocol

Before accepting architecture changes:

1. Freeze the pre-refactor commit.
2. Use `evals/baseline-queries.v1.json` as the reference sample set.
3. Compare before vs after on these dimensions:
   - report shape preserved
   - source diversity preserved or improved
   - confidence and evidence sections still present
   - no major regression in domain coverage
   - noise reduced without losing key conclusions
4. Keep the refactor only if differences are operational improvements rather than conclusion drift.
5. Roll back if the result changes from "same answer, cleaner path" to "different answer, different product."

## New Architecture Boundaries

### 1. Interface Layer

Owned by `SKILL.md`.

Responsibilities:

- user-visible trigger conditions
- when to invoke deep search
- expected user intent

### 2. Execution Contract Layer

Owned by `DEEP_SEARCH.md` plus contract/config files.

Responsibilities:

- stable execution phases
- quality gates
- output contract
- capability selection rules

### 3. Executor Strategy Layer

Owned by `DEEP_SEARCH_EXECUTOR.md`.

Responsibilities:

- adaptive scaling
- agent counts
- timeout tuning
- implementation strategy experiments

### 4. Capability Layer

Owned by `config/capability-registry.json`.

Responsibilities:

- explicit provider inventory
- availability expectations
- fallback order
- provider roles

### 5. Evidence Contract Layer

Owned by `contracts/evidence-schema.json`.

Responsibilities:

- normalized evidence fields
- source typing
- confidence metadata
- provider attribution

## Success Criteria

The refactor is considered successful if:

- contributors can tell which file owns which decision
- provider additions no longer require rewriting the whole protocol
- output shape remains stable
- baseline queries can be used to judge drift
- the repo is closer to a contract-driven engine than a prompt bundle
