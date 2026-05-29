---
name: yaaw-stack-constraints
description: "Keeps agents aligned to the repository's declared stack, tooling, and conventions before writing code. This passive skill is always active and should be read before implementation so generic advice does not override project-specific context."
argument-hint: "[none - always active]"
---

# YAAW Stack Constraints

This skill is **always active**. Before writing code, the agent must identify the repository stack, tooling, and conventions from `context/config.yaml`, `AGENTS.md`, and nearby project files.

## Stack Detection

Read `context/config.yaml` first. If it does not declare the stack clearly, infer it from the repository:

- Project manifests such as `package.json`, `.csproj`, `pom.xml`, `pyproject.toml`, `go.mod`, or equivalent files
- Build and test scripts in `scripts/`, pipeline YAML, or package manager scripts
- Existing source layout, naming conventions, test framework, dependency manager, and deployment model

## Rules

- Follow the repo's existing language version, framework, package manager, and build tool.
- Prefer local helper APIs, patterns, and conventions over generic framework advice.
- Do not introduce new architecture, dependencies, or tooling unless the plan explicitly calls for it.
- When adding files, mirror local directory structure, naming, formatting, and test placement.
- Verify changes with the repo's documented build and test command.
- If the stack is ambiguous, stop and ask or run discovery before implementing.

## Package And Dependency Changes

- Use the package manager already used by the repository.
- Keep dependency versions aligned with existing lockfiles, central version files, or workspace manifests.
- Do not change package sources, registries, feeds, or credentials as part of an unrelated task.
- Explain why a new dependency is needed before adding it.

## Configuration Changes

- Treat config files as part of the product contract.
- Preserve environment-specific settings and existing comments.
- Do not rename keys, change defaults, or move configuration unless the task requires it.
- If a convention is captured in `context/learnings/`, follow it and update the learning only when the convention changes.

## Output Expectations

When this skill affects a decision, briefly state the stack constraint in the work log or handoff, for example:

> Followed existing npm scripts and Playwright test layout from this repo instead of adding a new test runner.