# TASKS.md Format Reference

Use this file as the canonical shape for generated `TASKS.md` files.

## Required Section Order

1. Title
2. Task/tier count summary line
3. Dependency graph
4. Tier sections with task cards
5. Verification tier
6. Summary tables

## Required Top Header

```md
# <Feature Name> - Implementation Tasks

<N> tasks organized into <M> tiers for maximum parallelism. Backend and frontend tracks are independent until final verification.
```

Use an equivalent second sentence only when the feature is backend-only or frontend-only.

## Dependency Graph Block

Include:

- `## Dependency Graph`
- one fenced code block
- a tier-by-tier graph using task IDs and arrows
- clear parallel groups per tier

## Tier Section Contract

Each tier must include:

```md
## TIER <n> - <Tier Name>

<Dependency summary sentence>

---

### T<x>: <Area>: <Task title>

| Field | Value |
|-------|-------|
| Blocked by | ... |
| Blocks | ... |
| Files | ... |
| Reference | ... |

<Implementation bullets>
```

Task ID rules:

- Start at `T1`
- Increment by 1 with no gaps
- Use IDs globally across all tiers

Dependency rules:

- `Blocked by` must reference earlier task IDs only
- `Blocks` must reference later task IDs only
- Use `(none)` when no dependency exists

## Required Tier Coverage

Prefer this default tier model:

1. Foundation
2. Services/Hooks/Parsers
3. Routes/Components
4. Integration/Assembly
5. Tests
6. Verification

Use a different count only when source scope clearly demands it.

## Verification Task Contract

Final tier must contain one full verification task with:

- backend checks (`ruff`, `ruff format --check`, `pylint`, `pytest`, optional `alembic upgrade head`)
- frontend checks (`npm run build`, `npm test`)
- integration sanity checklist tied to feature behavior

## Summary Contract

Always end with `## Summary` and include:

1. Tier summary table (`Tier`, `Tasks`, `Max Parallel`, `Description`)
2. Total row
3. File impact tables when known:
   - `### Files Created (<n>)`
   - `### Files Modified (<n>)`
   - `### Test Files Created (<n>)` / `### Test Files Modified (<n>)` when applicable

## Batch Generation Behavior

For directory batch mode:

- Generate one `TASKS.md` per feature directory.
- Keep each file scoped to docs in that directory.
- Do not merge multiple features into one backlog unless explicitly requested.
