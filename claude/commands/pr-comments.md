# PR Comments Review and Resolution

Review comments on the PR for the current branch, process each comment one by one, implement appropriate changes, reply with rationale, and resolve only addressed comments.

## Steps

1. Determine current PR:
   - Run `gh pr view --json number,url,headRefName,baseRefName`.
   - If no PR exists for the current branch, stop and report that `/pr-comments` requires an existing PR.

2. Fetch all PR feedback:
   - Inline review comments:
     - `gh api repos/{owner}/{repo}/pulls/{number}/comments`
   - Top-level issue comments on the PR:
     - `gh api repos/{owner}/{repo}/issues/{number}/comments`
   - Review summaries:
     - `gh pr view {number} --json reviews`

3. Build a processing queue:
   - Include inline review comments first (oldest to newest).
   - Include top-level PR comments next.
   - Include actionable feedback from review summaries (e.g., "changes requested" bodies that contain specific asks not covered by inline comments).
   - Skip system/bot noise unless it contains actionable feedback.

4. Process comments one at a time:
   - Classify each comment:
     - **Address now**: clear, valid, in-scope change.
     - **Decline/Defer**: incorrect, conflicting, out of scope, or needs broader decision.
   - For **Address now**:
     - Make minimal code/doc changes.
     - Run relevant validation for touched areas.
     - Commit only when explicitly requested by user or command context.
     - Reply directly on the comment thread with:
       - What changed
       - Why this approach was chosen
       - Any caveats
     - Mark as resolved:
       - GraphQL `resolveReviewThread` for inline comments.
       - For top-level comments, indicate addressed in reply (cannot truly resolve issue comments).
   - For **Decline/Defer**:
     - Reply with clear rationale and whether follow-up is needed.
     - Leave inline thread unresolved.

5. Continue until all queued comments are processed.

## Resolution/Reply Rules

- Every processed comment must receive a response.
- Responses must include both:
  - **Action taken** (or explicit "no code change")
  - **Rationale** for that decision
- Only resolve inline threads when the requested concern was actually addressed.
- If partially addressed, explain what remains and keep unresolved.

## Suggested GitHub CLI helpers

- Reply to an inline review comment (use `in_reply_to` with the comment's numeric `id`):
  - `gh api repos/{owner}/{repo}/pulls/{number}/comments -F in_reply_to={comment_id} -f body='...'`
  - Note: The `/pulls/comments/{id}/replies` endpoint returns 404 via `gh api`. Use the create-comment endpoint with `-F in_reply_to=` instead.
- Top-level PR comment reply:
  - `gh api repos/{owner}/{repo}/issues/{number}/comments -f body='...'`
- Query thread + node IDs (for GraphQL resolve):
  - `gh api graphql -f query='{ repository(owner:"{owner}", name:"{repo}") { pullRequest(number:{number}) { reviewThreads(first:50) { nodes { id isResolved comments(first:1) { nodes { databaseId } } } } } } }'`
- Resolve thread:
  - `gh api graphql -f query='mutation { resolveReviewThread(input:{threadId:"{thread_node_id}"}) { thread { isResolved } } }'`

## Output

Provide a final report:

### Addressed
- Comment reference, summary, change made, reply posted, resolution status

### Declined/Deferred
- Comment reference, summary, rationale, reply posted, unresolved status

### Verification
- Commands run and their results
