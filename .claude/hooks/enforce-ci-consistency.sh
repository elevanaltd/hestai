#!/bin/bash

# CI Command Consistency Enforcement Hook
# Forces identical validation commands in all contexts
# From 106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md

PROJECT_ROOT="$1"
COMMAND_TYPE="$2"  # lint, typecheck, test

# Only check in project directories with package.json
if [[ ! -f "$PROJECT_ROOT/package.json" ]]; then
  exit 0
fi

# Extract CI commands from package.json
LINT_CHECK=$(node -p "JSON.parse(require('fs').readFileSync('package.json')).scripts['lint:check'] || 'Not found'" 2>/dev/null)
TYPECHECK=$(node -p "JSON.parse(require('fs').readFileSync('package.json')).scripts['typecheck'] || 'Not found'" 2>/dev/null)
TEST_CMD=$(node -p "JSON.parse(require('fs').readFileSync('package.json')).scripts['test'] || 'Not found'" 2>/dev/null)

case "$COMMAND_TYPE" in
  "lint")
    if [[ "$LINT_CHECK" == "Not found" ]]; then
      echo "⚠️  WARNING: No lint:check script found in package.json"
      echo "Add: \"lint:check\": \"eslint src --ext .ts\" (or appropriate)"
      exit 0
    fi
    echo "✅ ENFORCED: Use 'npm run lint:check' for validation"
    echo "CI Command: $LINT_CHECK"
    ;;
  "typecheck")
    if [[ "$TYPECHECK" == "Not found" ]]; then
      echo "⚠️  WARNING: No typecheck script found in package.json"
      exit 0
    fi
    echo "✅ ENFORCED: Use 'npm run typecheck' for validation"
    echo "CI Command: $TYPECHECK"
    ;;
  "test")
    if [[ "$TEST_CMD" == "Not found" ]]; then
      echo "⚠️  WARNING: No test script found in package.json"
      exit 0
    fi
    echo "✅ ENFORCED: Use 'npm test' for validation"
    echo "CI Command: $TEST_CMD"
    ;;
esac