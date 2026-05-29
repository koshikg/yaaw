---
name: yaaw-work
description: "Execute an approved YAAW plan in small verified units. Use after /yaaw-plan approval. Maintains work logs, follows repo conventions, writes tests when appropriate, and runs yaaw-build before declaring units complete."
argument-hint: "[approved plan path]"
---

# YAAW Work

Implement only approved work.

## Rules

- Read the approved plan, context, and relevant learnings first.
- Do not broaden scope without asking.
- Follow `yaaw-stack-constraints` and the repo's existing patterns.
- Keep a work log in `context/work/`.
- Run targeted tests as units complete.
- Run `yaaw-build` before marking the work complete.
- Stop with a handoff prompt for `/yaaw-review`.

## Output

Maintain:

- Files changed
- Tests added or run
- Build evidence
- Decisions and tradeoffs
- Remaining risk