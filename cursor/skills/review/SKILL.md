---
name: review
description: Alias for `code-review-personal` (kept for backward compatibility)
disable-model-invocation: true
---

# review (Alias)

This skill is a compatibility alias. Delegate to `code-review-personal` for the review workflow.

## Alias Behavior

1. Execute `code-review-personal`.
2. Preserve severity ordering and final verdict from canonical output.

## Migration Note

Prefer invoking `code-review-personal` directly in new prompts, docs, and automations.
