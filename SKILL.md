---
name: deep-search
description: Use when the user explicitly requests /deep-search <topic>, uses [search-mode] MAXIMIZE SEARCH EFFORT, or requires deep, multi-faceted research with exhaustive coverage and empirical validation. Triggers saturation search protocol with 5+ specialized agents.
version: 3.0.0
---

# /deep-search Command (v3.0: Architecturally Optimized)

This command triggers "Max-Search Mode" (Saturation Search Protocol) for exhaustive, zero-blind-spot research governed by strict Ultrawork protocols.

## Quick Start

```bash
# Setup
bash ~/.agents/skills/deep-search/setup.sh

# Check environment
bash ~/.agents/skills/deep-search/scripts/check-tools.sh

# Run deep search
/deep-search "your research topic"
```

## When to Use

- User requests `/deep-search <topic>`
- User includes `[search-mode] MAXIMIZE SEARCH EFFORT`
- Need deep, multi-faceted research
- Require empirical validation

---

## Architecture Overview

### 5-Agent Swarm Architecture

```
Orchestrator (The Conductor)
    ├─ Global Observer (librarian + multi-search-engine)
    │   └─ Broad web coverage + official sources
    ├─ Underground OSINT (librarian + news-aggregator)
    │   └─ Reddit + HN + forums (community voices)
    ├─ Oracle (oracle)
    │   └─ Bias detection + incentive analysis
    ├─ [Vertical Enhancer based on intent]
    │   └─ Domain-specific deep dive
    └─ Synthesizer (reports)
        └─ Cross-source validation & aggregation
```

**Complementary Design**:
- **Global Observer** uses `multi-search-engine` for **broad web coverage** (blogs, news sites, official docs)
- **Underground OSINT** uses `websearch_exa` + `news-aggregator` for **community discussions** (Reddit, HN, forums)
- They work TOGETHER, not competing — different data layers

### Agent Reference Docs

| Agent | Type | Reference | Core Tools |
|-------|------|-----------|------------|
| Global Observer | Universal Base | @references/vertical-enhancers/global-observer.md | multi-search-engine (17 engines) |
| Underground OSINT | Universal Base | @references/vertical-enhancers/underground-osint.md | websearch_exa + news-aggregator |
| Oracle | Universal Base | @references/vertical-enhancers/oracle.md | N/A (analysis only) |
| Technical Recon | Vertical | @references/vertical-enhancers/technical-recon.md | explore + ast_grep + github |
| Fact Assassin | Vertical | @references/vertical-enhancers/fact-assassin.md | news-aggregator + multi-search-engine |
| Compliance Auditor | Vertical | @references/vertical-enhancers/compliance-auditor.md | SEC filings + websearch |
| The Scholar | Vertical | @references/vertical-enhancers/scholar.md | academic-deep-research |
| Legal Decoder | Vertical | @references/vertical-enhancers/legal-decoder.md | Court records + ToS |
| Hardware Inspector | Vertical | @references/vertical-enhancers/hardware-inspector.md | iFixit + benchmarks |

**Tool Assignment Principle**: Each agent uses the BEST tool for their mandate — no duplication, no competition.

### Tool References

#### Universal Search Layer (Broad Coverage)
- **Multi-Search Engine**: @references/tools/multi-search.md — 17 engines for general web search
  - Use for: Background research, cross-engine validation, filling coverage gaps
  - Complements (NOT replaces) specialized sources below

#### Specialized Data Sources (Domain Deep Dives)
| Source | Tool/Skill | Best For | Why Not Replaceable |
|--------|-----------|----------|-------------------|
| **Reddit** | `websearch_exa` | Community discussions, user complaints | Authentic grassroots voices |
| **HackerNews** | `news-aggregator-skill` | Tech/startup discourse | High signal-to-noise ratio |
| **Academic** | `academic-deep-research` | Papers, citations, peer review | Structured academic data |
| **News** | `news-aggregator-skill` | Breaking news, journalist reports | Editorial curation |
| **GitHub** | `github` | Code repos, issues, PRs | Developer artifacts |
| **Documents** | `pdf-text-extractor` | PDFs, structured data | Non-web content |

#### Utility Tools
- Document Processing: @references/tools/document-processing.md
- Web Monitoring: @references/tools/web-monitoring.md

---

## The Execution Protocol

### PRE-PHASE: Tool Check

```bash
# Check environment
bash ~/.agents/skills/deep-search/scripts/check-tools.sh
```

### PHASE 0: Orchestrator Analysis

The Orchestrator (`unspecified-high`) coordinates:

1. **Intent Classification**
   - Analyze user query
   - Match to Vertical Enhancer (see table below)
   - Determine research scope

2. **Agent Dispatch**
   - Spawn 5 agents in parallel (`task run_in_background=true`)
   - Assign unique mandates
   - Set quality gates

3. **Quality Gates**
   - Gate 1: Tool Availability
   - Gate 2: Data Saturation (15-30 points)
   - Gate 3: Source Diversity (≥3 domains)
   - Gate 4: Validation Complete
   - Gate 5: Report Structure
   - Gate 6: Anti-Gaming Check

### Intent Detection Matrix

| Keywords | Intent | Primary Agent | Specialized Tools | Base Tools |
|----------|--------|---------------|-------------------|------------|
| paper, research, arxiv | Academic | The Scholar | academic-deep-research | multi-search-engine |
| legal, compliance, GDPR | Legal | Legal Decoder | Court records, ToS | multi-search-engine |
| hardware, chip, device | Hardware | Hardware Inspector | iFixit, benchmarks | multi-search-engine |
| repo, library, API | Code/Tech | Technical Recon | explore, ast_grep, github | multi-search-engine |
| breaking news, scandal | News/Drama | Fact Assassin | news-aggregator | multi-search-engine |
| startup, funding, SEC | Business | Compliance Auditor | SEC filings | multi-search-engine |
| **general query, broad topic** | **Universal** | **Global Observer** | — | **multi-search-engine** |

**Tool Layering**:
- **Specialized Tools**: Domain-specific,不可替代 (academic, SEC filings, court records)
- **Base Tools**: `multi-search-engine` provides universal coverage for ALL agents as fallback/filler
- **Result**: Specialized depth + Universal breadth = Complete coverage

### PHASE 1-4: Agent Execution

Each agent executes per their reference document:

1. Read agent reference: `@references/vertical-enhancers/[agent].md`
2. Execute mandate using specified tools
3. Collect data points (≥200 chars, URL + timestamp)
4. Return structured output

### PHASE 3.5: Document Processing (if needed)

For PDFs, Excel files, or structured data:

```bash
# See: @references/tools/document-processing.md
node ~/.agents/skills/pdf-text-extractor/scripts/extract.js "file.pdf"
python3 -c "import pdfplumber; ..."
```

### PHASE 5: Final Deliverable

**Report Structure**:
```markdown
# ⚡ Deep-Search: [Topic] 全景渗透报告
**Generated**: [Timestamp] | **Data Points**: [N] | **Sources**: [N domains]

## 1. Universal Core
- Timeline/Architecture
- Information silos (official vs community)
- Incentives & biases

## 2. Raw Evidence
- 5+ verbatim quotes (≥100 chars)
- Full attribution (URL + timestamp)

## 3. Vertical Analysis
- [Domain-specific deep dive]

## 4. Validation Log
- Empirical test results
- stdout/stderr/exit codes

## 5. Actionable Takeaways
- Specific recommendations
- Tool/version suggestions
```

---

## Anti-Gaming Rules

**Invalid excuses** (will be rejected):
- ❌ "时间紧迫" → No time exceptions
- ❌ "太累了" → Fatigue irrelevant
- ❌ "资料太少" → Expand scope, never truncate
- ❌ "验证不划算" → Trust No PR is mandatory
- ❌ "找不到负面信息" → Document search effort

---

## Data Quality Standards

| Standard | Requirement |
|----------|-------------|
| Quantity | 15-30 data points |
| Diversity | ≥3 distinct domains |
| Depth | ≥200 chars per point |
| Provenance | URL + timestamp required |
| Recency | 70% from last 2 years |

---

## Compliance Verification

Before submission, verify:

```markdown
- [ ] 5 agents launched with unique mandates
- [ ] 15-30 data points collected
- [ ] ≥3 sources, max 5 per source
- [ ] All points have URLs + timestamps
- [ ] Empirical validation complete (if Code/Tech)
- [ ] Report follows quality-gated structure
- [ ] No shortcuts taken
```

---

## Evaluation

Test cases: @evals/evals.json  
Schemas: @evals/schemas.md

---

## Resources

- **Vertical Enhancers**: @references/vertical-enhancers/
- **Tool Guides**: @references/tools/
- **Scripts**: @scripts/
- **Evaluations**: @evals/

---

## Version History

- v3.0.0 - Architecturally optimized with progressive disclosure
- v2.3.0 - SkillHub integration (7 skills)
- v2.2.0 - Stable data sources
- v2.0.0 - Bulletproof execution
