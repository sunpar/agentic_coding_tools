---
name: code-review-personal
description: Perform a comprehensive branch code review using `git diff main...HEAD`, feature-plan context files, and project conventions. Use when a user asks for a personal/manual PR review, quality gate, or merge-readiness assessment with severity-ranked findings and a final verdict.
---

# Code Review Personal

## Workflow

1. Run `git diff main...HEAD` to inspect all branch changes.
2. Load context from `FEATURE_PLAN.md` or `feature_summary.md` if either exists.
3. Load context from `ORIGINAL_PLAN.md` if it exists.
4. Review all changes against the criteria below.

## Review Criteria

### Functionality

- Verify code matches feature intent from the plan files.
- Check edge-case handling.
- Check error handling appropriateness.
- Flag obvious bugs or behavioral regressions.

### Code Quality

- Check readability, consistency, and organization.
- Prefer single-purpose functions.
- Check naming clarity.
- Enforce project conventions from `CLAUDE.md`.

### Security and Privacy

- Flag any sensitive data logging (raw transactions, account numbers, CSV rows).
- Check input validation where needed.
- Flag hardcoded secrets or credential-like values.

### Performance

- Flag inefficient algorithms or query patterns.
- Flag potential N+1 access patterns.
- Flag unnecessary recomputation or heavy work.

### Tests

- Check whether tests cover new behavior and risk areas.
- Prefer behavior-focused tests over brittle implementation-coupled tests.
- If additional tests are needed, use the `/write-tests` skill.

## Output Format

Provide all sections in this order:

1. Executive Summary (1-2 paragraphs)
2. Findings by Severity (Critical > Major > Minor > Cosmetic)
3. Test Coverage Assessment
4. Final Verdict: `Ready to merge` | `Needs minor cleanup` | `Needs major revisions`

## Ground Rules

- Prioritize findings and risks over praise.
- Keep findings specific and actionable.
- Reference concrete file paths and lines when possible.
- If no findings exist, state that explicitly and note residual risk/testing gaps.
