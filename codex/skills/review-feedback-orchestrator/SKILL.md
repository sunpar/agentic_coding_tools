---
name: review-feedback-orchestrator
description: Triage code review feedback from chat text or a markdown file, validate each item against the codebase, produce a fix plan, and delegate implementation to subagents. Use when the user wants every review comment verified before applying fixes.
---

# Review Feedback Orchestrator

## Inputs

- Review feedback source (one of):
  - comments earlier in the conversation,
  - pasted review text,
  - markdown file path.
- Optional scope hints (branch, folders, files).

## Workflow

1. Collect and normalize review items.
   - Convert each comment into: `id`, `summary`, `affected_files`, `requested_change`.
2. Validate each item against the actual code.
   - Read referenced files and surrounding context.
   - Classify item status:
     - `valid-defect`,
     - `valid-improvement`,
     - `not-applicable`,
     - `needs-clarification`.
   - Capture concrete evidence (paths, lines, behavior).
3. Build an implementation plan.
   - Include only validated and accepted items.
   - Order tasks by dependency and file overlap.
   - Define acceptance criteria and verification commands per task.
4. Delegate tasks to subagents.
   - Select implementation/testing subagent by task type.
   - Pass review IDs, evidence, constraints, and checks.
5. Reconcile final status.
   - For each original item, report `fixed`, `declined-with-rationale`, or `blocked`.

## Required Output

1. Validation matrix (`ID | Verdict | Severity | Evidence | Rationale`)
2. Ordered implementation plan with task owners
3. Subagent dispatch prompts
4. Final reconciliation ledger

## Rules

- Do not implement before validation.
- Keep explicit rationale for declined or out-of-scope items.
- Prefer smallest safe fix that satisfies the concern.
- If review items conflict, call it out and propose resolution options.
