---
description: Core coding philosophy — functional style, quality, readability, self-documenting code
alwaysApply: true
---

# Coding Preferences

## Functional First

- Prefer **pure functions** with explicit inputs and outputs over stateful methods and side effects.
- Use **immutable data** by default. Mutate only when there is a clear performance or API requirement.
- Favor **declarative constructs** — `map`, `filter`, `reduce`, comprehensions, pipelines — over imperative loops with mutable accumulators.
- Compose small, focused functions rather than building large procedural blocks.
- Avoid classes when a module of functions and types achieves the same goal with less ceremony.
- When a class is warranted, keep it small and give it a single responsibility.

## Quality Over Quantity

- Write **the minimum code that solves the actual problem**. Every line should justify its existence.
- Do not add speculative features, optional parameters "for later", or abstractions that serve only one call site.
- Prefer deleting dead code over commenting it out. Version control is the archive.
- A smaller, correct diff is always better than a large, "improved" diff that bundles unrelated changes.

## Readability and Self-Documenting Code

- **Names are documentation**. Variables, functions, types, and modules should describe their purpose so clearly that a reader rarely needs a comment.
  - Functions: verb phrases — `parse_transaction`, `calculateRunningBalance`, `fetchUserAccounts`.
  - Booleans: natural predicates — `is_valid`, `hasPermission`, `shouldRetry`.
  - Collections: plural nouns — `transactions`, `userIds`, `pendingJobs`.
  - Constants: `UPPER_SNAKE_CASE` in Python, `UPPER_SNAKE_CASE` or clear `camelCase` in TypeScript depending on project convention.
- **Avoid abbreviations** unless they are universally understood (`id`, `url`, `config`). Spell out domain terms.
- Keep functions short enough to read without scrolling. If a function needs a "sections" comment, it should be split.
- Prefer **early returns** and guard clauses over deeply nested `if/else` trees.
- Structure code so that the **happy path reads top-to-bottom** with minimal indentation.
- Add comments only when the *why* is not obvious from the code. Never comment *what* the code does — the code already says that.

## Error Handling

- Handle errors at **system boundaries** (user input, network, file I/O). Trust internal code and framework guarantees.
- Use typed error representations (custom exceptions, result types, discriminated unions) over generic catch-all handling.
- Never swallow errors silently. Either handle them meaningfully or propagate them with context.

## Code Organization

- Group code by **feature or domain**, not by technical layer (e.g., keep a feature's types, logic, and tests together).
- Keep files focused. One module should do one thing well.
- Prefer explicit imports over barrel files or wildcard re-exports.
