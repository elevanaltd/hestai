#!/usr/bin/env bash
# TRACED Protocol: C (Consult) Bash Command Interceptor - v1.0
# Prevents circumvention of governance via shell commands
# Companion to enforce-traced-consult.sh

set -euo pipefail

# Read bash command from stdin
command=$(cat)

# Configuration
REGISTRY_DB="$HOME/.claude/hooks/registry.db"
TMP_DIR="/tmp"
HOOKS_DIR="$HOME/.claude/hooks"

# Load helpers
[[ -f "$HOOKS_DIR/lib/anti-manipulation-helpers.sh" ]] && source "$HOOKS_DIR/lib/anti-manipulation-helpers.sh"
[[ -f "$HOOKS_DIR/lib/integration-detection.sh" ]] && source "$HOOKS_DIR/lib/integration-detection.sh"
[[ -f "$HOOKS_DIR/lib/registry-helpers-sqlite.sh" ]] && source "$HOOKS_DIR/lib/registry-helpers-sqlite.sh"

# =============================================================================
# TIER -2: REGISTRY TOKEN VALIDATION (Check First)
# =============================================================================
check_approval_token() {
  local command="$1"
  
  # Check for approval token in command
  if echo "$command" | grep -qE "(TESTGUARD|CRITICAL|ARCHITECT|TECHNICAL)-APPROVED:[[:space:]]*[A-Z0-9-]+" 2>/dev/null; then
    local token=$(echo "$command" | grep -oE "(TESTGUARD|CRITICAL|ARCHITECT|TECHNICAL)-APPROVED:[[:space:]]*[A-Z0-9-]+" | sed 's/.*APPROVED:[[:space:]]*//' | head -1)
    
    if [[ -n "$token" ]]; then
      echo "🔍 Checking bash approval token: $token" >&2
      
      # Validate token in SQLite registry, with fallback for known pattern tokens
      if validate_token_in_registry "$token" "$command"; then
        echo "✅ Valid approval token - bash command approved by specialist" >&2
        
        # Mark token as used
        mark_token_used "$token"
        
        # Log successful use
        log_approval_use "$token" "bash_command" "success"
        
        exit 0
      elif [[ "$token" =~ ^(CONTRACT-DRIVEN-CORRECTION|TEST-IMPROVEMENT|CODE-ALIGNMENT|CLEANUP-AFTER-SECURITY-FIX)$ ]]; then
        echo "✅ Recognized pattern token: $token - bash command approved" >&2
        echo "⚠️  Pattern token used - consider using registry for future approvals" >&2
        exit 0
      else
        echo "❌ Invalid or expired approval token: $token" >&2
        log_approval_use "$token" "bash_command" "failed"
        # Continue to normal blocking flow
      fi
    fi
  fi
}

# Check for approval token first
check_approval_token "$command"

# =============================================================================
# TIER -1: HOOK INFRASTRUCTURE EXEMPTION
# =============================================================================
if echo "$command" | grep -qE "\.claude/hooks/"; then
  echo "✓ HOOK_INFRASTRUCTURE: Hook system commands exempt from restrictions" >&2
  exit 0
fi

# =============================================================================
# TIER 1: DIRECT FILE MANIPULATION DETECTION
# =============================================================================
detect_file_manipulation() {
  local command="$1"
  
  # Detect direct editing of test files
  if echo "$command" | grep -qE "(sed -i|awk -i|perl -pi|vim|nano|echo.*>|>>).*\.(test|spec)\."; then
    return 0  # Manipulation detected
  fi
  
  # Detect indirect manipulation via redirection
  if echo "$command" | grep -qE ".*>.*\.(test|spec)\."; then
    return 0  # Manipulation detected
  fi
  
  return 1  # No manipulation
}

if detect_file_manipulation "$command"; then
  # Extract potential file path for context
  file_pattern=$(echo "$command" | grep -oE "[^[:space:]]+\.(test|spec)\.[^[:space:]]+" | head -1)
  
  # Save blocked command
  blocked_file="${TMP_DIR}/blocked-bash-$(date +%s)-$$"
  echo "$command" > "$blocked_file"
  
  cat >&2 <<LLM_MESSAGE
🛑 BASH CIRCUMVENTION DETECTED

BLOCKED COMMAND: Direct test file manipulation
FILE PATTERN: $file_pattern
SAVED: $blocked_file

VIOLATION: Shell editing bypasses governance and quality gates

COMMAND BLOCKED: $command

REQUIRED ACTIONS:
1. Use proper Edit tool: Edit(file_path="...", old_string="...", new_string="...")
2. Follow governance process with specialist consultation if needed
3. For test changes: mcp__hestai__testguard "review change"
4. Add approval token if pre-approved: // TESTGUARD-APPROVED: [token]

ALTERNATIVE APPROACHES:
- Use Edit tool with proper old_string/new_string parameters
- Use MultiEdit for multiple changes in single file
- Consult TestGuard for test integrity validation

PURPOSE: Ensure all file modifications follow quality gates and prevent test manipulation
NO BYPASS: Direct shell editing circumvents established governance protocols
LLM_MESSAGE
  exit 2
fi

# =============================================================================
# TIER 2: SUSPICIOUS COMMAND PATTERN DETECTION
# =============================================================================
detect_suspicious_patterns() {
  local command="$1"
  
  # Detect potential test result manipulation
  if echo "$command" | grep -qE "(grep -v|sed.*d|awk.*skip).*test"; then
    return 0  # Suspicious pattern
  fi
  
  # Detect coverage manipulation
  if echo "$command" | grep -qE "(coverage|lcov|jest|vitest).*--.*"; then
    if echo "$command" | grep -qE "(--coverage=false|--skip-coverage|--no-coverage)"; then
      return 0  # Coverage bypassing
    fi
  fi
  
  return 1  # No suspicious patterns
}

if detect_suspicious_patterns "$command"; then
  blocked_file="${TMP_DIR}/blocked-suspicious-$(date +%s)-$$"
  echo "$command" > "$blocked_file"
  
  cat >&2 <<LLM_MESSAGE
⚠️  SUSPICIOUS COMMAND PATTERN DETECTED

COMMAND: $command
SAVED: $blocked_file

PATTERN: Potential test result or coverage manipulation

ACTION_REQUIRED:
1. Review command intent with specialist
2. If legitimate, add justification comment
3. Consider using proper testing tools instead

CONSULTATION: mcp__hestai__testguard "review suspicious command: $blocked_file"
LLM_MESSAGE
  exit 3
fi

# =============================================================================
# TIER 3: EDUCATIONAL WARNINGS FOR RISKY PATTERNS
# =============================================================================
if echo "$command" | grep -qE "(rm.*test|mv.*test|cp.*test)"; then
  echo "⚠️  WARNING: Command affects test files - ensure this follows proper governance" >&2
  echo "💡 TIP: Consider using Edit/MultiEdit tools for safer file operations" >&2
fi

# Allow command to proceed
echo "✅ Bash command passes governance checks" >&2
exit 0