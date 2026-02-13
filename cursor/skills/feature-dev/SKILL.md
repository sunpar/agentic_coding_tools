---
name: feature-dev
description: Run a phased feature-development workflow with discovery, codebase exploration, clarifying questions, architecture options, implementation, quality review, and summary.
disable-model-invocation: true
---

# Feature Development

## Core Principles

- Understand existing patterns before coding.
- Ask clarifying questions for underspecified behavior.
- Present architecture trade-offs before implementation.
- Do not implement until the user approves direction.

## Phase 1: Discovery

1. Clarify feature goal, constraints, and success criteria.
2. Summarize understanding and confirm with the user.

## Phase 2: Codebase Exploration

1. Explore relevant code paths comprehensively.
2. Identify similar features, extension points, and conventions.
3. Build a focused list of key files and read them deeply.
4. Summarize findings.

## Phase 3: Clarifying Questions

1. Identify ambiguity in scope, edge cases, error handling, and compatibility.
2. Ask clear grouped questions.
3. Wait for user answers before design.

## Phase 4: Architecture Design

1. Propose multiple approaches (minimal change, cleaner architecture, pragmatic balance).
2. Compare trade-offs.
3. Recommend one approach with reasoning.
4. Ask the user to choose.

## Phase 5: Implementation

1. Start only after explicit user approval.
2. Implement with project conventions and chosen architecture.
3. Keep a running task checklist and update progress.

## Phase 6: Quality Review

1. Review for correctness, simplicity, and convention alignment.
2. Surface high-severity issues first.
3. Ask whether to fix now or defer.
4. Apply chosen fixes.

## Phase 7: Summary

1. Summarize what was built.
2. List key decisions and changed files.
3. Provide clear next steps.
