---
name: worktree
description: Create git worktrees for one or more branches. Use when you need to work on multiple branches simultaneously without switching contexts.
---

# Open Git Worktrees

Create git worktrees for the specified branches, allowing you to work on multiple branches simultaneously in separate directories.

## Input

$ARGUMENTS

Provide one or more branch names separated by spaces (e.g., `main feature-branch bugfix-123`).

## Workflow

### Step 1: Validate the Input

Parse the branch names from the arguments. If no branches are provided, list existing worktrees and available branches.

### Step 2: Determine Worktree Location

Worktrees will be created in a sibling directory named `<repo>-worktrees/`:
- Main repo: `/path/to/repo`
- Worktrees: `/path/to/repo-worktrees/<branch-name>`

### Step 3: Create Worktrees

For each branch provided:

1. Check if the branch exists (local or remote)
2. If remote-only, fetch it first
3. Create the worktree using `git worktree add`
4. Report success or any errors

```bash
# Get repo root and derive worktree base as a sibling directory
REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
WORKTREE_BASE="$(dirname "$REPO_ROOT")/${REPO_NAME}-worktrees"

# Create the worktree base directory if needed
mkdir -p "$WORKTREE_BASE"

# For each branch, create a worktree
# git worktree add "$WORKTREE_BASE/<branch>" <branch>
```

### Step 4: Report Results

After creating worktrees, show:

1. List of created worktrees with their paths
2. Any branches that failed (with reason)
3. Command to navigate to each worktree

## Commands Reference

```bash
# List existing worktrees
git worktree list

# Create a worktree for an existing branch
git worktree add ../repo-worktrees/branch-name branch-name

# Create a worktree with a new branch based on another
git worktree add -b new-branch ../repo-worktrees/new-branch base-branch

# Remove a worktree
git worktree remove ../repo-worktrees/branch-name

# Prune stale worktree references
git worktree prune
```

## Output Format

```markdown
## Worktrees Created

| Branch | Path | Status |
|--------|------|--------|
| branch-1 | /path/to/worktrees/branch-1 | ✓ Created |
| branch-2 | /path/to/worktrees/branch-2 | ✓ Created |

## Navigation

To open a worktree:
- `cd /path/to/worktrees/branch-1`

## All Worktrees

[Output of `git worktree list`]
```

## Error Handling

- **Branch doesn't exist**: Offer to create it or list similar branch names
- **Worktree already exists**: Report the existing path, don't recreate
- **Dirty worktree directory**: Warn and skip

## Tips

- Use `git worktree remove <path>` to clean up when done
- Run `git worktree prune` to clean up stale references
- Each worktree shares the same git objects, saving disk space
