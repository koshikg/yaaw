---
name: yaaw-crossrepo
description: "Coordinate changes across related repositories using yaaw_workspace_root and repo context. Use for dependency updates, shared templates, API contracts, generated clients, synchronized releases, or impact analysis across sibling repos."
argument-hint: "[change or dependency to coordinate]"
---

# YAAW Cross-Repo

Use this skill when a change may affect more than one repository.

## Process

1. Read `context/config.yaml` and `yaaw_workspace_root`.
2. Identify producer and consumer repos from config, manifests, package references, imports, API clients, or pipeline templates.
3. Inspect only the sibling repos needed to understand the impact.
4. Produce an ordered rollout plan with verification commands for each repo.
5. Note missing repos as uncertainty, not blockers.

## Output

Provide:

- Affected repos
- Change direction and dependency flow
- Required order of operations
- Verification commands per repo
- Risks and rollback notes