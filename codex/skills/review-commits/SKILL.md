---
name: review-commits
description: Review specific commits for quality and correctness using commit logs and per-commit diffs.
---

# Review Commits

## Input

Provide the commit range or SHA to review (for example `HEAD~3..HEAD` or a specific SHA).

## Steps

1. Run `git log <range> --oneline` to list commits.
2. Run `git show <sha>` for each commit to inspect diffs.
3. Review each commit for:
   - Clear, descriptive commit message
   - Focused, single-purpose change
   - No unrelated changes bundled in
   - Tests included if behavior changed
   - No sensitive data committed

## Output

For each commit include:

- SHA: short hash
- Message quality: Good or Needs improvement
- Change quality: assessment of code changes
- Issues: problems found
