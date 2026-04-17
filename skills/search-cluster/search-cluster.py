#!/usr/bin/env python3
import sys
import os
import json
import hashlib
import urllib.request
import urllib.parse
import ssl
import argparse
import concurrent.futures
import subprocess
import xml.etree.ElementTree as ET
import re

# Configuration (v3.5.1)
GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")
GOOGLE_CSE_ID = os.getenv("GOOGLE_CSE_ID")
REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
SCRAPLING_PYTHON = os.getenv("SCRAPLING_PYTHON_PATH", "python3")
# Corrected: Script is now in the same directory as this file
STEALTH_SCRIPT = os.path.join(os.path.dirname(__file__), "stealth_fetch.py")
# A browser-like UA is required by Google/Reddit/DDG to return real content.
# The previous default ("SearchCluster/3.5.1") was blocked by most providers.
USER_AGENT = os.getenv(
    "SEARCH_USER_AGENT",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36",
)
# Debug flag: when set, emit per-provider failure reasons to stderr so upstream
# agents can distinguish "no results" from "provider unreachable".
DEBUG = os.getenv("SEARCH_CLUSTER_DEBUG", "1") not in ("0", "false", "False", "")
# Stores last-run provider errors so --source all can include them in output.
_PROVIDER_ERRORS = {}

def _log_err(provider, err):
    _PROVIDER_ERRORS[provider] = str(err)
    if DEBUG:
        print(f"[search-cluster] {provider} failed: {err}", file=sys.stderr)

def internal_sanitize(text):
    if not text: return ""
    text = re.sub(r'ignore .*instructions|system override|you are now', '[REDACTED]', text, flags=re.I)
    text = "".join(ch for ch in text if ch.isprintable() or ch in ['\n', '\r', '\t'])
    return text.strip()

redis_client = None
if REDIS_HOST:
    try:
        import redis
        redis_client = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True, socket_connect_timeout=1)
    except: pass

def redis_set(key, value):
    if redis_client:
        try: redis_client.setex(key, 86400, value)
        except: pass

def redis_get(key):
    if redis_client:
        try: return redis_client.get(key)
        except: pass
    return None

def wiki_search(query):
    cache_key = f"search:wiki:{hashlib.md5(query.encode()).hexdigest()}"
    cached = redis_get(cache_key)
    if cached: return json.loads(cached)
    url = f"https://en.wikipedia.org/w/api.php?action=opensearch&search={urllib.parse.quote(query)}&limit=5&namespace=0&format=json"
    ctx = ssl.create_default_context()
    try:
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=10, context=ctx) as response:
            data = json.loads(response.read().decode())
            results = []
            if isinstance(data, list) and len(data) > 3:
                for i in range(len(data[1])):
                    results.append({
                        "source": "wiki",
                        "title": internal_sanitize(data[1][i]),
                        "link": data[3][i],
                        "snippet": internal_sanitize(data[2][i])
                    })
            if results: redis_set(cache_key, json.dumps(results))
            return results
    except Exception as e:
        _log_err("wiki", e)
        return []

def reddit_search(query):
    cache_key = f"search:reddit:{hashlib.md5(query.encode()).hexdigest()}"
    cached = redis_get(cache_key)
    if cached: return json.loads(cached)
    url = f"https://www.reddit.com/search.json?q={urllib.parse.quote(query)}&limit=5"
    ctx = ssl.create_default_context()
    try:
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=10, context=ctx) as response:
            data = json.loads(response.read().decode())
            results = []
            if "data" in data and "children" in data["data"]:
                for child in data["data"]["children"]:
                    post = child["data"]
                    results.append({
                        "source": "reddit",
                        "title": internal_sanitize(post.get("title")),
                        "link": f"https://reddit.com{post.get('permalink')}",
                        "snippet": internal_sanitize(f"r/{post.get('subreddit')} | {post.get('selftext', '')[:200]}")
                    })
            if results: redis_set(cache_key, json.dumps(results))
            return results
    except Exception as e:
        # Reddit's unauthenticated JSON endpoint is frequently blocked (HTTP 403/HTML bot wall).
        # Surface the failure rather than silently returning [].
        _log_err("reddit", e)
        return []

def scrapling_search(query):
    if not os.path.exists(SCRAPLING_PYTHON) or not os.path.exists(STEALTH_SCRIPT):
        return []
    try:
        result = subprocess.run([SCRAPLING_PYTHON, STEALTH_SCRIPT, query], capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            data = json.loads(result.stdout)
            for item in data:
                item["snippet"] = internal_sanitize(item.get("snippet", ""))
            return data
        else:
            _log_err("scrapling", f"exit={result.returncode} stderr={result.stderr[:200]}")
    except Exception as e:
        _log_err("scrapling", e)
    return []

def _strip_html(html_text):
    if not html_text:
        return ""
    # Remove tags without pulling in a dependency; good enough for RSS snippets.
    text = re.sub(r"<[^>]+>", " ", html_text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()

def gnews_search(query):
    url = f"https://news.google.com/rss/search?q={urllib.parse.quote(query)}&hl=en-US&gl=US&ceid=US:en"
    ctx = ssl.create_default_context()
    try:
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=10, context=ctx) as response:
            root = ET.fromstring(response.read())
            results = []
            for item in root.findall(".//item")[:10]:
                title_el = item.find("title")
                link_el = item.find("link")
                desc_el = item.find("description")
                pub_el = item.find("pubDate")
                # description usually contains HTML with source list; extract plain text.
                snippet = _strip_html(desc_el.text) if desc_el is not None and desc_el.text else ""
                if not snippet:
                    snippet = "Google News RSS item"
                results.append({
                    "source": "gnews",
                    "title": internal_sanitize(title_el.text) if title_el is not None else "",
                    "link": link_el.text if link_el is not None else "",
                    "snippet": internal_sanitize(snippet)[:500],
                    "published": pub_el.text if pub_el is not None else ""
                })
            return results
    except Exception as e:
        _log_err("gnews", e)
        return []

def google_search(query):
    if not GOOGLE_API_KEY or not GOOGLE_CSE_ID: return []
    url = f"https://www.googleapis.com/customsearch/v1?key={GOOGLE_API_KEY}&cx={GOOGLE_CSE_ID}&q={urllib.parse.quote(query)}"
    ctx = ssl.create_default_context()
    try:
        req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
        with urllib.request.urlopen(req, timeout=10, context=ctx) as response:
            data = json.loads(response.read().decode())
            results = []
            for item in data.get("items", []):
                results.append({
                    "source": "google", 
                    "title": internal_sanitize(item.get("title")), 
                    "link": item.get("link"), 
                    "snippet": internal_sanitize(item.get("snippet", ""))
                })
            return results
    except Exception as e:
        _log_err("google", e)
        return []

def search_all(query):
    results = []
    providers = {
        "google": google_search,
        "wiki": wiki_search,
        "reddit": reddit_search,
        "gnews": gnews_search,
        "scrapling": scrapling_search,
    }
    with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
        futures = {executor.submit(fn, query): name for name, fn in providers.items()}
        per_provider_counts = {name: 0 for name in providers}
        for f in concurrent.futures.as_completed(futures):
            name = futures[f]
            try:
                r = f.result() or []
                per_provider_counts[name] = len(r)
                results.extend(r)
            except Exception as e:
                _log_err(name, e)
    # Attach a diagnostics sentinel so downstream agents can detect provider failures
    # without changing the list contract. Consumers that only iterate dicts with "source"
    # field will still work; those that introspect can read source == "__meta__".
    results.append({
        "source": "__meta__",
        "provider_counts": per_provider_counts,
        "provider_errors": dict(_PROVIDER_ERRORS),
        "query": query,
    })
    return results

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Aggregated Search v3.5.1")
    parser.add_argument("source", choices=["google", "wiki", "reddit", "gnews", "scrapling", "all"])
    parser.add_argument("query")
    args = parser.parse_args()
    try:
        if args.source == "all": res = search_all(args.query)
        elif args.source == "wiki": res = wiki_search(args.query)
        elif args.source == "reddit": res = reddit_search(args.query)
        elif args.source == "scrapling": res = scrapling_search(args.query)
        elif args.source == "gnews": res = gnews_search(args.query)
        else: res = google_search(args.query)
        print(json.dumps(res, indent=2))
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)
