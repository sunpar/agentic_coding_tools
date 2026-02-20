# TASKS.md Generator

Generate implementation-ready `TASKS.md` files from planning documents.

## Quick Start

1. Accept one input path from the user (file or directory).
2. Run `python3 .claude/scripts/discover_targets.py <path>` to resolve the feature directories to process.
3. For each target, read the source planning docs and create/update `TASKS.md` in that directory.
4. Validate each output with `python3 .claude/scripts/validate_tasks_md.py <target>/TASKS.md`.

## Input Modes

### 1) Single Document Mode

Use when the path is one markdown planning file.

- Treat the file's parent directory as the feature directory.
- Create/update `<parent>/TASKS.md`.
- Prioritize that file, then include companion docs in the same directory.

### 2) Feature Directory Mode

Use when the path is one feature folder (for example `docs/login`).

- Create/update `<dir>/TASKS.md`.
- Load docs in this order when present:
  1. `PRD.md`
  2. `USER_FLOW.md`
  3. `BACKEND_ARCHITECTURE.md`
  4. `FRONTEND_DESIGN.md`
  5. `README.md`
  6. Any other `.md` files except `TASKS.md`

### 3) Batch Directory Mode

Use when the path is a parent docs folder with multiple feature directories.

- Detect child directories that contain planning docs.
- Generate one `TASKS.md` per detected feature directory.
- Skip directories with no planning docs unless the user explicitly asks otherwise.

## Build Rules

1. Derive scope only from source docs.
2. Split backend and frontend tracks when independent.
3. Assign global task IDs (`T1`, `T2`, …) in strict execution order.
4. Group tasks into tiers to maximize safe parallel work.
5. Ensure every dependency points backward (`Blocked by` only references earlier tasks).
6. Include explicit testing/verification tasks.

## Required Output Contract

Follow `.claude/references/tasks_format.md`.

Every generated `TASKS.md` must include, in order:

1. `# <Feature Name> - Implementation Tasks`
2. `<N> tasks organized into <M> tiers ...`
3. `## Dependency Graph` with an ASCII graph in a fenced code block
4. Tier sections (`## TIER <n> - <name>`) with task cards
5. `## Summary` with tier and file-impact tables

Each task must include:

- Header: `### T<n>: <area>: <title>`
- Metadata table containing at least:
  - `Blocked by`
  - `Blocks`
  - `Files`
  - `Reference` (when source references exist)
- Concrete implementation bullets (contracts, model/schema changes, tests, edge cases)

## Guardrails

- Preserve source intent; do not invent features.
- Keep tasks implementation-ready and testable.
- Prefer additive changes; call out migrations where needed.
- Keep dependency graph acyclic and explicit.
- Keep outputs deterministic for identical inputs.

## Validation

Run after writing each file:

```bash
python3 .claude/scripts/validate_tasks_md.py <path-to-TASKS.md>
```

If validation fails, fix ordering, numbering, missing sections, or malformed references.
