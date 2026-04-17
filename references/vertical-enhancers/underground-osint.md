# The Underground OSINT

**Execution Surface**: `community_discussion` capability  
**Category**: Universal Base Agent (Always Run)  
**Trigger**: ALL searches

---

## Unique Mandate

Find "raw truth" from community sources:
- Reddit complaints, scams, bugs
- HackerNews discussions
- Forum posts and deleted content
- User regrets and negative experiences
- **Broad web context for community trends**

---

## Two-Layer Tool Stack

### Primary Layer (Community Deep Dive)
**Capability**:
- `community_discussion` — Reddit/HN/V2EX and adjacent community surfaces via the planner-selected provider

**Why it matters**: This lane captures grassroots signal that broad web search will under-sample.

```text
Primary Layer examples:
- Reddit complaint threads
- Hacker News discussions
- V2EX / forum reactions
- other community surfaces exposed by the active provider
```

### Base Layer (Context Expansion)
**Capability**: `broad_web_search`
- **Purpose**: Find community discussions beyond Reddit/HN (forums, blogs, Twitter)
- **Activation**: When:
  - Reddit/HN coverage is insufficient
  - Need broader "grassroots" validation
  - Searching for deleted content traces
  - Finding alternative community perspectives

```bash
# Base Layer: Expand community search
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[topic] forum discussion user experience" general

bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[topic] twitter thread complaints" general

bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[topic] deleted post recovered" general
```

---

## Search Pattern Library

| Platform | Complaints | Praise | Technical Discussion |
|----------|-----------|--------|---------------------|
| Reddit (Primary) | `"[topic] problems issues"` | `"[topic] recommend"` | `"[topic] vs alternative"` |
| HN (Primary) | `"[topic] criticism"` | `"[topic] show hn"` | `"[topic] ask hn"` |
| V2EX (Primary) | `"[topic] 吐槽"` | `"[topic] 推荐"` | `"[topic] 讨论"` |
| Forums (Base) | `"[topic] forum complaints"` | `"[topic] review forum"` | `"[topic] technical forum"` |

---

## Collaboration with Global Observer

**Complementary Design**:

| Agent | Data Layer | Primary Sources | Question Answered |
|-------|-----------|-----------------|-------------------|
| **Global Observer** | Institutional | `broad_web_search` | "What do they OFFICIALLY say?" |
| **Underground OSINT** | Grassroots | `community_discussion` + `broad_web_search` backup | "What do USERS actually experience?" |

**Workflow**:
1. Global Observer researches official sources → Identifies gaps
2. Underground OSINT fills gaps with community voices (Primary Layer)
3. Base Layer expands beyond Reddit/HN if needed
4. **Both required** — institutional + grassroots = complete picture

---

## Output Format

Raw quotes with structured context:
```markdown
## Community Intelligence (Primary Layer)

### Reddit Insights (r/[subreddit])
- [Quote ≥100 chars with URL]
  **Sentiment**: [Complaint/Praise/Neutral]
  **Votes**: [N] | **Comments**: [N]

### HackerNews Insights
- [Quote ≥100 chars with URL]
  **Score**: [N] | **Comments**: [N]

## Extended Community (Base Layer)
| Source | Platform | Key Insight | Cross-Engine Found? |
|--------|----------|-------------|---------------------|
| [URL] | [Forum/Twitter/Blog] | [Summary] | Y/N on X/17 engines |

## Community Consensus
- **Primary sentiment**: [Positive/Negative/Mixed]
- **Common complaints**: [List from Primary]
- **Extended concerns**: [From Base Layer]
- **Coverage gaps**: [What communities are silent?]
```

---

## Anti-Gaming Rule

If "no negative info found", MUST document:
- Platforms searched (Primary: Reddit, HN, V2EX; Base: 17 engines)
- Keywords used
- Search duration
- **Hypothesis**: Why might this be? (e.g., "new product", "niche topic", "heavy moderation")

---

## Backup Sources (Base Layer)

If curated community coverage is insufficient:
- broaden with `broad_web_search`
- **GitHub Issues** → Technical Recon overlap
- **Stack Overflow** → Technical Recon overlap
- **Lobste.rs, IndieHackers** → Base Layer forum search
- **Product Hunt comments** → Base Layer product search

---

## Why Two Layers?

| Layer | Coverage | Strength | Limitation |
|-------|----------|----------|------------|
| **Primary** (Reddit/HN/V2EX) | Curated communities | High signal-to-noise, authentic voices | Limited to these platforms |
| **Base** (multi-search-engine) | Entire web | Fill gaps, find deleted content, broader perspective | Lower signal-to-noise |

**Combined**: Curated community insights + Broad web validation = No grassroots voice missed

---

## Example Workflow

**Query**: "Is Product X reliable?"

1. **Primary Layer** (Reddit/HN):
   - r/ProductX: "Great features but crashes daily" (47 upvotes)
   - HN: "Show HN: Product X — we built this" (author)

2. **Base Layer** (multi-search-engine):
   - Forum: "Product X reliability issues after 6 months"
   - Blog: "Product X review: good but buggy"
   - Twitter: "Anyone else having issues with Product X?"

3. **Synthesis**: Consistent reliability concerns across Primary + Base
