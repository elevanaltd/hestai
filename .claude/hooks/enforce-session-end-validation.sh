#!/usr/bin/env bash
# Session End Validation Hook - North Star & Build Plan Compliance Check
# Triggers on session end or major deliverable completion

set -euo pipefail

# Configuration
HOOKS_DIR="$HOME/.claude/hooks"
REGISTRY_DB="$HOME/.claude/hooks/registry.db"

# Load helpers
[[ -f "$HOOKS_DIR/lib/registry-helpers-sqlite.sh" ]] && source "$HOOKS_DIR/lib/registry-helpers-sqlite.sh"

# Read JSON input (if available, not all triggers provide it)
input=$(cat || echo '{}')

# Check if this is a session end or major completion marker
session_end_triggers=(
    "end"
    "complete"
    "finished"
    "done"
    "session end"
    "wrap up"
    "summary"
    "deliverable"
    "handoff"
)

# Extract user message if available
user_message=""
if command -v jq >/dev/null 2>&1; then
    user_message=$(echo "$input" | jq -r '.message // .user_message // .content // empty' 2>/dev/null || echo "")
fi

# Check if this looks like a session end
is_session_end=false
for trigger in "${session_end_triggers[@]}"; do
    if echo "$user_message" | grep -qi "$trigger" 2>/dev/null; then
        is_session_end=true
        break
    fi
done

# Also check if we're in a HestAI project directory with coordination docs
project_validation_needed=false
if [[ "$PWD" =~ /Volumes/HestAI-Projects/ ]] && [[ -d ".coord" || -d "../coordination" ]]; then
    project_validation_needed=true
fi

# Only proceed if this looks like a session end in a project context
if [[ "$is_session_end" != "true" && "$project_validation_needed" != "true" ]]; then
    exit 0
fi

# Function to find North Star document
find_north_star() {
    local north_star_file=""

    # Check common locations
    if [[ -f ".coord/workflow-docs/000-*-NORTH-STAR.md" ]]; then
        north_star_file=$(ls .coord/workflow-docs/000-*-NORTH-STAR.md 2>/dev/null | head -1)
    elif [[ -f "../coordination/workflow-docs/000-*-NORTH-STAR.md" ]]; then
        north_star_file=$(ls ../coordination/workflow-docs/000-*-NORTH-STAR.md 2>/dev/null | head -1)
    elif [[ -f ".coord/docs/000-*-NORTH-STAR.md" ]]; then
        north_star_file=$(ls .coord/docs/000-*-NORTH-STAR.md 2>/dev/null | head -1)
    elif [[ -f "../coordination/docs/000-*-NORTH-STAR.md" ]]; then
        north_star_file=$(ls ../coordination/docs/000-*-NORTH-STAR.md 2>/dev/null | head -1)
    fi

    echo "$north_star_file"
}

# Function to find build plan
find_build_plan() {
    local build_plan_file=""

    # Check common locations for B1 build plan
    if [[ -f ".coord/planning-docs/*B1-BUILD-PLAN.md" ]]; then
        build_plan_file=$(ls .coord/planning-docs/*B1-BUILD-PLAN.md 2>/dev/null | head -1)
    elif [[ -f "../coordination/planning-docs/*B1-BUILD-PLAN.md" ]]; then
        build_plan_file=$(ls ../coordination/planning-docs/*B1-BUILD-PLAN.md 2>/dev/null | head -1)
    fi

    echo "$build_plan_file"
}

# Check for validation bypass token
if echo "$user_message" | grep -qE "// VALIDATION-BYPASS:" 2>/dev/null; then
    echo "✅ Session validation bypass detected" >&2
    exit 0
fi

# Only proceed if we found key documents
north_star=$(find_north_star)
build_plan=$(find_build_plan)

if [[ -z "$north_star" && -z "$build_plan" ]]; then
    echo "ℹ️  No North Star or Build Plan found - skipping validation" >&2
    exit 0
fi

# If we have documents, suggest validation
if [[ -n "$north_star" || -n "$build_plan" ]]; then
    cat >&2 <<LLM_MESSAGE
🎯 SESSION END VALIDATION SUGGESTED

PROJECT_CONTEXT_AVAILABLE:
$(if [[ -n "$north_star" ]]; then echo "📋 North Star: $north_star"; fi)
$(if [[ -n "$build_plan" ]]; then echo "📊 Build Plan: $build_plan"; fi)

RECOMMENDED_VALIDATION:
1. Compare current work against North Star requirements
2. Check build plan compliance and timeline
3. Identify any scope drift or missing deliverables
4. Document lessons learned and next steps

VALIDATION_COMMANDS:
• Read("$north_star") - Review original requirements
$(if [[ -n "$build_plan" ]]; then echo "• Read(\"$build_plan\") - Check build plan compliance"; fi)
• Compare current state vs original scope
• Update project status in CONTEXT.md

BYPASS_IF_NOT_NEEDED:
Add: // VALIDATION-BYPASS: reason-for-skipping

BENEFIT: Prevents vibe coding drift, ensures deliverable completeness
LLM_MESSAGE

    # This is advisory only - don't block
    exit 0
fi

echo "✅ Session validation check complete" >&2
exit 0