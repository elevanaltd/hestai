#!/bin/bash

# /prepare - Context establishment and readiness verification
# Usage: /prepare [files...] [--scope <scope>] [--workflow <workflow>]
#
# Establishes comprehensive context understanding before workflow execution.
# Proactively discovers related files, identifies gaps, and confirms readiness.
#
# Options:
#   --scope <scope>     Context scope: feature|module|system|full (default: module)
#   --workflow <next>   Next workflow: enhance|build|deploy|debug|test (optional)
#   --depth <n>         Discovery depth: 1-5 (default: 3)
#   --strict           Require explicit confirmation before proceeding
#
# Examples:
#   /prepare src/auth.ts                    # Prepare auth module context
#   /prepare . --scope full --workflow build # Full project context for build
#   /prepare src/ --workflow enhance --strict # Strict preparation for enhancement

set -euo pipefail

# Configuration
SCOPE="${SCOPE:-module}"
WORKFLOW="${WORKFLOW:-}"
DEPTH="${DEPTH:-3}"
STRICT="${STRICT:-false}"
FILES=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --scope)
            SCOPE="$2"
            shift 2
            ;;
        --workflow)
            WORKFLOW="$2"
            shift 2
            ;;
        --depth)
            DEPTH="$2"
            shift 2
            ;;
        --strict)
            STRICT="true"
            shift
            ;;
        --*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            FILES+=("$1")
            shift
            ;;
    esac
done

# Default to current directory if no files specified
if [ ${#FILES[@]} -eq 0 ]; then
    FILES=(".")
fi

# Phase 1: Initial file reading
echo "===PREPARE: CONTEXT ESTABLISHMENT PROTOCOL==="
echo ""
echo "Phase 1: Reading provided files..."
echo "Files: ${FILES[*]}"
echo "Scope: $SCOPE"
[ -n "$WORKFLOW" ] && echo "Preparing for: $WORKFLOW workflow"
echo ""

# Convert files to absolute paths
ABS_FILES=()
for file in "${FILES[@]}"; do
    if [ -e "$file" ]; then
        ABS_FILES+=("$(realpath "$file")")
    fi
done

# Phase 2: Context discovery
echo "Phase 2: Discovering related context..."
echo ""
echo "INSTRUCTION: Use research-analyst to discover:"
echo "  1. Related implementation files (depth: $DEPTH)"
echo "  2. Test files and test patterns"
echo "  3. Configuration and dependencies"
echo "  4. Documentation and specifications"
echo "  5. Adjacent modules and interfaces"
echo ""

# Phase 3: Gap analysis
echo "Phase 3: Analyzing comprehension gaps..."
echo ""
echo "INSTRUCTION: Use coherence-oracle to identify:"
echo "  • Knowledge gaps: What context is missing?"
echo "  • Conflicts: Any contradictions or inconsistencies?"
echo "  • Assumptions: What needs clarification?"
echo "  • Dependencies: External systems or modules?"
echo "  • Risks: Potential issues for $WORKFLOW?"
echo ""

# Phase 4: Understanding validation
echo "Phase 4: Validating understanding..."
echo ""
echo "INSTRUCTION: Use requirements-steward to verify:"
echo "  ✓ North Star alignment (if exists)"
echo "  ✓ Workflow requirements understood"
echo "  ✓ Success criteria clear"
echo "  ✓ Constraints identified"
echo "  ✓ Test strategy understood"
echo ""

# Phase 5: Readiness assessment
echo "Phase 5: Readiness Assessment"
echo ""
echo "REQUIRED OUTPUT FORMAT:"
echo "┌────────────────────────────────────────┐"
echo "│ CONTEXT READINESS REPORT               │"
echo "├────────────────────────────────────────┤"
echo "│ ✓ Files Analyzed: [count]              │"
echo "│ ✓ Coverage: [percentage]%              │"
echo "│ ✓ Understanding: [HIGH/MEDIUM/LOW]     │"
echo "├────────────────────────────────────────┤"
echo "│ DISCOVERED CONTEXT:                    │"
echo "│   • [Key files found]                  │"
echo "│   • [Patterns identified]              │"
echo "│   • [Dependencies mapped]              │"
echo "├────────────────────────────────────────┤"
echo "│ GAPS & RISKS:                          │"
echo "│   ⚠ [Gap 1: description]               │"
echo "│   ⚠ [Gap 2: description]               │"
echo "├────────────────────────────────────────┤"
echo "│ STATUS: [READY/NEEDS_INPUT]            │"
echo "└────────────────────────────────────────┘"
echo ""

# Workflow-specific preparation
if [ -n "$WORKFLOW" ]; then
    echo "WORKFLOW-SPECIFIC PREPARATION: $WORKFLOW"
    echo ""
    
    case $WORKFLOW in
        enhance)
            echo "ENHANCE Checklist:"
            echo "  □ Current implementation understood"
            echo "  □ Test coverage analyzed"
            echo "  □ Enhancement goals clear"
            echo "  □ Breaking changes identified"
            echo "  □ Migration path considered"
            ;;
        build)
            echo "BUILD Checklist:"
            echo "  □ Requirements fully understood"
            echo "  □ Architecture patterns identified"
            echo "  □ Test strategy defined"
            echo "  □ Integration points mapped"
            echo "  □ Dependencies available"
            ;;
        deploy)
            echo "DEPLOY Checklist:"
            echo "  □ Environment configuration understood"
            echo "  □ Dependencies verified"
            echo "  □ Migration requirements clear"
            echo "  □ Rollback strategy defined"
            echo "  □ Monitoring plan established"
            ;;
        debug)
            echo "DEBUG Checklist:"
            echo "  □ Issue symptoms documented"
            echo "  □ Reproduction steps clear"
            echo "  □ Related code paths identified"
            echo "  □ Test failures analyzed"
            echo "  □ Recent changes reviewed"
            ;;
        test)
            echo "TEST Checklist:"
            echo "  □ Test framework understood"
            echo "  □ Existing patterns identified"
            echo "  □ Coverage gaps mapped"
            echo "  □ Edge cases considered"
            echo "  □ Test data requirements clear"
            ;;
    esac
    echo ""
fi

# Final instructions
echo "═══════════════════════════════════════════"
echo ""
if [ "$STRICT" = "true" ]; then
    echo "STRICT MODE: Require explicit user confirmation before proceeding"
    echo ""
fi

echo "NEXT STEPS:"
echo ""
echo "IF STATUS: READY"
echo "  → Report: 'READY for $WORKFLOW workflow. Full context established.'"
echo "  → Await: Next command will be '/$WORKFLOW' with full workflow execution"
echo "  → Commit: Must follow complete workflow protocol when received"
echo ""
echo "IF STATUS: NEEDS_INPUT"
echo "  → Report: Specific gaps and required information"
echo "  → Await: User response with additional context"
echo "  → Iterate: Re-run preparation until READY status achieved"
echo ""

echo "CRITICAL: Once READY is confirmed, you are COMMITTED to:"
echo "  1. Following the complete workflow protocol"
echo "  2. Using ALL required agents in sequence"
echo "  3. No shortcuts or simplifications"
echo "  4. Full TRACED compliance"
echo ""
echo "BEGIN CONTEXT ESTABLISHMENT NOW"