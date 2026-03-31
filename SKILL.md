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

| Agent | Type | Reference | Primary Layer (Depth) | Base Layer (Breadth) |
|-------|------|-----------|----------------------|---------------------|
| **Global Observer** | Universal Base | @references/vertical-enhancers/global-observer.md | multi-search-engine (17 engines) | — |
| **Underground OSINT** | Universal Base | @references/vertical-enhancers/underground-osint.md | websearch_exa + news-aggregator (Reddit/HN) | multi-search-engine (forum expansion) |
| **Oracle** | Universal Base | @references/vertical-enhancers/oracle.md | oracle (analysis) | multi-search-engine (context gathering) |
| **Technical Recon** | Vertical | @references/vertical-enhancers/technical-recon.md | explore + ast_grep + github (code deep) | multi-search-engine (ecosystem news) |
| **The Scholar** | Vertical | @references/vertical-enhancers/scholar.md | academic-deep-research (papers) | multi-search-engine (general context) |
| **Fact Assassin** | Vertical | @references/vertical-enhancers/fact-assassin.md | news-aggregator (curated news) | multi-search-engine (cross-validation) |
| **Compliance Auditor** | Vertical | @references/vertical-enhancers/compliance-auditor.md | SEC filings + websearch_exa (financials) | multi-search-engine (market sentiment) |
| **Legal Decoder** | Vertical | @references/vertical-enhancers/legal-decoder.md | Court records + ToS (legal docs) | multi-search-engine (regulatory news) |
| **Hardware Inspector** | Vertical | @references/vertical-enhancers/hardware-inspector.md | iFixit + benchmarks (teardowns) | multi-search-engine (reviews/reliability) |

**Two-Layer Architecture**:
- **Primary Layer**: Domain-specific tools (irreplaceable depth)
- **Base Layer**: multi-search-engine (universal breadth, cross-validation)
- **Result**: Every agent has specialized expertise + comprehensive coverage
- **Exception**: Global Observer is pure universal (only needs Base layer)

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

### Intent Detection Matrix (Two-Layer Architecture)

| Keywords | Intent | Primary Agent | Primary Layer (Depth) | Base Layer (Breadth) |
|----------|--------|---------------|----------------------|---------------------|
| paper, research, arxiv | Academic | The Scholar | academic-deep-research (papers, citations) | multi-search-engine (general context) |
| legal, compliance, GDPR | Legal | Legal Decoder | Court records, ToS (legal docs) | multi-search-engine (regulatory news) |
| hardware, chip, device | Hardware | Hardware Inspector | iFixit, benchmarks (teardowns) | multi-search-engine (reviews, reliability) |
| repo, library, API | Code/Tech | Technical Recon | explore, ast_grep, github (code deep) | multi-search-engine (ecosystem news) |
| breaking news, scandal | News/Drama | Fact Assassin | news-aggregator (curated news) | multi-search-engine (cross-validation) |
| startup, funding, SEC | Business | Compliance Auditor | SEC filings (financials) | multi-search-engine (market sentiment) |
| **general query, broad topic** | **Universal** | **Global Observer** | — | **multi-search-engine (17 engines)** |
| community, complaints, reddit | Grassroots | Underground OSINT | websearch_exa + news-aggregator (Reddit/HN) | multi-search-engine (forum expansion) |
| incentives, bias, stakeholders | Analysis | Oracle | oracle (reasoning) | multi-search-engine (context gathering) |

**Two-Layer Execution**:
1. **Primary Layer executes first** — domain-specific deep dive
2. **Base Layer activates** — cross-validation, gap filling, context expansion
3. **Results merge** — specialized depth + universal breadth = complete answer

**Universal Coverage Guarantee**: Every agent has access to 17 search engines for validation and context.

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

**Report Structure**: 8-section professional format

**Quick Reference**:
```markdown
# ⚡ Deep-Search: [Topic] 全景分析报告
**生成时间**: [Timestamp] | **数据点**: [N] | **来源域**: [N] | **整体置信度**: [HIGH/MEDIUM/LOW]

1. 执行摘要 (Executive Summary)     - 核心结论 + 多视角评估 + P0建议
2. 研究方法 (Methodology)           - 搜索范围 + 数据质量 + 局限性
3. 全景分析 (Universal Analysis)    - 时间线 + 多源对比 + 利益相关方
4. 实证数据 (Empirical Evidence)    - 关键引用 + 验证记录
5. 垂直分析 (Domain Analysis)       - 主题类型特定框架 (Technical/Business/News/Academic/Legal/Hardware)
6. 综合评估 (Synthesis)             - 关键判断 + 备选解释 + 信息缺口
7. 行动建议 (Recommendations)       - P0/P1/P2 优先级矩阵
8. 附录 (Appendices)                - 数据来源 + 置信度标准 + 术语表
```

**Full specification**: @references/schemas/report-format.md

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
- **Report Format**: @references/schemas/report-format.md
- **Scripts**: @scripts/
- **Evaluations**: @evals/

---

## Version History

- v3.2.0 - Professional output format: Executive Summary, Methodology, Multi-perspective Analysis, Confidence Assessment
- v3.1.0 - Perfect Organic Collaboration: Two-layer architecture (Primary + Base) for all agents
- v3.0.0 - Architecturally optimized with progressive disclosure
- v2.3.0 - SkillHub integration (7 skills)
- v2.2.0 - Stable data sources
- v2.0.0 - Bulletproof execution
