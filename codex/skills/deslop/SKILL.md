---
name: deslop
description: Remove AI-generated code slop from the current branch by auditing `git diff main...HEAD` and applying minimal cleanups. Use when a user asks to de-slop a PR/branch, make code look human-written, or remove over-defensive/verbose/generated patterns without changing behavior.
---

# De-Slop Diff

## Workflow

1. Run `git diff main...HEAD` to inspect branch-only changes.
2. Review each changed file against its local style and patterns.
3. Remove only clear slop while preserving behavior and scope.
4. Keep edits minimal and avoid unrelated refactors.

## Remove These Patterns

1. Excessive comments: remove comments that are obvious, redundant, or inconsistent with the file.
2. Over-defensive code: remove abnormal guard clauses/try-catch blocks in trusted code paths.
3. Type escape hatches: remove `any`/`Any` workarounds when a concrete type is straightforward.
4. Style inconsistencies: align naming, formatting, and structure to nearby code.
5. Unnecessary abstractions: inline one-off helpers that add indirection without reuse.
6. Verbose error handling: remove catch/rethrow or logging-only catches that add no value.

## Decision Rules

- Preserve behavior; de-slop is cleanup, not feature redesign.
- Prefer the smallest possible diff that resolves the issue.
- If a pattern is ambiguous, leave it and note it rather than over-editing.
- Respect existing project conventions and lint/type constraints.

## Output

After cleanup, report a 1-3 sentence summary of what changed.
If no slop is found, state that explicitly in 1 sentence.
