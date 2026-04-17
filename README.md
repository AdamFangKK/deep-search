# Deep Search

Deep Search is a local-first research skill for exhaustive, multi-angle investigation. It combines a command surface, execution playbooks, setup scripts, and bundled specialist sub-skills so you can run high-coverage research workflows from your own agent environment instead of a hosted black box.

## What It Does

- Expands a single research prompt into a saturation-style search workflow
- Combines broad web search, news aggregation, academic lookup, and code/repo reconnaissance
- Separates execution guidance from architectural notes so the workflow stays maintainable
- Ships with helper scripts for environment setup and dependency checks
- Bundles companion skills such as `academic-deep-research`, `news-aggregator-skill`, and `search-cluster`

## Repository Layout

- `SKILL.md`: top-level skill entrypoint and routing rules
- `DEEP_SEARCH.md`: main execution protocol
- `DEEP_SEARCH_EXECUTOR.md`: adaptive executor design
- `references/`: supporting references for tool and workflow choices
- `scripts/`: local setup and environment verification helpers
- `skills/`: bundled supporting skills used by the workflow
- `evals/`: evaluation notes and schema artifacts

## Install

```bash
git clone https://github.com/<your-github-username>/deep-search.git
cd deep-search
bash setup.sh
bash scripts/check-tools.sh
```

## Use

Use this repository as a local skill package inside an agent environment that supports `SKILL.md` workflows.

Typical trigger patterns:

- `/deep-search <topic>`
- `[search-mode] MAXIMIZE SEARCH EFFORT`
- tasks that need exhaustive, cross-validated research instead of a quick answer

## Why This Exists

Most search helpers stop at "one query, one summary." This skill is designed for the cases where that fails:

- conflicting sources
- thin evidence
- fast-moving narratives
- community sentiment hidden outside mainstream coverage
- research tasks that need both breadth and adversarial cross-checking

## Included Assets

- local setup bootstrap
- dependency audit script
- adaptive executor notes
- bundled sub-skills for news, academic research, and search clustering
- marketplace metadata for local plugin packaging

## Current State

This repo reflects an actively iterated local skill. Expect the architecture and prompts to evolve as the workflow is tested against real research tasks.
