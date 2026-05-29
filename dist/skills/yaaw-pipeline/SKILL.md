---
name: yaaw-pipeline
description: "Author, review, and troubleshoot CI/CD pipeline definitions for the current repository. Reads repo context before assuming provider, runner, template, or deployment model."
argument-hint: "[pipeline task or failure]"
---

# YAAW Pipeline

Use this skill for pipeline YAML, build automation, deployment workflows, and CI failures.

## Process

1. Read `context/config.yaml` for provider, pipelines, environments, variables, and deployment notes.
2. Inspect pipeline files and shared templates referenced by the repo.
3. Validate trigger, checkout, credentials, cache, artifact, and deployment behavior.
4. Prefer provider-native validation commands when available.
5. Capture fixes and verification evidence.

## Review Focus

- Secret handling
- Branch and path triggers
- Artifact naming and retention
- Environment approvals
- Reusable template contracts
- Build/test/deploy command correctness