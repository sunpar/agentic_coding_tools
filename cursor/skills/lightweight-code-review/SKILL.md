---
name: lightweight-code-review
description: lightweight-code-review
disable-model-invocation: true
---

# lightweight-code-review

Review the current diff like a senior engineer:

- correctness, edge cases, types, error handling
- security & privacy footguns (secrets, logging sensitive info)
- maintainability (too much coupling, missing docs, unclear naming)
- performance hotspots only if relevant

Output:
1) "Must fix" list
2) "Nice to have"
3) A short suggested patch list (file + what to change)
