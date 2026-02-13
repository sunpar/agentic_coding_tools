---
description: Generate a PR review guide from docs in a feature directory
argument-hint: Path to docs directory (e.g., docs/login)
---

# PR Review Guide Generator

Read through all documentation in a feature directory and produce a single PR review guide that describes what was built, why, and how to review it.

## Input

Docs directory: $ARGUMENTS

## Workflow

### Step 1: Gather context

1. Find the git root directory.
2. Resolve the docs directory path (relative to git root if not absolute).
3. Read all `.md` files in the docs directory. Prioritize in this order:
   - **Design docs first**: PRD.md, README.md, USER_FLOW.md, ARCHITECTURE.md, or similar high-level docs
   - **Task file**: TASKS.md or similar task breakdown
   - **Post-refactor feature summaries**: Files matching `T*-feature-summary-2.md` (these are the final state after refactoring)
   - **Code reviews**: Files matching `T*-code-review-personal.md`
   - **Pre-refactor summaries**: Files matching `T*-feature-summary.md` (only if no post-refactor version exists)
   - **Refactor analyses**: Files matching `T*-refactor.md`
4. Run `git diff --stat main` and `git status --short` to understand the full scope of file changes.

### Step 2: Synthesize the PR review guide

Write a single document that covers these sections. Be concrete and specific — a reviewer should be able to understand the entire PR from this document alone.

#### Section 1: What Was Built
- 2-3 paragraph summary of the feature, the problem it solves, and the approach taken
- Written for someone who hasn't read any of the design docs

#### Section 2: Design Decisions
- Table of key architectural choices with rationale
- Focus on decisions a reviewer might question ("why not X?")
- Include non-goals and deferred items

#### Section 3: Files Overview
- Organized by layer/concern (database, services, API, frontend, tests)
- Table format: file path, line count, one-line purpose
- Separate tables for new files, modified files

#### Section 4: Security Review Checklist
- Concrete checklist items with file references
- Organized by concern: authentication, authorization, data protection, privacy
- Each item should be verifiable by reading specific code

#### Section 5: API Endpoints Summary
- Table of all new/modified endpoints with method, path, auth level, purpose
- Note which existing endpoints gained new protection

#### Section 6: Frontend Route Architecture
- ASCII tree showing route structure and protection levels
- Note which components wrap which routes

#### Section 7: Test Coverage
- Table of test files with test counts and what they cover
- Note total test counts (auth-specific and full suite)
- Call out any coverage gaps honestly

#### Section 8: Known Gaps and Deferred Items
- Table of items intentionally out of scope
- Distinguish between "deferred to next version" and "coverage gap"

#### Section 9: Deployment Notes
- Required environment variables
- Migration/bootstrap steps
- Breaking changes (if any)

#### Section 10: How to Review
- Suggested review order (most critical files first)
- What to focus on in each area

### Step 3: Save the output

Save the document to `{docs-dir}/PR_REVIEW_GUIDE.md`.

## Notes

- If the docs directory doesn't contain design docs (PRD, README), fall back to reading the feature summary files and git diff to reconstruct the intent.
- If there are no `T*-feature-summary-2.md` files, use `T*-feature-summary.md` instead.
- The security checklist should be specific to the feature, not generic boilerplate.
- Include line counts and file counts where possible — concrete numbers help reviewers gauge scope.
- If a section doesn't apply (e.g., no frontend changes), skip it rather than including empty sections.
