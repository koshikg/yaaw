# YAAW Agent Instructions

This is the canonical instruction file for YAAW agentic development. It works with any AI coding agent (Amazon Q, GitHub Copilot, Claude Code, Cursor, Codex, etc.).

## Identity

You are an engineering agent working on this codebase. Your job is to help with the full SDLC while building a compounding knowledge base that makes every future session faster.

## System Configuration

All key facts about this codebase live in **`context/config.yaml`** — the single-source-of-truth snapshot. Read that file for: project details, package sources, deployables, pipelines, tech stack, and conventions.

For cross-repo system knowledge (how repos relate, shared conventions, deployment topology), read **`SYSTEM.md`** in the skills root.

Update `context/config.yaml` when the system changes.

## Knowledge Base

The `context/` folder is the compounding knowledge base. Every skill reads from it before starting work and writes back when something new is learned.

### Structure

```
context/
├── config.yaml              ← repo identity and configuration (READ FIRST)
├── _session.md              ← live work log (session continuity, READ SECOND)
├── skill-overrides.yaml     ← per-repo skill behavior overrides (optional)
├── discovery/               ← codebase investigation findings
├── learnings/               ← solved problems, decisions, gotchas
│   ├── _index.yaml          ← single-page lookup (READ THIRD)
│   ├── packages/
│   ├── deploy/
│   ├── process/
│   └── general/
├── plans/                   ← implementation plans (PRDs)
└── work/                    ← active work execution tracking
```

### Reading Order (mandatory)

Every session starts by reading files in this priority order:
1. `context/_session.md` — what's in progress NOW (resume incomplete work)
2. `context/config.yaml` — what this repo IS
3. `context/learnings/_index.yaml` — quick lookup of all prior knowledge
4. Relevant `context/discovery/` files — system understanding for the task at hand
5. `SYSTEM.md` — cross-repo context (only when cross-repo knowledge needed)

This order ensures the agent always resumes correctly after a session reset.

## Knowledge Refresh Command

When the user says **"refresh knowledge"** or **"update context"** or **"sync"**, the agent MUST:

1. Re-read ALL context files (config, session, learnings index, all discovery docs)
2. Check for stale or contradictory information
3. Update `_session.md` with current state
4. Report what's current, what's stale, and what's missing
5. Suggest which areas need re-discovery

This is the equivalent of a full memory bank sync after a session reset.

## Quick Status Command

When the user says **"status"** or **"where are we"**, the agent reads `_session.md` and `context/work/` then presents:

```
📍 Current State
• Branch: <branch or none>
• Phase: <active phase or idle>
• In Progress: <work item or none>
• Last Updated: <date from _session.md frontmatter>
• Pending decisions: <any items in Blocked/Waiting>
```

Keep it to 5 lines max. No elaboration unless asked.

## Knowledge Feedback Loop

Every skill participates in the feedback loop:

```
┌─────────────────────────────────────────────┐
│            context/ (Knowledge Base)          │
│                                              │
│  discovery/  → what the system IS            │
│  learnings/  → gotchas, decisions, patterns  │
│  plans/      → what we intend to DO          │
│  _session.md → what's in progress NOW        │
└──────────┬────────────────────┬──────────────┘
           │                    │
     ┌─────┘                    └─────┐
     ▼                                ▼
  READ before work              WRITE after work
```

### Rules for Every Skill

**Before starting work:**
1. Read `context/_session.md` — resume incomplete work if any
2. Read `context/learnings/_index.yaml` — quick lookup of all prior knowledge
3. Read relevant `context/discovery/` files — understand the system context
4. Read `context/config.yaml` — understand this repo's specifics

**After completing work:**
1. If anything new/unexpected was found → write to `context/learnings/` AND update `_index.yaml`
2. Update `context/_session.md` with progress
3. If a discovery area was completed → update findings

## Session Continuity

`context/_session.md` is the handoff contract between sessions:

1. **Read first** — Always the first file read on any invocation
2. **Write often** — Update at every phase transition
3. **Log partials** — If you've found something but haven't written docs yet, log partial findings
4. **Clear on complete** — Move items from "In Progress" to "Completed"
5. **Handoff notes** — Always leave breadcrumbs for the next agent

## Phase-Scoped Sessions (Copilot Optimization)

For chat-based agents such as GitHub Copilot, keep each core workflow phase in its own session whenever possible:

1. `yaaw-discover` — fresh session
2. `yaaw-plan` — fresh session
3. `yaaw-work` — fresh session to start implementation; later fresh sessions may resume the same work item from logs
4. `yaaw-review` — fresh session
5. `yaaw-commit` — fresh minimal session

This prevents discovery noise from polluting implementation, keeps review skeptical, and stops commit from inheriting unnecessary context.

### Required Phase Boundary Behavior

At every phase boundary:
1. Write the phase output to the correct `context/` artifact
2. Update `context/_session.md`
3. Stop and hand off to the next phase
4. Start the next phase in a NEW session

If the agent platform cannot automatically create a new session, the agent must not silently continue into the next phase. Instead, it must:
1. Finish the current phase artifact
2. Provide a ready-to-paste starter prompt for the next phase
3. Wait for the user to begin the new session

### Preferred Model Routing

When the client supports model selection per mode/agent:

| Phase | Primary Model | Alternatives |
|---|---|
| Discover | `GPT-5.5` | `Claude Opus 4.6`, `Gemini 2.5 Pro`, `Gemini 3.1 Pro` |
| Plan     | `GPT-5.5` | `Claude Opus 4.6`, `Claude Opus 4.5`, `Gemini 2.5 Pro`, `Gemini 3.1 Pro` |
| Work     | `GPT-5.3-Codex` | `GPT-5.2-Codex`, `GPT-5.4`, `Claude Sonnet 4.6` |
| Review   | `Claude Opus 4.6` | `GPT-5.5`, `Claude Opus 4.5`, `Gemini 2.5 Pro` |
| Commit   | `GPT-5.3-Codex` | `GPT-5.4`, `Claude Sonnet 4.6`, `Claude Sonnet 4.5` |

If only one model is available, use it. Model routing is an optimization, not a gate.

### Utility Skill Model Fit

| Utility Skill Group | Preferred Model Profile |
|---|---|
| Build and pipeline automation (`yaaw-build`, `yaaw-pipeline`, `yaaw-devops`, `yaaw-crossrepo`) | Codex-first (`GPT-5.3-Codex`, `GPT-5.2-Codex`) |
| Deep analysis (`yaaw-security`, `yaaw-techdebt`, `yaaw-grillme`) | Deep-reasoning (`Claude Opus 4.6`, `GPT-5.5`, `Claude Opus 4.5`) |
| Lightweight operational docs (`yaaw-capture`, `yaaw-release`, `yaaw-doctor`, `yaaw-caveman`) | Fast lower-cost model unless complexity spikes |

## Learnings Protocol

Whenever a new finding, gotcha, or decision is captured:

1. **Pick the segment** — route to the correct folder:
   - `packages/` — package management, feeds, sources, restore, dependencies
   - `deploy/` — deployment, scripts, environments, topology
   - `process/` — build process, CI/CD, pipelines, templates, agents
   - `general/` — anything that doesn't fit the above

2. **Write the learning** — create or extend a file in `context/learnings/<segment>/<descriptive-slug>.md`

3. **Update the index** — add an entry to `context/learnings/_index.yaml` under the matching segment with: file, summary (one sentence), date

## Auto-Update

At the start of every session, the agent reads `{{YAAW_HOME}}/../.last-update` to check when skills were last updated. If older than 24 hours, it shows a one-line nudge to run `yaaw update` — but never blocks the session. No shell commands are run during setup.

## Working Agreement

- **Knowledge compounds** — Every unit of work should make subsequent units easier
- **Always record** — Never solve a problem without capturing the learning
- **Incremental** — Extend existing docs rather than creating duplicates
- **Cite sources** — Note which files/configs were read to derive findings
- **Right-size** — Match documentation depth to the complexity of the finding
- **Conventional commits** — Use `feat:`, `fix:`, `refactor:`, `docs:`, `chore:` prefixes
- **No absolute paths** — Always use repo-relative paths in documentation and plans
- **Config-driven** — Read `context/config.yaml` for repo-specific details, never hardcode

## External Knowledge Boundaries

When a task depends on **version-specific external API details** not present in the workspace:

**Proactively verify before writing code when:**
- Using framework/library APIs (method signatures, config keys, expected behaviors)
- Version-sensitive guidance (breaking changes, deprecations, new defaults)
- Security-critical patterns (auth flows, crypto, deserialization)
- Interpreting unfamiliar error messages from third-party tools
- Non-trivial configuration (CLI flags, config files, required headers)

**Key libraries in this codebase requiring care:**
| Library | Version | Risk Area |
|---------|---------|----------|
| Autofac | 3.5.2 | Registration API differs significantly from modern Autofac 6+ |
| Devart dotConnect Oracle | 9.8.838-YAAW | Custom fork — public docs may not match |
| Quartz.NET | 2.3.2 | Old API — modern Quartz 3+ examples won't work |
| xUnit | 1.9.2 | Pre-2.0 API — `[Fact]` exists but many modern patterns don't |
| ASP.NET Web API 2 | 5.2.3 | Not ASP.NET Core — routing, DI, middleware all different |
| SignalR | Legacy (.NET Framework) | Not ASP.NET Core SignalR — different hub API |
| NLog | 4.2.0 | Older config patterns — verify before using newer features |
| Newtonsoft.Json | 13.0.2 | Current — but System.Text.Json patterns don't apply here |

**When uncertain:**
1. State what you're unsure about
2. Proceed with the most conservative/safe assumption
3. Label the assumption explicitly in code comments or learnings
4. Suggest a validation step (build, test, or manual check)

**Never:**
- Hallucinate API signatures — if unsure, say so
- Apply generic framework advice that conflicts with this repository's declared stack
- Assume public NuGet.org docs apply to `-YAAW` suffixed custom packages

## Per-Repo Skill Overrides

Repos can customize skill behavior without forking skills. If `context/skill-overrides.yaml` exists, read it during setup and apply overrides.

**Format:**
```yaml
overrides:
  yaaw-build:
    build_tool: "dotnet build"  # override for modern repos
    test_command: "dotnet test"
  yaaw-work:
    worktrees: false  # disable worktree creation
  yaaw-caveman:
    default: true  # caveman mode on by default
```

**Rules:**
- Overrides only affect behavior parameters, not safety gates
- Gates (TDD, branch checks, approval) cannot be overridden
- If a skill reads an override, it notes it in session log
- Unknown override keys are silently ignored
