#!/usr/bin/env bash
# Holistic Orchestrator Role Hook - Prevent Implementation, Enforce Delegation
# Triggers only when role=holistic-orchestrator and attempting code writing

set -euo pipefail

# Read JSON input
input=$(cat)

# Check if we're in an active holistic-orchestrator role
ACTIVE_ROLE=""
if [[ -f /tmp/active_role_holistic-orchestrator_* ]] 2>/dev/null; then
    ACTIVE_ROLE="holistic-orchestrator"
fi

# Only apply to holistic orchestrator
[[ "$ACTIVE_ROLE" != "holistic-orchestrator" ]] && exit 0

# Extract tool information
tool_name=""
file_path=""
content=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")

  # Only check code-writing tools
  [[ "$tool_name" =~ ^(Write|MultiEdit|Edit)$ ]] || exit 0

  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

  # Extract content
  case "$tool_name" in
    Write)
      content=$(echo "$input" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
      ;;
    Edit)
      content=$(echo "$input" | jq -r '.tool_input.new_string // empty' 2>/dev/null || echo "")
      ;;
    MultiEdit)
      content=$(echo "$input" | jq -r '.tool_input.edits[].new_string // empty' 2>/dev/null | tr '\n' ' ' || echo "")
      ;;
  esac
fi

[[ -z "$content" || -z "$file_path" ]] && exit 0

# Check for orchestrator override token
if echo "$content" | grep -qE "// ORCHESTRATOR-IMPLEMENTATION-OVERRIDE:" 2>/dev/null; then
  echo "✅ Orchestrator implementation override detected - allowing direct code writing" >&2
  exit 0
fi

# Exempt documentation and configuration files
if [[ "$file_path" =~ \.(md|txt|json|yaml|yml|toml|env)$ ]]; then
  echo "✅ Documentation/config file - orchestrator may write directly" >&2
  exit 0
fi

# Exempt coordination directory (orchestrator creates context files for delegation)
if [[ "$file_path" =~ \.coord/ ]] || [[ "$file_path" =~ ^\.coord/ ]]; then
  echo "✅ Coordination context file - orchestrator may write for delegation context" >&2
  exit 0
fi

# Exempt anchor directory (context preservation for drift prevention)
if [[ "$file_path" =~ \.anchor/ ]] || [[ "$file_path" =~ ^\.anchor/ ]]; then
  echo "✅ Anchor context file - orchestrator may write for context preservation" >&2
  exit 0
fi

# Exempt sessions directory (orchestrator may document findings)
if [[ "$file_path" =~ sessions/ ]] && [[ "$file_path" =~ \.(md|txt)$ ]]; then
  echo "✅ Session documentation - orchestrator may write findings" >&2
  exit 0
fi

# Exempt hook files (orchestrator may need to create delegation hooks)
if [[ "$file_path" =~ \.claude/hooks/ ]]; then
  echo "✅ Hook infrastructure - orchestrator may write directly" >&2
  exit 0
fi

# Check if this is ANY code file (including tests - orchestrator delegates ALL implementation)
if [[ "$file_path" =~ \.(js|ts|tsx|jsx|py|go|rs|java|cpp|c|sh|rb|php|swift|kt|scala|clj)$ ]]; then
  # Save the blocked implementation
  blocked_file="/tmp/blocked-orchestrator-$(date +%s)-$$"
  echo "$content" > "$blocked_file"

  cat >&2 <<LLM_MESSAGE
🚫 HOLISTIC ORCHESTRATOR: ROLE VIOLATION

VIOLATION: Holistic orchestrators delegate ALL code (including tests), they don't write code directly

BLOCKED_CONTENT: $blocked_file
FILE_TYPE: Code file ($(basename "$file_path"))
TEST_FILE: $(echo "$file_path" | grep -E '\.(test|spec)\.' >/dev/null && echo "YES - Still must delegate" || echo "NO")

CONSTITUTIONAL_AUTHORITY: Your role is system-wide orchestration, not implementation

CORRECT_APPROACH:
1. Write context to .coord/current-task.md with full requirements
2. Use Task tool: implementation-lead → "See .coord/current-task.md for requirements"
3. Or Task tool: {specialist} → domain expert with rich context
4. Or MCP tool: critical-engineer → validate approach first

EXAMPLE_DELEGATION:
# First, preserve context:
Write(".coord/auth-context-requirements.md", "Full requirements here...")
# Then delegate with reference:
Task(implementation-lead, "Implement auth context per .coord/auth-context-requirements.md")

# Or use rich inline context:
Task(implementation-lead, """
  Implement auth context for audit logs:
  - Use AsyncLocalStorage from node:async_hooks
  - Modify src/audit/audit-logger.ts
  - Write tests first in src/audit/audit-context.test.ts
  - Include userId, sessionId, requestId fields
  """)

OVERRIDE_ONLY_IF:
- Emergency situation requiring direct intervention
- Add: // ORCHESTRATOR-IMPLEMENTATION-OVERRIDE: emergency-justification

MISSION: Orchestrate the system, don't implement it
BUCK_STOPS_HERE: For orchestration decisions, not coding tasks
LLM_MESSAGE

  exit 2  # Blocking exit code
fi

echo "✅ Orchestrator action approved - not direct implementation" >&2
exit 0