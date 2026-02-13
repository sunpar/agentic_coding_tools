# Commit and Push

Create a commit from current changes, automatically handle pre-commit failures by fixing issues, push branch, and ensure a PR exists against `origin/main`.

## Input

A required commit message, provided by the user.

## Steps

1. Validate repository state:
   - Run `git rev-parse --abbrev-ref HEAD` and confirm you are not on `main`.
   - Run `git status --short` to confirm there are changes to commit.
   - If there are no changes, stop and report that nothing was committed.

2. Stage and attempt commit:
   - Run `git add -A`.
   - Run `git commit -m "<message>"`.

3. If commit fails due to pre-commit hooks:
   - Read hook output carefully.
   - Fix all reported issues in the working tree (formatting, lint, tests, etc.).
   - Re-stage with `git add -A`.
   - Retry `git commit -m "<message>"`.
   - Repeat until commit succeeds or a blocker is reached.

4. If a blocker remains:
   - Report the exact failing hook/test and why it could not be resolved automatically.
   - Do **not** push.

5. Push branch:
   - Run `git push -u origin <current-branch>` (or `git push` if upstream is already set).

6. Ensure PR exists to `origin/main`:
   - Detect repository owner/name using `gh repo view --json nameWithOwner`.
   - Check for an open PR from current branch with:
     - `gh pr list --head <current-branch> --base main --state open --json number,url`
   - If one exists, report the URL.
   - If none exists, create one with:
     - `gh pr create --base main --head <current-branch> --fill`
     - If `--fill` is insufficient, prompt for title/body and create with explicit values.

## Output

Return:
- Branch name
- Whether a commit was created
- If a commit was created:
  - Commit SHA and message
  - Push result
  - PR status (existing or newly created) and URL
- If no commit was created (e.g., no changes to commit):
  - A message indicating that there were no changes to commit and nothing was pushed
- Any unresolved blockers (if applicable)
