#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

hook_input="$(cat)"
command_text="$(printf '%s' "$hook_input" | jq -r '.tool_input.command // ""')"

if [[ -z "$command_text" ]]; then
  exit 0
fi

lower_command="$(printf '%s' "$command_text" | tr '[:upper:]' '[:lower:]')"
destructive=0

if [[ "$lower_command" == *"git reset --hard"* ]]; then
  destructive=1
fi

if [[ "$lower_command" == *"git checkout --"* ]]; then
  destructive=1
fi

if [[ "$lower_command" == *"git restore --source"* ]]; then
  destructive=1
fi

if [[ "$lower_command" == *"git clean"* ]] \
  && printf '%s' "$lower_command" | grep -Eq -- '-[[:alnum:]]*f' \
  && printf '%s' "$lower_command" | grep -Eq -- '-[[:alnum:]]*d'; then
  destructive=1
fi

if printf '%s' "$lower_command" | grep -Eq -- '(^|[[:space:]])rm([[:space:]]|$)' \
  && printf '%s' "$lower_command" | grep -Eq -- '-[[:alnum:]]*r' \
  && printf '%s' "$lower_command" | grep -Eq -- '-[[:alnum:]]*f'; then
  destructive=1
fi

if printf '%s' "$lower_command" | grep -Eq -- '(^|[[:space:]])mkfs([[:space:]]|\.|$)'; then
  destructive=1
fi

if [[ "$lower_command" == *"dd "* && "$lower_command" == *" of=/dev/"* ]]; then
  destructive=1
fi

if [[ "$destructive" -eq 0 ]]; then
  exit 0
fi

jq -n --arg cmd "$command_text" '{
  hookSpecificOutput: {
    permissionDecision: "ask"
  },
  systemMessage: ("Potentially destructive Bash command detected. Confirm intent before running: " + $cmd)
}'
