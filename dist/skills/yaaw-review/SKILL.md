---
name: yaaw-review
description: "Self-review code changes before pushing. Checks correctness, maintainability, security, tests, regressions, project-specific gotchas, and completeness."
argument-hint: "[optional: diff or focus area]"
---

# YAAW Review

Review the current changes as if blocking your own PR.

## Process

1. Read the approved plan and work log.
2. Inspect the diff and affected tests.
3. Verify build/test evidence exists.
4. Look for correctness, security, reliability, performance, and maintainability issues.
5. Return findings first, ordered by severity.

## Output

Use:

- Blockers
- Non-blocking issues
- Test gaps
- Residual risk
- Ready-to-paste `/yaaw-commit` prompt when clean