---
name: yaaw-commit
description: "Create conventional commits with proper context and traceability. Use when the user says 'commit this', 'ready to commit', 'commit my changes', or when a logical unit of work is complete and tests pass."
argument-hint: "[optional: commit message or description of what was done]"
---

# YAAW Commit

Create well-structured conventional commits that are traceable, searchable, and meaningful in the context of this legacy codebase.

## Pre-Conditions

Before committing:
1. Verify tests pass for the changed area
2. Verify only intended files are staged (no accidental inclusions)
3. Verify the change is a complete logical unit (not a partial WIP)

## Copilot Session Mode

- Start commit in a fresh minimal session.
- Load only commit readiness evidence: approved plan, work completion, build/test proof, review approval, and staged diff.
- Do not carry full discovery/planning/implementation chat history into this phase.
- Stop if any prerequisite is missing and route back to the phase that must fix it.
- Preferred model: `GPT-5.3-Codex` for commit gate checks. Alternatives: `GPT-5.4`, `Claude Sonnet 4.6`, `Claude Sonnet 4.5`.

## Core Principles

1. **Conventional format** — Always use `<type>(<scope>): <description>` format
2. **Atomic commits** — Each commit is one logical change that could be reverted independently
3. **Meaningful scope** — Scope identifies the area of the codebase affected
4. **Traceable** — Reference plan U-IDs or context when relevant
5. **No WIP** — If you can't write a meaningful message, the work isn't ready to commit

## Commit Format

```
<type>(<scope>): <short description>

[optional body — what and why, not how]

[optional footer — references]
```

### Breaking Changes

```bash
# Exclamation mark after type/scope
feat(api)!: remove deprecated endpoint

# Or BREAKING CHANGE footer
feat(config): allow config to extend other configs

BREAKING CHANGE: `extends` key behavior changed
```

### Types

| Type | When to Use |
|---|---|
| `feat` | New functionality or capability |
| `fix` | Bug fix or correction |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement (no functional change) |
| `chore` | Maintenance, config changes, dependency updates |
| `docs` | Documentation only (context/ files, README, comments) |
| `test` | Adding or updating tests |
| `ci` | Pipeline or build configuration changes |
| `style` | Formatting, whitespace (no logic change) |
| `revert` | Reverting a previous commit |

### Scopes (yaaw-specific)

Use the most specific applicable scope:

| Scope | When |
|---|---|
| `nuget` | Package source or packages.config changes |
| `server` | Rtio.yaaw.Server changes |
| `signalr` | Rtio.yaaw.SignalRService changes |
| `shell` | Rtio.yaaw.Shell (client UI) changes |
| `<component>` | Component-specific changes |
| `queuemonitor` | Rtio.Scheduling.KGQueueMonitor changes |
| `pipeline` | CI/CD pipeline changes |
| `deploy` | Deployment script changes |
| `config` | Application configuration changes |
| `<project-short-name>` | Any other specific project or domain area |

### Examples

```bash
# Package migration
git commit -m "chore(nuget): migrate QueueMonitor packages to Artifactory source"

# Config change
git commit -m "chore(config): update NuGet.Config to point to Artifactory virtual repo"

# Bug fix
git commit -m "fix(server): resolve Devart connection timeout on startup"

# Feature work
git commit -m "feat(scheduling): add retry logic to TPPS integration polling"

# Pipeline update
git commit -m "ci(pipeline): add Artifactory feed authentication to build agents"

# With body and reference
git commit -m "chore(nuget): replace Proget source with Artifactory

Migrates all package resolution from the legacy Proget feed
(https://aumelapd14/nuget/NuGet/) to the new Artifactory virtual
repository. Klondite HTTP feed is also removed.

Ref: context/plans/2025-07-01-001-chore-artifactory-migration-plan.md U1"
```

## Branch Naming Convention

Before committing, verify the current branch follows the naming rules defined in **PROCESS.yaml → branch_naming** (single source of truth).

Quick reference:
- Format: `<prefix>/<id>-<description>`
- Prefixes (optional): `feature/`, `bugfix/`, `hotfix/`
- ID must match: 5-digit work item, PRB7-digit, INCD7-digit, or DMND7-digit
- `release/*` branches are exempt from ID check

If the current branch doesn't comply, **warn the user** before committing and suggest renaming:
```bash
git branch -m <old-name> <correct-name>
```

If no work item ID is known, **ask the user** for the ID before proceeding.

## Push Rules

1. **NEVER push directly to `main`, `develop`, or `release/*` branches.** If the current branch is one of these, **refuse to push** and tell the user to create a feature/bugfix/hotfix branch instead.
2. **NEVER `git push` while on `main`** — even if the commit is on a different branch, verify `git branch --show-current` is NOT main/develop/release before pushing.
3. For all other branches, **always ask for explicit user approval** before executing `git push`. Display the branch name and remote, then wait for confirmation.

## Execution Flow

### Phase 1: Assess What's Ready

```bash
git status
git diff --cached --stat
```

Check:
- Are only intended files staged?
- Is this a complete logical unit?
- Do tests pass?

If unstaged changes exist, help the user decide what to stage:
```bash
# Stage specific files
git add <file1> <file2>

# Or stage by pattern
git add App/Src/*/packages.config
```

**Never use `git add .`** unless the user explicitly confirms all changes should be in one commit.

### Phase 2: Determine Commit Message

If the user provided a message or description, format it as conventional commit.

If not, analyze the staged diff to auto-detect type and scope:

```bash
git diff --staged --stat
git diff --staged
```

**Auto-detection heuristics:**

| Signal in diff | Inferred type |
|---|---|
| New files with business logic | `feat` |
| Modified test files only | `test` |
| Only `.md`, XML comments, or context/ files | `docs` |
| `packages.config`, `.csproj` dependency changes | `chore` |
| Pipeline YAML changes | `ci` |
| Whitespace, formatting, no logic change | `style` |
| Null checks, off-by-one, exception handling fixes | `fix` |
| Restructured code, same behavior | `refactor` |
| Caching, batching, query optimization | `perf` |

For scope, use the most specific affected area from the Scopes table above.

Then determine:
1. **Type** — What kind of change is this?
2. **Scope** — What area of the codebase is affected?
3. **Description** — What does this change accomplish? (imperative mood, no period)

**Rules for the description:**
- Imperative mood: "add", "fix", "update", "remove" (not "added", "fixes", "updated")
- No period at the end
- Under 72 characters
- Describe WHAT changed, not HOW

### Phase 3: Add Body (when needed)

Add a commit body when:
- The change is non-obvious (WHY was this done?)
- Multiple files were changed for a single reason
- There's important context that won't be obvious from the diff
- Referencing a plan or learning

Don't add a body for:
- Trivial changes where the subject line says it all
- Single-file changes with obvious intent

### Phase 4: Add Footer (when relevant)

```
Ref: context/plans/<plan-file>.md U<N>    # Links to plan unit
Ref: context/learnings/<file>.md          # Links to relevant learning
Breaking: <description>                    # If this is a breaking change
```

### Phase 5: Execute

```bash
git commit -m "<formatted message>"
```

Or for multi-line messages:
```bash
git commit -m "<subject>" -m "<body>" -m "<footer>"
```

### Phase 6: Update Session Log

Update `context/_session.md` with the commit:
```markdown
- Committed: `<type>(<scope>): <description>` on branch `<branch>`
```

## Anti-Patterns

| Don't | Do Instead |
|---|---|
| `git commit -m "update"` | `chore(nuget): update Newtonsoft.Json to 13.0.2 across all projects` |
| `git commit -m "fix stuff"` | `fix(server): resolve null reference in Oracle connection pool cleanup` |
| `git commit -m "WIP"` | Don't commit — the work isn't ready |
| `git commit -m "changes"` | Describe what actually changed and why |
| Commit 20 unrelated files | Split into logical commits per area |
| `git add .` then commit | Stage intentionally, commit meaningfully |

## Git Safety Rules

**NEVER** do any of these without explicit user request:
- `git push --force` or `--force-with-lease` to any branch
- `git push` while on `main`, `develop`, or `release/*` (refuse unconditionally — even if user asks)
- `git commit --no-verify` (skips pre-commit hooks)
- `git commit --amend` (rewrites history)
- `git reset --hard` (destroys uncommitted work)
- Modify git config (user.name, user.email, etc.)

If a commit fails due to hooks, fix the issue and create a NEW commit — don't amend or skip.

## Batch Commit Pattern

When multiple related changes need separate commits (e.g., migrating packages project by project):

```bash
# Commit 1: Infrastructure
git add App/Src/.nuget/NuGet.Config
git commit -m "chore(nuget): add Artifactory as package source"

# Commit 2: First batch of projects
git add App/Src/Rtio.yaaw.Server/packages.config App/Src/Rtio.yaaw.SignalRService/packages.config
git commit -m "chore(nuget): migrate server packages to Artifactory versions"

# Commit 3: Second batch
git add App/Src/Rtio.Scheduling.KGQueueMonitor/packages.config
git commit -m "chore(nuget): migrate QueueMonitor packages to Artifactory versions"
```

This creates a clean, reviewable, revertable history.
