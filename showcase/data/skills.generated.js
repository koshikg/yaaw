window.yaawSkillsData = [
  {
    "name": "yaaw-build",
    "command": "/yaaw-build",
    "group": "Utility",
    "description": "Run the repository's declared build and test verification commands. Use after implementation units, before review, and whenever the user asks to verify a change. Reads context/config.yaml for project-specific commands instead of assuming a stack."
  },
  {
    "name": "yaaw-capture",
    "command": "/yaaw-capture",
    "group": "Utility",
    "description": "Record a learning, decision, gotcha, or solved problem to the knowledge base so it's never re-discovered. Use when the user says 'log this', 'capture this', 'we just learned X', 'that's worth remembering', 'record this decision', or after solving a non-trivial problem. Also auto-triggered by other skills when they encounter something unexpected."
  },
  {
    "name": "yaaw-caveman",
    "command": "/yaaw-caveman",
    "group": "Utility",
    "description": "Ultra-compressed communication mode. Cuts token usage ~75% by dropping filler, articles, and pleasantries while keeping full technical accuracy. Use when user says \"caveman mode\", \"talk like caveman\", \"use caveman\", \"less tokens\", \"be brief\", or invokes /yaaw-caveman."
  },
  {
    "name": "yaaw-commit",
    "command": "/yaaw-commit",
    "group": "Core Workflow",
    "description": "Create conventional commits with proper context and traceability. Use when the user says 'commit this', 'ready to commit', 'commit my changes', or when a logical unit of work is complete and tests pass."
  },
  {
    "name": "yaaw-crossrepo",
    "command": "/yaaw-crossrepo",
    "group": "Utility",
    "description": "Coordinate changes across related repositories using yaaw_workspace_root and repo context. Use for dependency updates, shared templates, API contracts, generated clients, synchronized releases, or impact analysis across sibling repos."
  },
  {
    "name": "yaaw-devops",
    "command": "/yaaw-devops",
    "group": "Utility",
    "description": "Work with DevOps systems such as pull requests, work items, builds, releases, artifacts, and variable groups. Use the repository's configured provider and commands instead of assuming a specific organization."
  },
  {
    "name": "yaaw-discover",
    "command": "/yaaw-discover",
    "group": "Core Workflow",
    "description": "Investigate and document findings about any repository prepared with YAAW. Use when exploring code, tracing dependencies, mapping build/deploy flows, auditing packages, or answering structural questions that are not already documented."
  },
  {
    "name": "yaaw-doctor",
    "command": "/yaaw-doctor",
    "group": "Utility",
    "description": "Diagnose YAAW setup health for the current repository. Checks context files, generated routers, workspace root, install freshness, and common configuration drift."
  },
  {
    "name": "yaaw-grillme",
    "command": "/yaaw-grillme",
    "group": "Utility",
    "description": "Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions \"grill me\"."
  },
  {
    "name": "yaaw-pipeline",
    "command": "/yaaw-pipeline",
    "group": "Utility",
    "description": "Author, review, and troubleshoot CI/CD pipeline definitions for the current repository. Reads repo context before assuming provider, runner, template, or deployment model."
  },
  {
    "name": "yaaw-plan",
    "command": "/yaaw-plan",
    "group": "Core Workflow",
    "description": "Create implementation plans and PRDs from discovery findings. Use before code changes, architecture changes, risky refactors, multi-step work, or whenever requirements need structure."
  },
  {
    "name": "yaaw-release",
    "command": "/yaaw-release",
    "group": "Utility",
    "description": "Generate release notes and changelogs from conventional commits. Drafts PR descriptions using the repo's pull_request_template.md and release-notes-template.md. Use when preparing a PR, creating release notes, or summarizing changes."
  },
  {
    "name": "yaaw-review",
    "command": "/yaaw-review",
    "group": "Core Workflow",
    "description": "Self-review code changes before pushing. Checks correctness, maintainability, security, tests, regressions, project-specific gotchas, and completeness."
  },
  {
    "name": "yaaw-security",
    "command": "/yaaw-security",
    "group": "Utility",
    "description": "Audit code for security vulnerabilities in the current repository. Use for security checks, sensitive changes, public endpoints, auth, secrets, input handling, dependencies, and data flow risk."
  },
  {
    "name": "yaaw-stack-constraints",
    "command": "/yaaw-stack-constraints",
    "group": "Utility",
    "description": "Keeps agents aligned to the repository's declared stack, tooling, and conventions before writing code. This passive skill is always active and should be read before implementation so generic advice does not override project-specific context."
  },
  {
    "name": "yaaw-techdebt",
    "command": "/yaaw-techdebt",
    "group": "Utility",
    "description": "Analyze technical debt in any repository and prioritize it by impact, risk, effort, and timing. Use for code health reviews, modernization planning, recurring bug patterns, or architecture cleanup."
  },
  {
    "name": "yaaw-work",
    "command": "/yaaw-work",
    "group": "Core Workflow",
    "description": "Execute an approved YAAW plan in small verified units. Use after /yaaw-plan approval. Maintains work logs, follows repo conventions, writes tests when appropriate, and runs yaaw-build before declaring units complete."
  }
];
