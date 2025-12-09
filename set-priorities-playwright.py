#!/usr/bin/env python3
"""
Set GitHub Project issue priorities using Playwright
Uses GitHub token from .env.local for authentication
"""

import os
import asyncio
from pathlib import Path
from playwright.async_api import async_playwright

# Load environment variables
env_file = Path(__file__).parent / '.env.local'
if env_file.exists():
    with open(env_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                key, value = line.split('=', 1)
                os.environ[key.strip()] = value.strip()

GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN', '').strip()
if not GITHUB_TOKEN or GITHUB_TOKEN == 'your_github_token_here':
    print("❌ ERROR: GITHUB_TOKEN not set in .env.local")
    exit(1)

# Mapping of issue numbers to priorities
PRIORITY_MAP = {
    24: 'Medium',
    25: 'Medium',
    26: 'Medium',
    27: 'High',
    28: 'Medium',
    29: 'Low',
    30: 'High',
    31: 'High'
}

async def set_issue_priority(page, issue_num, priority):
    """Navigate to an issue and set its priority"""
    url = f"https://github.com/elevanaltd/hestai/issues/{issue_num}"

    print(f"[{issue_num}/31] Setting priority to '{priority}'... ", end='', flush=True)

    try:
        await page.goto(url, wait_until="networkidle")

        # Wait for the sidebar to load
        await page.wait_for_selector('aside', timeout=10000)

        # Look for the Priority field in the sidebar
        # Try multiple selectors for the priority section
        priority_section = None

        # Try to find by heading text "Priority"
        try:
            priority_heading = await page.query_selector('h3:has-text("Priority")')
            if priority_heading:
                # Click near the priority section
                priority_parent = await priority_heading.evaluate('el => el.closest("div")')
                if priority_parent:
                    priority_section = priority_parent
        except:
            pass

        # If not found, try alternative approach - find the "No priority" or similar text
        if not priority_section:
            try:
                # Look for buttons or clickable elements with priority-related text
                all_buttons = await page.query_selector_all('button, [role="button"]')
                for button in all_buttons:
                    text = await button.text_content()
                    if text and ('priority' in text.lower() or 'no' in text.lower()):
                        priority_section = button
                        break
            except:
                pass

        if not priority_section:
            print(f"❌ Could not find priority field")
            return False

        # Click on the priority section to open dropdown
        await priority_section.click()

        # Wait for dropdown menu to appear
        await asyncio.sleep(1)

        # Look for the priority option in the dropdown
        try:
            # Try to find the menu item with our priority
            menu_items = await page.query_selector_all('[role="option"], [role="menuitem"], li')
            for item in menu_items:
                text = await item.text_content()
                if text and priority in text:
                    await item.click()
                    await asyncio.sleep(1)
                    print(f"✅")
                    return True
        except:
            pass

        print(f"❌ Could not find priority option")
        return False

    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

async def main():
    print("🚀 Setting GitHub Issue Priorities with Playwright\n")

    async with async_playwright() as p:
        # Launch browser in headless mode
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context()
        page = await context.new_page()

        # Add GitHub token to requests
        await page.set_extra_http_headers({
            'Authorization': f'token {GITHUB_TOKEN}'
        })

        successes = 0
        failures = 0

        for issue_num in sorted(PRIORITY_MAP.keys()):
            priority = PRIORITY_MAP[issue_num]
            success = await set_issue_priority(page, issue_num, priority)

            if success:
                successes += 1
            else:
                failures += 1

        await browser.close()

    print(f"\n{'='*50}")
    print(f"Results: {successes} successful, {failures} failed")

    if failures == 0:
        print("✨ All priorities updated successfully!")
        return 0
    else:
        print(f"⚠️  {failures} updates failed")
        return 1

if __name__ == '__main__':
    exit(asyncio.run(main()))
