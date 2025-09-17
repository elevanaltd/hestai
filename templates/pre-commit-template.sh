#!/bin/sh
# HestAI Quality Enforcement Pre-commit Hook
# Prevents commits that don't meet quality standards

. "$(dirname "$0")/_/husky.sh"

echo "🔍 Running quality checks..."

# Run formatting first (auto-fix if possible)
echo "📝 Checking code formatting..."
npm run format 2>/dev/null || {
  echo "⚠️  No format script found, running individual tools..."
  npx prettier --write . 2>/dev/null || echo "⚠️  Prettier not available"
  npx eslint --fix . 2>/dev/null || echo "⚠️  ESLint auto-fix not available"
}

# Type checking (critical - no auto-fix available)
echo "🔧 Running TypeScript checks..."
npm run typecheck || {
  echo "❌ TypeScript compilation failed"
  echo "Run 'npm run typecheck' to see specific errors"
  exit 1
}

# Linting (critical - must pass after auto-fix)
echo "📋 Running lint checks..."
npm run lint:check || npm run lint || {
  echo "❌ Linting failed"
  echo "Run 'npm run lint' to see specific errors"
  echo "Use 'npm run lint:fix' to auto-fix if available"
  exit 1
}

# Test validation (ensure tests still pass)
echo "🧪 Running test suite..."
npm test || {
  echo "❌ Tests failed"
  echo "Fix failing tests before committing"
  exit 1
}

# Integration validation check
echo "🔗 Checking for unused variables/incomplete integrations..."
# This grep pattern catches common incomplete integration patterns
UNUSED_VARS=$(grep -r "const.*=.*validate\|let.*=.*validate" src/ 2>/dev/null | grep -v "test\|spec" | head -5)
if [ -n "$UNUSED_VARS" ]; then
  echo "⚠️  Potential unused validation variables detected:"
  echo "$UNUSED_VARS"
  echo ""
  echo "🔍 Please verify these validation results are actually used in execution flow"
  echo "This is a warning - commit will proceed but review recommended"
fi

echo "✅ All quality checks passed!"