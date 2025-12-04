#!/bin/bash
# Worktree Write Validation Hook - Global PreToolUse Hook
# Prevents agents in worktrees from writing to main repo or other worktrees
# Version: 1.0.0
# Authority: holistic-orchestrator
# Reference: CLAUDE.md WORKTREE_DISCIPLINE section

set -euo pipefail

# ============================================================================
# DETECT GIT CONTEXT
# ============================================================================

# Get current git root (works in both main repo and worktrees)
CURRENT_GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")

if [[ -z "$CURRENT_GIT_ROOT" ]]; then
  # Not in a git repo - allow operation (no worktree concern)
  exit 0
fi

# ============================================================================
# PARSE TOOL INVOCATION
# ============================================================================

# Read tool input from stdin (Claude Code passes JSON)
INPUT=$(cat)

# Extract tool name
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")

# Only validate Write, Edit, NotebookEdit tools
case "$TOOL_NAME" in
  Write|Edit|NotebookEdit)
    ;;
  *)
    # Not a file write operation - allow
    exit 0
    ;;
esac

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

if [[ -z "$FILE_PATH" ]]; then
  # No file path in input - allow (tool will handle its own error)
  exit 0
fi

# ============================================================================
# VALIDATE WRITE TARGET
# ============================================================================

# Resolve to absolute path
if [[ "$FILE_PATH" != /* ]]; then
  # Relative path - resolve from current directory
  RESOLVED_PATH="$(pwd)/$FILE_PATH"
else
  RESOLVED_PATH="$FILE_PATH"
fi

# Normalize the path (resolve .. and symlinks)
RESOLVED_PATH=$(cd "$(dirname "$RESOLVED_PATH")" 2>/dev/null && pwd)/$(basename "$RESOLVED_PATH") || RESOLVED_PATH="$FILE_PATH"

# Check if resolved path is within current git root
if [[ "$RESOLVED_PATH" != "$CURRENT_GIT_ROOT"* ]]; then
  echo "╔══════════════════════════════════════════════════════════════════════╗" >&2
  echo "║  WORKTREE BOUNDARY VIOLATION                                         ║" >&2
  echo "╠══════════════════════════════════════════════════════════════════════╣" >&2
  echo "║  Target path escapes current worktree boundary.                      ║" >&2
  echo "║                                                                      ║" >&2
  echo "║  Current Git Root: $CURRENT_GIT_ROOT" >&2
  echo "║  Target Path:      $RESOLVED_PATH" >&2
  echo "║                                                                      ║" >&2
  echo "║  BLOCKED: File operations must stay within worktree boundaries.     ║" >&2
  echo "║                                                                      ║" >&2
  echo "║  Resolution:                                                         ║" >&2
  echo "║  1. Use relative paths from current working directory                ║" >&2
  echo "║  2. Or use paths relative to: $CURRENT_GIT_ROOT" >&2
  echo "╚══════════════════════════════════════════════════════════════════════╝" >&2
  exit 1
fi

# Path is within worktree boundary - allow operation
exit 0
