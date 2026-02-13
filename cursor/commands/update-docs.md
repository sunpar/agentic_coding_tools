Update project documentation to reflect the latest development work.

You MUST use:
- The current repository state (git diff/changes)
- The current chat history
- Any relevant open files / recently changed files

Your goal is to update these docs as necessary (small diffs, only what changed):
- `docs/ARCHITECTURE.md`
- `docs/DATA_MODEL.md`
- `docs/DECISIONS.md`
- `AGENTS.md`
- `README.md`
- `TODO.md`
- `backend/app/pipeline/README.md`

## Guardrails (non-negotiable)
- Treat personal finance data as sensitive: do NOT add raw spend transactions, merchant strings, amounts, dates, `raw_fields`, CSV bytes, account numbers, or example payloads that look like real user data.
- Prefer concise edits over rewrites; keep structure consistent with each doc.
- Don’t invent endpoints/schemas/behavior—derive everything from the code + tests + commit history in the working tree.
- If nothing materially changed for a doc, leave it unchanged.

## What to inspect (in order)
1. **What changed**: use `git status` + `git diff` (+ optionally `git log -n 10`) to understand what was developed.
2. **What the user asked for / decisions made**: summarize relevant requirements/constraints from the chat.
3. **Touchpoints**: identify which layers changed (frontend, backend, pipeline, DB migrations, docs, infra).

## Update checklist by document
### `docs/ARCHITECTURE.md`
- Update the “Key components” bullets only if components, responsibilities, or flows changed.
- Update the mermaid diagram if a new service/API route/domain boundary was introduced or removed.
- Keep (and extend if needed) the Spend privacy boundary section; ensure it points to the correct code locations.

### `docs/DATA_MODEL.md`
- If any migrations/models changed, reflect new/changed tables, constraints, and relationships.
- If Spend persistence progressed, move statements from “in progress / not landed” to accurate current state.
- Avoid including sensitive sample rows; prefer describing columns/keys at a high level.

### `docs/DECISIONS.md`
- Add or adjust bullets only for meaningful decisions (tech choice, API contract, privacy posture, data model invariants, UX contract).
- Write decisions as “why this approach” and record constraints/tradeoffs.
- If you changed privacy logging/error behavior, ensure the decision reflects the current contract.

### `AGENTS.md`
- Keep it short and operational.
- Ensure commands are accurate (especially frontend checks scripts vs reality in `frontend/package.json`).
- Reinforce spend privacy boundaries and point to the canonical utilities/wrappers.

### `README.md`
- Keep Quickstart accurate: setup steps, ports, env files, and how to run backend/frontend.
- Update “Documentation” and Spend notes if new docs/paths are introduced.
- Do not add machine-specific commands/paths unless they are already a deliberate convention.

### `TODO.md`
- Update roadmap items to match what is now done vs what remains.
- Prefer checklists with clear next steps; remove or mark obsolete items.

### `backend/app/pipeline/README.md`
- If pipeline behavior changed (new pipelines, config changes, CLI flags), update usage and rules.
- Ensure any “Spend (WIP)” references remain accurate and consistent with Spend’s intentional isolation.

## Output expectations
- Make only the minimal doc edits required to reflect the new development.
- After edits, ensure docs are internally consistent (terminology, endpoints, paths).
- In your final response, list:
  - Which files changed
  - 1–2 bullets per file describing what changed and why
