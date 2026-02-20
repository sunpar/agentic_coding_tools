---
name: tasks-md-generator
description: Generate implementation TASKS.md plans from one design document or from all feature documents in a directory. Use when the user asks to create or refresh TASKS.md, decompose PRD/architecture/UX docs into tiered execution tasks, or batch-generate TASKS.md files that match the existing docs/*/TASKS.md structure.
---

# TASKS.md Generator

## Quick Start

1. Accept one user-provided path (file or directory).
2. Run `python3 .codex/scripts/discover_targets.py <path>` to map input to output target files.
3. Read each target's source docs and write `TASKS.md` in the same directory.
4. Run `python3 .codex/scripts/validate_tasks_md.py <target>/TASKS.md` before finalizing.

## Input Modes

### Single Document Mode

Use when the input path is a single markdown file.

- Treat the file's parent directory as the feature directory.
- Create or update `<parent>/TASKS.md`.
- Prioritize the provided file, then load companion docs in the same folder.

### Feature Directory Mode

Use when the input path is one feature directory (for example `docs/login`).

- Create or update `<dir>/TASKS.md`.
- Load docs in this priority order when present:
  - `PRD.md`
  - `USER_FLOW.md`
  - `BACKEND_ARCHITECTURE.md`
  - `FRONTEND_DESIGN.md`
  - `README.md`
  - any other `.md` files except `TASKS.md`

### Batch Directory Mode

Use when the input path is a parent docs folder containing multiple feature directories.

- Detect child directories that include planning docs.
- Create or update one `TASKS.md` per detected feature directory.
- Skip directories with no planning docs unless explicitly requested.

## Build Process

1. Derive scope from source docs only.
2. Split work into independent backend and frontend tracks where possible.
3. Assign global task IDs (`T1`, `T2`, ... `TN`) in strict execution order.
4. Group tasks into tiers that maximize parallel work.
5. Add dependency edges so each `Blocked by` reference points only to earlier tasks.
6. Include testing and verification tiers as explicit tasks.

## Output Contract

Follow `.codex/references/tasks_format.md` exactly.

Required top-level sections in this order:

1. `# <Feature Name> - Implementation Tasks`
2. `<N> tasks organized into <M> tiers ...`
3. `## Dependency Graph` with ASCII tier graph in a fenced code block
4. Tier sections (`## TIER <n> - <name>`) with task cards
5. `## Summary` with tier table and file impact tables

Required per-task structure:

- Heading: `### T<n>: <area>: <title>`
- Metadata table with at least:
  - `Blocked by`
  - `Blocks`
  - `Files`
  - `Reference` when source references exist
- Concrete implementation bullets (API contracts, model changes, tests, edge cases)

## Guardrails

- Preserve intent from source docs; do not invent features or architecture.
- Keep tasks implementation-ready and testable.
- Prefer additive changes; call out migrations when models/schema change.
- Keep dependencies acyclic and explicit.
- Keep output deterministic: same inputs should yield the same task IDs and tiering.

## Validation

Run structural checks:

```bash
python3 .codex/scripts/validate_tasks_md.py <path-to-TASKS.md>
```

If validation fails, fix ordering, task numbering, missing sections, or bad references.

## References

- `.codex/references/tasks_format.md`: canonical TASKS.md skeleton and constraints.
- `.codex/scripts/discover_targets.py`: target discovery for file, feature-dir, and batch-dir modes.
- `.codex/scripts/validate_tasks_md.py`: structural validator for generated TASKS.md output.
