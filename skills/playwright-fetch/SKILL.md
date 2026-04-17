---
name: playwright-fetch
description: Concurrent, multi-agent-safe Playwright scraper for JS-heavy / anti-scraping sites. Provides per-domain throttling, isolated per-id JSON writes, and an optional stealth mode for heavily walled targets (36kr articles, AppStore, a16z, Cloudflare-protected sites).
---

# Playwright Fetch (v1.0)

A **batch concurrent** web scraper using Playwright Chromium, designed for **deep-research workflows** where:

- Targets are a JSON list of `{ id, url }` (optionally `waitFor`, `mobile`, `cookies`)
- Pages are JS-heavy and `curl`/`fetch` returns empty shells
- Multiple agents may scrape concurrently — each writes to its own `<id>.json`, so **no file collisions**
- Per-domain throttling prevents rate-limiting (default 2.5s)
- Summary JSON aggregates OK / failed / byte counts

## When to use

| Scenario | Use this skill | Use `search-cluster` instead |
|---|---|---|
| Target list is known (URLs) | ✅ | ❌ |
| Need to search the web by keyword | ❌ | ✅ |
| Target is SPA (React/Vue) | ✅ | ❌ (curl returns shell) |
| Target is Cloudflare / WAF | ✅ (with stealth) | ❌ |
| Need Wikipedia/Reddit/GNews | ❌ | ✅ |

## Installation

```bash
cd <workspace>
npm install --no-save playwright@^1.59.1
npx playwright install chromium
```

`playwright-fetch.mjs` has zero non-playwright dependencies.

## Usage

### 1. Prepare target list

```json
[
  { "id": "example-home", "url": "https://example.com/" },
  { "id": "spa-article", "url": "https://news.example.com/story/123", "waitFor": "article h1" },
  { "id": "mobile-mp",  "url": "https://mp.weixin.qq.com/s/XXX", "mobile": true }
]
```

### 2. Run

```bash
node skills/playwright-fetch/playwright-fetch.mjs \
  --targets targets.json \
  --out raw/ \
  --concurrency 4 \
  --throttle 2500 \
  --timeout 25000
```

### 3. Outputs

- `raw/<id>.json` — one file per target, shape:
  ```json
  {
    "id": "example-home",
    "url": "https://example.com/",
    "status": 200,
    "ok": true,
    "bytes": 1234,
    "elapsed_ms": 1820,
    "fetched_at": "2026-04-17T10:15:22.113Z",
    "title": "…",
    "content": "…(visible text, truncated to 60KB)…",
    "error": null
  }
  ```
- `raw/_summary.json` — `{ ok_count, fail_count, total_bytes, by_domain }`

## Concurrency & multi-agent safety

- Single browser, N contexts — each worker has its own context (isolated cookies/storage)
- `domainLastHit` Map tracks last request time per host → worker sleeps if needed
- File writes are **per-id**, so two agents scraping disjoint id sets cannot conflict
- If two agents scrape overlapping ids, last-write-wins (use distinct prefixes to avoid)

## Stealth mode (for heavily walled sites)

Enable via `--stealth` flag:

```bash
node playwright-fetch.mjs --targets targets.json --out raw/ --stealth
```

Stealth mode applies:
- `playwright-extra` + `puppeteer-extra-plugin-stealth` patches (navigator.webdriver, plugins, chrome.runtime)
- Random mouse movement before extraction
- Desktop Chrome UA + Accept-Language zh-CN

**Install stealth deps**:

```bash
npm install --no-save playwright-extra puppeteer-extra-plugin-stealth
```

## Known limitations & workarounds

| Site | Status | Workaround |
|---|---|---|
| `36kr.com` article page | 🟥 0B even with stealth | Need logged-in session cookies; use `cookies: [{...}]` in target |
| `mp.weixin.qq.com/s/*` | 🟥 4B | Requires mobile UA + valid signature URL; best captured via WeChat client + Charles |
| `apps.apple.com` | 🟧 316B shell | Add `"waitFor": "section.product-header"` to target |
| `crunchbase.com` | 🟥 Cloudflare | No good Playwright workaround; use paid API or scrapling |
| `a16z.com` | 🟧 partial | UA=`Mozilla/5.0 (compatible; Googlebot/2.1)` sometimes bypasses |

See [SESSION_ASK_PROTOCOL.md](./SESSION_ASK_PROTOCOL.md) for how subagents should request session cookies from the user.

## Roadmap

- [ ] Integrate `scrapling` for Cloudflare/WAF bypass as a fallback tier
- [ ] Cookie-jar persistence across runs (session reuse)
- [ ] WebSocket / XHR response capture (for APIs behind SPAs)
- [ ] Integrated markdown extraction (via readability)
