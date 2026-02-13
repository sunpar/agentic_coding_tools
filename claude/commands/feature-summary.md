# Feature Summary

Generate a summary of the current feature/work in progress.

## Context to load

1. Run `git diff main...HEAD` to see all changes on this branch
2. Run `git log main..HEAD --oneline` to see commit history
3. Review any `FEATURE_PLAN.md` or `workflow.yml` if present

## Output Format

Create a `feature_summary.md` file with these sections:

### Executive Summary (2-4 sentences)
- What problem the feature solves
- Who/what it impacts
- How it changes behavior

### Scope of Changes
- High-level modules/packages touched
- Key files changed
- New types/endpoints/CLI flags
- Data model changes and migrations

### Behavioral Details
- New/changed user flows
- API contracts (inputs/outputs/status codes)
- Config or environment changes

### Security & Privacy
- AuthZ/AuthN changes
- PII handling (remember: financial data is sensitive)
- Logging implications

### Testing
- Tests added/updated
- Gaps to fill

### Open Questions
- Decisions pending
- TODOs remaining

### Suggested PR Title & Description
- 1-2 candidate PR titles (<=72 chars)
- A PR description suitable for GitHub
