const { test, expect } = require('@playwright/test');
const path = require('path');

test.describe('YAAW Browse Page', () => {
  test.beforeEach(async ({ page }) => {
    await page.addInitScript(() => {
      window.__copiedText = '';
      Object.defineProperty(navigator, 'clipboard', {
        value: {
          writeText: (text) => {
            window.__copiedText = text;
            return Promise.resolve();
          }
        },
        configurable: true
      });
    });

    const filePath = 'file:///' + path.join(__dirname, '..', '..', 'showcase', 'browse.html').replace(/\\/g, '/');
    await page.goto(filePath, { waitUntil: 'domcontentloaded' });
  });

  test('should load browse page with workflow tab active', async ({ page }) => {
    await expect(page).toHaveTitle('YAAW');
    await expect(page.locator('.hero-brand')).toBeVisible();
    await expect(page.locator('.hero-brand')).toHaveAttribute('src', './assets/media/yaaw-mark.svg');
    await expect(page.locator('#process-tab')).toHaveClass(/active/);
    await expect(page.locator('#process-panel')).toHaveClass(/active/);
  });

  test('should select Discover by default', async ({ page }) => {
    const discoverStep = page.locator('#process-flow .step').first();
    await expect(discoverStep).toContainText('Discover');
    await expect(discoverStep).toHaveClass(/active/);
    await expect(discoverStep).toHaveAttribute('aria-pressed', 'true');

    await expect(page.locator('#process-detail h4')).toHaveText('Discover');
    await expect(page.locator('#process-detail .detail-skill')).toContainText('yaaw-discover');
  });

  test('should copy setup script from footer with expected commands', async ({ page }) => {
    await page.locator('#install-footer button').click();

    const copiedText = await page.evaluate(() => window.__copiedText);

    expect(copiedText).toContain('git config --global credential.useHttpPath true');
    expect(copiedText).toContain('$y="$env:USERPROFILE\\.yaaw"');
    expect(copiedText).toContain('Get-Command yaaw -ErrorAction SilentlyContinue');
    expect(copiedText).toContain('Test-Path "$y\\install.ps1"');
    expect(copiedText).toContain('git clone https://github.com/koshikg/yaaw.git $y');
    expect(copiedText).toContain('& "$y\\install.ps1"');
  });

  test('should scale cleanly on mobile viewport', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });

    await expect(page.locator('.back-btn')).toBeVisible();
    await expect(page.locator('#install-footer button')).toBeVisible();

    const horizontalOverflow = await page.evaluate(() => {
      return document.documentElement.scrollWidth > window.innerWidth + 1;
    });
    expect(horizontalOverflow).toBe(false);
  });
});
