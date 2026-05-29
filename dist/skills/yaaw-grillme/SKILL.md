---
name: yaaw-grillme
description: >
  Interview the user relentlessly about a plan or design until reaching shared
  understanding, resolving each branch of the decision tree. Use when user wants
  to stress-test a plan, get grilled on their design, or mentions "grill me".
argument-hint: "[plan description or path to draft plan]"
---

# YAAW Grill Me

Interview the user relentlessly about every aspect of a plan until shared understanding is reached. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

## Rules

1. Ask questions **one at a time**
2. For each question, provide your **recommended answer** based on codebase knowledge
3. If a question can be answered by exploring the codebase, **explore the codebase instead of asking**
4. Do not proceed until the user confirms or corrects each answer
5. Track resolved decisions — do not re-ask

## Workflow

### Phase 1: Load Context

1. Read the plan/requirement description provided
2. Read `context/learnings/_index.yaml` for relevant prior knowledge
3. Read relevant `context/discovery/` files
4. Build a mental model of the decision tree

### Phase 2: Interview Loop

```
while (unresolved branches remain):
  - Identify the next unresolved decision
  - Check if codebase exploration can answer it → if yes, explore and present finding
  - If not → ask the user, providing your recommended answer
  - Record the resolution
  - Identify any new branches opened by this decision
```

### Phase 3: Output

Once all branches are resolved, produce a structured summary:

```markdown
## Resolved Decisions

| # | Decision | Resolution | Source |
|---|---|---|---|
| 1 | ... | ... | user / codebase |

## Requirements (confirmed)

- R1. ...
- R2. ...

## Out of Scope (confirmed)

- ...
```

This output feeds directly into the `yaaw-plan` PRD document.

## Integration

This skill is invoked by `yaaw-plan` during Phase 1 (requirements elicitation). It can also be invoked standalone via `/yaaw-grillme`.
