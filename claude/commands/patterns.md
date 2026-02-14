# Refactoring Patterns (Lean Index)

Use this command as a lightweight selector during refactor work.
Do not load the full pattern catalog by default.

## How to Use

1. Start from the current diff and identify the highest-impact smell.
2. Pick one pattern category below.
3. Apply only behavior-preserving changes.
4. If you need concrete before/after examples, load the extended reference file.

## Pattern Categories

- Simplify control flow: guard clauses, extracted predicates, early returns.
- Remove duplication: extract function/hook/helper, centralize shared literals.
- Improve data modeling: typed objects over ad hoc dictionaries, clearer interfaces.
- Improve readability: naming cleanup, smaller functions, flatter branching.
- Keep performance stable: avoid accidental N+1 loops and repeated expensive work.

## Extended Reference

Load detailed examples only when needed:

```
.claude/references/refactor-patterns.md
```
