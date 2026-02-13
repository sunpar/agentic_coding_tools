# Review Commits

Review specific commits for quality and correctness.

## Input

Provide the commit range or SHA to review (e.g., `HEAD~3..HEAD` or a specific SHA).

## Steps

1. Run `git log <range> --oneline` to list commits
2. Run `git show <sha>` for each commit to see the diff
3. Review each commit for:
   - Clear, descriptive commit message
   - Focused, single-purpose change
   - No unrelated changes bundled in
   - Tests included if behavior changed
   - No sensitive data committed

## Output

For each commit:
- **SHA**: Short hash
- **Message quality**: Good / Needs improvement
- **Change quality**: Assessment of the code changes
- **Issues**: Any problems found
