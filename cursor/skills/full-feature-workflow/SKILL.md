---
name: full-feature-workflow
description: Execute a full feature workflow by chaining feature development, tests, feature summaries, selective cleanup, personal review artifacts, and review-feedback triage when external feedback is available.
disable-model-invocation: true
---

# Full Feature Workflow

Execute these steps in order:

1. Determine git repository root.
2. Run `feature-dev` for the provided feature request.
3. Run `write-tests` for the implemented feature.
4. Run `feature-summary` with output path `{git-root}/docs/feature-summary.md`.
5. Run `code-review-personal` (it will load context from `docs/feature-summary.md`) and implement high-value low-risk cleanups.
6. Run `feature-summary` again with output path `{git-root}/docs/feature-summary-2.md`.
7. Run `code-review-personal` using updated context from `docs/feature-summary*.md` and save review to `{git-root}/docs/code-review-personal.md`.
8. Run `review-feedback-orchestrator` using `{git-root}/docs/code-review-personal.md` from Step 7 as the primary review source (append PR comments or pasted notes if available), then save output to `{git-root}/docs/review-feedback-resolution.md`.

## Rules

- Preserve sequence; do not skip steps without explicit user approval.
- Keep generated documentation artifacts concrete and file-backed.
- Prefer minimal-risk implementation decisions while improving clarity and quality.
- The final review-feedback step should always use `{git-root}/docs/code-review-personal.md` from Step 7, then include any additional external reviewer feedback when available.
