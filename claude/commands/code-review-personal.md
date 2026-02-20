# Code Review Personal

Perform a comprehensive code review of the current changes.

## Steps

1. Run `git diff main...HEAD` to see all changes on this branch
2. Load context from `FEATURE_PLAN.md`, `feature_summary.md`, any `{git-root}/docs/feature-summary*.md` files, or task-prefixed `T*-feature-summary*.md` files if they exist (prefer the most recent summary)
3. Load context from `ORIGINAL_PLAN.md` if it exists
4. Review against these criteria:

### Functionality

- Code matches feature intent from the original plan or the feature plan/feature summary.
- Edge cases covered
- Error handling appropriate
- No obvious bugs

### Code Quality

- Readable, consistent, organized
- Single-purpose functions
- Descriptive names
- Follows project conventions (see CLAUDE.md)

### Security & Privacy

- No sensitive data logged (raw transactions, account numbers, CSV rows)
- Input validation present
- No hardcoded secrets

### Performance

- Efficient algorithms and queries
- No N+1 patterns
- Avoids unnecessary computation

### Tests

- Tests cover new behavior
- Tests are behavior-driven, not brittle
- See the skill /write-tests and use it

## Output Format

Provide:

1. **Executive Summary** (1-2 paragraphs)
2. **Findings by Severity** (Critical > Major > Minor > Cosmetic)
3. **Test Coverage Assessment**
4. **Final Verdict**: Ready to merge | Needs minor cleanup | Needs major revisions
