// playwright-fetch-stealth.mjs
import { chromium } from 'playwright-extra';
import stealth from 'puppeteer-extra-plugin-stealth';
import fs from 'fs/promises';
import { dirname } from 'path';

// enable stealth plugin
chromium.use(stealth());

async function run() {
  const args = process.argv.slice(2);
  const targetsPath = args[args.indexOf('--targets') + 1];
  const outDir = args[args.indexOf('--out') + 1];

  const targets = JSON.parse(await fs.readFile(targetsPath, 'utf8'));

  const browser = await chromium.launch({ headless: true });
  
  for (const target of targets) {
    if(!target.url || !target.stealth) continue; 
    
    // some mobile overrides
    const context = await browser.newContext({
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1',
        viewport: { width: 390, height: 844 },
        deviceScaleFactor: 3,
        isMobile: true,
        hasTouch: true,
        locale: 'zh-CN'
    });
    
    const page = await context.newPage();
    console.log(`[stealth] Fetching ${target.id}: ${target.url}`);
    
    try {
        const response = await page.goto(target.url, { waitUntil: 'domcontentloaded', timeout: 15000 });
        
        // Anti-anti-bot delay
        await page.waitForTimeout(2000);
        
        const title = await page.title();
        const content = await page.innerText('body');
        
        console.log(`[stealth] Got ${content.length} bytes for ${target.id} `);
        
        await fs.writeFile(`${outDir}/${target.id}.json`, JSON.stringify({
            id: target.id,
            url: target.url,
            status: response ? response.status() : 500,
            ok: response ? response.ok() : false,
            bytes: content.length,
            title,
            content: content.slice(0, 10000)
        }, null, 2));

    } catch(err) {
        console.error(`[stealth] Error on ${target.id}:`, err.message);
    }
    await context.close();
  }
  
  await browser.close();
}

run().catch(console.error);
