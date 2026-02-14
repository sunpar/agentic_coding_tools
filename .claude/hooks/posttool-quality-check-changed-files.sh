#!/usr/bin/env bash
set -euo pipefail

# Consume hook input even though this hook keys off git diff state.
cat >/dev/null

if ! command -v git >/dev/null 2>&1; then
  exit 0
fi

repo_root="${CLAUDE_PROJECT_DIR:-$(pwd)}"
if [[ ! -d "$repo_root" ]]; then
  exit 0
fi

cd "$repo_root"
if [[ ! -d .git ]]; then
  exit 0
fi

mapfile -t changed_files < <(
  {
    git diff --name-only --diff-filter=ACMRTUXB
    git diff --cached --name-only --diff-filter=ACMRTUXB
  } | awk 'NF' | sort -u
)

if [[ ${#changed_files[@]} -eq 0 ]]; then
  exit 0
fi

backend_py_files=()
backend_py_test_files=()
frontend_js_ts_files=()
frontend_js_ts_test_files=()

for file in "${changed_files[@]}"; do
  [[ -f "$file" ]] || continue

  case "$file" in
    backend/*.py)
      rel_file="${file#backend/}"
      backend_py_files+=("$rel_file")
      case "$rel_file" in
        test_*.py|*_test.py|tests/*.py)
          backend_py_test_files+=("$rel_file")
          ;;
      esac
      ;;
  esac

  case "$file" in
    frontend/*.ts|frontend/*.tsx|frontend/*.js|frontend/*.jsx)
      rel_file="${file#frontend/}"
      frontend_js_ts_files+=("$rel_file")
      case "$rel_file" in
        *.test.ts|*.test.tsx|*.spec.ts|*.spec.tsx|*.test.js|*.test.jsx|*.spec.js|*.spec.jsx)
          frontend_js_ts_test_files+=("$rel_file")
          ;;
      esac
      ;;
  esac
done

notes=()
failures=()

if [[ ${#backend_py_files[@]} -gt 0 ]]; then
  if command -v ruff >/dev/null 2>&1 && [[ -d backend ]]; then
    if ! (cd backend && ruff format --check "${backend_py_files[@]}"); then
      failures+=("`ruff format --check` failed for changed backend Python files")
    fi

    if ! (cd backend && ruff check "${backend_py_files[@]}"); then
      failures+=("`ruff check` failed for changed backend Python files")
    fi
  else
    notes+=("Skipped backend Python format/lint (`ruff` not available)")
  fi
fi

if [[ ${#backend_py_test_files[@]} -gt 0 ]]; then
  if command -v pytest >/dev/null 2>&1 && [[ -d backend ]]; then
    if ! (cd backend && pytest -q "${backend_py_test_files[@]}"); then
      failures+=("`pytest` failed for changed backend Python test files")
    fi
  else
    notes+=("Skipped backend Python tests (`pytest` not available)")
  fi
fi

if [[ ${#frontend_js_ts_files[@]} -gt 0 ]]; then
  if command -v npm >/dev/null 2>&1 && [[ -f frontend/package.json ]] && command -v jq >/dev/null 2>&1; then
    if jq -e '.scripts.lint' frontend/package.json >/dev/null; then
      if ! (cd frontend && npm run -s lint); then
        failures+=("`npm run lint` failed for changed frontend JS/TS files")
      fi
    else
      notes+=("Skipped frontend lint (`scripts.lint` not defined)")
    fi
  else
    notes+=("Skipped frontend lint (npm/package setup unavailable)")
  fi
fi

if [[ ${#frontend_js_ts_test_files[@]} -gt 0 ]]; then
  if command -v npm >/dev/null 2>&1 && [[ -f frontend/package.json ]] && command -v jq >/dev/null 2>&1; then
    if jq -e '.scripts.test' frontend/package.json >/dev/null; then
      if ! (cd frontend && npm run -s test -- --run); then
        failures+=("`npm run test -- --run` failed for changed frontend JS/TS test files")
      fi
    else
      notes+=("Skipped frontend tests (`scripts.test` not defined)")
    fi
  else
    notes+=("Skipped frontend tests (npm/package setup unavailable)")
  fi
fi

if [[ ${#failures[@]} -gt 0 ]]; then
  {
    echo "Quality guardrail hook found failures after file edits:"
    for failure in "${failures[@]}"; do
      echo "- $failure"
    done
  } >&2
  exit 2
fi

if [[ ${#notes[@]} -gt 0 ]]; then
  echo "Quality guardrail hook completed with skips:"
  for note in "${notes[@]}"; do
    echo "- $note"
  done
fi
