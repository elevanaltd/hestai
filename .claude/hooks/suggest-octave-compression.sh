#!/bin/bash
# Suggest OCTAVE compression for eligible documentation

# Read JSON input from stdin
INPUT_JSON=$(cat)

# Extract tool_name and file_path from the JSON
TOOL_NAME=$(echo "$INPUT_JSON" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_PATH=$(echo "$INPUT_JSON" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Only process Write, MultiEdit, and Edit tools with file_path
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "MultiEdit" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

# If no file_path found, exit successfully
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILE_NAME=$(basename "$FILE_PATH")

# Check if this is a HestAI project
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
if [[ ! "$PROJECT_ROOT" =~ (HestAI|hestai|eav-orchestrator) ]] && 
   [[ ! -f "$PROJECT_ROOT/docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS"* ]]; then
  # Not a HestAI project, skip suggestions
  exit 0
fi

# Only check .md files (not already .oct.md)
if [[ ! "$FILE_PATH" =~ \.md$ ]] || [[ "$FILE_PATH" =~ \.oct\.md$ ]]; then
  exit 0
fi

# Only check documentation directories
if [[ ! "$FILE_PATH" =~ (^|/)(docs|reports)(/|$) ]]; then
  exit 0
fi

# Check if file exists and is readable
if [[ ! -f "$FILE_PATH" ]] || [[ ! -r "$FILE_PATH" ]]; then
  exit 0
fi

# Count lines and analyze content
LINE_COUNT=$(wc -l < "$FILE_PATH" 2>/dev/null || echo 0)

# Check for compression indicators (if file has 100+ lines)
if [[ $LINE_COUNT -gt 100 ]]; then
  # Count structured patterns that indicate compression potential
  PATTERN_COUNT=$(grep -c -E "(MUST|SHOULD|ALWAYS|NEVER|\:\:|→|←|↔)" "$FILE_PATH" 2>/dev/null || echo 0)
  
  # Count repeated words (high redundancy indicator)
  REDUNDANCY=$(grep -o -E '\b\w+\b' "$FILE_PATH" 2>/dev/null | sort | uniq -c | sort -rn | head -20 | awk '$1>5' | wc -l)
  
  if [[ $PATTERN_COUNT -gt 20 ]] || [[ $REDUNDANCY -gt 10 ]]; then
    echo ""
    echo "💡 SUGGESTION: Consider OCTAVE compression"
    echo "File: $FILE_NAME has compression potential"
    echo "  Lines: $LINE_COUNT"
    echo "  Pattern density: $PATTERN_COUNT structured patterns"
    echo "  Redundancy score: $REDUNDANCY repeated terms"
    echo "  Potential ratio: 3:1 or better"
    echo ""
    echo "To compress:"
    echo "  1. Apply patterns from 103-DOC-OCTAVE-COMPRESSION-RULES.md"
    echo "  2. Rename to: ${FILE_NAME%.md}.oct.md after compression"
    echo ""
  fi
fi

exit 0