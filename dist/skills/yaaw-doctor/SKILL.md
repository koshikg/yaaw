---
name: yaaw-doctor
description: "Diagnose YAAW setup health for the current repository. Checks context files, generated routers, workspace root, install freshness, and common configuration drift."
argument-hint: "[optional: symptom]"
---

# YAAW Doctor

Use this skill when setup feels broken or the user asks for a health check.

## Checks

- `context/config.yaml` exists and has repo identity
- `context/_session.md` exists
- `context/learnings/_index.yaml` exists
- Generated router exists for the selected agent
- Router does not contain unrendered template placeholders
- `yaaw_workspace_root` is present when cross-repo work is expected
- Local install is recent enough or user is nudged to run `yaaw update`

## Output

Report each check as pass, warning, or fail, then give the smallest repair command such as `yaaw init`, `yaaw update`, or `yaaw reset`.