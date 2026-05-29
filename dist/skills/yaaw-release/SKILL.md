---
name: yaaw-release
description: >
  Generate release notes and changelogs from conventional commits. Drafts PR descriptions
  using the repo's pull_request_template.md and release-notes-template.md.
  Use when preparing a PR, creating release notes, or summarizing changes.
argument-hint: "[branch to summarize, or 'pr' for PR description]"
---

# YAAW Release Notes

Generate structured release notes from conventional commits, following the repo's existing templates.

## Templates

Each YAAW repo may define templates in `.github/` or `docs/`:
- `pull_request_template.md` — PR description format
- `release-notes-template.md` — Release notes format

Read the relevant template before generating output.

## Execution Flow

### For PR Description (`/yaaw-release pr`)

1. Get current branch: `git branch --show-current`
2. Get base branch (ask user if ambiguous — usually `develop` or `main`)
3. Get commits: `git log {base}..HEAD --oneline`
4. Read the repo's PR template, usually `.github/pull_request_template.md`
5. Fill template with:
   - Work item ID (extracted from branch name)
   - Summary of changes (grouped by type)
   - Testing done (from `context/work/` session if available)
   - Deployment notes (if pipeline/config changes detected)

### For Release Notes (`/yaaw-release notes`)

1. Ask user for version range (tag-to-tag, or branch comparison)
2. Get commits: `git log {from}..{to} --oneline`
3. Read the repo's release notes template when one exists
4. Group commits by type:
   - **Features** (feat:)
   - **Bug Fixes** (fix:)
   - **Maintenance** (chore:, refactor:, ci:)
   - **Documentation** (docs:)
5. Generate release notes following template format

### For Changelog (`/yaaw-release changelog`)

1. Get all commits since last tag (or specified range)
2. Generate markdown changelog grouped by type
3. Include breaking changes prominently
4. Output to stdout (user decides where to put it)

## Output Format

```markdown
## What's Changed

### Features
- feat(scheduling): add retry logic to TPPS integration (#53822)

### Bug Fixes
- fix(api): handle duplicate rows in adjustment workflow (#53557)
- fix(inpits): adjust date_applied logic for LIFO tonnes adjustment (#53013)

### Maintenance
- chore(nuget): migrate to Artifactory
- ci(pipeline): update deployment variables for BM1

### Breaking Changes
- None
```

## Rules

- Extract work item IDs from branch names or commit footers
- Link to work items or issues where possible: `#{id}`
- Keep descriptions concise — one line per commit
- Group related commits (same work item) into single entries
- Flag any commits without conventional format as "Other"
