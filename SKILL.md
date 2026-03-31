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

### PHASE 0: Intent Classification & Agent Differentiation (ANTI-COLLUSION)

**CRITICAL**: Each of the 3-5 agents MUST have **non-overlapping mandates**. Deploying agents with identical tasks = GAMING THE SYSTEM.

Announce: > "Deep-Search Router: 识别到主要 [新闻/代码/商业] 意图，部署 5 个差异化代理并行工作。"

**Deploy EXACTLY 5 OMOC subagents IN PARALLEL (`task(run_in_background=true)`):**

*【Universal Base Agents - ALWAYS RUN】*
1. **The Global Observer (`librarian`)**: 
   - **Unique mandate**: Official docs, academic papers, financial reports
   - **Forbidden overlap**: Must NOT search Reddit/HN (that's Underground's job)
   - **Output format**: Structured facts with source URLs + timestamps

2. **The Underground OSINT (`librarian`)**: 
   - **Unique mandate**: Reddit (`reddit-readonly`), HackerNews, Forums
   - **Explicit instruction**: Find "complaints", "scams", "bugs", "deleted posts", "regrets"
   - **Anti-gaming rule**: If "no negative info found", MUST document: platforms searched, keywords used, search duration, and hypothesis why
   - **Output format**: Raw quotes (≥100 chars each) + source URLs + timestamps

3. **The Oracle (`oracle`)**: 
   - **Unique mandate**: Decode money flow, biases, hidden incentives
   - **Key question**: "Who profits? Who pays? What's the hidden agenda?"
   - **Output format**: Causal analysis with evidence chains

*【Vertical Enhancers - BASED ON INTENT】*
4. **The Technical Recon (`explore` + `ast_grep_search`)**: *[If Code/Tech]*
   - **Unique mandate**: Repository scanning, code patterns, GitHub Issues/PRs
   - **Must use**: `Context7` for API documentation
   - **Output format**: Code snippets + Issue numbers + architectural insights

5. **The Fact Assassin (`unspecified-high`)**: *[If News/Drama]* OR **The Compliance Auditor (`librarian`)**: *[If Business]*
   - News: Find contradictions, deleted content, timeline discrepancies
   - Business: SEC filings, hidden fees, Ponzi structures
   - **Output format**: Timeline analysis or risk assessment with evidence

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
- [ ] Agent 1 (Global Observer): [objective] → Expected: [N] facts
- [ ] Agent 2 (Underground OSINT): [objective] → Expected: [N] complaints
- [ ] Agent 3 (Oracle): [objective] → Expected: [N] bias analyses
- [ ] Agent 4 (Technical/Fact): [objective] → Expected: [N] code/evidence
- [ ] Agent 5 (Vertical): [objective] → Expected: [N] specialized findings
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
