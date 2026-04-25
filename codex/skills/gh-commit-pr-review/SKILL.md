---
name: gh-commit-pr-review
description: Commit and publish local GitHub work with review requests. Use when the user wants Codex to commit staged changes, stage all changes only when nothing is staged, push the current branch, and open a GitHub pull request that tags @codex and @copilot for review.
---

# GitHub Commit PR Review

Use this skill to turn current repository changes into a pushed branch and PR review request.

Prefer delegating the publish operation to the `gh-commit-pr-review-worker` subagent. That worker is configured in `$CODEX_HOME/agents/gh-commit-pr-review-worker.toml` to mirror the local `cheap` profile. If that named subagent is unavailable in the current Codex session, run the same workflow inline.

## Workflow

1. Inspect the repository state in the parent agent:
   - Run `git status --short`.
   - Run `git diff --cached --stat`.
   - Run `git branch --show-current`.
   - Do not proceed on `main` or `master` unless the user explicitly says to publish that branch.

2. Delegate to the cheap worker when available:
   - Spawn `gh-commit-pr-review-worker`.
   - Pass the current repository path, branch, status summary, staged diff stat, any verification commands that were actually run, and this script path.
   - Ask the worker to perform the commit, push, and PR creation using the helper script.
   - Wait for the worker result and report the commit hash and PR URL.

3. If the worker is unavailable, decide the commit message, PR title, and PR body inline:
   - Base them on the staged diff, or on the full working tree if no files are staged yet.
   - Keep the commit message concise and descriptive.
   - Write a PR body with `Summary` and `Test Plan` sections.
   - Include `@codex @copilot please review.` in the PR body.

4. Run the helper script inline only for fallback:

   ```bash
   /path/to/skill/scripts/commit_push_pr.sh \
     --message "feat: add useful behavior" \
     --title "Add useful behavior" \
     --body-file /tmp/pr-body.md
   ```

5. Report the commit hash and PR URL.

## Worker Prompt Shape

Use this compact prompt shape for the subagent:

```text
Use /path/to/skill/SKILL.md to publish the current branch.

Repository: /absolute/repo/path
Branch: branch-name
Status summary:
<git status --short output>

Staged diff stat:
<git diff --cached --stat output, or "No staged changes">

Verification actually run:
<commands and pass/fail output summaries, or "Not run">

Helper script: /path/to/skill/scripts/commit_push_pr.sh

Follow the skill exactly: stage all only if nothing is staged, commit with a descriptive message, push, open a PR, and include @codex and @copilot in the body.
```

## Helper Behavior

The script implements the exact publishing sequence:

- If staged changes already exist, leave the index untouched.
- If nothing is staged, run `git add -A`.
- If there are still no staged changes after that, stop without committing.
- Commit the staged files with the provided message.
- Push the current branch to its upstream, or set upstream with `git push -u origin HEAD`.
- Open a PR with `gh pr create`.

`git` is used for staging, committing, and pushing because `gh` does not stage or commit local files. `gh` is used for GitHub authentication checks and PR creation.

## Safety Rules

- Never stage extra files when any staged changes already exist.
- Never invent a test plan. Use commands that were actually run, or say `Not run`.
- Never include secrets, tokens, raw credentials, or private key material in commit messages or PR bodies.
- If `gh pr create` reports that a PR already exists, show the existing PR URL instead of creating another PR.
