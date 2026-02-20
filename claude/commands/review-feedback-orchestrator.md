---
description: Validate every code review comment, generate a fix plan, and delegate implementation tasks to subagents
argument-hint: Review source (pasted text, "earlier in chat", or markdown file path)
---

# Review Feedback Orchestrator

Process review feedback end-to-end: validate each concern against the code, plan fixes, then hand off implementation to subagents.

## Input

Review source: $ARGUMENTS

Acceptable sources:
- comments already in this conversation,
- pasted review text,
- markdown file path.

## Workflow

### Step 1: Collect and normalize feedback

1. Parse all review items from the chosen source.
2. Normalize each to:
   - `id`
   - `summary`
   - `affected_files` (if known)
   - `requested_change`

### Step 2: Validate every item before planning

For each review item:
1. Inspect referenced files and nearby code paths.
2. Determine verdict:
   - `valid-defect`
   - `valid-improvement`
   - `not-applicable`
   - `needs-clarification`
3. Record evidence and rationale.

### Step 3: Build implementation plan

Create tasks only for accepted valid items.
For each task include:
- linked review item IDs,
- objective,
- files to change,
- acceptance criteria,
- required test/check commands.

Order tasks to minimize merge conflicts and respect dependencies.

### Step 4: Delegate to subagents

Dispatch each plan task to the best subagent (writer/tester/reviewer as appropriate).
Each subagent prompt must include:
- exact review IDs,
- validation evidence,
- implementation boundaries,
- acceptance criteria,
- verification commands.

### Step 5: Reconcile results

Return final status per original item:
- `fixed`
- `declined-with-rationale`
- `blocked`

## Required Output Format

1. **Validation Matrix** (`ID | Verdict | Severity | Evidence | Rationale`)
2. **Fix Plan** (ordered checklist with assigned subagent)
3. **Subagent Prompts** (ready-to-run)
4. **Final Reconciliation Ledger** (mapped to original review items)

## Rules

- Never implement an item that has not been validated.
- Keep explicit rationale for declined comments.
- Prefer small, low-risk changes unless larger refactor is required.
- If review comments conflict, present options and trade-offs before dispatch.
