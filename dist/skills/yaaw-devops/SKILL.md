---
name: yaaw-devops
description: "Work with DevOps systems such as pull requests, work items, builds, releases, artifacts, and variable groups. Use the repository's configured provider and commands instead of assuming a specific organization."
argument-hint: "[DevOps task or query]"
---

# YAAW DevOps

Use this skill for operational workflow tasks around PRs, work items, builds, releases, and artifacts.

## Rules

- Read `context/config.yaml` for DevOps provider, project, repo, pipeline, and auth assumptions.
- Prefer read-only commands unless the user explicitly asks to mutate remote state.
- Never print tokens, PATs, connection strings, or secret variable values.
- Summarize IDs, URLs, states, failures, and next actions.

## Common Tasks

- List or inspect pull requests
- Check build or release status
- Find work items tied to a branch or commit
- Trace artifact versions
- Review pipeline variables without exposing secrets