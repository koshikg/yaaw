---
name: yaaw-capture
description: "Record a learning, decision, gotcha, or solved problem to the knowledge base so it's never re-discovered. Use when the user says 'log this', 'capture this', 'we just learned X', 'that's worth remembering', 'record this decision', or after solving a non-trivial problem. Also auto-triggered by other skills when they encounter something unexpected."
argument-hint: "[brief description of what was learned, or empty to extract from conversation]"
---

# YAAW Capture

Capture learnings, decisions, and solved problems to `context/learnings/` so they compound the team's knowledge. The first time you solve a problem takes research. Document it, and the next occurrence takes minutes.

**Why capture?** Each documented learning compounds your team's knowledge. An agent starting a fresh session should never have to re-discover something that was already learned. The knowledge base is the institutional memory.

## Pre-Conditions

Before capturing:
1. Read `context/_session.md` — context about what work produced this learning
2. Scan `context/learnings/` — check if this learning already exists (avoid duplicates)

## Core Principles

1. **Capture while fresh** — The best time to document a learning is immediately after discovering it. Context fades fast.
2. **One file, one learning** — Each capture produces exactly one markdown file in `context/learnings/`.
3. **Actionable over academic** — Write what someone needs to DO, not just what you observed.
4. **Check for overlap** — If a similar learning exists, update it rather than creating a duplicate.
5. **Right-size** — A gotcha might be 5 lines. A complex solved problem might be 50. Match depth to value.

## Input

<capture_input> #$ARGUMENTS </capture_input>

**If the capture input is empty:** Extract the learning from the current conversation context. Look for:
- A problem that was just solved
- A decision that was just made
- Something unexpected that was discovered
- A pattern that's easy to get wrong

If nothing is obvious, ask: "What did you just learn that's worth capturing for next time?"

## Execution Flow

### Phase 0: Classify the Learning

Determine what type of knowledge this is:

| Type | Description | Template |
|---|---|---|
| **Gotcha** | Something non-obvious that trips people up | Problem → Why it happens → How to avoid |
| **Decision** | A choice made with rationale worth preserving | Context → Options → Decision → Rationale |
| **Solved Problem** | A bug/issue that was diagnosed and fixed | Symptoms → Root Cause → Solution → Prevention |
| **Pattern** | A recurring approach worth standardizing | When to use → How it works → Example |
| **Discovery** | A factual finding about the system | What was found → Where → Implications |

### Phase 1: Check for Overlap

Search `context/learnings/` for existing files that cover the same topic:
- Read filenames for obvious matches
- If a candidate exists, read it and assess overlap:
  - **High overlap** — Same problem/decision, same conclusion → Update the existing file with fresher context
  - **Moderate overlap** — Same area, different angle → Create new file, cross-reference the existing one
  - **No overlap** — Create new file

### Phase 2: Write the Learning

#### File Naming

Use kebab-case, descriptive slugs: `<topic-slug>.md`

Examples:
- `devart-yaaw-suffix-custom-builds.md`
- `full-solution-build-constraint.md`
- `klondite-feed-insecure-http.md`
- `telerik-packages-need-license.md`
- `packages-config-version-mismatch-across-projects.md`

#### Templates by Type

**Gotcha:**
```markdown
# <Short descriptive title>

## The Gotcha
<What trips people up — 1-2 sentences>

## Why It Happens
<Root cause or explanation>

## How to Avoid
<What to do instead>

## Encountered During
<What work produced this learning — link to plan or discovery doc if relevant>
```

**Decision:**
```markdown
# <Decision title>

## Context
<What situation required a decision>

## Options Considered
1. <Option A> — <pros/cons>
2. <Option B> — <pros/cons>

## Decision
<What was chosen>

## Rationale
<Why this option was selected>

## Revisit When
<Conditions that would make this decision worth reconsidering>
```

**Solved Problem:**
```markdown
# <Problem title>

## Symptoms
<What was observed — error messages, behavior>

## Root Cause
<Why it happened>

## Solution
<What fixed it — include specific steps or code if relevant>

## Prevention
<How to avoid this in future>

## Encountered During
<What work produced this learning>
```

**Pattern:**
```markdown
# <Pattern name>

## When to Use
<Conditions where this pattern applies>

## How It Works
<The approach — steps, structure, or conventions>

## Example
<Concrete example from this codebase>

## Why This Way
<Rationale — why not the obvious alternative>
```

**Discovery (factual finding that doesn't fit other types):**
```markdown
# <Finding title>

## What Was Found
<The factual finding>

## Where
<File paths, configs, or areas where this applies>

## Implications
<What this means for future work>

## Source
<How this was discovered — which files were read>
```

### Phase 3: Validate and Write

1. Confirm the learning is actionable — would a future agent benefit from reading this?
2. Write the file to `context/learnings/<slug>.md`
3. If the learning contradicts or extends an existing `context/discovery/` file, update that file too

### Phase 4: Update Session Log

Update `context/_session.md`:
```markdown
## Completed This Session
- [x] Captured learning → `context/learnings/<filename>.md`
```

### Phase 5: Report

Tell the user:
1. What was captured (one-line summary)
2. Where it was stored (file path)
3. Whether any existing docs were updated

## Auto-Capture Triggers

Other skills (yaaw-work, yaaw-review, yaaw-discover) should trigger yaaw-capture when they encounter:

- A non-obvious error that took time to diagnose
- A constraint that isn't documented anywhere
- A decision made during execution that has lasting implications
- A pattern that's easy to get wrong
- Something that contradicts existing documentation

The trigger is lightweight — just write the file directly using the templates above. No need to invoke the full skill flow for auto-captures.

## Quality Bar

A good learning entry:
- Can be understood without reading the full conversation that produced it
- Is specific enough to be actionable (not "be careful with packages")
- Includes the WHY, not just the WHAT
- References specific files or configs when relevant
- Is findable by keyword search (good title, clear language)

A bad learning entry:
- Requires conversation context to understand
- Is too vague to act on
- States the obvious
- Duplicates what's already in `context/discovery/`
- Is so long that nobody will read it
