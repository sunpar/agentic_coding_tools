---
description: Launch parallel agents for each task in a task file, each running the full feature workflow
argument-hint: Path to TASKS.md file (e.g., docs/login/TASKS.md)
---

# Agent Team Workflow

Launch a team of parallel agents from a structured task file. Each agent independently executes the full feature workflow for its assigned task.

## Input

Task file: $ARGUMENTS

The task file should follow the standard format with tasks prefixed as `T{N}:` (e.g., `T1:`, `T2:`, `T13:`), each containing a description, file list, and implementation details. Tasks are organized into tiers for dependency management.

## Workflow

### Step 1: Parse the task file

1. Find the git root directory.
2. Read the task file at `$ARGUMENTS` (relative to git root if not absolute).
3. Identify the **docs directory** — use the parent directory of the task file. For example, if the task file is `docs/login/TASKS.md`, the docs directory is `docs/login/`.
4. Parse all tasks from the file. Each task starts with a heading like `### T{N}: ...` and includes everything until the next task heading or tier heading.
5. Extract for each task:
   - **Task number** (e.g., `T1`, `T2`, `T13`)
   - **Task title** (the heading text after `T{N}: `)
   - **Full task body** (everything between this heading and the next task/tier heading)
   - **File list** (from the `Files` field in the table)

### Step 2: Determine output paths

For each task T{N}, the agent will produce four documents in the docs directory:

| Document | Path |
|----------|------|
| Feature Summary | `{docs-dir}/T{N}-feature-summary.md` |
| Refactor Analysis | `{docs-dir}/T{N}-refactor.md` |
| Updated Feature Summary | `{docs-dir}/T{N}-feature-summary-2.md` |
| Code Review | `{docs-dir}/T{N}-code-review-personal.md` |

### Step 3: Launch agent team

Launch **one background agent per task**, all in parallel (use `run_in_background=true`). Each agent receives the following prompt (fill in the task-specific values):

---

**Agent prompt template** (for task T{N}):

```
You are performing a quality review workflow for task T{N} of a feature implementation.

## Your Task

**T{N}: {task_title}**

{full_task_body}

## Files to Focus On

{file_list_from_task}

## Instructions

Execute steps 4-8 of the full feature workflow. You are NOT implementing the feature (it's already implemented). You are reviewing and refining existing code.

Find the git root directory first.

### Step 4: Feature Summary

Read {git-root}/.claude/commands/feature-summary.md for the output format.

Generate a feature summary focused ONLY on the files and functionality from task T{N}. Instead of running `git diff main...HEAD` for ALL changes, focus your analysis on the specific files listed above for this task.

Save the output to: {docs-dir}/T{N}-feature-summary.md

### Step 5: Refactor Analysis

Read {git-root}/.claude/commands/refactor.md for the analysis format.

Analyze ONLY the files belonging to task T{N} for refactoring opportunities. Read each file in full. Evaluate against the refactoring checklist. Focus on:
- Code duplication within and across the task's files
- Magic numbers/strings that should be constants
- Functions that could be simplified
- Naming improvements
- Type annotation improvements

Save the output to: {docs-dir}/T{N}-refactor.md

### Step 6: Implement Refactors

Read {docs-dir}/T{N}-refactor.md. For each proposed refactoring, decide whether it offers a meaningful improvement in readability, code structure, performance, or brevity. Implement the ones that provide clear benefit.

IMPORTANT: Only modify files that belong to task T{N}. Do NOT modify files from other tasks.

After implementing, run the relevant tests:
- For backend Python files: `cd {git-root}/backend && source .venv/bin/activate && pytest -q`
- For frontend TypeScript files: `cd {git-root}/frontend && npm test -- --run`

If tests fail after refactoring, fix the issue or revert the refactoring.

### Step 7: Updated Feature Summary

Read {git-root}/.claude/commands/feature-summary.md for the output format again.

Generate an updated feature summary reflecting any refactorings applied in Step 6.

Save the output to: {docs-dir}/T{N}-feature-summary-2.md

### Step 8: Code Review

Read {git-root}/.claude/commands/code-review_personal.md for the review format.

Perform a code review focused on the task T{N} files, using {docs-dir}/T{N}-feature-summary-2.md as context.

Save the output to: {docs-dir}/T{N}-code-review-personal.md
```

---

### Step 4: Monitor and report

1. Wait for all agents to complete.
2. Report a summary table showing each task, its agent status, and what refactorings were applied.
3. If any agents failed, report the failures and suggest next steps.

## Notes

- Agents run independently and should NOT modify files outside their task scope.
- The task file format matches the pattern used in `docs/login/TASKS.md` — tasks prefixed with `T{N}:`, organized in tiers, with file lists and descriptions.
- If a task has no files listed (e.g., a verification-only task like T17), still launch an agent but instruct it to focus on the verification aspects described in the task body.
- The docs directory is automatically derived from the task file location.
