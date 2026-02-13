---
name: summarize-for-future-me
description: Alias for `feature-summary` with concise future-you framing
disable-model-invocation: true
---

# summarize-for-future-me (Alias)

This skill is a compatibility alias. Delegate to `feature-summary` for the core summary workflow.

## Alias Behavior

1. Execute `feature-summary`.
2. Present results in concise future-you framing:
   - What changed
   - How to run/verify
   - What is next
3. Keep output under 200 lines unless the user asks for more detail.

## Migration Note

Prefer invoking `feature-summary` directly in new prompts, docs, and automations.
