# /deep-search Command (V111: The Unfiltered Leviathan - Perfect Synthesis)

This command triggers "Max-Search Mode" (Saturation Search Protocol) for exhaustive, zero-blind-spot research and information gathering. It is governed by strict Ultrawork protocols requiring absolute certainty, manual QA, empirical validation, and active anti-hallucination checks.

## 🔋 Batteries-Included Installation
Before using this skill on a new machine, run the built-in setup script to automatically install all required system, Python, and Node dependencies:
```bash
bash ~/.agents/skills/deep-search/setup.sh
```
*(This installs: `pandas`, `yt-dlp`, `playwright`, `tmux`, `sqlite3`, `jq`, and configures the `/tmp/omo-deep-search/` sandbox.)*

## When to Use
Use when the user explicitly requests `/deep-search`, uses `[search-mode] MAXIMIZE SEARCH EFFORT`, or requires deep, multi-faceted research on a complex topic (whether it's code, politics, business, or pop culture).

---

## THE IRONCLAD EXECUTION PROTOCOL (MANDATORY)

When triggered, you MUST execute Phase 1 and 2 in PARALLEL in your very first response. You must NOT wait for intermediate results. 

### PHASE 1: Planning, Orchestration, & Tracking (The "No Drift" Rule)
- **Mandatory Planning**: Before launching massive searches, spawn a `plan` or `gsd-planner` agent to map out the search vectors and assign MECE (Mutually Exclusive, Collectively Exhaustive) boundaries to background agents to avoid duplicate work and context collapse.
- **Mandatory Tracking (`todowrite`)**: You MUST create a strict TODO list logging every background agent fired, its objective, and its expected return time.
- **Ontology Mapping**: Use the `ontology` skill to build a dynamic JSONL knowledge graph linking discovered entities.

### PHASE 2: Absolute Breadth Baseline & Leviathan Swarm (The Horizon Engine)
**CRITICAL MANDATE: DO NOT PREMATURELY CONVERGE.** You must map the entire landscape before drilling down.
- **Saturation Threshold**: You MUST capture and categorize at least 15-30 raw data points/projects/sources across multiple dimensions before selecting targets for deep analysis.
- Stop relying solely on shallow APIs. Spawn 3-5 background agents (`run_in_background=true`) to act as a highly parallelized "Leviathan Swarm". Each head must drill down into specific vectors:
  - **Head 1 (Official & Macro)**: Target official docs, whitepapers, and financial indices.
  - **Head 2 (Adversarial & OSINT)**: Use `reddit-readonly` and `hacker-news` MCPs to find "X scam", "X fatal flaws", and "X alternatives". Seek raw, unfiltered critique.
  - **Head 3 (Underground & Codebase)**: Search `grep_app_searchGitHub` globally, or `ast_grep_search` and `lsp_symbols` locally for actual implementation truths.
  - **Head 4 (Recursive Driller & Entropy Evaluation)**: Scan the outputs of the others for high-value links. Evaluate "Information Entropy" before following a link. If the path shows low-entropy fractal repetition, trigger absolute self-destruct for that thread.

### PHASE 3: Deep-Web Penetration & API Fallback (Absolute Acquisition)
We do not accept "403 Forbidden", "429 Too Many Requests", behavioral WAFs, or "No HTML structure".
- **API Meltdown Fallback**: If official APIs (Exa/HN/GitHub) hit rate limits, you MUST automatically fallback to `bash/curl/jq` scraping third-party mirror sites, Web Archives, or alternative search operators. **Failure to reach the 15-30 Breadth Baseline due to API limits is unacceptable.**
- **Dark Data Extraction**: Do not just parse HTML. Use `bash` and `curl`/`jq` to intercept XHR/Fetch requests. Extract raw `.json`, `.sqlite`, or GraphQL endpoints directly.
- **Biometric Mimicry & Anti-Block Breaker**: If blocked by advanced behavior-based WAFs (like Cloudflare/Datadome), switch to the `playwright` skill or stealth headless scripts. Inject OS-level hardware interrupt simulations and enforce cognitive fatigue curves (delay/overshoot) on mouse/scroll events.
- **Visual Truth Extraction**: If DOM text contradicts logical sanity, abandon `innerHTML`. Render off-screen and use OCR/Vision from the pixel layer. Normalize all homoglyphs to sanitize hidden watermarks.

### PHASE 4: Empirical Validation & The Execution Gap (CRITICAL ULTRAWORK RULE)
We do not trust; we verify.
- **Code/Tool Validation**: If an algorithm, script, or CLI tool is discovered, you MUST use `bash` to write a quick Python/Shell script to *empirically validate* it. Capture the actual stdout/stderr. Do not just say "it should work."
- **Ephemeral Sandboxing**: ALL cloning, downloading, and testing MUST occur in `/tmp/omo-deep-search-[timestamp]/`. If Docker is available locally, run untrusted GitHub code inside a container.
- **Mandatory Cleanup**: You MUST execute `rm -rf /tmp/omo-deep-search-[timestamp]/` immediately after results are captured.
- **Time-Bounding**: Imposed a strict timeout (e.g., 60 seconds) on bash validations. Max 2 tries.

### PHASE 5: Perfect Synthesis (Oracle/Momus Gatekeeper)
- **Zero-Distortion Mandate**: The Oracle MUST explicitly present the raw context (extreme emotion, exact code) BEFORE summarizing.
- **The "Apex Predator" Lens**: AFTER presenting the raw data, the Oracle must analyze it through a ruthless filter designed for human decision-making: Extract "Capital Flow", expose "Consensus Forgery", identify "Asymmetric Table Rules", and pinpoint the "Structural SPOF".

### PHASE 6: Final Deliverable (The Perfect Synthesis Report)
- Output the final report **DIRECTLY IN THE CHAT WINDOW**. DO NOT generate local files unless explicitly asked.
- Structure the response strictly as follows to ensure breadth, raw fidelity, AND high-level synthesis:

```markdown
# ⚡ Deep-Search V111: [Topic/Event/Project Name] 全景生态与无损剖析

## 1. 🌐 全景生态映射 (Panoramic Ecological Landscape)
*(Present the massive breadth of your search. Categorize the 15-30 items/events/sources found into 3-5 distinct sectors.)*
- **维度 1 (Dimension A)**: [Item 1], [Item 2], [Item 3]...

## 2. 🩸 原生切片展厅 (Raw Feedback Showcase - ZERO DISTORTION)
*(CRITICAL: Present 5-15 raw, unedited, and unfiltered quotes, reviews, forum posts, or code snippets across the targets. Let the user see the exact words, rage, or technical implementation BEFORE your analysis.)*
- **[Source/Reviewer Type A]**: *"Exact raw quote or code block..."*
- **[Source/Reviewer Type B]**: *"Exact raw quote or code block..."*

## 3. ⚖️ 高浓缩概括与多维对垒 (High-Level Synthesis & Matrix)
*(Based strictly on the raw evidence above, synthesize the core conflict for 3-5 targets.)*
### 🎯 靶点一: [Target 1]
- 📣 **官方/营销视角 (Official Claim)**: [What the PR or general consensus claims]
- 🕵️ **底层真实反馈 (Synthesized Truth)**: [AI's sharp summary of the actual issues, bugs, or complaints based on the raw slices]

## 4. 🔪 现实解剖与利益剥离 (Carbon-Decision Dissection)
*(Apply the 4 pragmatic analysis modules)*
* 🩸 **资金血脉与暗箱抽水 (Capital Bloodlines)**: `[输入源(真正买单方)] ⭢ (抽水节点) ⭢ [输出源(获利方)]`
* 🪞 **共识伪造与情绪收割 (Emotional Harvesting)**: `[舆论造势] vs [内部筹码异动]`
* ⚖️ **非对称博弈与真实桌规 (Asymmetric Gaming)**: `[明面规则] vs [暗箱特权/霸王条款]`
* 💣 **结构性死穴与崩溃触发器 (Structural SPOF)**: `[死穴定位] -> [崩溃条件] -> [连环爆雷路径]`

## 5. 🚀 动态推演与执行红利 (Evolution & Actionable Dividends)
* 🔴 **认知盲区预警 (Blind Spots)**: [Where 90% of people are being fooled]
* 🚀 **执行红利 (Actionable Strategy)**: [Asymmetric leverage points for the user]
```