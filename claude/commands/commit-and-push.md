# Commit and Push

Create a commit from current changes, automatically handle pre-commit failures by fixing issues, push branch, ensure a PR exists against `origin/main`, and run PR comment follow-up checks.

## Input

A required commit message, provided by the user.

## Steps

1. Validate repository state:
   - Run `git rev-parse --abbrev-ref HEAD` and confirm you are not on `main`.
   - Run `git status --short` to confirm there are changes to commit.
   - If there are no changes, stop and report that nothing was committed.

2. Determine staged vs unstaged strategy:
   - Check whether anything is already staged (for example: `git diff --cached --name-only`).
   - If staged files already exist, do **not** stage anything else; proceed with the current staged set.
   - If nothing is staged, stage only files that logically belong together for this commit (never default to `git add -A`).

3. Attempt commit:
   - Run `git commit -m "<message>"`.

4. If commit fails due to pre-commit hooks:
   - Read hook output carefully.
   - Fix all reported issues in the working tree (formatting, lint, tests, etc.).
   - Re-stage only files that were actually fixed/touched while addressing the hook failures (do not broadly stage unrelated files).
   - Retry `git commit -m "<message>"`.
   - Repeat until commit succeeds or a blocker is reached.

5. If a blocker remains:
   - Report the exact failing hook/test and why it could not be resolved automatically.
   - Do **not** push.

6. Push branch:
   - Run `git push -u origin <current-branch>` (or `git push` if upstream is already set).

7. Ensure PR exists to `origin/main`:
   - Detect repository owner/name using `gh repo view --json nameWithOwner`.
   - Check for an open PR from current branch with:
     - `gh pr list --head <current-branch> --base main --state open --json number,url`
   - If one exists, report the URL.
   - If none exists, create one with:
     - `gh pr create --base main --head <current-branch> --fill`
     - If `--fill` is insufficient, prompt for title/body and create with explicit values.

8. PR follow-up loop:
   - After the PR exists/has been created, wait 5 minutes (`sleep 300`).
   - Then run `/pr-comments`.
   - Repeat this wait + `/pr-comments` cycle for up to 5 total iterations.
   - Stop early if the user asks to stop or cancel.

## Output

Return:
- Branch name
- Whether a commit was created
- If a commit was created:
  - Commit SHA and message
  - Push result
  - PR status (existing or newly created) and URL
  - PR follow-up loop status (how many iterations ran and whether stopped early)
- If no commit was created (e.g., no changes to commit):
  - A message indicating that there were no changes to commit and nothing was pushed
- Any unresolved blockers (if applicable)
