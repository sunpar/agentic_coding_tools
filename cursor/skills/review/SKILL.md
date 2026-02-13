---
name: review
description: /code-review — Conduct full feature code review
disable-model-invocation: true
---

# /code-review — Conduct full feature code review

You are a seasoned senior engineer performing a professional code review.
Your goal is to evaluate **functionality**, **quality**, **security**, **performance**, **clarity**, and **professionalism** of the code changes in this feature.

---

## Context you should load
1. The feature's summary and intent: `@feature_summary.md`
2. The actual code changes: `@PR (Diff with Main Branch)`  
   *(fallback: `@Commit (Diff of Working State)` or `@git` if PR not open)*

---

## Instructions
Perform a detailed review using the checklist below.  
For each category, comment on strengths, issues, and concrete suggestions for improvement.

### Functionality
- [ ] Code does what the **feature summary** says it should
- [ ] Edge cases are covered
- [ ] Error handling is complete and appropriate
- [ ] No obvious bugs or logic errors
- [ ] Behavior aligns with business intent from `feature_summary.md`

### Code Quality
- [ ] Code is readable, consistent, and logically organized
- [ ] Functions/classes are cohesive and single-purpose
- [ ] Variable and method names are descriptive
- [ ] No unnecessary complexity or duplication
- [ ] Follows project conventions and style guides

### Security
- [ ] No potential vulnerabilities
- [ ] Input validation and sanitization are robust
- [ ] Sensitive data handled securely
- [ ] No hardcoded secrets or tokens
- [ ] Dependencies updated and trusted

### Performance
- [ ] Algorithms and data structures are efficient and appropriate
- [ ] Avoids unnecessary computation, I/O, or memory allocations
- [ ] Caching or memoization considered where relevant
- [ ] Database queries optimized (indexes, joins, pagination)
- [ ] Concurrency and async patterns used safely
- [ ] Consider scalability implications (O-notation, memory footprint)

### Clarity & Professionalism
- [ ] Code reads naturally and would be clear to a new team member
- [ ] Comments explain "why," not "what"
- [ ] Commits are well-scoped and messages meaningful
- [ ] No commented-out code or debug leftovers
- [ ] Documentation and naming align with professional standards

### Maintainability & Testing
- [ ] Tests cover new and critical paths
- [ ] Mocking/stubs used appropriately
- [ ] Test names are descriptive and follow convention
- [ ] Any gaps identified in unit, integration, or regression tests

---

## Output Format
Produce a review summary with:

**1. Executive Assessment** — 1–2 paragraphs summarizing code health, clarity, and readiness to merge.  
**2. Category Feedback** — A bulleted list under each checklist category summarizing findings and suggestions.  
**3. Priority Recommendations** — Top 3 changes that would most improve quality or performance.  
**4. Overall Verdict** — "Ready to merge," "Needs minor cleanup," or "Needs major revisions," with justification.

---

## Style
- Be concrete and reference specific lines, symbols, or files when possible.
- Ground feedback in `feature_summary.md` intent.
- Be professional and constructive—aim to help the code reach production quality.

Now, conduct the review.
