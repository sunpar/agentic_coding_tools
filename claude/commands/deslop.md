# Remove AI Code Slop

Check the diff against main and remove all AI-generated slop introduced in this branch.

## What to look for and remove

1. **Excessive comments** - Comments that a human developer wouldn't add, or that are inconsistent with the rest of the file
2. **Over-defensive code** - Extra try/catch blocks or defensive checks that are abnormal for that area of the codebase, especially if called by trusted/validated codepaths
3. **Type escape hatches** - Casts to `any` (TypeScript) or `Any` (Python) added to work around type issues
4. **Style inconsistencies** - Any style that is inconsistent with the surrounding code in the file
5. **Unnecessary abstractions** - Helper functions or classes for one-time operations
6. **Verbose error handling** - Catch blocks that just re-throw or log without adding value

## Steps

1. Run `git diff main...HEAD` to see all changes
2. For each file, compare the new code style against the existing code in that file
3. Remove or simplify any slop found
4. Keep changes minimal - only remove actual slop

## Output

After cleanup, report with a 1-3 sentence summary of what was changed.
