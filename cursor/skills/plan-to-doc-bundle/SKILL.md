---
name: plan-to-doc-bundle
description: Convert one planning document into PRD.md, USER_FLOW.md, BACKEND_ARCHITECTURE.md, FRONTEND_DESIGN.md, and TASKS.md in fixed deterministic order with a quality gate and traceability checks.
disable-model-invocation: true
---

# Plan to Doc Bundle

## Inputs

- `source_plan_path`: planning source document.
- `output_dir`: destination directory.
- `reference_dirs`: optional directories for style alignment only.
- `mode`: optional `strict` or `standard`.

## Output contract

Generate files in this exact order:

1. `PRD.md`
2. `USER_FLOW.md`
3. `BACKEND_ARCHITECTURE.md`
4. `FRONTEND_DESIGN.md`
5. `TASKS.md` (must be derived from the first four generated docs)

## Deterministic rules

1. Scope lock: derive requirements only from the source plan, plus explicit assumptions.
2. No invention: do not add out-of-scope features.
3. Sequential generation: write one file at a time in required order.
4. Dependency rule: derive `TASKS.md` from the first 4 generated docs.
5. Traceability: every task maps to at least one requirement or flow item.
6. Idempotence: unchanged inputs should produce minimal textual variance.

## Role simulation workflow

Execute these roles sequentially, even if one model performs all work:

1. **Planner role**: extract scope, constraints, non-goals, assumptions.
2. **Product role**: write `PRD.md`, then `USER_FLOW.md`.
3. **Backend role**: write `BACKEND_ARCHITECTURE.md`.
4. **Frontend role**: write `FRONTEND_DESIGN.md`.
5. **Delivery role**: synthesize `TASKS.md` with ordering and dependencies.

## TASKS.md required schema

Each task must include:

- `id`
- `title`
- `area` (`backend` | `frontend` | `fullstack`)
- `estimate` (`S` | `M` | `L`)
- `dependencies` (task ids or `none`)
- `acceptance_criteria` (testable bullets)
- `source_refs` (references to sections in generated docs)

## Quality gate (required)

After all five files are generated, run a review pass and report:

1. Contradictions across the five docs.
2. Missing acceptance criteria in tasks.
3. Dependency ordering errors.
4. Unmapped tasks (no requirement/flow trace).
5. Minimal patch plan.

Apply only the minimal patch plan, then finalize.

## Completion criteria

Complete only when:

- All five files exist in `output_dir`.
- Generation order was respected.
- `TASKS.md` includes all required schema fields.
- Quality gate has no unresolved critical issues.
