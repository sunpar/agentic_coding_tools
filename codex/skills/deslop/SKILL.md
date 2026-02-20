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

1. Decorative comment separators: remove divider comments like `# --------`, `// ========`, and other visual filler.
2. Self-evident/verbose comments: remove comments that merely narrate obvious code behavior.
3. Redundant docstrings: remove docstrings that only restate the function/class name without useful detail.
4. Type escape hatches: remove `any`/`Any` workarounds when a concrete type is straightforward (prioritize TypeScript `any`).
5. Overly verbose variable names: shorten names that are unnecessarily long while keeping clarity.
6. Over-defensive code: remove abnormal guard clauses/try-catch blocks in trusted code paths.
7. Style inconsistencies: align naming, formatting, and structure to nearby code.
8. Unnecessary abstractions: inline one-off helpers that add indirection without reuse.
9. Verbose error handling: remove catch/rethrow or logging-only catches that add no value.

## Decision Rules

- Preserve behavior; de-slop is cleanup, not feature redesign.
- Preserve meaningful documentation (non-obvious rationale, constraints, API contracts, and caveats).
- Prefer the smallest possible diff that resolves the issue.
- If a pattern is ambiguous, leave it and note it rather than over-editing.
- Respect existing project conventions and lint/type constraints.

## Output

After cleanup, report a 1-3 sentence summary of what changed.
If no slop is found, state that explicitly in 1 sentence.
