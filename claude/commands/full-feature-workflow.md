Execute these steps in order. First determine the git repository root, then read and follow each command file exactly:

1. Find the git root directory
2. Read {git-root}/.claude/commands/feature-dev.md and execute it for: $ARGUMENTS
3. Read {git-root}/.claude/commands/write-tests.md and execute it for the feature just implemented
4. Read {git-root}/.claude/commands/feature-summary.md and execute it, saving output to {git-root}/docs/feature-summary.md
5. Read {git-root}/.claude/commands/refactor.md and execute it, linking both {git-root}/docs/feature-summary.md and the original file: $ARGUMENTS and saving output to {git-root}/docs/refactor.md
6. Read {git-root}/docs/refactor.md and decide which refactors offer a good gain in readability, code structure, performance, and brevity and implement them.
7. Read {git-root}/.claude/commands/feature-summary.md and execute it, saving output to {git-root}/docs/feature-summary-2.md
8. Read {git-root}/.claude/commands/code-review-personal.md and execute it, linking both {git-root}/docs/feature-summary-2.md and the original file: $ARGUMENTS and saving output to {git-root}/docs/code-review-personal.md
