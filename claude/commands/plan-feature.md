# Plan Feature

Create an implementation plan for a new feature.

## Required context to load first

Read these files to ground the plan:
- `README.md`, `AGENTS.md`
- `docs/ARCHITECTURE.md`
- `docs/DATA_MODEL.md`
- `docs/DECISIONS.md`
- `docs/spend_transactions/*.md` (if spend-related)

## Output: Create FEATURE_PLAN.md

### Goal
- Restate the feature request in your own words

### Acceptance Tests
- Checklist of verifiable, user-facing acceptance criteria
- Include negative/error cases

### Constraints & Assumptions
- Repo constraints (security/privacy, architecture, backwards compatibility)
- Assumptions made due to ambiguous requirements

### Clarifying Questions (if any)
- Targeted questions if requirements are unclear
- Still produce a plan; mark dependent steps

### Implementation Plan
- Step-by-step, ordered to keep changes small and safe
- Brief architecture notes (why this approach)
- Invariants to preserve

### File-by-File Change List
- Bullet list grouped by `backend/`, `frontend/`, `docs/`
- For each file: what will change and why

### Test Plan
- Exact commands to run
- Unit/integration/e2e considerations
- Quick smoke test sequence

## Quality bar

- Be explicit about edge cases and failure modes
- Prefer incremental delivery (phase 1 minimal, phase 2 enhancements)
- Avoid speculative complexity - smallest thing that meets acceptance tests
