Create a commit from current changes, push the branch, and ensure a pull request exists against `origin/main`.

## Input
- Required: commit message text from the user.

## Steps
1. Validate repo state:
   - Run `git rev-parse --abbrev-ref HEAD` and ensure you are not on `main`.
   - Run `git status --short` and stop if there are no changes.

2. Respect staged work:
   - Check staged files with `git diff --cached --name-only`.
   - If anything is staged, do not stage additional files.
   - If nothing is staged, stage only files that logically belong together (never use `git add -A`).

3. Commit:
   - Run `git commit -m "<message>"`.

4. If pre-commit hooks fail:
   - Fix only the reported issues.
   - Re-stage only files you actually touched while fixing those issues.
   - Retry commit until success or a true blocker.

5. Push:
   - Push with upstream if needed: `git push -u origin <branch>`.

6. Ensure PR:
   - Check for existing PR to `main`; create one if missing.

7. Request reviewer attention:
   - Post a PR comment tagging `@codex` and `@copilot`.

8. Follow-up loop:
   - Sleep 5 minutes (`sleep 300`) then run `/pr-comments`.
   - Repeat up to 5 iterations, or stop early if canceled/stopped by the user.

## Output
- Branch name
- Commit result (sha/message)
- Push result
- PR URL/status
- Whether `@codex` + `@copilot` tag comment was posted
- Follow-up loop status
