const { test, expect } = require('@playwright/test');
const path = require('node:path');

test.describe('YAAW Skills Presentation', () => {
  test.beforeEach(async ({ page }) => {
    // Navigate to the presentation HTML file
    const filePath = 'file:///' + path.join(__dirname, '..', '..', 'showcase', 'yaaw-overview.html').replaceAll('\\', '/');
    await page.goto(filePath, { waitUntil: 'domcontentloaded' });
  });

  test('should load the presentation with correct title', async ({ page }) => {
    await expect(page).toHaveTitle('YAAW — Shared Agentic Development Infrastructure');
  });

  test('should display the first slide content', async ({ page }) => {
    await expect(page.locator('.hero-brand')).toBeVisible();
    await expect(page.locator('.hero-brand')).toHaveAttribute('src', './assets/media/yaaw-mark.svg');

    // Check for main heading
    await expect(page.locator('h1')).toContainText('YAAW');
    
    // Check for subtitle
    await expect(page.locator('.tagline')).toContainText('yet another agentic workflow');
    
    // Check for skills count
    await expect(page.locator('.highlight', { hasText: '17+ skills' }).first()).toBeVisible();
  });

  test('should have navigation controls visible', async ({ page }) => {
    // Check for navigation buttons
    await expect(page.locator('#prev-btn')).toBeVisible();
    await expect(page.locator('#next-btn')).toBeVisible();
    
    // Check for progress dots
    const dots = page.locator('.dot');
    await expect(dots).toHaveCount(20);
    
    // Check for slide counter
    await expect(page.locator('#slide-counter')).toContainText('1 / 20');
  });

  test('should navigate to next slide using button', async ({ page }) => {
    // Click next button
    await page.locator('#next-btn').click();
    await page.waitForTimeout(600); // Wait for animation
    
    // Check slide counter updated
    await expect(page.locator('#slide-counter')).toContainText('2 / 20');
    
    // Check second slide content is visible
    await expect(page.getByText('The Problem')).toBeVisible();
  });

  test('should navigate using keyboard arrows', async ({ page }) => {
    // Press right arrow
    await page.keyboard.press('ArrowRight');
    await page.waitForTimeout(600);
    
    await expect(page.locator('#slide-counter')).toContainText('2 / 20');
    
    // Press left arrow
    await page.keyboard.press('ArrowLeft');
    await page.waitForTimeout(600);
    
    await expect(page.locator('#slide-counter')).toContainText('1 / 20');
  });

  test('should navigate using Home and End keys', async ({ page }) => {
    // Go to end
    await page.keyboard.press('End');
    await page.waitForTimeout(600);
    
    await expect(page.locator('#slide-counter')).toContainText('20 / 20');
    
    // Go to home
    await page.keyboard.press('Home');
    await page.waitForTimeout(600);
    
    await expect(page.locator('#slide-counter')).toContainText('1 / 20');
  });

  test('should navigate by clicking progress dots', async ({ page }) => {
    // Click on the 5th dot (index 4)
    await page.locator('.dot').nth(4).click();
    await page.waitForTimeout(600);
    
    await expect(page.locator('#slide-counter')).toContainText('5 / 20');
  });

  test('should show progress bar', async ({ page }) => {
    const progressBar = page.locator('#progress-bar');
    await expect(progressBar).toBeVisible();
    
    // Navigate to slide 10
    await page.locator('.dot').nth(9).click();
    await page.waitForTimeout(600);
    
    // Progress bar should be at 50%
    const width = await progressBar.evaluate(el => el.style.width);
    expect(width).toBe('50%');
  });

  test('should display all 20 slides with correct content', async ({ page }) => {
    const expectedSlides = [
      'YAAW Skills',
      'The Problem',
      'The Solution',
      'First-Time Setup',
      'CLI Commands',
      'Architecture',
      'The 17+ Skills',
      'Skill: yaaw-discover',
      'Skill: yaaw-plan',
      'Skill: yaaw-work',
      'Skill: yaaw-build',
      'Skill: yaaw-review',
      'Skill: yaaw-commit',
      'The Knowledge Base',
      'Process Gates',
      'Compounding Knowledge',
      'Cross-Agent Compatibility',
      'Migration & Adoption',
      'Future Roadmap',
      'Get Started'
    ];

    for (let i = 0; i < expectedSlides.length; i++) {
      // Navigate to slide
      await page.locator('.dot').nth(i).click();
      await page.waitForTimeout(400);
      
      // Verify slide counter
      await expect(page.locator('#slide-counter')).toContainText(`${i + 1} / 20`);
      
      // Check if expected content is somewhere on the page
      const slideContent = await page.locator('.slide.active').textContent();
      expect(slideContent).toBeTruthy();
    }
  });

  test('should have responsive design with proper styling', async ({ page }) => {
    // Check background color (should be white for Apple-inspired design)
    const bgColor = await page.evaluate(() => {
      return globalThis.getComputedStyle(document.body).backgroundColor;
    });
    expect(bgColor).toMatch(/rgb\(255,\s*255,\s*255\)/); // White background
    
    // Check if navigation controls have backdrop blur
    const controlsBg = await page.locator('#controls').evaluate(el => {
      return globalThis.getComputedStyle(el).backdropFilter;
    });
    expect(controlsBg).toContain('blur');
  });

  test('should update active dot when navigating', async ({ page }) => {
    // First dot should be active
    await expect(page.locator('.dot').first()).toHaveClass(/active/);
    
    // Navigate to slide 3
    await page.keyboard.press('ArrowRight');
    await page.keyboard.press('ArrowRight');
    await page.waitForTimeout(600);
    
    // Third dot should be active
    await expect(page.locator('.dot').nth(2)).toHaveClass(/active/);
  });

  test('should show keyboard hints', async ({ page }) => {
    const keyboardHint = page.locator('#keyboard-hint');
    await expect(keyboardHint).toBeVisible();
    await expect(keyboardHint).toContainText('←');
    await expect(keyboardHint).toContainText('→');
  });

  test('should have copy buttons on code blocks', async ({ page }) => {
    // Navigate to setup slide
    await page.locator('.dot').nth(3).click();
    await page.waitForTimeout(600);
    
    // Check for copy buttons
    const copyButtons = page.locator('.copy-btn');
    await expect(copyButtons.first()).toBeVisible();
  });

  test(String.raw`should use USERPROFILE\.yaaw in setup commands`, async ({ page }) => {
    await page.locator('.dot').nth(3).click();
    await page.waitForTimeout(600);

    await expect(page.locator('#setup-script')).toContainText(String.raw`$env:USERPROFILE\.yaaw`);
    await expect(page.locator('#setup-script')).toContainText('Get-Command yaaw -ErrorAction SilentlyContinue');
    await expect(page.locator('#setup-script')).toContainText(String.raw`$y="$env:USERPROFILE\.yaaw"`);
    await expect(page.locator('#setup-script')).toContainText(String.raw`Test-Path "$y\install.ps1"`);
    await expect(page.locator('#setup-script')).toContainText(String.raw`git clone https://github.com/koshikg/yaaw.git $y`);
    await expect(page.locator('#setup-script')).toContainText(String.raw`& "$y\install.ps1"`);

    const inlineScripts = await page.locator('script').allTextContents();
    const scripts = inlineScripts.join('\n');
    expect(scripts).toContain('String.raw`git config --global credential.useHttpPath true');
    expect(scripts).toContain(String.raw`$y="$env:USERPROFILE\.yaaw"`);
    expect(scripts).toContain('Get-Command yaaw -ErrorAction SilentlyContinue');
    expect(scripts).toContain(String.raw`Test-Path "$y\install.ps1"`);
    expect(scripts).toContain('git clone https://github.com/koshikg/yaaw.git $y');
    expect(scripts).toContain(String.raw`& "$y\install.ps1"`);
  });

  test('should have proper Apple-inspired styling', async ({ page }) => {
    // Check font family
    const fontFamily = await page.evaluate(() => {
      return globalThis.getComputedStyle(document.body).fontFamily;
    });
    expect(fontFamily).toContain('apple-system');
    
    // Check for accent blue color on links/highlights
    const accentColor = await page.locator('.tagline').evaluate(el => {
      return globalThis.getComputedStyle(el).color;
    });
    expect(accentColor).toMatch(/rgb\(0,\s*113,\s*227\)/); // #0071e3
  });

  test('should prevent default Prev button behavior on first slide', async ({ page }) => {
    // Should be on slide 1
    await expect(page.locator('#slide-counter')).toContainText('1 / 20');
    
    // Click prev button
    await page.locator('#prev-btn').click();
    await page.waitForTimeout(400);
    
    // Should still be on slide 1
    await expect(page.locator('#slide-counter')).toContainText('1 / 20');
  });

  test('should prevent default Next button behavior on last slide', async ({ page }) => {
    // Go to last slide
    await page.keyboard.press('End');
    await page.waitForTimeout(600);
    
    // Should be on slide 20
    await expect(page.locator('#slide-counter')).toContainText('20 / 20');
    
    // Click next button
    await page.locator('#next-btn').click();
    await page.waitForTimeout(400);
    
    // Should still be on slide 20
    await expect(page.locator('#slide-counter')).toContainText('20 / 20');
  });

  test('should adapt controls and layout for mobile viewport', async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 });

    await expect(page.locator('#controls')).toBeVisible();
    await expect(page.locator('#install-footer button')).toBeVisible();

    const controlLayout = await page.locator('#controls').evaluate((el) => {
      const style = globalThis.getComputedStyle(el);
      return {
        flexDirection: style.flexDirection,
        position: style.position
      };
    });

    expect(controlLayout.position).toBe('fixed');
    expect(controlLayout.flexDirection).toBe('row');

    const horizontalOverflow = await page.evaluate(() => {
      return document.documentElement.scrollWidth > window.innerWidth + 1;
    });
    expect(horizontalOverflow).toBe(false);
  });
});
