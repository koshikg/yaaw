import fs from 'node:fs';
import path from 'node:path';

const repoRoot = process.cwd();
const skillsRoot = path.join(repoRoot, 'dist', 'skills');
const outputPath = path.join(repoRoot, 'showcase', 'data', 'skills.generated.js');
const watchMode = process.argv.includes('--watch');
let debounceTimer = null;

function parseFrontmatter(content) {
  const match = content.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
  if (!match) {
    return {};
  }

  const block = match[1];
  const result = {};
  let activeMultilineKey = null;

  for (const rawLine of block.split(/\r?\n/)) {
    const line = rawLine.trimEnd();

    if (!line.trim()) {
      continue;
    }

    if (activeMultilineKey) {
      if (/^\s+/.test(rawLine)) {
        const nextValue = rawLine.trim();
        result[activeMultilineKey] += ` ${nextValue}`;
        continue;
      }
      activeMultilineKey = null;
    }

    const kv = line.match(/^([a-zA-Z0-9_-]+):\s*(.*)$/);
    if (!kv) {
      continue;
    }

    const key = kv[1];
    let value = kv[2].trim();

    if (value === '>') {
      result[key] = '';
      activeMultilineKey = key;
      continue;
    }

    value = value.replace(/^"|"$/g, '');
    result[key] = value;
  }

  for (const key of Object.keys(result)) {
    result[key] = result[key].replace(/\s+/g, ' ').trim();
  }

  return result;
}

function inferGroup(skillName) {
  const coreWorkflow = new Set([
    'yaaw-discover',
    'yaaw-plan',
    'yaaw-work',
    'yaaw-review',
    'yaaw-commit'
  ]);

  return coreWorkflow.has(skillName) ? 'Core Workflow' : 'Utility';
}

function inferCommand(skillName) {
  return `/${skillName}`;
}

function generateSkillsData() {
  const dirEntries = fs.readdirSync(skillsRoot, { withFileTypes: true });
  const skills = [];

  for (const entry of dirEntries) {
    if (!entry.isDirectory()) {
      continue;
    }

    const skillMdPath = path.join(skillsRoot, entry.name, 'SKILL.md');
    if (!fs.existsSync(skillMdPath)) {
      continue;
    }

    const content = fs.readFileSync(skillMdPath, 'utf8');
    const fm = parseFrontmatter(content);

    const name = fm.name || entry.name;
    const description = fm.description || 'No description provided.';

    skills.push({
      name,
      command: inferCommand(name),
      group: inferGroup(name),
      description
    });
  }

  skills.sort((a, b) => a.name.localeCompare(b.name));
  return skills;
}

function writeSkillsData() {
  const skillsData = generateSkillsData();
  const output = `window.yaawSkillsData = ${JSON.stringify(skillsData, null, 2)};\n`;

  fs.writeFileSync(outputPath, output, 'utf8');
  console.log(`Generated ${skillsData.length} skills in ${path.relative(repoRoot, outputPath)}`);
}

writeSkillsData();

if (watchMode) {
  console.log(`Watching ${path.relative(repoRoot, skillsRoot)} for changes...`);

  fs.watch(skillsRoot, { recursive: true }, () => {
    if (debounceTimer) {
      clearTimeout(debounceTimer);
    }

    debounceTimer = setTimeout(() => {
      try {
        writeSkillsData();
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.error(`Failed to regenerate skills data: ${message}`);
      }
    }, 120);
  });
}
