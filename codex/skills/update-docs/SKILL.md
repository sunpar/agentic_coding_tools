---
name: update-docs
description: Update project documentation to match recent implementation changes by inspecting git status, diffs, and recent commits. Use when the user asks to refresh docs after feature work and wants minimal, accurate updates without inventing behavior.
---

# Update Documentation

## Context To Load

1. Run `git status` and `git diff`.
2. Run `git log -n 10 --oneline`.
3. Identify touched layers: frontend, backend, pipeline, DB migrations, docs, infra.

## Documents To Update (Only If Relevant)

- `docs/ARCHITECTURE.md`
- `docs/DATA_MODEL.md`
- `docs/DECISIONS.md`
- `AGENTS.md`
- `README.md`
- `TODO.md`
- `backend/app/pipeline/README.md`

## Guardrails

- Never add raw spend data, merchant strings, amounts, dates, `raw_fields`, CSV bytes, or account numbers.
- Make minimal edits tied directly to code changes.
- Do not invent endpoints/schemas/contracts.
- Leave unrelated docs unchanged.

## Output

List changed documentation files and provide 1-2 bullets per file describing what changed and why.
