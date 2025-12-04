#!/bin/bash
# enforce-traced-protocol.sh
# Enforces TRACED protocol for implementation work
# Blocks implementation without proper test/review/architecture checks

set -euo pipefail

input=$(cat)

# Extract information
tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null || echo "")

# Only check implementation files
[[ "$tool_name" =~ ^(Write|MultiEdit|Edit)$ ]] || exit 0
[[ "$file_path" =~ \.(tsx?|jsx?|py|go|java|rs)$ ]] || exit 0
[[ "$file_path" =~ \.(test|spec)\. ]] && exit 0  # Tests are part of T in TRACED

# Check for active implementation work
if [[ "$file_path" =~ /src/ ]] && [[ ! "$file_path" =~ /(tests?|__tests__)/ ]]; then

  # Check for TRACED markers in the content
  HAS_TEST_MARKER=$(echo "$content" | grep -c "// TRACED-T:" || true)
  HAS_REVIEW_MARKER=$(echo "$content" | grep -c "// TRACED-R:" || true)
  HAS_ARCHITECTURE_MARKER=$(echo "$content" | grep -c "// TRACED-A:" || true)

  # Check for test file existence
  TEST_FILE="${file_path%.*}.test.${file_path##*.}"
  SPEC_FILE="${file_path%.*}.spec.${file_path##*.}"

  if [[ ! -f "$TEST_FILE" ]] && [[ ! -f "$SPEC_FILE" ]] && [[ $HAS_TEST_MARKER -eq 0 ]]; then
    cat >&2 <<EOF
HOOK_BLOCKED: TRACED_VIOLATION_T

MISSING: Test-First Development
FILE: $file_path

TRACED PROTOCOL VIOLATION:
T (Test First) - No test file found for implementation

Required:
1. Create test file first: ${TEST_FILE}
2. Write failing test (RED state)
3. Then implement feature (GREEN state)

To bypass (only if tests exist elsewhere):
Add marker to your code: // TRACED-T: Tests in [location]

COMMAND SEQUENCE:
1. Write ${TEST_FILE} with failing test
2. Run test to verify RED state
3. Then implement in $file_path

Reference: BUILD.oct.md lines 117-121
EOF
    exit 2
  fi

  # Check for review requirement (for substantial changes)
  if [[ $(echo "$content" | wc -l) -gt 50 ]] && [[ $HAS_REVIEW_MARKER -eq 0 ]]; then
    echo "⚠️  TRACED-R Reminder: Code review required after implementation" >&2
    echo "  Run: Task(subagent_type: 'code-review-specialist', prompt: 'review $file_path')" >&2
  fi

  # Check for architecture validation (for new files or major changes)
  if [[ ! -f "$file_path" ]] && [[ $HAS_ARCHITECTURE_MARKER -eq 0 ]]; then
    echo "⚠️  TRACED-A Reminder: Architecture validation recommended" >&2
    echo "  Run: mcp__hestai__critical-engineer for validation" >&2
  fi
fi

exit 0