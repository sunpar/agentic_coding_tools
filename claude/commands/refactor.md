---
name: refactor-changes
description: Analyze staged and unstaged git changes and refactor for readability, maintainability, and conciseness. Use when the user asks to refactor recent changes, clean up code, improve code quality, or review their work-in-progress for improvements.
---

# Refactor Changes

Analyze git changes in the workspace and refactor code to improve readability, organization, and maintainability.

## Workflow

### Step 1: Gather Changes and Context

Run these commands to understand what's changed:

```bash
# View all modified files (staged and unstaged)
git status --short

# View the actual changes
git diff HEAD
```

Read the modified files in full to understand the broader context.

### Step 2: Understand Intent

Before refactoring, understand what the code is trying to accomplish:

1. **Read user-provided context** about the feature/fix
2. **Examine the diff** to understand the change's purpose
3. **Look at surrounding code** to understand existing patterns
4. **Identify the public interface** that must be preserved

### Step 3: Apply Refactoring Analysis

Evaluate each changed file against these criteria (in priority order):

| Priority | Category        | Goal                                       |
| -------- | --------------- | ------------------------------------------ |
| 1        | **Correctness** | Does the code do what it's supposed to?    |
| 2        | **Clarity**     | Can someone understand this in 30 seconds? |
| 3        | **Structure**   | Is responsibility properly distributed?    |
| 4        | **Conciseness** | Is there unnecessary code?                 |

### Step 4: Propose Refactorings

For each improvement opportunity, provide:

1. **What**: Specific code location and change
2. **Why**: Concrete benefit (not just "cleaner")
3. **How**: The refactored code
4. **Risk**: Any behavioral changes or considerations

## Refactoring Checklist

Copy and use this checklist when analyzing changes:

```
Refactoring Analysis:
- [ ] Extract magic numbers/strings to named constants
- [ ] Rename unclear variables/functions to reveal intent
- [ ] Break large functions into focused, single-purpose units
- [ ] Eliminate code duplication (DRY)
- [ ] Simplify nested conditionals (early returns, guard clauses)
- [ ] Remove dead code and unused imports
- [ ] Consolidate related logic (cohesion)
- [ ] Reduce function parameters (consider objects/configs)
- [ ] Replace comments with self-documenting code
- [ ] Improve type annotations for clarity
```

## Language-Specific Guidance

### Python

| Smell                    | Refactoring                     |
| ------------------------ | ------------------------------- |
| Long parameter lists     | Use dataclass/Pydantic model    |
| Repeated dict access     | Destructure or use TypedDict    |
| Complex conditionals     | Extract to predicate functions  |
| Callback nesting         | Use comprehensions or itertools |
| String formatting soup   | Use f-strings consistently      |
| Manual resource handling | Use context managers            |
| Type: `Optional[X]`      | Prefer `X \| None`              |

### TypeScript/React

| Smell                       | Refactoring                            |
| --------------------------- | -------------------------------------- |
| Prop drilling               | Extract to context or custom hook      |
| Large components            | Split into container/presentational    |
| Inline handlers             | Extract to named functions             |
| Repeated fetch logic        | Create custom hook                     |
| Complex conditionals in JSX | Extract to early returns or components |
| Any types                   | Add proper type annotations            |
| Mutable state patterns      | Use immutable updates                  |

## Output Format

Structure your response as:

```markdown
## Summary

[1-2 sentences on overall code quality and main opportunities]

## Refactorings

### 1. [Brief description]

**File**: `path/to/file.py`
**Category**: [Clarity/Structure/Conciseness]
**Risk**: [None/Low/Medium] - [explanation if not None]

**Before**:
[code block]

**After**:
[code block]

**Why**: [Concrete benefit]

---

### 2. [Next refactoring...]

## Optional Improvements

[Lower priority suggestions that could be deferred]
```

## Guidelines

1. **Preserve behavior**: Refactorings should not change what the code does
2. **Respect existing patterns**: Match the codebase's existing style
3. **Be aggressive but safe**: Suggest significant improvements, but flag any risk
4. **Prioritize impact**: Start with changes that provide the most benefit
5. **Consider the diff**: Focus more attention on new/changed code than touched context

## Additional Resources

**Important**: For detailed refactoring patterns with before/after examples, read the extended reference file:
```
.claude/references/refactor-patterns.md
```
Use the Read tool to load this file when you need specific pattern examples during the refactoring analysis.
