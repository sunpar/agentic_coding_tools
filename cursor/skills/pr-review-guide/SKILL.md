---
name: pr-review-guide
description: Generate a single PR review guide from a feature docs directory and current git change scope.
disable-model-invocation: true
---

# PR Review Guide Generator

## Input

- Docs directory argument (for example `docs/login`).

## Workflow

1. Find git root and resolve docs directory path.
2. Read all Markdown files in the docs directory using this priority:
   - Design docs (`PRD.md`, `README.md`, `USER_FLOW.md`, `ARCHITECTURE.md`)
   - Task breakdown (`TASKS.md`)
   - Post-refactor summaries (`T*-feature-summary-2.md`)
   - Review notes (`T*-code-review-personal.md`)
   - Pre-refactor summaries (`T*-feature-summary.md`) if no post-refactor summary exists
   - Refactor analyses (`T*-refactor.md`)
3. Run `git diff --stat main` and `git status --short` to size the implementation.
4. Synthesize one reviewer-ready document with concrete details.

## Required Sections

1. What Was Built
2. Design Decisions
3. Files Overview
4. Security Review Checklist
5. API Endpoints Summary
6. Frontend Route Architecture
7. Test Coverage
8. Known Gaps and Deferred Items
9. Deployment Notes
10. How to Review

## Save Output

Write the result to `{docs-dir}/PR_REVIEW_GUIDE.md`.

## Notes

- If design docs are missing, reconstruct intent from summaries and git diff.
- Skip non-applicable sections instead of leaving empty placeholders.
- Keep security checklist feature-specific and verifiable.
