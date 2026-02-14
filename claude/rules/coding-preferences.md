---
description: Coding philosophy — functional, quality over quantity, self-documenting
alwaysApply: true
---

# Coding Preferences

## Functional first
- Prefer pure functions with explicit inputs/outputs over stateful methods
- Default to immutable data; mutate only when required by performance or API constraints
- Favor declarative constructs (`map`, `filter`, comprehensions) over imperative loops with mutable accumulators
- Compose small focused functions; avoid large procedural blocks
- Use classes only when a module of functions and types won't suffice — and keep them single-responsibility

## Quality over quantity
- Write the minimum code that solves the actual problem
- No speculative features, no "just in case" abstractions, no parameters for hypothetical future callers
- Delete dead code — version control is the archive
- Smaller correct diffs beat larger "improved" diffs that bundle unrelated changes

## Self-documenting code
- Names are the primary documentation — if a reader needs a comment to understand what code does, rename things first
- Comments explain *why*, never *what*
- Early returns and guard clauses over nested `if/else`
- Happy path reads top-to-bottom with minimal indentation
- If a function needs section comments, split it into smaller functions
