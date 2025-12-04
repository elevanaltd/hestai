#!/bin/bash

# Validation Claim Verification Hook
# Requires evidence artifacts for quality claims
# From 106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md

MESSAGE="$1"

# Detect quality claims without evidence
CLAIM_PATTERNS=(
  "all.*eslint.*fixed"
  "no.*errors.*warnings"
  "lint.*clean"
  "typecheck.*passes"
  "all.*tests.*pass"
  "validation.*complete"
)

for PATTERN in "${CLAIM_PATTERNS[@]}"; do
  if echo "$MESSAGE" | grep -qiE "$PATTERN"; then
    echo "🚨 BLOCKING: Quality claims require evidence"
    echo "Detected claim: $(echo "$MESSAGE" | grep -iE "$PATTERN")"
    echo ""
    echo "Required evidence formats:"
    echo "  ✅ Command output: \`npm run lint:check\` (0 errors, 0 warnings)"
    echo "  ✅ Test results: \`npm test\` (98 tests passed)"
    echo "  ✅ TypeCheck: \`npm run typecheck\` (no errors)"
    echo ""
    echo "NEVER claim success without running exact CI commands"
    exit 2  # Using successful blocking exit code pattern
  fi
done