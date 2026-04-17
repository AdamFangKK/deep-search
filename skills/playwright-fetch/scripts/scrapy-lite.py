import json
import argparse
import sys
import logging
import asyncio
from typing import List, Dict, Any

from bs4 import BeautifulSoup
import httpx

logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

async def fetch_target(client: httpx.AsyncClient, target: Dict[str, Any], out_dir: str):
    url = target.get('url')
    id_ = target.get('id')
    stealth = target.get('stealth', False)
    logging.info(f"[{id_}] Fetching {url}")
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    }
    
    try:
        response = await client.get(url, headers=headers, follow_redirects=True, timeout=20.0)
        content_bytes = len(response.content)
        logging.info(f"[{id_}] Got {content_bytes} bytes from {url}")
        
        # very basic test for JS wall / Cloudflare
        # 36kr usually returns a small skeleton if anti-scraping
        # WeChat MP returns 4 bytes if missing sig
        
        soup = BeautifulSoup(response.text, 'html.parser')
        title = soup.title.string if soup.title else ""
        text = soup.get_text(separator=' ', strip=True)
        
        # heuristic check for walls
        walled = False
        if content_bytes < 500:
            walled = True
        elif 'Just a moment' in title or 'Cloudflare' in title:
            walled = True
        
        output = {
            'id': id_,
            'url': url,
            'bytes': content_bytes,
            'title': title,
            'content': text[:5000] if not walled else "",
            'walled': walled
        }
        
        out_path = f"{out_dir}/{id_}.json"
        with open(out_path, 'w', encoding='utf-8') as f:
            json.dump(output, f, ensure_ascii=False, indent=2)
            
    except Exception as e:
        logging.error(f"[{id_}] Error fetching {url}: {e}")

async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--targets', required=True)
    parser.add_argument('--out', required=True)
    args = parser.parse_args()
    
    with open(args.targets, 'r') as f:
        targets = json.load(f)
        
    async with httpx.AsyncClient() as client:
        tasks = []
        for target in targets:
            tasks.append(fetch_target(client, target, args.out))
        await asyncio.gather(*tasks)

if __name__ == '__main__':
    asyncio.run(main())
