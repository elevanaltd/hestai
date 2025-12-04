#!/bin/bash
# PostToolUse hook: Auto-update sequence registry after document creation
# Triggered after Write/Edit operations on docs/reports directories

# Read JSON input from stdin
INPUT_JSON=$(cat)

# Extract tool_name and file_path
TOOL_NAME=$(echo "$INPUT_JSON" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_PATH=$(echo "$INPUT_JSON" | grep -o '"tool_input"[^}]*"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Only process Write tool (new files)
if [[ "$TOOL_NAME" != "Write" ]]; then
  exit 0
fi

# If no file_path found, exit
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILE_NAME=$(basename "$FILE_PATH")
DIR_PATH=$(dirname "$FILE_PATH")

# Only update registry for reports
if [[ ! "$DIR_PATH" =~ (^|/)(reports|\.coord/reports)(/|$) ]]; then
  exit 0
fi

# Extract sequence number from filename
if [[ ! "$FILE_NAME" =~ ^([0-9]{3})-REPORT ]]; then
  exit 0
fi

SEQUENCE="${BASH_REMATCH[1]}"
SEQUENCE_NUM=$((10#$SEQUENCE))  # Remove leading zeros for arithmetic

# Registry file location
REGISTRY_FILE="/Volumes/HestAI/docs/.registry/sequence-tracker.json"

if [[ ! -f "$REGISTRY_FILE" ]]; then
  exit 0
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
  exit 0
fi

# Get current last_sequence for reports
CURRENT_LAST=$(jq -r '.last_sequences.reports // 0' "$REGISTRY_FILE" 2>/dev/null)

# Only update if new sequence is higher
if [[ "$SEQUENCE_NUM" -gt "$CURRENT_LAST" ]]; then
  NEXT_SEQ=$((SEQUENCE_NUM + 1))
  TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Update registry
  TMP_FILE=$(mktemp)

  jq --argjson last "$SEQUENCE_NUM" \
     --argjson next "$NEXT_SEQ" \
     --arg ts "$TIMESTAMP" \
     '.last_sequences.reports = $last | .next_available.reports = $next | .metadata.last_updated = $ts' \
     "$REGISTRY_FILE" > "$TMP_FILE" 2>/dev/null

  if [[ $? -eq 0 && -s "$TMP_FILE" ]]; then
    mv "$TMP_FILE" "$REGISTRY_FILE"
    echo "📊 Registry updated: reports sequence now at $SEQUENCE_NUM (next: $NEXT_SEQ)" >&2
  else
    rm -f "$TMP_FILE"
  fi
fi

exit 0
