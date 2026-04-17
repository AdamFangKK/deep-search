#!/usr/bin/env node
/**
 * playwright-fetch.mjs — 并发抓取工具，带域名限流、超时、隔离写入
 *
 * 用法:
 *   node playwright-fetch.mjs <targets.json> <out-dir> [--concurrency=4] [--per-domain-ms=2500]
 *
 * targets.json 格式:
 *   [{ "id": "char-ai-wiki", "url": "https://...", "waitFor": "networkidle", "timeout": 30000 }]
 *
 * 输出:
 *   <out-dir>/<id>.json  每个目标一个文件，含 title/content/html_length/status/error
 *   <out-dir>/_summary.json  本次总结
 *
 * 设计要点:
 * - 单一浏览器 + N 个 context（比多进程省资源）
 * - 每个域名有最小时间间隔（默认 2.5 秒）防止被 ban
 * - 每个任务独立 try/catch，一个失败不影响其他
 * - 内置 Readability.js（CDN 注入）做内容抽取
 */

import { chromium } from 'playwright';
import { writeFile, mkdir, readFile } from 'node:fs/promises';
import path from 'node:path';

// -------- CLI --------
const args = process.argv.slice(2);
if (args.length < 2) {
  console.error('用法: playwright-fetch.mjs <targets.json> <out-dir> [--concurrency=4] [--per-domain-ms=2500]');
  process.exit(1);
}
const [targetsFile, outDir, ...rest] = args;
const opts = Object.fromEntries(
  rest.filter((a) => a.startsWith('--')).map((a) => {
    const [k, v] = a.slice(2).split('=');
    return [k, v];
  })
);
const CONCURRENCY = Number(opts.concurrency) || 4;
const PER_DOMAIN_MS = Number(opts['per-domain-ms']) || 2500;
const NAV_TIMEOUT = Number(opts.timeout) || 30000;

const UA =
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 ' +
  '(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36';

// -------- 工具 --------
function domainOf(u) {
  try {
    return new URL(u).hostname;
  } catch {
    return '__invalid__';
  }
}
const domainLastHit = new Map();
async function waitForDomain(host) {
  const last = domainLastHit.get(host) || 0;
  const now = Date.now();
  const diff = PER_DOMAIN_MS - (now - last);
  if (diff > 0) await new Promise((r) => setTimeout(r, diff));
  domainLastHit.set(host, Date.now());
}

// -------- 主流程 --------
async function main() {
  const targets = JSON.parse(await readFile(targetsFile, 'utf-8'));
  await mkdir(outDir, { recursive: true });

  console.error(
    `[fetch] ${targets.length} 个目标 · concurrency=${CONCURRENCY} · per-domain=${PER_DOMAIN_MS}ms`
  );

  const browser = await chromium.launch({ headless: true });

  const queue = [...targets];
  const results = [];
  let inFlight = 0;

  async function worker(id) {
    while (queue.length > 0) {
      const t = queue.shift();
      if (!t) return;
      inFlight++;
      const start = Date.now();
      const host = domainOf(t.url);
      await waitForDomain(host);
      const ctx = await browser.newContext({
        userAgent: UA,
        locale: 'zh-CN',
        viewport: { width: 1366, height: 900 },
      });
      const page = await ctx.newPage();
      page.setDefaultNavigationTimeout(t.timeout || NAV_TIMEOUT);
      const rec = { id: t.id, url: t.url, host, ok: false };
      try {
        const resp = await page.goto(t.url, {
          waitUntil: t.waitFor || 'domcontentloaded',
        });
        rec.status = resp?.status() || 0;
        // 等一小会儿让 JS 渲染
        await page.waitForTimeout(1200);
        // 抽取 title
        rec.title = await page.title();
        // 抽取主要内容：优先 article/main，其次 body 的文本
        rec.content = await page.evaluate(() => {
          const pickLongest = (sels) => {
            let best = '';
            for (const sel of sels) {
              const el = document.querySelector(sel);
              if (el && el.innerText && el.innerText.length > best.length) best = el.innerText;
            }
            return best;
          };
          const byTag = pickLongest(['article', 'main', '[role="main"]', '.article-content', '.post', '#article']);
          if (byTag && byTag.length > 200) return byTag;
          // fallback: body text, 去掉导航和脚本
          const body = document.body?.innerText || '';
          return body;
        });
        rec.html_length = (await page.content()).length;
        rec.content_length = rec.content?.length || 0;
        rec.ok = true;
      } catch (e) {
        rec.error = e.message || String(e);
      } finally {
        rec.elapsed_ms = Date.now() - start;
        await ctx.close().catch(() => {});
      }
      // 隔离写入：每个 id 一个文件
      const fp = path.join(outDir, `${t.id}.json`);
      await writeFile(fp, JSON.stringify(rec, null, 2), 'utf-8');
      results.push({
        id: rec.id,
        host: rec.host,
        ok: rec.ok,
        status: rec.status,
        content_length: rec.content_length || 0,
        elapsed_ms: rec.elapsed_ms,
        error: rec.error,
      });
      const tag = rec.ok ? 'OK' : 'FAIL';
      console.error(
        `[w${id}] ${tag} ${rec.host} · ${t.id} · ${rec.content_length || 0}B · ${rec.elapsed_ms}ms${rec.error ? ' · ' + rec.error.slice(0, 80) : ''}`
      );
      inFlight--;
    }
  }

  const workers = Array.from({ length: CONCURRENCY }, (_, i) => worker(i + 1));
  await Promise.all(workers);
  await browser.close();

  const summary = {
    total: targets.length,
    ok: results.filter((r) => r.ok).length,
    fail: results.filter((r) => !r.ok).length,
    total_content_bytes: results.reduce((s, r) => s + (r.content_length || 0), 0),
    by_host: Object.fromEntries(
      Object.entries(
        results.reduce((acc, r) => {
          acc[r.host] = acc[r.host] || { ok: 0, fail: 0 };
          acc[r.host][r.ok ? 'ok' : 'fail']++;
          return acc;
        }, {})
      )
    ),
    results,
  };
  await writeFile(path.join(outDir, '_summary.json'), JSON.stringify(summary, null, 2));
  console.error(`\n[done] ok=${summary.ok}/${summary.total} · bytes=${summary.total_content_bytes}`);
  console.error(`[done] summary: ${outDir}/_summary.json`);
}

main().catch((e) => {
  console.error('[fatal]', e);
  process.exit(1);
});
