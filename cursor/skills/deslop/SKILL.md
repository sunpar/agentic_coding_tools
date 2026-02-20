---
name: deslop
description: Remove AI code slop
disable-model-invocation: true
---

# Remove AI code slop

Check the diff against main, and remove all AI generated slop introduced in this branch.

This includes:
- Decorative comment separators (for example `# --------` or `// ========`)
- Self-evident or overly verbose comments that just narrate obvious code
- Redundant docstrings that only restate function/class names without useful detail
- TypeScript `any` (and similar type escape hatches) added to bypass type safety
- Overly verbose variable names that can be shortened without losing clarity
- Extra defensive checks or try/catch blocks that are abnormal for that area of the codebase (especially if called by trusted / validated codepaths)
- Any other style that is inconsistent with the file

Preserve meaningful documentation (non-obvious rationale, constraints, API behavior, caveats).

Report at the end with only a 1-3 sentence summary of what you changed
