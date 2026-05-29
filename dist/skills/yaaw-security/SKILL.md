---
name: yaaw-security
description: "Audit code for security vulnerabilities in the current repository. Use for security checks, sensitive changes, public endpoints, auth, secrets, input handling, dependencies, and data flow risk."
argument-hint: "[scope or files to audit]"
---

# YAAW Security

Scan code and configuration for exploitable risk.

## Focus Areas

- Hardcoded secrets and credentials
- Injection risks
- Authentication and authorization gaps
- Unsafe deserialization or parsing
- Sensitive data exposure
- Weak crypto or token handling
- Dependency vulnerabilities
- Insecure defaults in infrastructure and pipelines

## Process

1. Read repo context and threat-relevant discovery notes.
2. Trace user input, secrets, tokens, files, network calls, and persistence paths.
3. Separate exploitable findings from theoretical noise.
4. Rate severity and confidence.
5. Provide concrete remediation and verification steps.

## Output

Lead with findings. Include affected files, exploit path, impact, fix, and confidence.