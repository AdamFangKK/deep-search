# /deep-search Command (V123: The Unified Swarm - Core & Vertical Fusion)

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

### PHASE 0: Intent Classification & The Unified Core
Do not rigidly silo the search. All topics (News, Tech, Business) have underlying biases, money flows, and hidden mechanics. 
Before launching, announce the primary gravity of the search, but deploy a **Unified Swarm**:
> "Deep-Search Router: 识别到主要 [新闻/代码/商业] 意图，加载通用基座并开启对应垂直增强滤镜。"

**Deploy 3-5 OMOC subagents IN PARALLEL (`task(run_in_background=true)`):**
1. **The Global Observer (`librarian`)**: Official docs, macro news, financial indices.
2. **The Underground OSINT (`librarian`)**: Reddit, HackerNews, Forums. Explicitly instructed to find "complaints", "scams", "bugs", and "deleted posts".
3. **The Tech/Empirical Validator (`explore` / `bash`)**: FOR ALL SEARCHES involving tech or code, use local scripts (`/tmp/omo-deep-search/`) or AST-grep to empirically validate the claims.
4. **The Oracle (`oracle`)**: The ultimate pragmatic tear-down agent to decode the flow of money and biases across all modes.

### PHASE 1: OMOC Swarm Orchestration & Tracking (The "No Drift" Rule)
- **Mandatory Tracking (`todowrite`)**: You MUST log every OMOC subagent fired, its objective, and expected return time.
- **Saturation Threshold**: Capture 15-30 raw data points BEFORE synthesizing. Do not converge prematurely.

### PHASE 2: Deep-Web Penetration & Absolute Acquisition
- We do not accept "403 Forbidden" or "No HTML structure".
- **Fallback**: Use `bash/curl/jq` to scrape mirror sites. Use `playwright` for headless evasion or `look_at` for OCR extraction.

### PHASE 3: Empirical Validation (CRITICAL ULTRAWORK RULE)
- **Trust No PR**: If code, APIs, or tools are claimed to work, use `bash` to *empirically test* them in `/tmp/omo-deep-search-[timestamp]/`. Capture actual stdout/stderr.
- Execute `rm -rf /tmp/omo-deep-search-[timestamp]/` immediately after validation.

---

### PHASE 4: The Final Deliverable (The Blended Synthesis)
Output the final report **DIRECTLY IN THE CHAT WINDOW**. Use plain, direct language. The report MUST include the **Universal Core Analysis**, followed by **Dynamic Vertical Modules** based on the findings.

```markdown
# ⚡ Deep-Search: [主题/事件/项目名称] 全景渗透报告

## 1. 🌐 通用基座分析 (The Universal Core)
*(This applies to EVERYTHING: News, Tech, or Business. What is the fundamental reality?)*
- ⏱️ **全景时间线/架构大盘 (Timeline / Architecture Landscape)**: [What actually happened or what it actually is]
- 🎭 **信息茧房与回音壁 (The Echo Chamber)**: 
  - 📣 **官方定调 (PR & Official)**: [What they want you to believe]
  - 🕵️ **民间真相 (Underground OSINT)**: [What Reddit/HN/Developers are actually experiencing]
- 💰 **利益驱动与偏见 (Money Flow & Incentives)**: [谁在出钱？谁在获利？哪怕是开源框架也有其商业目的 (e.g., Vercel pushing Next.js). Explain the hidden motives.]

---

## 2. 🩸 原生证据展厅 (Raw Evidence - NO AI FILTER)
*(Present 5-10 raw, unedited quotes, reviews, forum posts, or code snippets recovered by the OSINT agents. Let the user read the actual words first.)*

---

## 3. 🧩 垂直深度切片 (Dynamic Modules - Include what applies)

*(If the topic involves Code/Tech, include this)*:
### 💣 技术坑点与最佳实践 (Gotchas & Best Practices)
- ⚠️ **千万别踩的坑 (Empirically Validated Gotchas)**: [What breaks in production based on actual GitHub Issues or local testing]
- ✅ **工业级架构选型 (Architecture Positioning)**: [How it compares to alternatives]

*(If the topic involves Business/Products/Drama, include this)*:
### 🔪 现实扒皮与崩溃条件 (The Pragmatic Tear-down)
- ⚖️ **霸王条款与黑盒 (Unfair Rules & Centralization)**: [Hidden fees, fake openness, unfair advantages]
- 💣 **致命软肋 (Fatal Flaws)**: [触发 X 事件，这个项目/产品/公关就会彻底死掉]

---

## 4. 🚀 执行与避坑建议 (Actionable Takeaways)
* 🔴 **大众盲区 (Common Blind Spots)**: [Where the general public is getting fooled right now]
* 🚀 **可操作建议 (Your Action Plan)**: [What the user should do: avoid, short, implement differently, or adopt]
```