# Update Documentation

Update project documentation to reflect the latest development work.

## Context to load

1. Run `git status` and `git diff` to understand what changed
2. Run `git log -n 10 --oneline` for recent commit history
3. Identify which layers changed (frontend, backend, pipeline, DB migrations, docs, infra)

## Documents to update (only if relevant changes occurred)

- `docs/ARCHITECTURE.md` - Component changes, flows, diagrams
- `docs/DATA_MODEL.md` - Schema/model changes, new tables
- `docs/DECISIONS.md` - Tech choices, API contracts, privacy posture
- `AGENTS.md` - Operational commands, privacy boundaries
- `README.md` - Setup steps, ports, env files
- `TODO.md` - Roadmap items done vs remaining
- `backend/app/pipeline/README.md` - Pipeline behavior changes

## Guardrails (non-negotiable)

- Do NOT add raw spend transactions, merchant strings, amounts, dates, `raw_fields`, CSV bytes, account numbers, or example payloads that look like real user data
- Make minimal edits - only what changed
- Don't invent endpoints/schemas - derive from code
- If nothing changed for a doc, leave it unchanged

## Output

List which files changed and 1-2 bullets per file describing what changed and why.
