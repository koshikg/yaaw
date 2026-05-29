---
name: yaaw-build
description: "Run the repository's declared build and test verification commands. Use after implementation units, before review, and whenever the user asks to verify a change. Reads context/config.yaml for project-specific commands instead of assuming a stack."
argument-hint: "[optional: what to verify]"
---

# YAAW Build

Verify the current repository using the commands and conventions declared in `context/config.yaml`.

## Process

1. Read `context/config.yaml` for build tool, test command, package manager, and known prerequisites.
2. Inspect repo manifests only when config is missing or stale.
3. Run the smallest command that proves the changed surface.
4. Escalate to broader test/build commands before marking work complete.
5. Capture command, outcome, and evidence in the active work log.

## Output

Report:

- Commands run
- Pass/fail status
- Relevant output summary
- Follow-up fixes if verification failed