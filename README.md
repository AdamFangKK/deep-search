# Deep Search

**Deep Search is a local-first deep research skill for people who are tired of shallow summaries.**

It turns one prompt into a serious investigation workflow: broad search, news aggregation, academic lookup, code and repo signals, cross-validation, and structured synthesis.

If normal search gives you "a quick answer," Deep Search is built to give you **a defensible answer**.

## Why People Use It

Most AI search flows fail in the same ways:

- they stop after a few easy sources
- they miss community signals and second-order context
- they collapse conflicting evidence into a fake consensus
- they give polished summaries without showing enough research depth

Deep Search is built for the opposite:

- wider coverage
- more source diversity
- better adversarial cross-checking
- a reusable workflow you can run locally and keep improving

## What Makes It Different

- **Local-first**: your workflow lives in your own environment, not inside a closed SaaS box
- **Multi-source by design**: web, news, academic material, repo/code signals, and supporting specialist skills
- **Config-driven**: routing, capability resolution, and evidence policy live in machine-readable config, not only prose docs
- **Research-oriented**: designed for investigation, not just answer generation
- **Reusable**: packaged as a skill with setup scripts, execution docs, and bundled sub-skills
- **Composable**: easy to adapt for competitive research, technical research, trend tracking, and content discovery

## Good Fit For

- AI tool and product research
- startup, market, and competitor analysis
- technical ecosystem mapping
- topic validation before writing or investing time
- tracking fast-moving narratives with less blind trust
- building agentic research workflows on top of a solid base

## What You Get

- `SKILL.md`: skill entrypoint and routing rules
- `DEEP_SEARCH.md`: stable execution contract
- `DEEP_SEARCH_EXECUTOR.md`: current execution strategy
- `scripts/strict-run.py`: auditable strict runner for planner/runtime/artifact execution
- `scripts/`: setup and environment verification
- `skills/`: bundled supporting skills
- `references/`: supporting notes and protocol references
- `evals/`: evaluation artifacts

Historical drafts and superseded architecture notes live under `docs/archive/` and are not part of the active contract surface.

## Example Outcome

Instead of:

> "Here are the top 3 links and a summary."

Deep Search is meant to produce something closer to:

- what the mainstream sources say
- what community discussion contradicts
- what technical or academic sources confirm
- where the evidence is still weak
- what you should watch next

That is the difference between a summary tool and a research tool.

## Install

```bash
git clone https://github.com/fanghongyang/deep-search.git
cd deep-search
bash setup.sh
bash scripts/check-tools.sh
```

## Typical Triggers

- `/deep-search <topic>`
- `[search-mode] MAXIMIZE SEARCH EFFORT`
- any task where a shallow answer is risky or insufficient

## Who Should Star This

Star this repo if you care about any of these:

- better research workflows for AI agents
- reducing blind spots in online investigation
- local-first alternatives to black-box deep research products
- reusable skill architecture instead of one-off prompts
- practical building blocks for competitive intelligence and topic analysis

## Why I Open-Sourced It

I wanted a research workflow I could inspect, modify, and improve over time.

Most "deep research" products feel powerful, but they hide the process. This repo goes in the opposite direction: expose the workflow, keep it editable, and make it reusable.

If you are building serious research agents, this repo gives you a working base instead of a vague idea.

## Current State

This project is actively iterated. The architecture, prompts, and supporting skills will continue to evolve with real-world use.

Some providers are intentionally optional. If host-level skills like `github` or `pdf-text-extractor` are absent, deep-search should degrade through planner-selected fallbacks instead of pretending those capabilities are always available.

If you need auditability rather than best effort, use the strict lane. A strict run emits execution artifacts, deviation logs, and a final artifact-driven report instead of only returning prose.

If it saves you time, gives you better coverage, or helps you build a stronger research workflow, give it a star.
