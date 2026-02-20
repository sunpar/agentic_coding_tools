---
name: review-feedback-orchestrator
description: Triage code review feedback from chat text or a markdown file, validate each item against the codebase, produce a fix plan, and hand implementation to subagents. Use when the user wants every review comment verified before fixes are applied.
disable-model-invocation: true
---

# Review Feedback Orchestrator

## Inputs

- Review feedback source (one of):
  - comments earlier in the chat,
  - pasted review text,
  - a markdown file path.
- Optional scope hints (branch, folders, or files).

## Workflow

1. Collect review items from the provided source.
   - If source is ambiguous, summarize candidate items and proceed with the clearest set.
   - Normalize each item into: `id`, `summary`, `files`, `suggested_change`.
2. Validate every item before planning fixes:
   - Read the referenced files and nearby code.
   - Classify as one of:
     - `valid-defect` (real bug/risk),
     - `valid-improvement` (non-blocking but worthwhile),
     - `not-applicable` (incorrect or stale),
     - `needs-clarification` (insufficient evidence).
   - Add evidence for each decision (file paths, snippets, behavior).
3. Build a fix plan only for `valid-defect` and accepted `valid-improvement` items.
   - Group by dependency order and file overlap.
   - For each plan item include: objective, target files, acceptance criteria, tests/checks.
4. Dispatch implementation to subagents.
   - Use the most relevant coding/test subagent for each plan item.
   - Give each subagent:
     - exact review item IDs,
     - validation evidence,
     - required acceptance criteria,
     - required verification commands.
5. Track outcomes and reconcile with original review items.
   - Mark each item: `fixed`, `declined-with-rationale`, or `blocked`.

## Required Output

1. **Review Item Validation Matrix**
   - Columns: `ID | Verdict | Severity | Evidence | Rationale`.
2. **Implementation Plan**
   - Ordered checklist with owner subagent and acceptance criteria.
3. **Subagent Dispatch Prompts**
   - One prompt per implementation task.
4. **Completion Ledger**
   - Item-by-item status mapped back to the original feedback.

## Rules

- Never implement a review item before validating it.
- Keep declined items with explicit reasoning and evidence.
- Prefer minimal-risk fixes and include regression checks.
- If feedback conflicts, surface the conflict and propose a decision path.
