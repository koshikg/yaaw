# YAAW Skills

**YAAW** stands for **yet another agentic workflow**. It is pronounced **yaw**, rhyming with **saw**.

YAAW is a tool that prepares any repo for human+AI collaboration with reusable skills, structured conventions, and compound memory that ensures no discovery and findings go to waste.

## What It Does

YAAW installs a shared CLI and skill library, then scaffolds each repository with a committed `context/` knowledge base and generated agent router files. Agents use that context to understand the repo, follow local conventions, plan work, execute safely, review changes, and preserve new learnings.

## First-Time Setup

Paste in PowerShell after cloning this repository to your machine:

```powershell
git config --global credential.useHttpPath true; $y="$env:USERPROFILE\.yaaw"; if (Get-Command yaaw -ErrorAction SilentlyContinue) { yaaw help } elseif (Test-Path "$y\install.ps1") { & "$y\install.ps1" } elseif (Test-Path $y) { throw "$y already exists but is not a yaaw-skills checkout. Rename or remove it, then run setup again." } else { git clone https://github.com/koshikg/yaaw.git $y; if ($LASTEXITCODE -ne 0) { throw "git clone failed" }; & "$y\install.ps1" }
```

Restart your terminal, then run this inside any repo you want to prepare:

```powershell
yaaw init
```

## CLI Commands

| Command | What it does |
|---|---|
| `yaaw init` | Sets up the current repo for human+AI collaboration |
| `yaaw update` | Pulls latest skills and refreshes generated router files |
| `yaaw skills` | Lists installed skills and can open the hosted skills browser |
| `yaaw status` | Shows installed version and current repo setup info |
| `yaaw doctor` | Diagnoses profile, path, router, and context setup issues |
| `yaaw reset` | Repairs install and regenerates router files |

## Skills

### Core Workflow

| Skill | Purpose |
|---|---|
| `yaaw-discover` | Investigate a codebase and write durable findings |
| `yaaw-plan` | Create PRDs with references, implementation units, and success criteria |
| `yaaw-work` | Execute approved plans with tests, build checks, work logs, and small commits |
| `yaaw-review` | Self-review changes before pushing |
| `yaaw-commit` | Create conventional commits only after gates are satisfied |

### Utility Skills

| Skill | Purpose |
|---|---|
| `yaaw-build` | Repo-aware build and test verification gate |
| `yaaw-capture` | Record learnings, decisions, and gotchas |
| `yaaw-grillme` | Stress-test plans and requirements through focused questioning |
| `yaaw-caveman` | Compressed communication mode |
| `yaaw-security` | Audit for vulnerabilities and risky data flows |
| `yaaw-techdebt` | Analyze and prioritize technical debt |
| `yaaw-pipeline` | Author and troubleshoot CI/CD pipelines |
| `yaaw-crossrepo` | Coordinate changes across related repositories |
| `yaaw-release` | Generate release notes, changelogs, and PR descriptions |
| `yaaw-doctor` | Diagnose YAAW setup health |
| `yaaw-devops` | Work with DevOps systems and workflow metadata |
| `yaaw-stack-constraints` | Keep agents aligned to repo-specific stack conventions |

## Context Layout

`yaaw init` creates this structure in the target repository:

```text
context/
├── config.yaml
├── _session.md
├── discovery/
├── learnings/
│   └── _index.yaml
├── plans/
└── work/
```

Agents read this context before work and update it when they discover reusable information. This is the compound memory layer that keeps findings from being rediscovered repeatedly.

## Workflow Gates

YAAW makes the collaboration path explicit:

1. Discover the system before changing it.
2. Plan the change and get human approval.
3. Work in small verified units.
4. Review risk and completeness.
5. Commit only when the gates are satisfied.

These gates are defined in `dist/PROCESS.yaml` and reinforced by the generated agent router.

## Generated Router Files

Depending on the selected agent, `yaaw init` can create:

```text
.amazonq/rules/yaaw-agent.md
.github/agents/yaaw.agent.md
```

These router files are generated per developer and should usually be gitignored. The committed `context/` directory is the shared project memory.

## Updating

```powershell
yaaw update
```

Changes to skills, `AGENTS.md`, `PROCESS.yaml`, `SYSTEM.md`, and templates propagate to onboarded repos on update.

## Contributing

All changes to `dist/`, commands, templates, or showcase files should be tested locally before pushing.

Every feature, fix, or behavior change should update `CHANGELOG.md` under `[Unreleased]`.