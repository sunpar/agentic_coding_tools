---
name: plan-to-doc-bundle
description: Generate a deterministic 5-file documentation bundle from one planning doc (PRD, user flow, backend architecture, frontend design, tasks) with strict sequencing and quality-gate patching.
---

# Plan to Doc Bundle

## Inputs

- `source_plan_path`
- `output_dir`
- `reference_dirs` for style alignment only
- optional `mode`: `strict` or `standard`

## Ordered outputs

Write exactly in this order:

1. `PRD.md`
2. `USER_FLOW.md`
3. `BACKEND_ARCHITECTURE.md`
4. `FRONTEND_DESIGN.md`
5. `TASKS.md`

Generate `TASKS.md` only after reading the first four generated files.

## Deterministic execution rules

1. Scope lock to source plan requirements and explicit assumptions.
2. No invention of out-of-scope features.
3. Sequential generation in required order.
4. `TASKS.md` depends on docs 1-4.
5. Every task must trace to requirement/flow items.
6. Reruns with unchanged input should be near-idempotent.

## Internal role simulation

1. Planner: extract scope, constraints, non-goals.
2. Product: produce `PRD.md`, `USER_FLOW.md`.
3. Backend: produce `BACKEND_ARCHITECTURE.md`.
4. Frontend: produce `FRONTEND_DESIGN.md`.
5. Delivery: produce `TASKS.md` with dependencies and ordering.

## TASKS.md per-task schema

- `id`
- `title`
- `area` (`backend` | `frontend` | `fullstack`)
- `estimate` (`S` | `M` | `L`)
- `dependencies` (task ids or `none`)
- `acceptance_criteria` (testable bullets)
- `source_refs` (sections from generated docs)

## Quality gate

After generating all files, review and patch only minimally:

1. Contradictions across docs.
2. Missing task acceptance criteria.
3. Dependency ordering errors.
4. Unmapped tasks (no trace).
5. Minimal patch plan.

Apply only that patch plan, then finalize.

## Done criteria

- All five files exist in output dir.
- Order respected.
- `TASKS.md` schema complete.
- No unresolved critical issues from quality gate.
