#!/usr/bin/env bash
# North Star Authority Enforcement Hook v1.0
# Requires human authorization for North Star document changes
# Prevents unauthorized scope changes while allowing legitimate evolution

set -euo pipefail

# Hook integrity validation
HOOKS_DIR="/Users/shaunbuswell/.claude/hooks"
CHECKSUMS_FILE="$HOOKS_DIR/.checksums"
if [[ -f "$CHECKSUMS_FILE" ]]; then
  if ! (cd "$HOOKS_DIR" && shasum -c .checksums >/dev/null 2>&1); then
    echo "🚨 SECURITY BREACH: Hook system integrity compromised" >&2
    echo "   Run /lock-hooks to restore system integrity" >&2
    exit 1
  fi
fi

# Read JSON input from stdin
input=$(cat)

# Extract tool information using jq (if available)
tool_name=""
file_path=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
  
  # Only process Write, MultiEdit, and Edit tools
  if [[ "$tool_name" != "Write" && "$tool_name" != "MultiEdit" && "$tool_name" != "Edit" ]]; then
    exit 0
  fi
  
  # Extract file path
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
fi

# Skip agent definition files (false positive for north-star-architect.oct.md)
if [[ "$file_path" =~ /agents/.*\.oct\.md$ ]]; then
  exit 0
fi

# Check if this is a North Star document
if [[ "$file_path" =~ (NORTH_STAR|north.star).*\.md$ ]] || [[ "$file_path" =~ 000-.*NORTH_STAR\.md$ ]]; then
  
  # Check for session authorization token (any active session)
  session_token_pattern="/tmp/north_star_unlock_*"
  session_token=""
  
  # Find any valid authorization token
  for token in $session_token_pattern; do
    if [[ -f "$token" ]]; then
      session_token="$token"
      break
    fi
  done
  
  if [[ -z "$session_token" ]]; then
    # Allow initial creation by north-star-architect (file doesn't exist yet)
    if [[ "$tool_name" == "Write" ]] && [[ ! -f "$file_path" ]]; then
      echo "INFO: North Star initial creation allowed (north-star-architect authority)" >&2
      exit 0
    fi

    cat >&2 <<EOF

🚨 NORTH STAR MODIFICATION BLOCKED

North Star document changes require explicit human authorization.
This prevents unauthorized scope changes and ensures governance oversight.

File: $file_path

🔐 TO AUTHORIZE THIS SESSION:

Run this command to unlock North Star modifications:
   /authorize-north-star-change

The authorization will be valid for this session only and expires automatically.

🎯 GOVERNANCE PRINCIPLE:
North Star documents define project scope and strategic direction.
Changes require human authority to prevent scope creep and maintain alignment.

NOTE: Initial North Star creation by north-star-architect does not require authorization.
This hook only protects MODIFICATIONS to existing North Star documents.

If this is legitimate evolution (not scope creep), use the authorization command above.

EOF
    exit 2
  else
    # Authorization exists - log and allow
    auth_info=$(cat "$session_token" 2>/dev/null || echo "Unknown")
    echo "INFO: North Star modification authorized - $auth_info" >&2
    exit 0
  fi
fi

# Allow operation if not North Star related
exit 0