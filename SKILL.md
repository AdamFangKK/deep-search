# /deep-search Command (V122: The Tri-Swarm Router - Multi-Modal Precision)

This command triggers "Max-Search Mode" (Saturation Search Protocol) for exhaustive, zero-blind-spot research and information gathering. It is governed by strict Ultrawork protocols requiring absolute certainty, manual QA, empirical validation, and active anti-hallucination checks.

## 🔋 Batteries-Included Installation
Before using this skill on a new machine, run the built-in setup script to automatically install all required system, Python, and Node dependencies:
```bash
bash ~/.agents/skills/deep-search/setup.sh
```
*(This installs: `pandas`, `yt-dlp`, `playwright`, `tmux`, `sqlite3`, `jq`, and configures the `/tmp/omo-deep-search/` sandbox.)*

## When to Use
Use when the user explicitly requests `/deep-search <topic>`, uses `[search-mode] MAXIMIZE SEARCH EFFORT`, or requires deep, multi-faceted research.

---

## THE IRONCLAD EXECUTION PROTOCOL (MANDATORY NATIVE SWARM)

### PHASE 0: Intent Classification (The Tri-Swarm Router)
Before launching ANY background agents, the Orchestrator MUST analyze the user's query and explicitly announce the selected routing mode in the chat:
> "Deep-Search Router: 识别到 [新闻吃瓜 / 硬核代码 / 深度商业] 意图，已加载对应 Swarm 预设引擎。"

**Select ONE of the following three modes based on the query:**

#### 🔴 MODE A: News & Trends (情报与吃瓜模式)
- **Target**: Breaking news, drama, gossip, trending topics, public sentiment.
- **Swarm Strategy**:
  - `librarian` (Freshness 24h/week): Official news outlets, multi-search-engine.
  - `librarian` (OSINT): HackerNews, Reddit (`reddit-readonly`), Twitter archives to extract civilian sentiment and underground discourse.
  - `unspecified-high`: Fact-checker agent looking for contradictions across timelines.

#### 🔵 MODE B: Code & Tech (硬核代码模式)
- **Target**: Open-source projects, API best practices, tech stack comparisons, error root-cause analysis.
- **Swarm Strategy**:
  - `explore` & `ast_grep_search`: Local/Remote repository pattern scanning.
  - `librarian` (GitHub & Context7): Scrape GitHub Issues, PRs, and official documentation using Context7.
  - `gsd-codebase-mapper`: Analyze architectural paradigms.
- **Mandatory Action**: YOU MUST use `bash` to run empirical validation (write simple scripts in `/tmp/omo-deep-search-[timestamp]/` to test APIs/libraries).

#### ⚫ MODE C: Deep Domain & Product (商业与领域深度扒皮模式)
- **Target**: Web3/Crypto, startups, business models, financial products, industry deep-dives.
- **Swarm Strategy**:
  - `librarian` (Macro & Official): Whitepapers, SEC filings, official PR.
  - `librarian` (Deep Forums): Uncover scams, hidden fees, Ponzi structures.
  - `oracle`: The ultimate pragmatic tear-down agent to decode the flow of money.

---

### PHASE 1: OMOC Swarm Orchestration & Tracking (The "No Drift" Rule)
- **Mandatory Tracking (`todowrite`)**: You MUST create a strict TODO list logging every OMOC subagent fired, its `subagent_type`, its objective, and expected return time.
- **Parallel Deployment**: Spawn 3-5 OMOC subagents IN PARALLEL using `task(run_in_background=true)`. DO NOT execute them sequentially.

### PHASE 2: Deep-Web Penetration & API Fallback (Absolute Acquisition)
- We do not accept "403 Forbidden" or "No HTML structure".
- **Fallback**: Use `bash/curl/jq` to scrape mirror sites.
- **Biometrics**: Instruct subagents to use `playwright` for headless evasion or `look_at` for OCR extraction if DOM text contradicts visual sanity.

### PHASE 3: Empirical Validation (CRITICAL ULTRAWORK RULE)
- **Code/Tool Validation**: If code or CLI tools are discovered, use `bash` to *empirically validate* them in `/tmp/omo-deep-search-[timestamp]/`. Capture actual stdout/stderr. Do not assume "it works."
- **Mandatory Cleanup**: Execute `rm -rf /tmp/omo-deep-search-[timestamp]/` immediately after validation.

### PHASE 4: The Final Deliverable (Mode-Specific Synthesis)
Output the final report **DIRECTLY IN THE CHAT WINDOW**. Use plain, direct language. Apply the template matching the selected Mode:

#### 🔴 Template A: 情报与吃瓜模式 (News & Drama)
```markdown
# ⚡ Deep-Search: [事件/热点名称] 全景还原报告

## 1. ⏱️ 核心时间线还原 (Timeline)
*(Chronological breakdown of what actually happened, stripped of sensationalism)*

## 2. 🎭 各方回音壁 (Echo Chamber Analysis)
*(What different groups are saying. Compare Official Statements vs Reddit/HN vs Underground Forums)*
- 📣 **官方/主流媒体定调**: ...
- 🕵️ **网民/社区真实情绪**: ...

## 3. 🔪 隐藏的反转与真相 (Hidden Truths & Discrepancies)
*(Point out conflicting evidence, deleted tweets, or PR spin found by fact-checkers)*
```

#### 🔵 Template B: 硬核代码模式 (Code & Tech)
```markdown
# ⚡ Deep-Search: [技术/项目名称] 极客调研报告

## 1. 🏗️ 核心架构与选型定位 (Architecture & Positioning)
*(What it actually does, under the hood. Compare with 2-3 alternatives)*

## 2. 🩸 原生代码与 Issues 展厅 (Raw GitHub Evidence)
*(Unfiltered snippets, real open issues, and actual developer complaints from GitHub/Context7)*
- 🐛 **高频报错/未解 Issue**: ...
- 💡 **核心源码精读**: ...

## 3. 💣 坑点与最佳实践 (Gotchas & Best Practices)
*(Empirically validated truths. What breaks in production?)*
- ⚠️ **千万别踩的坑**: ...
- ✅ **工业级最佳实践**: ...
```

#### ⚫ Template C: 商业与领域深度扒皮模式 (Deep Domain & Product)
```markdown
# ⚡ Deep-Search: [产品/领域名称] 商业扒皮报告

## 1. 🩸 原生证据展厅 (Raw Evidence - NO AI FILTER)
*(Present 5-15 raw, unedited quotes, reviews, or forum posts recovered by OSINT agents)*

## 2. ⚖️ 核心争议盘点 (Core Controversies)
- 📣 **官方怎么吹的**: ...
- 🕵️ **用户在骂什么**: ...

## 3. 🔪 现实扒皮 (The Pragmatic Tear-down)
* 💰 **钱从哪来，谁被坑了**: `[谁在买单] ⭢ [谁抽走钱] ⭢ [谁发财了]`
* 🎭 **表里不一的地方**: `[表面造势] vs [背地干事]`
* 💣 **致命软肋与崩溃条件**: `[触发 X，项目必死]`

## 4. 🚀 搞钱/避坑建议 (Actionable Takeaways)
* 🔴 **大众盲区**: ...
* 🚀 **操作建议**: ...
```
