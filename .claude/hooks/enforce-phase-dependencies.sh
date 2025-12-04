#!/bin/bash
# Enforce phase dependencies for PROJECT deliverables
# Blocks phase documents without prerequisite deliverables

set -euo pipefail

# Read JSON input from stdin
INPUT_JSON=$(cat)

# Extract tool_name and file_path from the JSON
TOOL_NAME=$(echo "$INPUT_JSON" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_PATH=$(echo "$INPUT_JSON" | grep -o '"tool_input"[^}]*"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Only process Write, MultiEdit, and Edit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "MultiEdit" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

# If no file_path found, exit successfully
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILE_NAME=$(basename "$FILE_PATH")
DIR_PATH=$(dirname "$FILE_PATH")

# Only check PROJECT deliverables in docs/
if [[ ! "$DIR_PATH" =~ (^|/)(docs)(/|$) ]] || [[ ! "$FILE_NAME" =~ ^[0-9]{3}-PROJECT.*-(D1|D2|D3|B0|B1|B2|B3|B4)- ]]; then
  exit 0
fi

# Extract project identifier and phase  
if [[ "$FILE_NAME" =~ ^([0-9]{3}-PROJECT-[^-]+)-([DB][0-9])-(.+)$ ]]; then
  PROJECT_BASE="${BASH_REMATCH[1]}"
  CURRENT_PHASE="${BASH_REMATCH[2]}"
else
  # Not a valid PROJECT phase document pattern
  exit 0
fi

# Define phase dependencies
case "$CURRENT_PHASE" in
  "D1") exit 0 ;;  # No dependencies
  "D2") REQUIRED_PHASE="D1" ;;
  "D3") REQUIRED_PHASE="D2" ;;
  "B0") REQUIRED_PHASE="D3" ;;
  "B1") REQUIRED_PHASE="B0" ;;
  "B2") REQUIRED_PHASE="B1" ;;
  "B3") REQUIRED_PHASE="B2" ;;
  "B4") REQUIRED_PHASE="B3" ;;
  *) exit 0 ;;  # Unknown phase, allow
esac

# Check if prerequisite deliverable exists
SEARCH_PATTERN="$DIR_PATH/${PROJECT_BASE}-${REQUIRED_PHASE}-*.md"
if ! ls $SEARCH_PATTERN >/dev/null 2>&1; then
  cat >&2 <<EOF
🚨 BLOCKING: Missing prerequisite deliverable

Attempting to create: $FILE_NAME
Required phase: $REQUIRED_PHASE must exist first

Missing prerequisite pattern: ${PROJECT_BASE}-${REQUIRED_PHASE}-*.md

Phase progression requirements:
  D1 (North Star) → D2 (Design) → D3 (Blueprint) → B0 (Validation)
  B0 (Validation) → B1 (Planning) → B2 (Implementation) → B3 (Integration) → B4 (Delivery)

Create the prerequisite deliverable first, then retry.
EOF
  exit 2
fi

exit 0