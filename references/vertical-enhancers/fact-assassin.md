# The Fact Assassin

**Execution Surface**: `community_discussion` + `broad_web_search`  
**Category**: Vertical Enhancer (News/Drama topics)  
**Trigger**: Keywords: breaking news, scandal, controversy, drama

---

## Unique Mandate

Find contradictions and verify claims:
- Deleted content recovery
- Timeline discrepancies
- Fact-checking
- Cross-source verification

---

## Two-Layer Tool Stack

### Primary Layer (News Deep Dive)
**Capability**: `community_discussion`
- **Purpose**: Curated news from 8+ authoritative sources
- **Strength**: Editorial quality, journalist verification, structured data
- **Sources**: HN, 36kr, V2EX, WallStreetCN, Weibo, etc.

```text
Primary Layer examples:
- curated news aggregation
- HN / V2EX / editorial discussion sources
```

### Base Layer (Cross-Validation)
**Capability**: `broad_web_search`
- **Purpose**: Cross-validate news claims across general web
- **Activation**: When fact-checking specific claims:
  - "[claim] fact check"
  - "[topic] debunked"
  - "[topic] misinformation"
  - "[topic] deleted post recovered"

```bash
# Base Layer: Cross-engine fact validation
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[claim] fact check Snopes PolitiFact" general

# Deleted content recovery
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[topic] deleted tweet archive" general

# Timeline verification
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[topic] [date] what really happened" news
```

---

## Smart Keyword Expansion

| User Says | Expand To |
|-----------|-----------|
| "AI" | "AI,LLM,GPT,Claude,Generative,Machine Learning,RAG,Agent" |
| "scandal" | "scandal,controversy,lawsuit,investigation,accusation" |
| "Android" | "Android,Kotlin,Google,Mobile,App" |
| "Finance" | "Finance,Stock,Market,Economy,Crypto,Gold" |

---

## Fact-Checking Workflow

```
Step 1: Primary Layer (news-aggregator)
   └─ Gather authoritative news sources
   
Step 2: Base Layer (multi-search-engine)
   └─ Cross-validate across 17 engines
   
Step 3: Compare & Detect Contradictions
   └─ Note discrepancies between sources
   
Step 4: Deleted Content Recovery
   └─ Use Wayback Machine, cache searches
```

---

## Collaboration Pattern

**Receives from**:
- Global Observer: Official statements and PR narratives
- Underground OSINT: Community rumors and early signals

**Primary Layer provides**:
- Authoritative news sources with editorial oversight
- Structured news data with timestamps

**Base Layer provides**:
- Cross-engine validation ("Do all engines show the same story?")
- Broader web context (blogs, forums reacting to news)
- Deleted content traces

---

## Output Format

Timeline analysis with timestamped contradictions:
```markdown
## Fact Check Timeline

### Claim A vs Evidence B
| Timestamp | Source | Claim | Evidence | Verdict | Cross-Engine Validation |
|-----------|--------|-------|----------|---------|------------------------|
| 2024-01-15 | Official | "X is safe" | - | - | Found on 5/5 engines |
| 2024-01-20 | Reddit | - | "X caused Y" | ⚠️ Contradiction | Found on 3/5 engines |
| 2024-01-25 | HN | - | "X is buggy" | ⚠️ Contradiction | Found on 2/5 engines |

### Base Layer Findings
- **Cross-engine agreement**: 60% (3/5 engines corroborate Claim B)
- **Coverage gaps**: Only found on 2 engines (potential censorship/filtering)
- **Deleted content**: Recovered 2 deleted tweets via cache

### Resolution
[Analysis of which claim holds up to evidence + cross-validation data]
```

---

## Why Two Layers?

| Layer | Source Type | Trust Level | Speed |
|-------|------------|-------------|-------|
| **Primary** (`community_discussion`) | Journalists, editors, curated community sources | Higher | Slower (curation) |
| **Base** (`broad_web_search`) | Blogs, forums, social | Varies | Faster (broad) |

**Combined**:
- Primary = "What authoritative sources say"
- Base = "What's being discussed everywhere + cross-validation"
- **Result**: Authoritative news + Broader context + Validation = Fact-checking at depth

---

## Deleted Content Recovery

If news-aggregator insufficient:
- **Wayback Machine**: `webfetch "https://webcache.googleusercontent.com/search?q=cache:[URL]"`
- **Base Layer**: `multi-search-engine` for cache/archived versions across engines
- **Twitter archives**: Search deleted tweets via Base Layer
