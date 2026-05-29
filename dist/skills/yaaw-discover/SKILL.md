---
name: yaaw-discover
description: "Investigate and document findings about any repository prepared with YAAW. Use when exploring code, tracing dependencies, mapping build/deploy flows, auditing packages, or answering structural questions that are not already documented."
argument-hint: "[what to investigate]"
---

# YAAW Discover

Use this skill to turn investigation into durable context.

## Process

1. Read `context/config.yaml`, `context/_session.md`, and `context/learnings/_index.yaml`.
2. Search the codebase for the concrete question or behavior.
3. Follow references only as far as needed to answer confidently.
4. Write findings to `context/discovery/` when they are reusable.
5. Update `context/_session.md` with the current understanding and next step.

## Output

Return:

- Answer or finding
- Evidence paths
- Unknowns or assumptions
- Recommended next prompt when planning or implementation should follow