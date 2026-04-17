# Deep-Search Subagent Session Protocol

When a subagent encounters an anti-scraping wall (e.g., 0B `36kr.com`, 4B `mp.weixin.qq.com`, or Cloudflare triggers), it **MUST NOT** endlessly retry or silently fail.

It must exit to the user with a specific `NEEDS_SESSION` flag in its final return message.

## Procedure

1. **Detect wall**: Subagent runs `playwright-fetch.mjs`. The result JSON shows `"bytes": 0`, `"bytes": 4` (for weixin), or `"content"` contains `Cloudflare`/`Just a moment...` text.
2. **Halt further fetch**: Stop fetching that domain to avoid IP bans.
3. **Format Return**: The subagent's final message back to the orchestrator (you) MUST look like this:

```
[PARTIAL REPORT]
...what was found before wall...

[NEEDS_SESSION]
Domain: <e.g., 36kr.com or mp.weixin.qq.com>
Reason: <e.g., JS wall requires logged in session cookies>
Requested Action: Please provide session cookies as a JSON string `[{name, value, domain}]` to inject into Playwright.
```

## Orchestrator Action

When the orchestrator (you) receives a `[NEEDS_SESSION]` flag from a subagent, you MUST:

1. **Pause execution** of the automated workflow for that domain.
2. **Use the `vscode_askQuestions` tool** and ask the user to provide the requested session.
   - Set `allowFreeformInput: true`.
   - Ask: "The scraper hit a wall on [Domain]. Do you have a session cookie JSON `[{name: '...', value: '...', domain: '...'}]` to bypass this?"
3. If provided, save it to `cookies-<domain>.json` and re-run the target list with Playwright `--cookies cookies-<domain>.json`.
4. If the user skips or refuses, proceed using only the `[PARTIAL REPORT]` data.
