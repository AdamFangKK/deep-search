# Search Swarm Agent

**Type**: Universal Base Agent  
**Core Tool**: multi-search-engine (17 search engines)  
**Trigger**: General/broad queries requiring maximum coverage

---

## Purpose

The Search Swarm Agent orchestrates parallel searches across 17 engines to achieve:
- **Maximum data coverage** - No single engine has complete index
- **Cross-validation** - Compare results across engines for accuracy
- **Anti-censorship** - If one engine blocks/filters, others provide backup
- **Source diversity** - Different engines prioritize different content types

---

## Architecture

```
Search Swarm Agent
    ├─ Engine Selector (picks 5-7 engines based on query type)
    ├─ Parallel Dispatch (task run_in_background=true)
    ├─ Result Collector (aggregates with deduplication)
    ├─ Quality Scorer (ranks by authority/recency)
    └─ Fallback Manager (retries with alternate engines)
```

---

## Engine Selection Strategy

### For General/Broad Queries (Default)

Launch 5 engines in parallel:
1. **Google** - Comprehensive index
2. **Bing INT** - Alternative perspective
3. **DuckDuckGo** - Privacy-focused, different ranking
4. **Startpage** - Google results + privacy
5. **Brave** - Independent index

### For CN-Related Queries

Add domestic engines:
1. **Baidu** - CN web coverage
2. **Sogou** - WeChat content
3. **360** - Alternative CN perspective

### For News/Breaking Topics

Prioritize fresh content:
1. **Google** (with `&tbs=qdr:d` time filter)
2. **Bing** (with recent filter)
3. **DuckDuckGo** (news section)
4. **Yahoo News**

### For Technical/Code Queries

Focus on technical sources:
1. **Google** - `site:github.com` + `site:stackoverflow.com`
2. **DuckDuckGo** - `!so` (Stack Overflow bang)
3. **Bing** - Developer results

---

## Execution Protocol

### Phase 1: Query Analysis

Determine engine selection strategy:

```javascript
// Analyze query characteristics
const queryFeatures = {
  hasChinese: /[\u4e00-\u9fa5]/.test(query),
  isTechnical: /\b(code|api|github|programming|bug|error)\b/i.test(query),
  isNews: /\b(news|breaking|latest|today|2024|2025)\b/i.test(query),
  isAcademic: /\b(paper|research|arxiv|study|journal)\b/i.test(query)
};
```

### Phase 2: Engine Dispatch

Spawn parallel searches (`task run_in_background=true`):

```javascript
// Example: General query dispatch
const searchTasks = [
  task({ engine: 'google', url: `https://www.google.com/search?q=${q}` }),
  task({ engine: 'bing_int', url: `https://cn.bing.com/search?q=${q}&ensearch=1` }),
  task({ engine: 'ddg', url: `https://duckduckgo.com/html/?q=${q}` }),
  task({ engine: 'startpage', url: `https://www.startpage.com/sp/search?query=${q}` }),
  task({ engine: 'brave', url: `https://search.brave.com/search?q=${q}` })
];
```

### Phase 3: Result Collection

Each task returns:
```json
{
  "engine": "google",
  "status": "success|blocked|timeout",
  "results": [
    {
      "title": "...",
      "url": "...",
      "snippet": "...",
      "timestamp": "..."
    }
  ],
  "count": 10
}
```

### Phase 4: Deduplication

Remove duplicate URLs across engines:

```javascript
// URL normalization for dedup
function normalizeUrl(url) {
  return url
    .replace(/^https?:\/\//, '')
    .replace(/\/$/, '')
    .replace(/\?utm_.*/, '')
    .toLowerCase();
}

// Keep best result for each URL
const uniqueResults = new Map();
results.forEach(r => {
  const key = normalizeUrl(r.url);
  if (!uniqueResults.has(key) || r.score > uniqueResults.get(key).score) {
    uniqueResults.set(key, r);
  }
});
```

### Phase 5: Quality Scoring

Score each result:

| Factor | Weight | Criteria |
|--------|--------|----------|
| Engine Authority | 0.3 | Google=1.0, Bing=0.9, DDG=0.8, etc. |
| Content Depth | 0.3 | Snippet length > 200 chars |
| Recency | 0.2 | Published within last year |
| Source Diversity | 0.2 | Prefer less-represented domains |

### Phase 6: Fallback Management

If engine fails (blocked/timeout):

```javascript
const fallbackChain = {
  'google': ['bing_int', 'startpage', 'brave'],
  'baidu': ['bing_cn', 'sogou', '360'],
  'duckduckgo': ['startpage', 'brave', 'qwant']
};

// Auto-retry with fallback
if (result.status !== 'success') {
  const fallback = fallbackChain[result.engine]?.[0];
  if (fallback) {
    retryWith(fallback);
  }
}
```

---

## Smart Rate Limiting

### Per-Engine Limits

| Engine | Max Concurrent | Delay Between | Daily Cap |
|--------|---------------|---------------|-----------|
| Google | 2 | 3s | 100 |
| Bing | 3 | 2s | 150 |
| Baidu | 3 | 2s | 200 |
| DuckDuckGo | 5 | 1s | 300 |
| Others | 5 | 1s | 500 |

### Adaptive Throttling

If rate limit detected:
1. Pause engine for 60 seconds
2. Activate fallback engine
3. Log incident for future avoidance

---

## Output Format

```json
{
  "query": "original search query",
  "engines_used": ["google", "bing_int", "ddg", "startpage", "brave"],
  "engines_succeeded": 4,
  "engines_failed": 1,
  "total_raw_results": 47,
  "unique_results": 32,
  "results": [
    {
      "rank": 1,
      "title": "...",
      "url": "...",
      "snippet": "...",
      "engines_found": ["google", "bing"],
      "authority_score": 0.95,
      "estimated_date": "2024-03"
    }
  ],
  "cross_engine_analysis": {
    "agreement_rate": 0.4,
    "top_domains": ["github.com", "stackoverflow.com"],
    "coverage_gaps": ["reddit discussions"]
  }
}
```

---

## Integration with Deep-Search

### When Activated

The Orchestrator activates Search Swarm when:
- Intent Matrix matches "general search, broad query, multi-angle"
- User explicitly requests `[search-mode] MAXIMIZE SEARCH EFFORT`
- Other agents request additional data sources

### Data Flow

```
Orchestrator
    → Dispatches Search Swarm (task background=true)
    ← Receives aggregated results (15-30 data points)
    → Forwards to Vertical Enhancers for deep analysis
```

---

## Anti-Gaming Rules

**Strictly Enforced**:
- ❌ Never use fewer than 3 engines (insufficient coverage)
- ❌ Never skip deduplication (inflates data point count)
- ❌ Never ignore blocked engines (document failures)
- ❌ Never use only one engine's results (echo chamber risk)

**Required**:
- ✅ Document which engines were used
- ✅ Report engine failure rates
- ✅ Note coverage gaps (what engines missed)
- ✅ Include cross-engine agreement metrics

---

## Example Queries & Engine Selection

| Query | Engines Launched | Rationale |
|-------|-----------------|-----------|
| "React best practices 2024" | Google, Bing, DDG, Startpage, Brave | General tech, max coverage |
| "特斯拉裁员最新消息" | Baidu, Sogou, Bing CN, Google | CN news + international |
| "site:github.com rust async" | Google, Bing INT, DDG | Code search, technical |
| "Bitcoin price crash today" | Google, Bing, DDG, Yahoo | News/breaking, time-sensitive |
| "Climate change research paper" | Google, Bing INT, DDG | Academic, comprehensive |

---

## References

- **Multi-Search Tool Guide**: @references/tools/multi-search.md
- **Multi-Search Engine Skill**: @multi-search-engine
- **Orchestrator Protocol**: @SKILL.md (Phase 0)

---

## Version

- v1.0.0 - 17-engine parallel search with deduplication
- v1.1.0 - Smart rate limiting and adaptive throttling
