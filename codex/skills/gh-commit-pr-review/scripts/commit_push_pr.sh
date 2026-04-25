#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' "Usage: $0 --message MESSAGE --title TITLE (--body BODY | --body-file PATH) [--allow-protected-branch]"
}

commit_message=""
pr_title=""
pr_body=""
body_file=""
allow_protected_branch="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --message)
      commit_message="${2:-}"
      shift 2
      ;;
    --title)
      pr_title="${2:-}"
      shift 2
      ;;
    --body)
      pr_body="${2:-}"
      shift 2
      ;;
    --body-file)
      body_file="${2:-}"
      shift 2
      ;;
    --allow-protected-branch)
      allow_protected_branch="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$commit_message" || -z "$pr_title" ]]; then
  usage >&2
  exit 2
fi

if [[ -n "$body_file" && -n "$pr_body" ]]; then
  printf '%s\n' "Use either --body or --body-file, not both." >&2
  exit 2
fi

if [[ -n "$body_file" ]]; then
  if [[ ! -f "$body_file" ]]; then
    printf 'Body file not found: %s\n' "$body_file" >&2
    exit 2
  fi
  pr_body="$(<"$body_file")"
fi

if [[ -z "$pr_body" ]]; then
  printf '%s\n' "PR body is required." >&2
  exit 2
fi

git rev-parse --show-toplevel >/dev/null
gh auth status >/dev/null

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
  printf '%s\n' "Current checkout is detached; create or switch to a branch first." >&2
  exit 1
fi

if [[ "$allow_protected_branch" != "true" && ( "$branch" == "main" || "$branch" == "master" ) ]]; then
  printf 'Refusing to publish protected branch: %s\n' "$branch" >&2
  exit 1
fi

if git diff --cached --quiet; then
  git add -A
fi

if git diff --cached --quiet; then
  printf '%s\n' "No staged changes to commit." >&2
  exit 1
fi

git commit -m "$commit_message"
commit_hash="$(git rev-parse --short HEAD)"

if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
  git push
else
  git push -u origin HEAD
fi

review_request='@codex @copilot please review.'
if [[ "$pr_body" != *"@codex"* || "$pr_body" != *"@copilot"* ]]; then
  pr_body="${pr_body}"$'\n\n'"${review_request}"
fi

existing_pr_url="$(gh pr view --json url --jq .url 2>/dev/null || true)"
if [[ -n "$existing_pr_url" ]]; then
  printf 'commit=%s\n' "$commit_hash"
  printf 'pr=%s\n' "$existing_pr_url"
  exit 0
fi

pr_url="$(gh pr create --title "$pr_title" --body "$pr_body")"
printf 'commit=%s\n' "$commit_hash"
printf 'pr=%s\n' "$pr_url"
