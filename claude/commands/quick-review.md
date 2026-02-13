# Quick Review

Lightweight code review focused on critical issues only.

## Steps

1. Run `git diff` to see uncommitted changes (or `git diff main...HEAD` for branch)
2. Focus ONLY on:
   - Security issues (injection, auth bypass, sensitive data exposure)
   - Obvious bugs (null derefs, off-by-one, logic errors)
   - Privacy violations (logging raw transactions, account numbers)
   - Breaking changes to existing behavior

## Output

Keep it brief:
- **Critical issues**: List any blockers (or "None found")
- **Quick suggestions**: 1-3 bullet points max
- **Verdict**: Ship it | Fix first
