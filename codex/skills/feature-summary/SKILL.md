---
name: feature-summary
description: Create a structured summary of current branch feature work from git diff, commit history, and optional planning files. Use when the user asks for a concise feature write-up suitable for PR context, handoff, or planning alignment.
---

# Feature Summary

## Context To Load

1. Run `git diff main...HEAD`.
2. Run `git log main..HEAD --oneline`.
3. Read `FEATURE_PLAN.md` or `workflow.yml` if present.

## Output File

Create `feature_summary.md` with these sections:

1. Executive Summary (2-4 sentences)
2. Scope of Changes
3. Behavioral Details
4. Security and Privacy
5. Testing
6. Open Questions
7. Suggested PR Title and Description

## Section Expectations

- Describe problem solved, impact, and behavior changes.
- List touched modules/files and new contracts (types, endpoints, flags).
- Document data model/migration and config/env changes.
- Call out auth/authz and sensitive-data/logging implications.
- Include test additions and known gaps.
