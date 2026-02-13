---
name: refactor-changes
description: Analyze staged and unstaged git changes and refactor for readability, maintainability, and conciseness while preserving behavior. Use when the user asks to refactor recent changes, clean up work in progress, improve code quality, or review a diff for safe structural improvements.
---

# Refactor Changes

## Workflow

1. Run `git status --short` and `git diff HEAD`.
2. Read modified files in full to understand surrounding patterns.
3. Confirm intent from user context and current diff behavior.
4. Evaluate changes in priority order: correctness, clarity, structure, conciseness.
5. Apply minimal, behavior-preserving refactors.

## Refactoring Checklist

- Extract magic numbers/strings into named constants when it improves clarity.
- Rename unclear identifiers to reveal intent.
- Split large functions into focused units.
- Remove duplication and dead code.
- Simplify nested conditionals with guard clauses.
- Consolidate related logic and reduce unnecessary parameters.
- Replace redundant comments with self-documenting code.
- Improve type annotations where ambiguity exists.

## Language Guidance

### Python

- Prefer `X | None` over `Optional[X]`.
- Use context managers for resource handling.
- Use consistent f-string formatting.

### TypeScript/React

- Remove `any` where concrete types are available.
- Split oversized components into focused pieces.
- Extract repeated logic into hooks/utilities only when reused.

## Output Format

Use this structure:

1. Summary (1-2 sentences)
2. Refactorings (what, why, risk, and code-level change)
3. Optional Improvements (lower priority)

## Notes

- Preserve behavior; call out any non-zero risk.
- Focus on changed code first, then adjacent cleanup.
- For extra pattern examples, read `.claude/commands/patterns.md` if present.
