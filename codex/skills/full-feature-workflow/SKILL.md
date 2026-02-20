---
name: full-feature-workflow
description: Execute a full feature workflow in order by chaining feature development, test writing, feature summaries, refactor analysis, selective refactor implementation, personal code review artifacts, and review-feedback triage when feedback is available. Use when the user wants an end-to-end structured delivery process.
---

# Full Feature Workflow

Execute these steps in order:

1. Determine git repository root.
2. Run the `feature-dev` workflow for the provided feature request.
3. Run the `write-tests` workflow for the implemented feature.
4. Run `feature-summary` and save to `{git-root}/docs/feature-summary.md`.
5. Run `refactor-changes` using feature context and save to `{git-root}/docs/refactor.md`.
6. Read `{git-root}/docs/refactor.md`, choose high-value low-risk refactors, and implement them.
7. Run `feature-summary` again and save to `{git-root}/docs/feature-summary-2.md`.
8. Run `code-review-personal` using updated context and save to `{git-root}/docs/code-review-personal.md`.
9. Run `review-feedback-orchestrator` using `{git-root}/docs/code-review-personal.md` from Step 8 as the primary review source (append PR comments or pasted notes if available). Save output to `{git-root}/docs/review-feedback-resolution.md`.

## Rules

- Preserve sequence; do not skip steps without explicit user approval.
- Keep documentation artifacts concrete and file-backed.
- Prefer minimal-risk implementation decisions while improving clarity and quality.
- Step 9 should always start from `{git-root}/docs/code-review-personal.md` produced in Step 8; include external reviewer feedback as additional input when available.
