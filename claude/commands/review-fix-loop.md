---
description: Iterative code review and fix loop — reviews code against a feature document, fixes findings, then re-reviews, up to 4 iterations or until clean
argument-hint: Path to feature document A (e.g., docs/feature-spec.md)
---

# Review-Fix Loop Orchestrator

Run an iterative review-then-fix cycle against a feature document. Each iteration spawns a **reviewer** subagent that produces a review, then a **fixer** subagent that addresses the findings. The loop repeats until the review comes back clean or 4 full iterations complete.

## Input

Feature document (A): $ARGUMENTS

## Documents

The orchestrator manages three documents:

| Document | Role | Path |
|----------|------|------|
| **A** — Feature Spec | Input (read-only) | `$ARGUMENTS` |
| **B** — Review Report | Written by reviewer, overwritten each iteration | `{A-dir}/review-report.md` |
| **C** — Fix Report | Written by fixer, overwritten each iteration | `{A-dir}/fix-report.md` |

Where `{A-dir}` is the directory containing document A.

## Workflow

### Step 0: Setup

1. Find the git root directory.
2. Resolve `$ARGUMENTS` to an absolute path (relative to git root if not absolute).
3. Read document A to confirm it exists and is valid. It must contain a description of the feature and a list of involved files.
4. Determine `{A-dir}` — the directory containing document A.
5. Set `MAX_ITERATIONS = 4` and `iteration = 1`.

### Step 1: Review (produce document B)

Launch a **doc-code-reviewer** subagent with the following prompt:

---

```
You are performing iteration {iteration} of a review-fix loop.

Read the agent definition at {git-root}/.claude/agents/doc-code-reviewer.md and follow it precisely.

## Your inputs

- **Feature document (A)**: {absolute path to A}
- **Prior fix report (C)**: {absolute path to C, or "None — this is the first iteration"}
- **Output file (B)**: {A-dir}/review-report.md
- **Iteration number**: {iteration}

## Instructions

1. Read the feature document at the path above.
2. If a prior fix report path is provided and the file exists, read it.
3. Follow the review process defined in the agent definition.
4. Write your review report to the output file path above.
5. IMPORTANT: At the very end of your response, state the verdict on its own line in this exact format:
   VERDICT: {CLEAN|MINOR_ISSUES|NEEDS_FIXES}
```

---

After the subagent completes:

1. Read document B (`{A-dir}/review-report.md`).
2. Check the verdict:
   - If **CLEAN**: The loop is done. Skip to **Step 3: Final Report**.
   - If **MINOR_ISSUES** or **NEEDS_FIXES**: Continue to Step 2.

### Step 2: Fix (produce document C)

Launch a **review-fixer** subagent with the following prompt:

---

```
You are performing iteration {iteration} of a review-fix loop.

Read the agent definition at {git-root}/.claude/agents/review-fixer.md and follow it precisely.

## Your inputs

- **Feature document (A)**: {absolute path to A}
- **Review document (B)**: {A-dir}/review-report.md
- **Output file (C)**: {A-dir}/fix-report.md
- **Iteration number**: {iteration}

## Instructions

1. Read the feature document for context on intent.
2. Read the review document to get the list of findings.
3. Validate each finding against the actual code.
4. Fix valid findings directly in the codebase.
5. Write your fix report to the output file path above.
6. Be thorough but minimal — only change what the findings require.
```

---

After the subagent completes:

1. Read document C (`{A-dir}/fix-report.md`) to confirm it was written.
2. Increment `iteration`.
3. If `iteration > MAX_ITERATIONS`: go to **Step 3: Final Report**.
4. Otherwise: go back to **Step 1: Review** (the next review will use both A and C as input).

### Step 3: Final Report

After the loop ends (either by a CLEAN verdict or hitting MAX_ITERATIONS), present a summary to the user:

```markdown
## Review-Fix Loop Complete

**Feature document**: {path to A}
**Iterations completed**: {iteration count}
**Exit reason**: {CLEAN verdict | Max iterations reached}

### Iteration History

| Iteration | Review Verdict | Findings | Fixed | Declined |
|-----------|---------------|----------|-------|----------|
| 1 | NEEDS_FIXES | 5 | 4 | 1 |
| 2 | MINOR_ISSUES | 2 | 2 | 0 |
| 3 | CLEAN | 0 | — | — |

### Documents Produced

- Review report: `{A-dir}/review-report.md` (from iteration {last review iteration})
- Fix report: `{A-dir}/fix-report.md` (from iteration {last fix iteration})

### Outstanding Items

{List any findings from the final review that were not addressed, if the loop ended due to max iterations}
```

## Loop Flow Diagram

```
                    ┌──────────────┐
                    │  Document A  │
                    │ (feature spec)│
                    └──────┬───────┘
                           │
                    ┌──────▼───────┐
              ┌────►│   REVIEWER   │
              │     │  subagent    │
              │     └──────┬───────┘
              │            │
              │     ┌──────▼───────┐
              │     │  Document B  │
              │     │   (review)   │
              │     └──────┬───────┘
              │            │
              │       ┌────▼────┐      ┌──────────────┐
              │       │ CLEAN?  ├─YES─►│  Final Report │
              │       └────┬────┘      └──────────────┘
              │            │NO
              │     ┌──────▼───────┐
              │     │    FIXER     │
              │     │  subagent    │
              │     └──────┬───────┘
              │            │
              │     ┌──────▼───────┐
              │     │  Document C  │
              │     │ (fix report) │
              │     └──────┬───────┘
              │            │
              │     ┌──────▼──────┐     ┌──────────────┐
              └─NO──┤ iteration>4?├─YES►│  Final Report │
                    └─────────────┘     └──────────────┘
```

## Rules

- Each subagent runs to completion before the next one starts. Do NOT run review and fix in parallel.
- Document B and C are overwritten each iteration — only the latest version is kept on disk.
- The orchestrator reads B after each review to determine the verdict. Parse the `**Verdict**:` line from the review report.
- If a subagent fails (e.g., cannot read files, crashes), report the failure and stop the loop.
- Track progress using TodoWrite — update the current iteration status as you go.
- The feature document (A) is never modified.
