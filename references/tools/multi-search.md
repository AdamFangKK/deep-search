# Multi-Search Engine Integration

Integration of 17 search engines for comprehensive web crawling without API keys.

## Overview

**Source**: `@multi-search-engine`  
**Engines**: 17 (8 Domestic CN + 9 International)  
**Config**: Zero-config, no API keys required  
**Primary Use**: Broad topic search, cross-engine validation, filling coverage gaps

---

## Position in Deep-Search Ecosystem

**NOT a replacement** — **A complementary layer**:

```
Deep-Search Data Stack
├── Universal Layer (YOU ARE HERE)
│   └── multi-search-engine — Broad web coverage
│       (news, blogs, official docs, general web)
│
├── Community Layer
│   ├── Reddit → websearch_exa
│   ├── HN → news-aggregator-skill
│   └── Forums → websearch_exa
│
├── Academic Layer
│   └── academic-deep-research
│
├── Code Layer
│   └── github
│
└── Document Layer
    └── pdf-text-extractor
```

**When to use multi-search-engine**:
- ✅ Quick background research
- ✅ Cross-engine validation ("Is this true across sources?")
- ✅ Filling gaps Reddit/HN don't cover
- ✅ Official sources, news, blogs

**When NOT to use** (use specialized tools instead):
- ❌ Deep community discussions → Use websearch_exa (Reddit)
- ❌ Academic papers → Use academic-deep-research
- ❌ GitHub repos → Use github skill
- ❌ PDF documents → Use pdf-text-extractor

**The Rule**: Use the RIGHT tool for each data layer — they work TOGETHER.

---

## Engine Matrix

### Domestic (8) - For CN Content

| Engine | URL Pattern | Best For | Reliability |
|--------|-------------|----------|-------------|
| **Baidu** | `https://www.baidu.com/s?wd={q}` | CN web, Baidu Baike | ⭐⭐⭐⭐ |
| **Bing CN** | `https://cn.bing.com/search?q={q}&ensearch=0` | Balanced CN/INT | ⭐⭐⭐⭐⭐ |
| **Bing INT** | `https://cn.bing.com/search?q={q}&ensearch=1` | International from CN | ⭐⭐⭐⭐⭐ |
| **360** | `https://www.so.com/s?q={q}` | Alternative CN index | ⭐⭐⭐ |
| **Sogou** | `https://sogou.com/web?query={q}` | WeChat content | ⭐⭐⭐⭐ |
| **WeChat** | `https://wx.sogou.com/weixin?type=2&query={q}` | WeChat articles | ⭐⭐⭐⭐ |
| **Toutiao** | `https://so.toutiao.com/search?keyword={q}` | News, Trending | ⭐⭐⭐ |
| **Jisilu** | `https://www.jisilu.cn/explore/?keyword={q}` | Finance, Investment | ⭐⭐⭐ |

### International (9) - For Global Content

| Engine | URL Pattern | Best For | Reliability |
|--------|-------------|----------|-------------|
| **Google** | `https://www.google.com/search?q={q}` | Comprehensive | ⭐⭐⭐⭐⭐ |
| **Google HK** | `https://www.google.com.hk/search?q={q}` | Asia-Pacific | ⭐⭐⭐⭐⭐ |
| **DuckDuckGo** | `https://duckduckgo.com/html/?q={q}` | Privacy, No tracking | ⭐⭐⭐⭐ |
| **Yahoo** | `https://search.yahoo.com/search?p={q}` | News, Finance | ⭐⭐⭐ |
| **Startpage** | `https://www.startpage.com/sp/search?query={q}` | Google results + privacy | ⭐⭐⭐⭐ |
| **Brave** | `https://search.brave.com/search?q={q}` | Independent index | ⭐⭐⭐⭐ |
| **Ecosia** | `https://www.ecosia.org/search?q={q}` | Eco-friendly | ⭐⭐⭐ |
| **Qwant** | `https://www.qwant.com/?q={q}` | EU GDPR compliant | ⭐⭐⭐⭐ |
| **WolframAlpha** | `https://www.wolframalpha.com/input?i={q}` | Knowledge, Math | ⭐⭐⭐⭐⭐ |

---

## Search Operators

### Standard Operators (Work on Most Engines)

| Operator | Example | Description |
|----------|---------|-------------|
| `site:` | `site:github.com python` | Search within specific site |
| `filetype:` | `filetype:pdf annual report` | Specific file type |
| `""` | `"machine learning"` | Exact phrase match |
| `-` | `python -snake` | Exclude term |
| `OR` | `cat OR dog` | Either term |
| `*` | `best * tool` | Wildcard |
| `..` | `price 100..500` | Number range |

### Time Filters (Google/Bing)

| Parameter | URL Append | Description |
|-----------|------------|-------------|
| Past hour | `&tbs=qdr:h` | Last 60 minutes |
| Past day | `&tbs=qdr:d` | Last 24 hours |
| Past week | `&tbs=qdr:w` | Last 7 days |
| Past month | `&tbs=qdr:m` | Last 30 days |
| Past year | `&tbs=qdr:y` | Last 365 days |

---

## Usage Patterns

### Pattern 1: Single Engine Quick Search

```javascript
// Google search
webfetch({"url": "https://www.google.com/search?q=react+tutorial"})

// Baidu search (for CN content)
webfetch({"url": "https://www.baidu.com/s?wd=React教程"})

// DuckDuckGo (privacy)
webfetch({"url": "https://duckduckgo.com/html/?q=privacy+tools"})
```

### Pattern 2: Multi-Engine Validation

For critical information, search 3+ engines and compare:

```javascript
// Query: "Company X scam allegations"
const queries = [
  "https://www.google.com/search?q=Company+X+scam",
  "https://duckduckgo.com/html/?q=Company+X+scam",
  "https://www.baidu.com/s?wd=Company+X+诈骗"
];
// Aggregate results, note differences
```

### Pattern 3: Site-Specific Deep Dive

```javascript
// Search only GitHub for code examples
webfetch({"url": "https://www.google.com/search?q=site:github.com+useState+typescript"})

// Search Reddit for discussions
webfetch({"url": "https://www.google.com/search?q=site:reddit.com+best+laptop+2024"})
```

### Pattern 4: Document Search

```javascript
// Find PDFs
webfetch({"url": "https://www.google.com/search?q=machine+learning+filetype:pdf"})

// Find specific file types
webfetch({"url": "https://www.google.com/search?q=annual+report+filetype:xlsx"})
```

### Pattern 5: Knowledge Queries (WolframAlpha)

```javascript
// Currency conversion
webfetch({"url": "https://www.wolframalpha.com/input?i=100+USD+to+CNY"})

// Math
webfetch({"url": "https://www.wolframalpha.com/input?i=integrate+x^2+dx"})

// Stock
webfetch({"url": "https://www.wolframalpha.com/input?i=AAPL+stock"})
```

---

## DuckDuckGo Bangs (Shortcuts)

| Bang | Destination | Example URL |
|------|-------------|-------------|
| `!g` | Google | `https://duckduckgo.com/html/?q=!g+python` |
| `!gh` | GitHub | `https://duckduckgo.com/html/?q=!gh+tensorflow` |
| `!so` | Stack Overflow | `https://duckduckgo.com/html/?q=!so+react+hooks` |
| `!w` | Wikipedia | `https://duckduckgo.com/html/?q=!w+machine+learning` |
| `!yt` | YouTube | `https://duckduckgo.com/html/?q=!yt+tutorial` |
| `!a` | Amazon | `https://duckduckgo.com/html/?q=!a+laptop` |
| `!maps` | Google Maps | `https://duckduckgo.com/html/?q=!maps+Beijing` |

---

## Anti-Crawling & Rate Limiting

### Best Practices

1. **Sequential Requests**: Don't hit same engine in parallel
2. **Delay Between Requests**: Add 1-2 second delay between same-engine calls
3. **Rotate User-Agents**: Vary the browser fingerprint
4. **Failover**: If one engine blocks, automatically try another

### Rate Limit Behavior

| Engine | Limit | Penalty |
|--------|-------|---------|
| Google | ~100 req/5min | IP temp ban (1-24h) |
| Bing | ~150 req/5min | CAPTCHA challenge |
| Baidu | ~200 req/5min | Verification code |
| DuckDuckGo | ~300 req/5min | Silent blocking |

### Fallback Strategy

```javascript
// If Google fails → Try Bing → Try DuckDuckGo → Try Startpage
const fallbackChain = [
  "https://www.google.com/search?q={q}",
  "https://cn.bing.com/search?q={q}&ensearch=1",
  "https://duckduckgo.com/html/?q={q}",
  "https://www.startpage.com/sp/search?query={q}"
];
```

---

## Search Swarm Agent Integration

The Search Swarm Agent (`@references/vertical-enhancers/search-swarm.md`) automates:

1. **Parallel Dispatch**: Launch 5-10 engines simultaneously
2. **Result Deduplication**: Merge overlapping results
3. **Quality Scoring**: Rank by source authority
4. **Auto-Failover**: Blocked engine → automatic retry with next

### Manual Swarm (Without Agent)

```javascript
// Launch parallel searches (different engines)
const swarm = [
  webfetch({"url": "https://www.google.com/search?q=topic"}),
  webfetch({"url": "https://duckduckgo.com/html/?q=topic"}),
  webfetch({"url": "https://www.baidu.com/s?wd=topic"})
];
// Aggregate and deduplicate
```

---

## Troubleshooting

### "Empty Results"
- Check URL encoding (spaces → `+` or `%20`)
- Try different engine (Google might block, Bing might work)
- Add delay between requests

### "CAPTCHA Detected"
- Switch to different engine
- Wait 5+ minutes before retry
- Use privacy engines (DuckDuckGo, Startpage)

### "Different Results on Different Engines"
- This is expected and useful for validation
- Note the divergence in your report
- Use as evidence of information fragmentation

---

## References

- **Multi-Search Skill**: `@multi-search-engine`
- **Search Swarm Agent**: `@references/vertical-enhancers/search-swarm.md`
- **Advanced Domestic Search**: `@multi-search-engine/references/advanced-search.md`
- **International Guide**: `@multi-search-engine/references/international-search.md`

---

## Version

- v1.0.0 - Initial integration with 17 engines
- v1.1.0 - Added anti-crawling strategies
