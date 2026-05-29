# YAAW System Context

YAAW stands for **yet another agentic workflow**. It prepares any repository for human+AI collaboration with reusable skills, structured conventions, and compound memory so discoveries and findings become durable context instead of disappearing into chat history.

Pronunciation: **yaw**, rhyming with **saw**.

## Purpose

This file is the generic system context shipped with YAAW. Project-specific facts belong in the onboarded repository's `context/config.yaml`, `context/discovery/`, and `context/learnings/` files.

## Repository Model

A YAAW-enabled repo contains:

| Path | Purpose |
|---|---|
| `context/config.yaml` | Repo identity, stack, build commands, deployment notes, and conventions |
| `context/_session.md` | Current handoff state between AI sessions |
| `context/discovery/` | Investigations and system findings |
| `context/learnings/` | Reusable lessons, gotchas, and decisions |
| `context/plans/` | Approved plans and PRDs |
| `context/work/` | Work logs and execution evidence |

## Operating Principles

- Read repo context before changing files.
- Capture new discoveries as durable context.
- Prefer existing project conventions over generic advice.
- Keep work gated by plan approval, tests, build verification, review, and explicit human approval.
- Treat every finding as reusable knowledge unless it is sensitive or temporary.

## Cross-Repo Context

If `yaaw_workspace_root` is set in `context/config.yaml`, agents may inspect sibling repositories for dependency and workflow context. Missing sibling repos should never block local work; note the missing context and continue with the evidence available.

## Stack Constraints

Use `yaaw-stack-constraints` before implementation. The skill tells agents to follow the repository's declared stack, package manager, build tool, test runner, and local conventions rather than applying generic framework advice.