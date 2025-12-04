#!/usr/bin/env bash
# Activation script for anti-manipulation hooks
# Switches from risk-tier approach to test manipulation prevention

set -euo pipefail

HOOKS_DIR="$HOME/.claude/hooks"

echo "🔄 Activating Anti-Manipulation Hook System"
echo "=========================================="
echo ""
echo "PURPOSE: Prevent AI from weakening tests instead of fixing code"
echo ""

# Backup current hooks
echo "📦 Backing up current hooks..."
if [[ -f "$HOOKS_DIR/enforce-traced-consult.sh" ]]; then
  cp "$HOOKS_DIR/enforce-traced-consult.sh" "$HOOKS_DIR/enforce-traced-consult.sh.bak"
  echo "  ✓ Backed up enforce-traced-consult.sh"
fi

# Activate new anti-manipulation version
echo ""
echo "🚀 Activating anti-manipulation hooks..."
if [[ -f "$HOOKS_DIR/enforce-traced-consult-v2.sh" ]]; then
  mv "$HOOKS_DIR/enforce-traced-consult.sh" "$HOOKS_DIR/enforce-traced-consult.sh.old" 2>/dev/null || true
  cp "$HOOKS_DIR/enforce-traced-consult-v2.sh" "$HOOKS_DIR/enforce-traced-consult.sh"
  chmod +x "$HOOKS_DIR/enforce-traced-consult.sh"
  echo "  ✓ Activated enforce-traced-consult.sh (v2 - anti-manipulation)"
fi

echo ""
echo "✅ Anti-Manipulation System Active!"
echo ""
echo "🎯 What This Prevents:"
echo "  ❌ Changing test assertions to match broken code"
echo "  ❌ Weakening test specificity (toBe → toBeTruthy)"
echo "  ❌ Removing test validations"
echo "  ❌ Adding .skip() to failing tests"
echo "  ❌ Adjusting expected values to match actual output"
echo ""
echo "✅ What This Allows:"
echo "  ✓ Integration of already-tested components"
echo "  ✓ Test refactoring that maintains strictness"
echo "  ✓ Legitimate API updates with code changes"
echo "  ✓ Test infrastructure improvements"
echo ""
echo "📚 Key Files:"
echo "  • Hook: $HOOKS_DIR/enforce-traced-consult.sh"
echo "  • Helpers: $HOOKS_DIR/lib/anti-manipulation-helpers.sh"
echo "  • Detector: $HOOKS_DIR/lib/detect-test-manipulation.js"
echo "  • Patterns: $HOOKS_DIR/manipulation-patterns.yml"
echo ""
echo "🧪 Test the System:"
echo "  Try weakening a test assertion and watch it get blocked!"
echo ""
echo "🔄 To Rollback:"
echo "  cp $HOOKS_DIR/enforce-traced-consult.sh.bak $HOOKS_DIR/enforce-traced-consult.sh"