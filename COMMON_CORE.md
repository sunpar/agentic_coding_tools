# Common Core Capabilities

This file defines the shared, canonical capability names that should remain aligned across Cursor, Claude, and Codex.

## Core v1 names

- `deslop`
- `update-docs`
- `feature-dev`
- `feature-summary`
- `write-tests`
- `full-feature-workflow`
- `pr-review-guide`
- `code-review-personal`
- `review-commits`

## Platform mapping

| Canonical name | Cursor | Claude | Codex |
|---|---|---|---|
| `deslop` | `cursor/skills/deslop/SKILL.md` | `claude/commands/deslop.md` | `codex/skills/deslop/SKILL.md` |
| `update-docs` | `cursor/commands/update-docs.md` | `claude/commands/update-docs.md` | `codex/skills/update-docs/SKILL.md` |
| `feature-dev` | `cursor/skills/feature-dev/SKILL.md` | `claude/commands/feature-dev.md` | `codex/skills/feature-dev/SKILL.md` |
| `feature-summary` | `cursor/skills/feature-summary/SKILL.md` | `claude/commands/feature-summary.md` | `codex/skills/feature-summary/SKILL.md` |
| `write-tests` | `cursor/skills/write-tests/SKILL.md` | `claude/commands/write-tests.md` | `codex/skills/write-tests/SKILL.md` |
| `full-feature-workflow` | `cursor/skills/full-feature-workflow/SKILL.md` | `claude/commands/full-feature-workflow.md` | `codex/skills/full-feature-workflow/SKILL.md` |
| `pr-review-guide` | `cursor/skills/pr-review-guide/SKILL.md` | `claude/commands/pr-review-guide.md` | `codex/skills/pr-review-guide/SKILL.md` |
| `code-review-personal` | `cursor/skills/code-review-personal/SKILL.md` | `claude/commands/code-review-personal.md` (alias to underscore version) | `codex/skills/code-review-personal/SKILL.md` |
| `review-commits` | `cursor/skills/review-commits/SKILL.md` | `claude/commands/review-commits.md` | `codex/skills/review-commits/SKILL.md` |

## Notes

- This intentionally creates a common baseline first; platform-specific custom capabilities remain in place.
- `claude/commands/code-review_personal.md` is preserved for backward compatibility.
- See `DEPRECATION_MAP.md` for old-name migration and alias status.
- If you add new shared capabilities, add them to this file only when all three platforms have matching names and similar intent.
