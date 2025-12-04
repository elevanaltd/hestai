#!/usr/bin/env bash
# North Star Location Enforcement Hook
# Enforces canonical location: .coord/workflow-docs/000-{PROJECT}-D1-NORTH-STAR.md

set -euo pipefail

# Read JSON input
input=$(cat)

# Extract tool information
tool_name=""
file_path=""
content=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")

  # Only process Write, MultiEdit, and Edit tools
  [[ "$tool_name" =~ ^(Write|MultiEdit|Edit)$ ]] || exit 0

  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

  # Extract content
  case "$tool_name" in
    Write)
      content=$(echo "$input" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
      ;;
    Edit)
      content=$(echo "$input" | jq -r '.tool_input.new_string // empty' 2>/dev/null || echo "")
      ;;
    MultiEdit)
      content=$(echo "$input" | jq -r '.tool_input.edits[].new_string // empty' 2>/dev/null | tr '\n' ' ' || echo "")
      ;;
  esac
fi

[[ -z "$content" || -z "$file_path" ]] && exit 0

# Skip hook files themselves
if [[ "$file_path" =~ \.claude/hooks/ ]]; then
  exit 0
fi

# Skip standards documents that aren't North Star
if [[ "$file_path" =~ /docs/standards/ ]] && [[ ! "$file_path" =~ NORTH-STAR\.md$ ]]; then
  exit 0
fi

# Check if this is actually a North Star document (not just mentioning it)
# Look for patterns that indicate it's THE North Star document
is_north_star=false

# Check filename patterns that indicate a North Star document
if [[ "$file_path" =~ (^|/).*NORTH-STAR\.md$ ]] || \
   [[ "$file_path" =~ (^|/).*D1-NORTH-STAR\.md$ ]] || \
   [[ "$file_path" =~ (^|/)000-.*NORTH-STAR\.md$ ]]; then
  is_north_star=true
fi

# For new files, check if content indicates it's a North Star document
if [[ "$tool_name" == "Write" ]] && [[ "$is_north_star" == "false" ]]; then
  # Check for North Star document markers in content
  if echo "$content" | head -20 | grep -qE "^#.*North Star" && \
     echo "$content" | grep -qE "(Purpose|Vision|Requirements|Scope):" ; then
    is_north_star=true
  fi
fi

# If not a North Star document, allow it
[[ "$is_north_star" == "false" ]] && exit 0

# Define canonical location pattern
canonical_pattern=".coord/workflow-docs/000-*-D1-NORTH-STAR.md"

# Check if file path matches canonical location
if [[ ! "$file_path" =~ \.coord/workflow-docs/000-.*-D1-NORTH-STAR\.md$ ]]; then

  # Extract project name if possible
  project_name=""
  if [[ "$file_path" =~ /([^/]+)/[^/]*$ ]]; then
    project_dir="${BASH_REMATCH[1]}"
    project_name=$(echo "$project_dir" | tr '[:lower:]' '[:upper:]' | sed 's/-/_/g')
  fi

  # Suggest canonical location
  if [[ -n "$project_name" ]]; then
    suggested_location=".coord/workflow-docs/000-${project_name}-D1-NORTH-STAR.md"
  else
    suggested_location=".coord/workflow-docs/000-PROJECT-NAME-D1-NORTH-STAR.md"
  fi

  cat >&2 <<LLM_MESSAGE
🎯 NORTH STAR LOCATION VIOLATION

WRONG_LOCATION: $file_path
CANONICAL_LOCATION: $suggested_location

NAMING_CONVENTION:
- Pattern: .coord/workflow-docs/000-{PROJECT}-D1-NORTH-STAR.md
- Project name in UPPERCASE with underscores
- Always in coordination repository (.coord/)
- Always in workflow-docs/ subdirectory
- Always numbered 000 (highest priority)
- Always tagged D1 (Requirements phase)

RATIONALE:
- Single source of truth location
- Consistent across all projects
- Easy for hooks and tools to find
- Survives repository reorganization
- Clear priority (000) and phase (D1)

ACTION_REQUIRED:
1. Move/rename to canonical location: $suggested_location
2. Update any references to point to new location
3. Use symlinks if build directories need access

BYPASS_ONLY_IF:
- This is a temporary draft (add // DRAFT: temporary-location)
- This is a reference/copy (add // REFERENCE: points-to-canonical)

NO_MULTIPLE_NORTH_STARS: Each project must have exactly one canonical North Star
LLM_MESSAGE

  # Check for bypass tokens
  if echo "$content" | grep -qE "// (DRAFT|REFERENCE):" 2>/dev/null; then
    echo "✅ North Star location bypass detected" >&2
    exit 0
  fi

  exit 2  # Blocking exit code
fi

echo "✅ North Star location compliance verified" >&2
exit 0