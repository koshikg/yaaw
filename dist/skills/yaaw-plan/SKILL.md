---
name: yaaw-plan
description: "Create implementation plans and PRDs from discovery findings. Use before code changes, architecture changes, risky refactors, multi-step work, or whenever requirements need structure."
argument-hint: "[feature, fix, or problem to plan]"
---

# YAAW Plan

Plan work before implementation.

## Process

1. Read context and relevant discovery findings.
2. Clarify requirements when scope or acceptance criteria are ambiguous.
3. Break the work into small implementation units.
4. Define test, build, review, and documentation gates.
5. Save approved plans under `context/plans/`.

## Plan Format

Include:

- Goal
- Non-goals
- Current evidence
- Implementation units
- Tests and verification
- Risks and rollback
- Ready-to-paste `/yaaw-work` handoff prompt

Do not start implementation until the user approves the plan.