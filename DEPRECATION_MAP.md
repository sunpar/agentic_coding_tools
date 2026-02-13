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
| Claude | `code-review_personal` | `code-review-personal` | `Active Alias` | `claude/commands/code-review-personal.md` routes to underscore version for backward compatibility. |
| Cursor | `explain-feature` | `feature-summary` | `Planned Deprecation` | Both produce branch-level feature summaries; canonical name is shared across all 3 platforms. |
| Cursor | `review` | `code-review-personal` | `Planned Deprecation` | Both are full code-review flows; canonical name is shared across all 3 platforms. |
| Cursor | `summarize-for-future-me` | `feature-summary` | `Planned Deprecation` | Keep output concise via prompt style, but use canonical name for discoverability. |
| Cursor | `lightweight-code-review` | `code-review-personal` | `Planned Deprecation` | For lighter output, invoke canonical name with reduced-depth instructions. |

## Migration Rules

1. For all new automation/docs/prompts, use canonical names only.
2. Keep aliases until downstream usages are migrated.
3. Remove deprecated names only after repo-wide search confirms no active references.

## Suggested Validation Command

```bash
rg -n "code-review_personal|explain-feature|review|summarize-for-future-me|lightweight-code-review" cursor claude codex
```
