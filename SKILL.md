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

**Report Structure**:
```markdown
# ⚡ Deep-Search: [Topic] 全景分析报告
**生成时间**: [Timestamp] | **数据点**: [N] | **来源域**: [N] | **整体置信度**: [HIGH/MEDIUM/LOW]

---

## 1. 执行摘要 (Executive Summary)

### 核心结论
[一句话概括最关键的发现，不超过100字]

### 关键证据
- [证据1，带超链接]
- [证据2，带超链接]

### 多视角评估
| 视角 | 评估 | 依据 |
|------|------|------|
| 官方立场 | [立场描述] | [来源] |
| 市场反馈 | [反馈描述] | [来源] |
| 技术层面 | [技术评估] | [来源] |
| 合规状况 | [合规评估] | [来源] |

### 建议措施
[P0优先级建议，最多3条]

---

## 2. 研究方法 (Methodology)

### 搜索范围
- **数据层**: Universal (17引擎) + Community (Reddit/HN) + Academic + Code + Document
- **时间范围**: [起始] - [结束]
- **语言范围**: 中文/英文/[其他]

### 数据质量指标
| 指标 | 数值 | 标准 |
|------|------|------|
| 原始数据点 | [N] | ≥15 |
| 去重后数据点 | [N] | — |
| 来源域多样性 | [N] | ≥3 |
| 跨引擎验证率 | [N%] | — |
| 时效性(近2年) | [N%] | ≥70% |

### 局限性声明
- [数据盲区1]
- [数据盲区2]
- [潜在偏见来源]

---

## 3. 全景分析 (Universal Analysis)

### 3.1 时间线与架构
[事件发展时间线或系统架构描述]

### 3.2 多源信息对比
| 维度 | 官方/机构叙述 | 社区/市场反馈 | 差异分析 |
|------|--------------|--------------|----------|
| 核心主张 | [内容] | [内容] | [对比] |
| 关键数据 | [数据] | [数据] | [对比] |
| 风险评估 | [评估] | [评估] | [对比] |

### 3.3 利益相关方分析
| 相关方 | 利益诉求 | 信息立场 | 可信度评估 |
|--------|---------|----------|-----------|
| [方1] | [诉求] | [立场] | [HIGH/MED/LOW] |
| [方2] | [诉求] | [立场] | [HIGH/MED/LOW] |

---

## 4. 实证数据 (Empirical Evidence)

### 4.1 关键引用
[5-10条原始引用，每条≥100字符，带完整出处]

| 序号 | 引用内容 | 来源 | 时间 | 置信度 |
|------|---------|------|------|--------|
| 1 | [内容] | [URL] | [时间] | [HIGH/MED/LOW] |
| 2 | [内容] | [URL] | [时间] | [HIGH/MED/LOW] |

### 4.2 验证记录
| 验证项 | 方法 | 结果 | 输出 |
|--------|------|------|------|
| [测试1] | [方法] | ✅/❌ | [stdout/stderr] |

---

## 5. 垂直分析 (Domain Analysis)

根据主题类型，选择对应框架：

### 5A. 技术类主题 (Technical)
#### 技术实现评估
- 架构设计: [评估]
- 代码质量: [评估]
- 维护状态: [评估]

#### 生产环境考量
- 已知问题: [列表]
- 性能特征: [数据]
- 替代方案: [对比]

#### 采用建议
- 适用场景: [描述]
- 风险评估: [等级]
- 实施建议: [步骤]

### 5B. 商业类主题 (Business)
#### 商业模式分析
- 盈利逻辑: [描述]
- 成本结构: [分析]
- 可持续性: [评估]

#### 合规与风险
- 监管合规: [状态]
- 财务健康: [指标]
- 重大风险: [列表]

#### 市场定位
- 竞争格局: [分析]
- 差异化因素: [识别]
- 前景评估: [判断]

### 5C. 新闻/事件类主题 (News/Event)
#### 事实核查
- 核心主张: [验证]
- 时间线核实: [结果]
- 信息来源: [评估]

#### 多方叙述对比
- 官方版本: [内容]
- 独立报道: [内容]
- 社区反应: [内容]

#### 影响评估
- 直接影响: [范围]
- 次生效应: [预测]
- 长期意义: [判断]

---

## 6. 综合评估 (Synthesis)

### 6.1 关键判断
| 判断 | 置信度 | 依据 | 备选解释 |
|------|--------|------|----------|
| [判断1] | [HIGH/MED/LOW] | [N个数据点] | [其他可能] |
| [判断2] | [HIGH/MED/LOW] | [N个数据点] | [其他可能] |

### 6.2 信息缺口
- [无法验证的声明1]
- [待进一步调查的问题2]

---

## 7. 行动建议 (Recommendations)

| 优先级 | 行动项 | 责任方 | 时间线 | 预期结果 |
|--------|--------|--------|--------|----------|
| P0 | [行动] | [责任方] | [时间] | [结果] |
| P1 | [行动] | [责任方] | [时间] | [结果] |
| P2 | [行动] | [责任方] | [时间] | [结果] |

---

## 8. 附录 (Appendices)

### 8.1 数据来源清单
[完整URL列表，按Agent分类]

### 8.2 置信度评估标准
- **HIGH**: ≥5个独立来源验证，或官方文件证实
- **MEDIUM**: 2-4个来源，或单一权威来源
- **LOW**: 单一来源，或间接证据

### 8.3 术语表
- [术语1]: [定义]
- [术语2]: [定义]
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

- v3.2.0 - Professional output format: Executive Summary, Methodology, Multi-perspective Analysis, Confidence Assessment
- v3.1.0 - Perfect Organic Collaboration: Two-layer architecture (Primary + Base) for all agents
- v3.0.0 - Architecturally optimized with progressive disclosure
- v2.3.0 - SkillHub integration (7 skills)
- v2.2.0 - Stable data sources
- v2.0.0 - Bulletproof execution
