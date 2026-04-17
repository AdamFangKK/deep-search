---
name: deep-search
description: Multi-platform deep research skill for exhaustive, multi-faceted investigation with config-driven routing, portable adapters, and auditable strict mode.
version: 4.0.0
---

# /deep-search Command (v4.0: Executable Architecture)

## Source Of Truth Boundaries

- `SKILL.md`: trigger surface and user-visible invocation rules
- `DEEP_SEARCH.md`: stable execution contract
- `DEEP_SEARCH_EXECUTOR.md`: adaptive executor strategy
- `contracts/runtime-contract.md`: platform-neutral runtime semantics
- `contracts/output-contract.md`: frozen user-facing report shape
- `contracts/evidence-schema.json`: normalized evidence contract
- `config/capability-registry.json`: provider inventory and fallback order

The goal of this split is to keep user-facing behavior stable while allowing internal execution strategy to evolve.

## 🚀 执行入口

**当用户请求 deep-search 时，执行以下步骤：**

1. **加载稳定契约**: 读取 `DEEP_SEARCH.md`，确认输出契约、配置边界、适配器边界
2. **加载执行策略**: 读取 `DEEP_SEARCH_EXECUTOR.md`，采用当前生效的执行策略版本
3. **先走 planner**: 通过 `scripts/plan-query.py` 生成机器可读 plan，再选择能力与搜索模式
4. **生成报告**: 输出 8-section 专业报告

**如果用户显式要求严格执行 / 审计执行路径**，必须进入 strict lane：

1. 运行 `python3 scripts/strict-run.py "<query>" --platform <platform>`
2. 落严格执行 artifacts：
   - `plan.json`
   - `run-summary.json`
   - `sources.json`
   - `deviations.json`
   - `report-template.md`
   - `final-report.json`
   - `final-report.md`
3. 公开报告实际偏差，不允许把 fallback 隐藏成“正常执行”

**注意**: `SKILL.md` 负责触发和边界，`DEEP_SEARCH.md` 负责稳定执行契约，`DEEP_SEARCH_EXECUTOR.md` 负责实现策略。真实路由、能力选择、搜索模式以 `config/` 和 `scripts/plan-query.py` 为准。平台专属调用方式请放在 `adapters/`，不要回灌进核心契约。

---

## ⚠️ 重要：代理启动方式

**必须使用 `category` 参数，不要使用 `subagent_type`**

```typescript
// ✅ 正确用法 - 使用 category
task({
  category: "quick",  // 或 "deep", "ultrabrain", "artistry" 等
  load_skills: ["multi-search-engine"],
  run_in_background: true,
  prompt: "..."
});

// ❌ 错误用法 - subagent_type 会导致代理死锁
// task({
//   subagent_type: "librarian",  // 千万不要用！
//   ...
// });
```

**原因**: `subagent_type` 参数会导致子代理初始化死锁，无法完成任何任务。`category` 参数是正确且唯一可用的方式。

---

## 快速开始

```bash
# Setup
bash ~/.agents/skills/deep-search/setup.sh

# Check environment
bash ~/.agents/skills/deep-search/scripts/check-tools.sh

# Run deep search (通过任意受支持宿主调用)
# /deep-search "your research topic"
```

---

# /deep-search Command (v4.0: Architecturally Optimized)

This command triggers a multi-platform "Max-Search Mode" for exhaustive, zero-blind-spot research governed by stable contracts, config-driven routing, and host adapters.

## Quick Start

```bash
# Setup
bash ~/.agents/skills/deep-search/setup.sh

# Check environment
bash ~/.agents/skills/deep-search/scripts/check-tools.sh

# Run deep search
/deep-search "your research topic"

# Run strict deep search
python3 ~/.agents/skills/deep-search/scripts/strict-run.py "your research topic" --platform codex
```

## Platform Portability

`deep-search` should be understood as a portable research core plus platform adapters:

- core contracts live in `contracts/` and `config/`
- execution surfaces live in `scripts/`
- platform-specific guidance lives in `adapters/`

Current adapter docs:

- `adapters/opencode/README.md`
- `adapters/codex/README.md`
- `adapters/claude-code/README.md`
- `adapters/hermes/README.md`
- `adapters/openclaw/README.md`

It is not an OpenCode-only or Claude-only workflow surface. The skill is designed to keep the core contract portable and push host-specific behavior into adapters.

## When to Use

- User requests `/deep-search <topic>`
- User includes `[search-mode] MAXIMIZE SEARCH EFFORT`
- Need deep, multi-faceted research
- Require empirical validation

---

## Architecture Overview

### Research Swarm Architecture

```
Orchestrator (The Conductor)
    ├─ Global Observer (broad_web_search capability)
    │   └─ Broad web coverage + official sources
    ├─ Underground OSINT (community_discussion capability)
    │   └─ Reddit + HN + forums (community voices)
    ├─ Oracle (reasoning / synthesis lane)
    │   └─ Bias detection + incentive analysis
    ├─ [Vertical Enhancer based on intent]
    │   └─ Domain-specific deep dive
    └─ Synthesizer (reports)
        └─ Cross-source validation & aggregation
```

**Complementary Design**:
- **Global Observer** uses the `broad_web_search` capability for **broad web coverage** (blogs, news sites, official docs)
- **Underground OSINT** uses the `community_discussion` capability for **community discussions** (Reddit, HN, forums)
- They work TOGETHER, not competing — different data layers

### Agent Reference Docs

| Agent | Type | Reference | Primary Layer (Depth) | Base Layer (Breadth) |
|-------|------|-----------|----------------------|---------------------|
| **Global Observer** | Universal Base | @references/vertical-enhancers/global-observer.md | multi-search-engine (17 engines) | — |
| **Underground OSINT** | Universal Base | @references/vertical-enhancers/underground-osint.md | community_discussion capability | broad_web_search capability |
| **Oracle** | Universal Base | @references/vertical-enhancers/oracle.md | reasoning / synthesis | broad_web_search capability |
| **Technical Recon** | Vertical | @references/vertical-enhancers/technical-recon.md | code_intelligence capability | broad_web_search capability |
| **The Scholar** | Vertical | @references/vertical-enhancers/scholar.md | academic-deep-research (papers) | multi-search-engine (general context) |
| **Fact Assassin** | Vertical | @references/vertical-enhancers/fact-assassin.md | news-aggregator (curated news) | multi-search-engine (cross-validation) |
| **Compliance Auditor** | Vertical | @references/vertical-enhancers/compliance-auditor.md | regulatory and filing sources | broad_web_search capability |
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
| **Reddit / Forums** | `community_discussion` capability | Community discussions, user complaints | Authentic grassroots voices |
| **HackerNews** | `news-aggregator-skill` | Tech/startup discourse | High signal-to-noise ratio |
| **Academic** | `academic-deep-research` | Papers, citations, peer review | Structured academic data |
| **News** | `news-aggregator-skill` | Breaking news, journalist reports | Editorial curation |
| **GitHub** | `github` (optional external provider) | Code repos, issues, PRs | Developer artifacts |
| **Documents** | `pdf-text-extractor` (optional external provider) | PDFs, structured data | Non-web content |

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
| repo, library, API | Code/Tech | Technical Recon | code_intelligence capability | broad_web_search capability |
| breaking news, scandal | News/Drama | Fact Assassin | news-aggregator (curated news) | multi-search-engine (cross-validation) |
| startup, funding, SEC | Business | Compliance Auditor | SEC filings (financials) | multi-search-engine (market sentiment) |
| **general query, broad topic** | **Universal** | **Global Observer** | — | **multi-search-engine (17 engines)** |
| community, complaints, reddit | Grassroots | Underground OSINT | community_discussion capability | broad_web_search capability |
| incentives, bias, stakeholders | Analysis | Oracle | reasoning / synthesis | broad_web_search capability |

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
- ❌ "已经有5个来源了，够了" → **Anti-Convergence: 5 sources is minimum floor, NOT the ceiling. More is better.**

### Anti-Convergence Rule (Critical)

**⚠️ 严禁提前收敛 (Strictly Forbidden: Premature Convergence)**

**Minimum Floor**: ≥5 distinct sources (hard requirement)  
**Recommended**: 8-15 sources (depending on topic scope)  
**Ceiling**: None (more diverse sources = better coverage)

| 指标 | 常见误区 (❌ 错误) | 正确理解 (✅ 必须) |
|------|------------------|-------------------|
| **≥5 sources** | "找到5个来源就停止，刚好达标" | **最少**需要5个来源，**上不封顶**，越多越好 |
| **15-30 data points** | 从3个来源各取5-10点 | 从**≥5个来源**（推荐更多）分散采集，确保视角多元 |
| **max 5 per source** | 从少数来源取满5点凑数 | 达到5点后必须扩展到新来源，**不能深耕单一来源** |

### Real-World Examples

**Example 1: Narrow Scope (Minimum Acceptable)**
```
Query: "今天硅谷科技圈新闻"
Scope: Single day, specific geography, tech-only

Minimum Output:
- TechCrunch: 3 news items
- The Verge: 3 news items
- HackerNews: 3 discussions
- Twitter/X Tech: 3 tweets/posts
- Reddit r/tech: 3 posts

Total: 5 sources, 15 data points ✅
Note: This meets minimum. Can expand to 8-10 sources for better coverage.
```

**Example 2: Standard Scope (Recommended)**
```
Query: "React 19新特性分析"
Scope: Technical feature review

Recommended Output:
- React官方文档: 3 points
- GitHub PRs/Issues: 3 points
- HackerNews讨论: 2 points
- Reddit r/reactjs: 2 points
- Dev.to/ Medium: 2 points
- YouTube技术博主: 2 points
- Twitter工程师: 2 points
- Stack Overflow: 2 points

Total: 8 sources, 18 data points ✅
```

**Example 3: Broad Scope (Maximum)**
```
Query: "AI行业2024年度回顾"
Scope: Industry-wide comprehensive analysis

Maximum Output:
- 12-15 sources
- 25-30 data points
- Academic papers + Industry reports + News + Community + Code repos
```

**Convergence Traps to Avoid**:
1. ❌ "5个来源 × 3点 = 15点，刚好达标，停！" → **过早收敛**
2. ✅ "5个来源 × 3点 = 15点，已达最低要求，继续扩展到8-10来源" → **正确做法**
3. ✅ "10个来源 × 2-3点 = 25点，全面覆盖" → **理想状态**

**Rule**: ≥5 sources is the hard floor. For narrow topics, 5 quality sources is acceptable. For comprehensive topics, expand to 10+. Never exceed 5 points per source.

---

## Data Quality Standards

| Standard | Requirement | Anti-Convergence Check |
|----------|-------------|----------------------|
| **Quantity** | 15-30 data points | Must collect across wide range, not concentrate in few |
| **Diversity** | **≥5 distinct sources (minimum)** | 5 is floor, 10+ recommended; prevents reliance on convenient sources |
| **Per-Source Limit** | max 5 points per source | Forces expansion to new sources when limit reached |
| **Depth** | ≥200 chars per point | Surface skimming not acceptable |
| **Provenance** | URL + timestamp required | Every point traceable |
| **Recency** | 70% from last 2 years | Balance of current + historical context |

### Source Distribution Target

**Minimum Acceptable** (Small Scope Topics):
```
Example: "今天硅谷科技圈新闻"
15 data points from 5 sources:
- TechCrunch: 3 points
- The Verge: 3 points  
- HackerNews: 3 points
- Twitter/X: 3 points
- Reddit r/tech: 3 points
Total: 15 points ✅ (minimum met, can expand to 30)
```

**Recommended** (Standard Topics):
```
25 data points from 10 sources:
- Source A: 3 points
- Source B: 2 points  
- Source C: 2 points
- Sources D-M: 1-3 points each
```

**Unacceptable** (Premature Convergence):
```
25 data points from 3 sources:
- Source A: 8 points ❌ (exceeds max 5)
- Source B: 9 points ❌ (exceeds max 5)  
- Source C: 8 points ❌ (exceeds max 5)
```

**Rule**: ≥5 sources minimum, but more is better. Never exceed 5 points per source.

---

## Compliance Verification

Before submission, verify:

```markdown
- [ ] 5 agents launched with unique mandates
- [ ] 15-30 data points collected
- [ ] ≥5 distinct sources (minimum floor, 10+ recommended for broad topics)
- [ ] max 5 points per source (forces source diversity)
- [ ] All points have URLs + timestamps
- [ ] Empirical validation complete (if Code/Tech)
- [ ] Report follows quality-gated structure
- [ ] No shortcuts taken
- [ ] Anti-Convergence Rule satisfied (≥5 sources, but more is better)
```

### Scope-Based Source Requirements

| Topic Scope | Example | Min Sources | Target Sources | Max Points |
|-------------|---------|-------------|----------------|------------|
| **Narrow** | "今天硅谷科技圈新闻" | 5 | 5-8 | 15-20 |
| **Standard** | "React vs Vue对比" | 5 | 8-12 | 20-25 |
| **Broad** | "AI行业2024年度回顾" | 5 | 12-17 | 25-30 |

**Key**: 5 sources is the hard floor. For narrow/time-sensitive topics, 5 quality sources with 15 points is acceptable. For comprehensive topics, expand to 10+ sources.

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

- **v4.0.0 - Executable Skill Architecture** 🆕
  - 创建 `DEEP_SEARCH.md` - 可执行的 5-Agent Swarm 协调器
  - 修复依赖技能路径（符号链接到主 skills 目录）
  - 实现渐进式披露的数据流（Layer 1→2→3）
  - 添加任务分发与结果收集机制
  - SKILL.md 作为设计文档，DEEP_SEARCH.md 作为执行入口
- v3.2.0 - Professional output format: Executive Summary, Methodology, Multi-perspective Analysis, Confidence Assessment
- v3.1.0 - Perfect Organic Collaboration: Two-layer architecture (Primary + Base) for all agents
- v3.0.0 - Architecturally optimized with progressive disclosure
- v2.3.0 - SkillHub integration (7 skills)
- v2.2.0 - Stable data sources
- v2.0.0 - Bulletproof execution
