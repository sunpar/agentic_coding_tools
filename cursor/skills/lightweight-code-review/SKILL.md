---
name: lightweight-code-review
description: Alias for `code-review-personal` with concise output formatting
disable-model-invocation: true
---

# lightweight-code-review (Alias)

This skill is a compatibility alias. Delegate to `code-review-personal` for review logic.

## Alias Behavior

1. Execute `code-review-personal`.
2. Condense final output into:
   - Must fix
   - Nice to have
   - Short patch list (file + change)

## Migration Note

Prefer invoking `code-review-personal` directly in new prompts, docs, and automations.
