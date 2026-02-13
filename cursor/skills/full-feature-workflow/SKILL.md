---
name: full-feature-workflow
description: Execute a full feature workflow by chaining feature development, tests, feature summaries, selective cleanup, and personal review artifacts.
disable-model-invocation: true
---

# Full Feature Workflow

Execute these steps in order:

1. Determine git repository root.
2. Run `feature-dev` for the provided feature request.
3. Run `write-tests` for the implemented feature.
4. Run `feature-summary` and save to `{git-root}/docs/feature-summary.md`.
5. Run `lightweight-code-review` and implement high-value low-risk cleanups.
6. Run `feature-summary` again and save to `{git-root}/docs/feature-summary-2.md`.
7. Run `code-review-personal` using updated context and save to `{git-root}/docs/code-review-personal.md`.

## Rules

- Preserve sequence; do not skip steps without explicit user approval.
- Keep generated documentation artifacts concrete and file-backed.
- Prefer minimal-risk implementation decisions while improving clarity and quality.
