# Deep Search Runtime Contract

This document defines the platform-neutral runtime semantics for `deep-search`.

The goal is to keep the core skill architecture portable across skill-capable platforms such as Codex, Claude Codex, Hermes, OpenCode, and OpenClaw.

## Core Principle

The core skill decides:

- what the query means
- which capabilities are needed
- how evidence should be treated
- what the final report shape must be

The platform adapter decides:

- how to invoke workers or tools
- how to express parallelism
- how to load platform-local skills or tools
- how to feed execution outputs back into the host system

## Runtime Stages

1. `query_normalization`
2. `plan_generation`
3. `capability_resolution`
4. `provider_selection`
5. `search_execution`
6. `evidence_normalization`
7. `synthesis`
8. `report_output`

## Required Planner Output

Any platform adapter must be able to consume a plan with at least:

- `query`
- `intent`
- `primary_agent`
- `profile`
- `min_sources`
- `min_domains`
- `search_mode`
- `capabilities`
- `evidence_policy`
- `report_contract`

## Capability Semantics

Capabilities are platform-neutral names:

- `broad_web_search`
- `community_discussion`
- `academic_research`
- `code_intelligence`
- `document_processing`

Platform adapters must map these to platform-local tools, skills, scripts, or MCP surfaces.

## Adapter Responsibilities

Each adapter must define:

1. how `parallel workers` are expressed
2. how `providers` are invoked
3. how `missing capabilities` degrade
4. how raw search results are returned to the core evidence layer

## What Must Stay Platform-Neutral

These concerns must remain outside adapter-specific docs:

- query routing rules
- execution profiles
- evidence policy
- evidence schema
- output contract

## What May Be Platform-Specific

- worker spawn syntax
- background execution syntax
- local skill loading syntax
- local connector or MCP naming
- host-specific installation commands

## Compatibility Rule

If platform guidance conflicts with:

- `config/query-routing.json`
- `config/capability-registry.json`
- `config/execution-profiles.json`
- `config/evidence-policy.json`
- `contracts/evidence-schema.json`
- `contracts/output-contract.md`

then the core contracts win, and the adapter must be updated.
