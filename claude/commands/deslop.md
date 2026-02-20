# Remove AI Code Slop

Check the diff against main and remove all AI-generated slop introduced in this branch.

## What to look for and remove

1. **Decorative comment separators** - Divider comments like `# --------` or `// ========` used as visual filler
2. **Self-evident/verbose comments** - Comments that just restate obvious code behavior
3. **Redundant docstrings** - Docstrings that only repeat function/class names without useful detail
4. **Type escape hatches** - Casts to `any` (especially TypeScript) or `Any` (Python) used to bypass type safety
5. **Overly verbose variable names** - Excessively long names that can be shortened while staying clear
6. **Over-defensive code** - Extra try/catch blocks or defensive checks that are abnormal for that area of the codebase, especially if called by trusted/validated codepaths
7. **Style inconsistencies** - Any style that is inconsistent with the surrounding code in the file
8. **Unnecessary abstractions** - Helper functions or classes for one-time operations
9. **Verbose error handling** - Catch blocks that just re-throw or log without adding value

## Steps

1. Run `git diff main...HEAD` to see all changes
2. For each file, compare the new code style against the existing code in that file
3. Remove or simplify any slop found
4. Keep changes minimal - only remove actual slop
5. Preserve meaningful documentation (non-obvious rationale, constraints, API contracts, and caveats)

## Output

After cleanup, report with a 1-3 sentence summary of what was changed.
