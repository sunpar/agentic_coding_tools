# Deprecation Map

This document defines old capability names and their canonical replacements for Core v1 alignment across Cursor, Claude, and Codex.

## Scope

- Date: February 13, 2026
- Canonical source: `COMMON_CORE.md`
- Goal: migrate invocations to shared canonical names before custom capability cleanup

## Status Legend

- `Active Alias`: old name still works, but canonical name should be used for new usage.
- `Planned Deprecation`: old name is still present; migrate callers now, then remove old name later.

## Mappings

| Platform | Old Name | Canonical Name | Status | Notes |
|---|---|---|---|---|
| Cursor | `explain-feature` | `feature-summary` | `Active Alias` | Alias delegates to `feature-summary`; use canonical name in new usage. |
| Cursor | `review` | `code-review-personal` | `Active Alias` | Alias delegates to `code-review-personal`; use canonical name in new usage. |
| Cursor | `summarize-for-future-me` | `feature-summary` | `Active Alias` | Alias delegates to `feature-summary`; use canonical name in new usage. |
| Cursor | `lightweight-code-review` | `code-review-personal` | `Active Alias` | Alias delegates to `code-review-personal`; keep lighter format via prompt style. |

## Migration Rules

1. For all new automation/docs/prompts, use canonical names only.
2. Keep aliases until downstream usages are migrated.
3. Remove deprecated names only after repo-wide search confirms no active references.

## Suggested Validation Command

```bash
rg -n "explain-feature|review|summarize-for-future-me|lightweight-code-review" cursor claude codex
```
