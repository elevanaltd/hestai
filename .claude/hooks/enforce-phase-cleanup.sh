#!/bin/bash
# Enforce phase transition cleanup

PHASE=$1
CURRENT_DIR=$(pwd)

# Check if at phase transition point
if [[ "$PHASE" =~ (B1_02|B2_04|B3_04|B4_05) ]]; then
  echo "⚠️ PHASE TRANSITION CLEANUP REQUIRED"
  echo ""
  echo "Directory placement violations must be resolved before continuing."
  echo ""
  echo "CLEANUP ORCHESTRATION SEQUENCE:"
  echo "1. holistic-orchestrator → directory-curator[analyze]"
  echo "2. directory-curator → report violations"
  echo "3. holistic-orchestrator → workspace-architect[fix]"
  echo "4. Validate clean state"
  echo ""
  echo "MANDATORY ACTION:"
  echo "1. Run: /role holistic-orchestrator"
  echo "2. Request: 'Perform phase transition cleanup for $PHASE'"
  echo ""
  echo "See: /Users/shaunbuswell/.claude/protocols/DOCUMENT_PLACEMENT_AND_VISIBILITY.md"
  echo ""
  echo "Phase progression blocked until cleanup complete."
  exit 1
fi

# Special check for B1_03 - must be in build directory
if [[ "$PHASE" == "B1_03" ]] && [[ ! "$CURRENT_DIR" =~ "/build" ]]; then
  echo "❌ ERROR: B1_03 must be executed in build directory"
  echo ""
  echo "Current directory: $CURRENT_DIR"
  echo "Required: */build/"
  echo ""
  echo "MIGRATION GATE NOT PASSED"
  echo "1. cd /Volumes/HestAI-Projects/{PROJECT}/build/"
  echo "2. Then run B1_03"
  exit 1
fi

echo "✓ Phase $PHASE validation passed"