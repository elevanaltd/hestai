#!/bin/bash
# enforce-role-boundaries.sh
# Prevents agents from exceeding their constitutional boundaries
# Enforces proper delegation patterns per BUILD.oct.md

set -euo pipefail

# EMERGENCY DISABLE: Hook causing too many false positives
# Blocking legitimate Task-invoked agent work
# TODO: Need better Task detection mechanism
echo "⚠️  Role boundary enforcement temporarily disabled - false positive issues" >&2
exit 0

# Read input
input=$(cat)

# Extract tool and content information
tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Only check Write/Edit operations
[[ "$tool_name" =~ ^(Write|MultiEdit|Edit)$ ]] || exit 0

# Check for active role marker
ACTIVE_ROLE=""

# IMPORTANT: Only consider role markers created in last 5 minutes
# This prevents stale markers from previous sessions affecting current work
CUTOFF_TIME=$(($(date +%s) - 300))

for marker in /tmp/active_role_*; do
  if [[ -f "$marker" ]]; then
    # Extract timestamp from filename
    MARKER_TIME=$(echo "$marker" | sed 's/.*active_role_[^_]*_\([0-9]*\)_.*/\1/')

    # Skip if marker is too old (likely from previous session)
    if [[ "$MARKER_TIME" -lt "$CUTOFF_TIME" ]]; then
      continue
    fi

    # Check if this is a DIRECT role activation (not Task-invoked)
    # Task-invoked agents don't create role markers via /role command
    if grep -q "DIRECT_ACTIVATION" "$marker" 2>/dev/null; then
      ACTIVE_ROLE=$(grep "^ROLE:" "$marker" | cut -d' ' -f2)
      break
    fi
  fi
done

# HEURISTIC: If no direct activation marker found, check if we're in a Task context
# by looking for recent Task tool invocations in the input stream
if [[ -z "$ACTIVE_ROLE" ]]; then
  # No explicit role activation - likely either human or Task-invoked agent
  # Let it through as we can't determine definitively
  echo "✓ No explicit role constraints detected" >&2
  exit 0
fi

# If no role detected, pass through (human user)
[[ -z "$ACTIVE_ROLE" ]] && exit 0

# Define role boundaries using case statements for compatibility
is_orchestrator_role() {
  case "$1" in
    holistic-orchestrator|coherence-oracle|eav-coherence-oracle|workflow-orchestrator)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_implementation_role() {
  case "$1" in
    implementation-lead|error-resolver|completion-architect|error-architect)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_architect_role() {
  case "$1" in
    technical-architect|design-architect|workspace-architect|visual-architect)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Check if file is implementation code (not docs/configs)
is_implementation_file() {
  local file="$1"

  # Implementation files
  [[ "$file" =~ \.(tsx?|jsx?|py|go|java|rs|cpp|c|h)$ ]] && \
  [[ ! "$file" =~ \.(test|spec|config|setup)\. ]] && \
  [[ ! "$file" =~ /(tests?|docs?|config)/ ]] && \
  return 0

  return 1
}

# Check role violations
if is_orchestrator_role "$ACTIVE_ROLE"; then
  if is_implementation_file "$file_path"; then
    cat >&2 <<EOF
HOOK_BLOCKED: ROLE_BOUNDARY_VIOLATION

ROLE: $ACTIVE_ROLE (Orchestrator)
ACTION: Direct implementation detected
FILE: $file_path

CONSTITUTIONAL VIOLATION:
Orchestrators must ORCHESTRATE, not IMPLEMENT.

Per BUILD.oct.md:
IF_ORCHESTRATOR→ORCHESTRATE_PATTERN::[
  IDENTIFY_SPECIALISTS→phase_appropriate,
  INVOKE::Task(specialist, context),
  MONITOR→cross_boundary_coherence
]

REQUIRED ACTION:
1. Identify the appropriate specialist:
   - For B2 implementation: implementation-lead
   - For error fixes: error-resolver
   - For integration: completion-architect

2. Invoke via Task tool:
   Task(
     subagent_type: "implementation-lead",
     prompt: "[your implementation requirements]"
   )

3. Monitor and coordinate, don't implement

ALTERNATIVE:
If you need to demonstrate or prototype:
1. Create a file in /tmp/ for demonstration
2. Then delegate to proper specialist for production implementation

NO BYPASS: Orchestrators orchestrate, implementers implement.
EOF
    exit 2
  fi
fi

# Check if architects are doing implementation instead of design
if is_architect_role "$ACTIVE_ROLE"; then
  # Architects can create design docs and configs, but not implementation
  if is_implementation_file "$file_path" && [[ ! "$file_path" =~ \.d\.ts$ ]]; then
    cat >&2 <<EOF
HOOK_BLOCKED: ARCHITECT_IMPLEMENTATION_VIOLATION

ROLE: $ACTIVE_ROLE (Architect)
ACTION: Direct implementation detected
FILE: $file_path

CONSTITUTIONAL VIOLATION:
Architects design, they don't implement.

Per BUILD.oct.md:
IF_ARCHITECT→DESIGN_PATTERN::[
  DESIGN→validate→delegate_to_implementation
]

REQUIRED ACTION:
1. Complete your design/architecture
2. Validate with critical-engineer
3. Delegate to implementation-lead:
   Task(
     subagent_type: "implementation-lead",
     prompt: "Implement this design: [your design]"
   )

ALLOWED:
- Architecture documents (*.md)
- Type definitions (*.d.ts)
- Configuration files
- Design patterns

NO BYPASS: Maintain separation of design and implementation.
EOF
    exit 2
  fi
fi

echo "✓ Role boundaries respected: $ACTIVE_ROLE" >&2
exit 0