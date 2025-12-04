#!/bin/bash

# Error Resolution Validation Hook
# Requires systematic error analysis for error claims
# From 106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md

MESSAGE="$1"

# Detect error resolution claims
ERROR_PATTERNS=(
  "fixed.*error"
  "resolved.*issue"
  "error.*corrected"
  "bug.*fixed"
  "issue.*resolved"
)

REQUIRES_INVESTIGATION=(
  "unhandled.*rejection"
  "typescript.*error"
  "lint.*error"
  "test.*fail"
  "ci.*fail"
)

for PATTERN in "${ERROR_PATTERNS[@]}"; do
  if echo "$MESSAGE" | grep -qiE "$PATTERN"; then
    # Check if this is a complex error requiring investigation
    for COMPLEX_PATTERN in "${REQUIRES_INVESTIGATION[@]}"; do
      if echo "$MESSAGE" | grep -qiE "$COMPLEX_PATTERN"; then
        echo "💡 SUGGESTION: Complex error requires systematic investigation"
        echo "Error type: $(echo "$MESSAGE" | grep -iE "$COMPLEX_PATTERN")"
        echo ""
        echo "Consider using error-resolver agent for:"
        echo "  - Root cause analysis (RCCAFP framework)"
        echo "  - Evidence-based investigation"
        echo "  - Prevention mechanism implementation"
        echo ""
        echo "Pattern: Claim → Investigation → Evidence → Fix → Verification"
        # Non-blocking suggestion
      fi
    done
  fi
done