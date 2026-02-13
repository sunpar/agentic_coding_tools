---
name: explain-feature
description: /feature-summary — Summarize current feature intent from diff + chat history
disable-model-invocation: true
---

# /feature-summary — Summarize current feature intent from diff + chat history

You are an experienced staff engineer helping document an in-progress feature.

## Context you should load
1) Include **recent conversation**: `@Past Chats` (pull the last relevant chats to capture decisions, goals, and constraints).
2) Prefer **PR diff** when available: `@PR (Diff with Main Branch)`.
3) Otherwise, use **working state diff**: `@Commit (Diff of Working State)`.
4) If needed, also pull `@git` to surface staged/working changes and any referenced files.

## What to produce
Return a crisp, developer-friendly brief with these sections:

**Executive Summary (2–4 sentences)**
- What problem the feature solves, who/what it impacts, and how it changes behavior.

**Scope of Changes**
- High-level modules/packages touched, key files, new types/endpoints/CLI flags/feature flags.
- Data model changes and migrations (schema, seeds, backfills).

**Behavioral Details**
- New/changed user flows and API contracts (inputs/outputs/status codes), config toggles, environment changes.

**Algorithmic / Performance Notes**
- Complexity/perf tradeoffs, caching, concurrency, memory/latency considerations.

**Security / Compliance**
- AuthZ/AuthN changes, PII handling, logging/telemetry implications.

**Risks & Edge Cases**
- Known risks, fallbacks, compat concerns, rollout/rollback plan.

**Testing**
- Tests added/updated, gaps to fill, suggested property-based/fuzz/load tests.

**Open Questions**
- Decisions pending, external dependencies, TODOs.

**Suggested Titles & Descriptions**
- 1–2 candidate **PR titles** (<=72 chars).
- A **PR description** and a conventional-commit-style **commit message**.

## Style & constraints
- Be specific; cite exact symbols/files when helpful.
- Do NOT invent behavior not shown in diff or chat history—if unsure, list as an open question.
- Keep bullets concise; avoid marketing language.

## Inputs to reference explicitly in your analysis
- Recent chats: `@Past Chats`
- Diff (prefer): `@PR (Diff with Main Branch)`
- Diff (fallback): `@Commit (Diff of Working State)`
- Optional: `@git` (to enumerate changed files or staged changes)

Now, generate the summary and save it as "feature_summary.md"
