# Plan to Doc Bundle

Build a deterministic documentation bundle from one planning document.

## Inputs

- `source_plan_path`
- `output_dir`
- `reference_dirs` (style/alignment only)
- `mode` (optional: `strict` or `standard`)

## Required output sequence

Write files in this strict order:

1. `PRD.md`
2. `USER_FLOW.md`
3. `BACKEND_ARCHITECTURE.md`
4. `FRONTEND_DESIGN.md`
5. `TASKS.md`

`TASKS.md` must be generated only after reading the first 4 generated docs.

## Deterministic rules

1. Scope lock: requirements come from source plan or explicit assumptions.
2. No invention: do not add out-of-scope features.
3. Sequential generation: one file at a time in required order.
4. Dependency rule: task content must derive from docs 1-4.
5. Traceability rule: each task maps to requirements or flow items.
6. Idempotence: unchanged inputs should produce only minimal textual variance.

## Role-based workflow (single-agent compatible)

1. Planner role: extract scope, constraints, non-goals.
2. Product role: write `PRD.md` and `USER_FLOW.md`.
3. Backend role: write `BACKEND_ARCHITECTURE.md`.
4. Frontend role: write `FRONTEND_DESIGN.md`.
5. Delivery role: generate `TASKS.md` with ordering/dependencies.

## TASKS.md schema (required per task)

- `id`
- `title`
- `area` (`backend` | `frontend` | `fullstack`)
- `estimate` (`S` | `M` | `L`)
- `dependencies` (task ids or `none`)
- `acceptance_criteria` (testable bullets)
- `source_refs` (section refs to generated docs)

## Quality gate (must run before completion)

Return:

1. Contradictions across the five docs.
2. Missing acceptance criteria in tasks.
3. Dependency ordering errors.
4. Unmapped tasks.
5. Minimal patch plan.

Apply only that patch plan and finalize.

## Completion criteria

- All five files exist in `output_dir`.
- Order contract was followed.
- `TASKS.md` contains required schema fields.
- No unresolved critical quality-gate issues.
