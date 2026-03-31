# /deep-search Command (V2.0: Bulletproof Execution - Anti-Gaming Edition)

This command triggers "Max-Search Mode" (Saturation Search Protocol) for exhaustive, zero-blind-spot research. It is governed by strict Ultrawork protocols requiring **absolute certainty**, **empirical validation**, and **active anti-hallucination checks**. **THIS SKILL IS BULLETPROOFED AGAINST SHORTCUTS.**

## 🔋 Batteries-Included Installation
Before using this skill on a new machine, run the built-in setup script:
```bash
bash ~/.agents/skills/deep-search/setup.sh
```

## When to Use
Use when the user explicitly requests `/deep-search <topic>`, uses `[search-mode] MAXIMIZE SEARCH EFFORT`, or requires deep, multi-faceted research.

---

## ⚠️ ANTI-GAMING DECLARATION (READ FIRST)

**The following excuses are INVALID and will be rejected:**
- ❌ "时间紧迫" → Protocol has NO time exceptions
- ❌ "太累了" → Fatigue is irrelevant to protocol compliance  
- ❌ "资料太少" → Must expand search scope, never truncate
- ❌ "验证不划算" → Trust No PR is MANDATORY, not optional
- ❌ "找不到负面信息" → Must document search scope and effort

**Violating the letter = Violating the spirit.** No partial credit.

---

## THE IRONCLAD EXECUTION PROTOCOL (ZERO-TOLERANCE EDITION)

### PRE-PHASE: Tool Availability & Environment Check (ANTI-STALL)

**CRITICAL**: Before launching ANY agents, verify tool availability to prevent "stalling" (wasting tokens on failed tool calls).

**Step 1: Check Core AI Tools & SkillHub Skills**
```bash
# Check Exa AI websearch (PRIMARY for Reddit/HN)
echo "=== Core AI Tools ==="
echo "✅ websearch_exa - Primary tool for Reddit/HN (via Exa AI)"
echo "✅ webfetch - Direct URL fetching for Reddit JSON and HN Algolia API"

echo "=== SkillHub Skills (Enhanced Data Sources) ==="
# Check if SkillHub skills are available
ls ~/.agents/skills/ 2>/dev/null | grep -E "search-cluster|news-aggregator|academic-deep-research" && echo "✅ SkillHub skills installed" || echo "⚠️ Some SkillHub skills missing - will use native tools"
```

**Step 2: Verify System Dependencies**
```bash
echo "=== System Dependencies ==="
which curl && echo "✅ curl available" || echo "❌ curl missing - install with: brew install curl"
which jq && echo "✅ jq available" || echo "❌ jq missing - install with: brew install jq"
which git && echo "✅ git available" || echo "❌ git missing"
```

**Step 3: Document Data Sources**
在 `todowrite` 中记录：
```markdown
- [ ] Tool Health Check Complete
  - [ ] Reddit Data Source: search-cluster (PRIMARY) / websearch_exa (FALLBACK)
  - [ ] HN Data Source: news-aggregator-skill (PRIMARY) / webfetch Algolia API (FALLBACK)
  - [ ] Academic Source: academic-deep-research (PRIMARY) / websearch (FALLBACK)
  - [ ] News Source: news-aggregator-skill (PRIMARY) / websearch_exa (FALLBACK)
  - [ ] Context7: [OK / Fallback to webfetch]
  - [ ] System deps (curl, jq): [All OK / Partial / Missing]
  - [ ] SkillHub Skills Available (开箱即用):
    - [ ] news-aggregator-skill: [Installed / Not Installed]
    - [ ] academic-deep-research: [Installed / Not Installed]
```

**Enhanced Data Source Matrix** (v2.2 with SkillHub Integration):

| Data Source | Primary Method | Tool/Skill | Reliability |
|-------------|----------------|------------|-------------|
| **Reddit** | `websearch_exa` | Exa AI search with `site:reddit.com` | ⭐⭐⭐⭐⭐ |
| **Reddit (direct)** | `webfetch` | Reddit JSON API | ⭐⭐⭐⭐ |
| **HackerNews** | `news-aggregator-skill` | SkillHub (HN + 7 other sources) | ⭐⭐⭐⭐⭐ |
| **HN (backup)** | `webfetch` | Algolia API | ⭐⭐⭐⭐⭐ |
| **Academic** | `academic-deep-research` | SkillHub (APA citations, 2-cycle research) | ⭐⭐⭐⭐⭐ |
| **News** | `news-aggregator-skill` | SkillHub (8-source aggregation) | ⭐⭐⭐⭐⭐ |
| **Code Docs** | `webfetch` | Official docs / GitHub README | ⭐⭐⭐⭐ |
| **GitHub** | `grep_app_searchGitHub` | GitHub API | ⭐⭐⭐⭐ |

**✅ ENHANCED**: v2.2+ integrates SkillHub skills (news-aggregator-skill, academic-deep-research) for maximum coverage and stability.
**⚠️ DEPRECATED**: Reddit MCP and HN MCP are unreliable and should NOT be used.
```

**Step 2: Verify System Dependencies**
```bash
echo "=== System Dependencies ==="
which curl && echo "✅ curl available" || echo "❌ curl missing - install with: brew install curl"
which jq && echo "✅ jq available" || echo "❌ jq missing - install with: brew install jq"
which git && echo "✅ git available" || echo "❌ git missing"
```

**Step 3: Document Tool Status**
在 `todowrite` 中记录：
```markdown
- [ ] Tool Health Check Complete
  - [ ] reddit-readonly: [OK / Fallback Mode]
  - [ ] hacker-news: [OK / Fallback Mode]
  - [ ] Context7: [OK / Fallback Mode]
  - [ ] curl: [OK / Missing]
  - [ ] jq: [OK / Missing]
```

**Fallback Strategy Matrix**:

| Primary Tool | Status | Fallback Chain | Last Resort |
|-------------|--------|----------------|-------------|
| `reddit-readonly` | ❌ Timeout/Error | 1. `websearch "site:reddit.com/r/[sub] [query]"` → 2. `webfetch` Reddit URL directly | General web search |
| `hacker-news` | ❌ Timeout/Error | 1. `webfetch https://hn.algolia.com/api/v1/search?query=[topic]` → 2. `websearch "site:news.ycombinator.com [topic]"` | General web search |
| `Context7` | ❌ No API Key | 1. `webfetch` official docs → 2. `websearch "[library] documentation API"` | GitHub README |
| `playwright` | ❌ Not Configured | 1. `curl` with headers → 2. `webfetch` with mobile UA | `webfetch` basic |

**⚠️ If P0 tools are unavailable**: Proceed with fallback modes but DOCUMENT THIS in final report's "Methodology Limitations" section.

---

### PHASE 0: Intent Classification & Agent Differentiation (ANTI-COLLUSION)

**CRITICAL**: Each of the 3-5 agents MUST have **non-overlapping mandates**. Deploying agents with identical tasks = GAMING THE SYSTEM.

Announce: > "Deep-Search Router: 识别到主要 [新闻/代码/商业] 意图，部署 5 个差异化代理并行工作。"

**Deploy EXACTLY 5 OMOC subagents IN PARALLEL (`task(run_in_background=true)`):**

*【Universal Base Agents - ALWAYS RUN】*
1. **The Global Observer (`librarian`)**: 
   - **Unique mandate**: Official docs, academic papers, financial reports
   - **Forbidden overlap**: Must NOT search Reddit/HN (that's Underground's job)
   - **Output format**: Structured facts with source URLs + timestamps

2. **The Underground OSINT (`librarian` + `news-aggregator-skill`)**: 
   - **Unique mandate**: Reddit, HackerNews, Forums - find "complaints", "scams", "bugs", "deleted posts", "regrets"
   - **⚠️ STABILITY NOTE**: Use SkillHub skills as PRIMARY for maximum coverage and stability.
   - **Primary Tools** (RECOMMENDED - SkillHub):
     ```markdown
     news-aggregator-skill (8-source aggregator, 开箱即用):
     - `python3 scripts/fetch_news.py --source hackernews --limit 20 --keyword "[topic],issues,problems" --deep`
     - `python3 scripts/fetch_news.py --source v2ex --limit 15 --keyword "[topic]" --deep` (Chinese dev community)
     - `python3 scripts/fetch_news.py --source all --limit 10 --keyword "[topic]" --deep` (global scan)
     ```
   - **Fallback Tools** (NATIVE - if SkillHub unavailable):
     ```markdown
     Reddit (Exa AI):
     - `websearch_exa "site:reddit.com/r/[subreddit] [topic] complaints/problems"`
     - `webfetch "https://www.reddit.com/r/[sub]/comments/[post_id].json"`
     
     HackerNews (Algolia API):
     - `webfetch "https://hn.algolia.com/api/v1/search?query=[topic]&tags=story"`
     ```
   - **Search Pattern Library**:
     | Platform | Complaints | Praise | Technical Discussion |
     |----------|-----------|--------|---------------------|
     | Reddit | `"[topic] problems issues"` | `"[topic] recommend"` | `"[topic] vs alternative"` |
     | HN | `"[topic] criticism"` | `"[topic] show hn"` | `"[topic] ask hn"` |
     | V2EX | `"[topic] 吐槽"` | `"[topic] 推荐"` | `"[topic] 讨论"` |
   - **Anti-gaming rule**: If "no negative info found", MUST document: platforms searched, keywords used, search duration, and hypothesis why
   - **Backup Sources**: Twitter/X, GitHub Issues, Stack Overflow, Lobste.rs, IndieHackers
   - **Output format**: Raw quotes (≥100 chars) + source URLs + timestamps + **tool used** (search-cluster/news-aggregator/native)

3. **The Oracle (`oracle`)**: 
   - **Unique mandate**: Decode money flow, biases, hidden incentives
   - **Key question**: "Who profits? Who pays? What's the hidden agenda?"
   - **Output format**: Causal analysis with evidence chains

*【Vertical Enhancers - BASED ON INTENT】*

**Enhanced with SkillHub Skills** (v2.2+):
The following SkillHub skills are auto-loaded as enhancements (开箱即用):
- `news-aggregator-skill`: 8-source news aggregator (HN, 36Kr, 微博, etc.) - 仅需 pip install
- `academic-deep-research`: Academic-grade research methodology - 零配置

**Integration Strategy**:
- Use SkillHub skills as PRIMARY data sources when available
- Fall back to native tools (websearch_exa, webfetch) if needed
- Combine outputs for maximum coverage

**Intent Detection Matrix** (Match user query to enhancer):

| Keywords/Patterns | Primary Intent | Vertical Enhancer | Required Tools |
|-------------------|----------------|-------------------|----------------|
| "paper", "research", "arxiv", "study", "academic", "citation" | Academic | **The Scholar** | scholar search, arxiv, semanticscholar |
| "legal", "compliance", "regulation", "GDPR", "lawsuit", "patent" | Legal | **The Legal Decoder** | court records, regulatory filings, ToS analysis |
| "hardware", "chip", "device", "teardown", "benchmark" | Hardware | **The Hardware Inspector** | iFixit, hardware reviews, supply chain DB |
| "game", "gaming", "player", "steam", "metaverse" | Gaming | **The Gaming Analyst** | Steam data, player reviews, industry reports |
| "medical", "health", "FDA", "clinical trial" | Healthcare | **The Health Inspector** | PubMed, FDA database, medical journals |
| repo name, "library", "framework", "API" | Code/Tech | **The Technical Recon** | explore, ast_grep, Context7/GitHub |
| "breaking news", "scandal", "controversy" | News/Drama | **The Fact Assassin** | unspec-high, fact-check DB |
| "startup", "funding", "valuation", "SEC" | Business | **The Compliance Auditor** | librarian, SEC EDGAR, crunchbase |

4. **The Technical Recon (`explore` + `ast_grep_search`)**: *[If Code/Tech detected]*
   - **Unique mandate**: Repository scanning, code patterns, GitHub Issues/PRs
   - **Must use**: `Context7` for API documentation (with fallback to webfetch)
   - **Fallback chain**: Context7 → `webfetch` official docs → `websearch` "[lib] API docs"
   - **Output format**: Code snippets + Issue numbers + architectural insights

5. **The Fact Assassin (`news-aggregator-skill` + `unspecified-high`)**: *[If News/Drama detected]* 
   - **Unique mandate**: Find contradictions, deleted content, timeline discrepancies
   - **⚡ ENHANCED**: Uses `news-aggregator-skill` for 8-source real-time news aggregation
   - **Primary Tools** (SkillHub news-aggregator-skill):
     ```markdown
     Global News Scan (all 8 sources):
     - `python3 scripts/fetch_news.py --source all --limit 15 --keyword "[topic],controversy,scandal" --deep`
     
     Specific Source Deep Dives:
     - HN Tech: `python3 scripts/fetch_news.py --source hackernews --limit 20 --keyword "[topic]" --deep`
     - Chinese Tech: `python3 scripts/fetch_news.py --source 36kr --limit 15 --keyword "[topic]" --deep`
     - Finance: `python3 scripts/fetch_news.py --source wallstreetcn --limit 10 --keyword "[topic]" --deep`
     - Social: `python3 scripts/fetch_news.py --source weibo --limit 10 --keyword "[topic]" --deep`
     
     Smart Keyword Expansion:
     - User: "AI" → Use: "AI,LLM,GPT,Claude,Generative,Machine Learning,RAG,Agent,controversy"
     - User: "scandal" → Use: "scandal,controversy,lawsuit,investigation,accusation"
     ```
   - **Fact-Checking Tools**:
     - Wayback Machine for deleted content
     - Fact-check databases (Snopes, PolitiFact, etc.)
     - Cross-reference multiple sources from news-aggregator output
   - **Output format**: Timeline analysis with timestamped contradictions + source diversity report

6. **The Compliance Auditor (`librarian`)**: *[If Business detected]*
   - **Unique mandate**: SEC filings, hidden fees, Ponzi structures, regulatory actions
   - **Must search**: EDGAR database, regulatory enforcement actions, lawsuit trackers
   - **Output format**: Risk assessment with specific filing numbers and legal citations

7. **The Scholar (`academic-deep-research` + `librarian`)**: *[If Academic detected]* **NEW**
   - **Unique mandate**: Academic paper analysis, citation tracking, research trends
   - **⚡ ENHANCED**: Uses `academic-deep-research` SkillHub skill for rigorous methodology
   - **Primary Approach** (SkillHub academic-deep-research):
     ```markdown
     1. **Phase 1**: Initial Engagement - Ask 2-3 clarifying questions about research scope
     2. **Phase 2**: Research Planning - Present plan with themes, tools, deliverables (STOP for user approval)
     3. **Phase 3**: Mandated Research Cycles:
        - Cycle 1: Broad search (web_search count=20) + landscape analysis
        - Cycle 2: Deep investigation targeting gaps (web_fetch primary sources)
     4. **Phase 4**: Final Report - APA 7th edition citations, evidence hierarchy, full narrative
     ```
   - **Evidence Hierarchy** (from academic-deep-research):
     1. Systematic reviews & meta-analyses [HIGHEST]
     2. Randomized controlled trials
     3. Cohort / longitudinal studies
     4. Expert consensus / guidelines
     5. Cross-sectional / observational
     6. Expert opinion / editorials
     7. Media reports / blogs [LOWEST]
   - **Key outputs**: 
     - Most cited papers with citation counts (APA format)
     - Recent breakthrough papers (last 2 years)
     - Controversies or retractions in the field
     - Key researchers and their affiliations
     - **[NEW]** Evidence quality assessment [HIGH/MEDIUM/LOW/SPECULATIVE]
     - **[NEW]** Cross-theme synthesis and meta-patterns
   - **Fallback**: If academic DBs unavailable, use `websearch "filetype:pdf [topic] site:arxiv.org"`

8. **The Legal Decoder (`librarian`)**: *[If Legal detected]* **NEW**
   - **Unique mandate**: Legal document parsing, compliance requirement extraction, case law analysis
   - **Must search**: Court filings, regulatory guidance, Terms of Service deep-dives
   - **Key outputs**:
     - Relevant statutes and regulations with section numbers
     - Recent precedent cases with citations
     - Compliance checklist based on jurisdiction
     - Risk assessment matrix
   - **Fallback**: PACER (US courts), EUR-Lex (EU), regulatory agency websites

9. **The Hardware Inspector (`librarian`)**: *[If Hardware detected]* **NEW**
   - **Unique mandate**: Hardware teardowns, supply chain analysis, benchmark validation
   - **Must search**: iFixit teardowns, tech reviews, supply chain reports, FCC filings
   - **Key outputs**:
     - Component breakdown with estimated costs
     - Repairability scores and common failure points
     - Performance benchmarks from multiple sources
     - Supply chain dependencies and geopolitical risks
   - **Fallback**: YouTube teardown transcripts, manufacturer spec sheets

**Agent Differentiation Requirement**: Before launching, verify each agent has:
- [ ] Unique role description (no overlap)
- [ ] Different search tools/keywords
- [ ] Different output format requirements
- [ ] **Fallback tools identified** (if primary tools fail)

**Agent Differentiation Requirement**: Before launching, verify each agent has:
- [ ] Unique role description (no overlap)
- [ ] Different search tools/keywords
- [ ] Different output format requirements

---

### PHASE 1: Data Collection with Quality Gates (ANTI-DILUTION)

**Saturation Threshold**: Capture **15-30 high-quality raw data points** BEFORE synthesizing.

**Data Point Quality Standards (ALL must be met)**:

| Requirement | Minimum Standard | Anti-Gaming Check |
|------------|------------------|-------------------|
| **Quantity** | 15-30 points | Must use `todowrite` to count |
| **Source Diversity** | ≥ 3 distinct domains/platforms | Same domain max 5 points |
| **Content Depth** | ≥ 200 characters of substance per point | No URL-only or title-only entries |
| **Uniqueness** | No duplicate content/similar quotes | Must de-duplicate before counting |
| **Provenance** | Every point MUST include: source URL + fetch timestamp | No anonymous sources |
| **Recency** | ≥ 70% of points from last 2 years (unless historical topic) | Document if using older sources |

**Mandatory Tracking (`todowrite`)**:
```markdown
### Pre-Phase: Tool Health
- [ ] Reddit Data Source: websearch_exa (STABLE) / webfetch JSON
- [ ] HN Data Source: webfetch Algolia API (STABLE) / websearch_exa
- [ ] Context7: [OK / Fallback to webfetch]
- [ ] System deps (curl, jq): [All OK / Partial / Missing]

### Agent Deployment
- [ ] Agent 1 (Global Observer): [objective] → Expected: [N] facts
- [ ] Agent 2 (Underground OSINT): [objective] → Expected: [N] complaints
- [ ] Agent 3 (Oracle): [objective] → Expected: [N] bias analyses
- [ ] Agent 4 (Intent-Specific): [objective] → Expected: [N] findings
  - [ ] Intent detected: [Code/Tech/News/Business/Academic/Legal/Hardware]
  - [ ] Enhancer assigned: [Technical/Fact/Compliance/Scholar/Legal/Hardware]
- [ ] Agent 5 (Specialized): [objective] → Expected: [N] specialized findings
- [ ] Data Point Quality Check: 15-30 points, 3+ sources, all with URLs
```

**The "No Drift" Rule**: If any agent returns <3 quality data points, expand their search scope (different keywords, broader time range, alternative platforms). **Never accept "not much found" as completion.**

---

### PHASE 2: Deep-Web Penetration & Fallback Protocol

- We do not accept "403 Forbidden" or "No HTML structure".
- **Mandatory Fallbacks** (try in order):
  1. `webfetch` with different User-Agent
  2. `bash` + `curl` with headers to scrape mirror sites
  3. `playwright` for headless browser rendering
  4. `look_at` for OCR extraction if paywall blocks text
- **Documentation**: If fallbacks used, note which one and why in final report.

---

### PHASE 3: Empirical Validation (TRUST NO PR - VERIFICATION PROTOCOL)

**ABSOLUTELY MANDATORY for Code/Tech topics.** Optional skip ONLY for pure theory/concept topics with no implementable components.

**Validation Requirements**:

1. **Test Coverage** (ALL required):
   - [ ] **Basic functionality**: Does the simplest case work?
   - [ ] **Typical use case**: Does the main advertised feature work?
   - [ ] **Edge case**: Boundary condition or large input
   - [ ] **Error handling**: Invalid input or failure scenario

2. **Environment Setup**:
   ```bash
   TEST_DIR="/tmp/omo-deep-search-$(date +%s)"
   mkdir -p "$TEST_DIR" && cd "$TEST_DIR"
   ```

3. **Required Output Capture** (MUST include in report):
   ```markdown
   ### Empirical Validation Log
   
   **Test 1: [Description]**
   ```
   $ [exact command executed]
   [stdout output - COMPLETE, no truncation]
   [stderr output - COMPLETE, or "(no stderr)"]
   $ echo $?
   [exit code]
   ```
   **Timestamp**: [YYYY-MM-DD HH:MM:SS]
   **Result**: [PASS/FAIL with explanation]
   
   [Repeat for Tests 2-4...]
   ```

4. **Cleanup**:
   ```bash
   rm -rf "$TEST_DIR"
   ```

**Anti-Gaming Rules**:
- ❌ Running `echo "test"` and claiming validation = **VIOLATION**
- ❌ Testing only hello-world while ignoring complex features = **VIOLATION**
- ❌ Showing only successful tests while hiding failures = **VIOLATION**
- ❌ Using `2>/dev/null` to hide stderr = **VIOLATION**

---

### PHASE 4: The Final Deliverable (QUALITY-GATED STRUCTURE)

**Output the final report DIRECTLY IN THE CHAT WINDOW.** Use the following structure with **minimum information density requirements**:

```markdown
# ⚡ Deep-Search: [主题/事件/项目名称] 全景渗透报告
**Generated**: [Timestamp] | **Data Points**: [N] | **Sources**: [N domains] | **Validation**: [PASS/FAIL]

---

## 1. 🌐 通用基座分析 (The Universal Core)
*(Minimum: 3 bullets × 3 sentences each with specific data/numbers)*

- ⏱️ **全景时间线/架构大盘**: 
  [What happened + when + key milestones with dates. Must include ≥2 specific dates/versions]
  
- 🎭 **信息茧房与回音壁**: 
  - 📣 **官方定调**: [Specific claims from official sources with exact quotes or press release dates]
  - 🕵️ **民间真相**: [Contradictory experiences from Reddit/HN with ≥2 verbatim quotes]
  
- 💰 **利益驱动与偏见**: 
  [Who funds this + how they profit + specific dollar amounts or market share data if available]

---

## 2. 🩸 原生证据展厅 (Raw Evidence - NO AI FILTER)
*(Minimum: 5 evidence items, each ≥100 chars + full attribution)*

### Evidence 1: [Source Type - e.g., GitHub Issue / Reddit Comment / HN Post]
> "[Verbatim quote, ≥100 characters, unedited]"
**Source**: [Exact URL] | **Fetched**: [YYYY-MM-DD HH:MM:SS] | **Author**: [Username/Handle]

[Repeat for Evidence 2-5+...]

---

## 3. 🧩 垂直深度切片 (Dynamic Modules)

### 💣 技术坑点与最佳实践 *[If Code/Tech]*
*(Each gotcha must cite specific GitHub Issue # or validation test result)*

- ⚠️ **[Gotcha Title]**: [Specific problem description]
  - **Evidence**: GitHub Issue #[number] or Validation Test #[number]
  - **Impact**: [What breaks and under what conditions]
  - **Workaround**: [Specific solution or code snippet]

- ✅ **工业级架构选型**:
  | Criteria | Option A | Option B | Winner |
  |----------|----------|----------|--------|
  | [Metric] | [Data] | [Data] | [A/B] |

### 🔪 现实扒皮与崩溃条件 *[If Business/Products]*
*(Each claim must cite SEC filing, ToS clause, or specific fee structure)*

- ⚖️ **霸王条款**: [Specific unfair rule with clause number or URL]
- 💣 **致命软肋**: [Scenario that kills the project + trigger conditions]

### 🔪 隐藏的反转与真相 *[If News/Drama]*
*(Must show timeline with timestamped contradictions)*

- 🔍 **事实核查**: [Claim A vs Evidence B with specific timestamps]

### 🎓 学术研究深度解析 *[If Academic detected - NEW]*
*(Each paper must include citation count and publication venue)*

- 📚 **核心论文矩阵**:
  | Paper Title | Authors | Venue | Year | Citations | Key Finding |
  |-------------|---------|-------|------|-----------|-------------|
  | [Title] | [Names] | [arXiv/NeurIPS/etc] | [YYYY] | [N] | [1-sentence summary] |

- 🔄 **研究趋势**: [Emerging directions + declining topics with evidence]
- ⚠️ **争议与反驳**: [Papers with conflicting conclusions or retractions]
- 👥 **关键研究者**: [Top 3 researchers + affiliations + h-index if available]

### ⚖️ 法律合规风险图谱 *[If Legal detected - NEW]*
*(Each claim must cite specific statute, case, or regulatory guidance)*

- 📜 **适用法规**: 
  - [Jurisdiction]: [Statute/Regulation] Section [X.X] - [Brief description]
  - Key requirements: [Bullet list]

- ⚡ **合规检查清单**:
  - [ ] [Requirement 1]: [How to comply + reference]
  - [ ] [Requirement 2]: [How to comply + reference]

- 🏛️ **相关判例**: [Case name, citation, holding, relevance]
- 🚨 **风险评级**: [High/Medium/Low with justification]

### 🔧 硬件解剖与供应链 *[If Hardware detected - NEW]*
*(Each claim must cite iFixit, manufacturer spec, or benchmark source)*

- 🧩 **组件拆解**: 
  | Component | Supplier | Est. Cost | Function |
  |-----------|----------|-----------|----------|
  | [Chip name] | [Vendor] | [$X] | [Purpose] |

- 📊 **性能基准**: 
  | Metric | This Product | Competitor A | Source |
  |--------|--------------|--------------|--------|
  | [Score] | [Value] | [Value] | [Review site] |

- 🔧 **可维修性**: iFixit Score: [X/10] | Common failures: [List]
- 🌏 **供应链风险**: [Geopolitical dependencies + alternative suppliers]

---

## 4. 🔬 实证验证记录 (Empirical Validation)
*(If Code/Tech - MANDATORY section)*

[See PHASE 3 requirements for full log format]

**Validation Summary**: [N/4 tests passed]

---

## 5. 🚀 执行与避坑建议 (Actionable Takeaways)
*(Must start with action verbs: 避免/使用/安装/修改/等待)*

- 🔴 **大众盲区**: [Specific misconception + why it's wrong + evidence]
- 🚀 **可操作建议**:
  1. [Actionable step 1 with specific tool/version recommendation]
  2. [Actionable step 2 with resource links]
  3. [Actionable step 3 with risk assessment]
```

---

### PHASE 5: Compliance Verification (SELF-AUDIT)

**BEFORE submitting the final report, you MUST complete this checklist:**

```markdown
## ✅ Deep-Search Compliance Verification

### Agent Deployment
- [ ] Launched exactly 5 differentiated agents (or documented why fewer)
- [ ] Each agent has unique role, keywords, and output format (no overlap)
- [ ] All agents tracked in `todowrite` with objectives

### Data Quality
- [ ] Collected 15-30 raw data points
- [ ] Points come from ≥3 distinct sources (max 5 per source)
- [ ] Each point has source URL + timestamp
- [ ] Each point contains ≥200 characters of substance
- [ ] Duplicates removed

### Empirical Validation (if Code/Tech)
- [ ] 4 test cases: basic + typical + edge + error
- [ ] All tests run in `/tmp/omo-deep-search-[timestamp]/`
- [ ] Complete stdout/stderr/exit code captured for each
- [ ] Timestamps recorded
- [ ] Test directory cleaned up

### Report Quality
- [ ] Universal Core: 3 bullets × 3 sentences with specific data
- [ ] Raw Evidence: 5+ items, each ≥100 chars with full attribution
- [ ] Vertical Modules: Evidence-based claims (Issue #s, URLs, test results)
- [ ] Actionable Takeaways: Start with verbs, include specific resources

### Anti-Gaming Checks
- [ ] No "时间紧迫" shortcuts taken
- [ ] No "找不到" excuses without documented search effort
- [ ] No selective output hiding (all stderr shown)
- [ ] No formalistic validation (real test cases, not `echo`)

**Declaration**: I certify this deep-search complies with ALL Ironclad Protocol requirements.
**Completed**: [Timestamp]

### Tool Health Summary
Document data source usage and any issues:
```markdown
| Data Source | Method Used | Queries/API Calls | Results Quality |
|-------------|-------------|-------------------|-----------------|
| Reddit | websearch_exa / webfetch JSON | [List queries] | [High/Medium/Low] |
| HackerNews | webfetch Algolia API / websearch_exa | [List queries] | [High/Medium/Low] |
| GitHub | grep_app_searchGitHub / webfetch | [List queries] | [High/Medium/Low] |
| Official Docs | webfetch / Context7 | [List URLs] | [High/Medium/Low] |

**Data Source Notes**:
- Reddit: Using Exa AI search (STABLE) - no MCP dependency
- HN: Using Algolia API (STABLE) - official HN search
- Total data points collected: [N]
- Sources diversity: [N] distinct domains
```
```

**If you cannot check ALL boxes, DO NOT submit. Return to missing phase and complete it.**

---

## 🚨 RED FLAGS - STOP AND RESTART IF YOU SEE THESE

If you catch yourself thinking:
- "I'll just collect 15 quick links to hit the number" → **STOP. Focus on quality per point.**
- "The validation is too hard, I'll skip it" → **STOP. Use simpler test cases, but run them.**
- "I'll hide this error from the user" → **STOP. Show all stderr, explain what it means.**
- "These 3 agents can do similar work" → **STOP. Redesign with non-overlapping mandates.**

**There are no shortcuts. There is only compliance or non-compliance.**
