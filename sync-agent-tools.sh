#!/usr/bin/env bash
# sync-agent-tools.sh — Keep local AI-tool configs in sync with the central
# agentic_coding_tools repo (https://github.com/sunpar/agentic_coding_tools).
#
# This script is the distribution mechanism for shared agent configs. It pulls
# the latest main branch of the central repo, then rsyncs its contents into:
#
#   1. User-level config dirs  (~/.claude, ~/.codex, ~/.cursor)
#   2. Project-level config dirs (~/*/.claude, ~/*/.codex, ~/*/.cursor)
#
# Sync modes:
#   "delete" — mirror the repo exactly (local-only files are removed)
#   "keep"   — additive merge (local-only files are preserved)
#
# Dirs that are project-specific (hooks, settings) are never touched.
#
# Setup:
#   1. Clone the repo:  git clone git@github.com:sunpar/agentic_coding_tools.git ~/agentic_coding_tools
#   2. Add a shell alias so you can run it from anywhere:
#        alias sync-agent-tools='~/agentic_coding_tools/sync-agent-tools.sh'
#   3. (Optional) Call it from a cron job or shell profile for automatic sync.
#
# Usage:
#   sync-agent-tools          # pull latest & sync everything
#
# Requirements: git, rsync

set -euo pipefail

REPO="$HOME/agentic_coding_tools"
SKIP_PROJECTS="agentic_coding_tools|coding_agent_tools"

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { printf "${CYAN}[sync]${NC} %s\n" "$*"; }
ok()   { printf "${GREEN}  ✓${NC} %s\n" "$*"; }
warn() { printf "${YELLOW}  ⚠${NC} %s\n" "$*"; }

# Rsync a source dir into a destination dir.
# $1=src  $2=dest  $3=delete (mirror) | keep (additive, default)
sync_dir() {
    local src="$1" dest="$2" mode="${3:-keep}"
    [[ -d "$src" ]] || return 0
    mkdir -p "$dest"
    if [[ "$mode" == "delete" ]]; then
        rsync -a --delete "$src/" "$dest/"
    else
        rsync -a "$src/" "$dest/"
    fi
    ok "$dest"
}

# ── Pull latest from central repo ────────────────────────────────────
log "Pulling latest main..."
git -C "$REPO" checkout main --quiet 2>/dev/null
git -C "$REPO" pull origin main --quiet
ok "Repo updated"

# ── User-level: ~/.claude ────────────────────────────────────────────
# agents, commands, rules, references → mirror (delete mode)
# plugins → additive (preserve local installs, blocklist, cache)
log "Syncing user-level Claude configs..."
for subdir in agents commands rules references; do
    sync_dir "$REPO/claude/$subdir" "$HOME/.claude/$subdir" delete
done
sync_dir "$REPO/claude/plugins" "$HOME/.claude/plugins" keep

# ── User-level: ~/.codex ─────────────────────────────────────────────
# rules → mirror; skills → additive (preserve .system/ and auto-generated dirs)
log "Syncing user-level Codex configs..."
sync_dir "$REPO/codex/rules"  "$HOME/.codex/rules"  delete
sync_dir "$REPO/codex/skills" "$HOME/.codex/skills" keep

# ── User-level: ~/.cursor ────────────────────────────────────────────
log "Syncing user-level Cursor configs..."
for subdir in agents commands rules; do
    sync_dir "$REPO/cursor/$subdir" "$HOME/.cursor/$subdir" delete
done
sync_dir "$REPO/cursor/skills" "$HOME/.cursor/skills" keep

# ── Project-level ────────────────────────────────────────────────────
# Walk ~/*/  and update any existing tool config dirs.
# Only dirs that already have .claude/.codex/.cursor are touched — nothing is created.
# Hooks and settings are project-specific, so they are never overwritten.
log "Syncing project-level configs..."

for project_dir in "$HOME"/*/; do
    [[ -d "$project_dir" ]] || continue
    project_name=$(basename "$project_dir")
    [[ "$project_name" =~ ^($SKIP_PROJECTS)$ ]] && continue
    [[ "$project_name" == .* ]] && continue

    synced=false

    # .claude — agents, commands (mirror, only if subdir exists);
    # rules, references (mirror, always created); plugins (additive).
    # Hooks/settings are project-specific and never touched.
    if [[ -d "$project_dir.claude" ]]; then
        for subdir in agents commands; do
            if [[ -d "$project_dir.claude/$subdir" && -d "$REPO/claude/$subdir" ]]; then
                sync_dir "$REPO/claude/$subdir" "$project_dir.claude/$subdir" delete
                synced=true
            fi
        done
        for subdir in rules references; do
            if [[ -d "$REPO/claude/$subdir" ]]; then
                sync_dir "$REPO/claude/$subdir" "$project_dir.claude/$subdir" delete
                synced=true
            fi
        done
        if [[ -d "$project_dir.claude/plugins" && -d "$REPO/claude/plugins" ]]; then
            sync_dir "$REPO/claude/plugins" "$project_dir.claude/plugins" keep
            synced=true
        fi
    fi

    # .cursor — agents, commands, rules (mirror); skills (additive)
    if [[ -d "$project_dir.cursor" ]]; then
        for subdir in agents commands rules; do
            if [[ -d "$project_dir.cursor/$subdir" && -d "$REPO/cursor/$subdir" ]]; then
                sync_dir "$REPO/cursor/$subdir" "$project_dir.cursor/$subdir" delete
                synced=true
            fi
        done
        if [[ -d "$project_dir.cursor/skills" && -d "$REPO/cursor/skills" ]]; then
            sync_dir "$REPO/cursor/skills" "$project_dir.cursor/skills" keep
            synced=true
        fi
    fi

    # .codex — rules & skills (additive)
    if [[ -d "$project_dir.codex" ]]; then
        for subdir in rules skills; do
            if [[ -d "$project_dir.codex/$subdir" && -d "$REPO/codex/$subdir" ]]; then
                sync_dir "$REPO/codex/$subdir" "$project_dir.codex/$subdir" keep
                synced=true
            fi
        done
    fi

    $synced && log "  → $project_name"
done

log "Done!"
