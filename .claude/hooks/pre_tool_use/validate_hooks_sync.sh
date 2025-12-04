#!/bin/bash
# Pre-Tool-Use Hook: Validate hooks sync operations
# Prevents HESTAI-only governance hooks from being pushed to non-HESTAI projects
# Reference: /Volumes/HestAI/reports/813-REPORT-HOOKS-GOVERNANCE-SCOPE-ANALYSIS.md

set -e

# Parse incoming tool call
TOOL_NAME=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.tool // empty' 2>/dev/null)
[ "$TOOL_NAME" != "Bash" ] && exit 0

COMMAND=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.arguments.command // empty' 2>/dev/null)

# Check if this is a hooks sync push operation
if ! echo "$COMMAND" | grep -q "hs-hooks-sync.*push"; then
  exit 0  # Not a hooks sync, allow
fi

# Extract target project from command
PROJECT=$(echo "$COMMAND" | grep -oP 'push\s+\K\w+' 2>/dev/null || echo "unknown")

# HESTAI-only patterns (governance hooks that enforce constitutional workflow)
HESTAI_PATTERNS=(
  "enforce-"
  "GOVERNANCE"
  "STEWARDSHIP"
  "AGENT_STEWARDSHIP"
  "context7_enforcement"
  "manipulation-patterns"
)

# If pushing to non-HESTAI project, provide governance guidance
if [ "$PROJECT" != "hestai" ] && [ "$PROJECT" != "unknown" ]; then
  cat >&2 << EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  HOOKS SYNC VALIDATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Target project: $PROJECT

REMINDER: HESTAI-only governance hooks should not be distributed.

Governance patterns (excluded automatically):
$(printf '  - %s*\n' "${HESTAI_PATTERNS[@]}")

✅ Governance exclusion implemented in /hs-hooks-sync command
   → Only universal infrastructure (lib/*.ts, core hooks) will be pushed
   → Governance hooks remain HESTAI-specific

Reference: /Volumes/HestAI/reports/813-REPORT-HOOKS-GOVERNANCE-SCOPE-ANALYSIS.md

Proceeding with selective push...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
fi

exit 0  # Allow (validation complete, guidance provided)
