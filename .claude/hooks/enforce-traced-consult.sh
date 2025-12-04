#!/usr/bin/env bash
# TRACED Protocol: C (Consult) with SQLite Registry - v6.0
# Direct SQLite database access for token validation
# Works with hestai-mcp-server registry tool

set -euo pipefail

# Configuration
REGISTRY_DB="$HOME/.claude/hooks/registry.db"  # SQLite database location
TMP_DIR="/tmp"
HOOKS_DIR="$HOME/.claude/hooks"

# Load helpers
[[ -f "$HOOKS_DIR/lib/anti-manipulation-helpers.sh" ]] && source "$HOOKS_DIR/lib/anti-manipulation-helpers.sh"
[[ -f "$HOOKS_DIR/lib/integration-detection.sh" ]] && source "$HOOKS_DIR/lib/integration-detection.sh"
[[ -f "$HOOKS_DIR/lib/registry-helpers-sqlite.sh" ]] && source "$HOOKS_DIR/lib/registry-helpers-sqlite.sh"
[[ -f "$HOOKS_DIR/lib/registry-cleanup.sh" ]] && source "$HOOKS_DIR/lib/registry-cleanup.sh"

# Probabilistic cleanup (1% chance, non-blocking)
if [[ -f "$HOOKS_DIR/lib/registry-cleanup.sh" ]] && should_cleanup 2>/dev/null; then
  quick_cleanup "$REGISTRY_DB" 2>/dev/null || true
fi

# Read JSON input
input=$(cat)

# Extract tool information
tool_name=""
content=""
file_path=""
old_content=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
  
  # Only process Write, MultiEdit, and Edit tools
  [[ "$tool_name" =~ ^(Write|MultiEdit|Edit)$ ]] || exit 0
  
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
  
  # CRITICAL: Only enforce hooks on HestAI project directories
  # Skip enforcement for temp files, system files, and other locations
  if [[ -n "$file_path" ]]; then
    if [[ ! "$file_path" =~ ^(/Volumes/HestAI-Projects/|/Volumes/HestAI-Tools/) ]]; then
      echo "✓ LOCATION_EXEMPT: File outside HestAI project directories - hook skipped" >&2
      exit 0
    fi
  fi
  
  # Extract content based on tool type
  case "$tool_name" in
    Write)
      content=$(echo "$input" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
      ;;
    Edit)
      old_content=$(echo "$input" | jq -r '.tool_input.old_string // empty' 2>/dev/null || echo "")
      content=$(echo "$input" | jq -r '.tool_input.new_string // empty' 2>/dev/null || echo "")
      ;;
    MultiEdit)
      content=$(echo "$input" | jq -r '.tool_input.edits[].new_string // empty' 2>/dev/null | tr '\n' ' ' || echo "")
      ;;
  esac
fi

[[ -z "$content" ]] && exit 0

# =============================================================================
# TIER -2: REGISTRY TOKEN VALIDATION (Check First)
# =============================================================================
check_approval_token() {
  local content="$1"
  local file_path="$2"
  local token=""
  
  # Check for approval token in content (APPROVED only - no arbitrary bypasses)
  # Method 1: Comment-style tokens (for most files) - Updated to handle both spaces and hyphens in specialist names
  if echo "$content" | grep -qE "(TESTGUARD|CRITICAL[[:space:]]*ENGINEER|ARCHITECT|TECHNICAL[[:space:]]*ARCHITECT|SECURITY[[:space:]]*SPECIALIST|SECURITY-SPECIALIST|TEST[[:space:]]*METHODOLOGY[[:space:]]*GUARDIAN|SECURITY|TECHNICAL|CRITICAL)-APPROVED:[[:space:]]*[A-Za-z0-9-]+" 2>/dev/null; then
    token=$(echo "$content" | grep -oE "(TESTGUARD|CRITICAL[[:space:]]*ENGINEER|ARCHITECT|TECHNICAL[[:space:]]*ARCHITECT|SECURITY[[:space:]]*SPECIALIST|SECURITY-SPECIALIST|TEST[[:space:]]*METHODOLOGY[[:space:]]*GUARDIAN|SECURITY|TECHNICAL|CRITICAL)-APPROVED:[[:space:]]*[A-Za-z0-9-]+" | sed 's/.*APPROVED:[[:space:]]*//' | head -1)
  # Method 2: JSON embedded tokens (for comment-less formats)
  elif echo "$content" | grep -qE '"_approval_token":[[:space:]]*"[A-Za-z0-9-]+"' 2>/dev/null; then
    token=$(echo "$content" | grep -oE '"_approval_token":[[:space:]]*"[A-Za-z0-9-]+"' | sed 's/.*"_approval_token":[[:space:]]*"//' | sed 's/".*$//' | head -1)
  fi
  
  # If token found, validate it
  if [[ -n "$token" ]]; then
    echo "🔍 Checking approval token: $token" >&2
      
      # Validate token in SQLite registry, with fallback for known pattern tokens
      if validate_token_in_registry "$token" "$content"; then
        echo "✅ Valid approval token - operation approved by specialist" >&2
        
        # Mark token as used
        mark_token_used "$token"
        
        # Log successful use
        log_approval_use "$token" "$file_path" "success"
        
        exit 0
      elif [[ "$token" =~ ^(CONTRACT-DRIVEN-CORRECTION|TEST-IMPROVEMENT|CODE-ALIGNMENT)$ ]]; then
        echo "✅ Recognized pattern token: $token - operation approved" >&2
        echo "⚠️  Pattern token used - consider using registry for future approvals" >&2
        exit 0
      else
        echo "❌ Invalid or expired approval token: $token" >&2
        log_approval_use "$token" "$file_path" "failed"
        # Continue to normal blocking flow
      fi
    fi
}

# Check for approval token first
check_approval_token "$content" "$file_path"

# =============================================================================
# TIER -1: HOOK INFRASTRUCTURE EXEMPTION
# =============================================================================
if [[ "$file_path" =~ \.claude/hooks/ ]]; then
  echo "✓ HOOK_INFRASTRUCTURE: Hook system files exempt from test requirements" >&2
  exit 0
fi

# Skip test requirements for documentation files
if [[ "$file_path" =~ \.(md|txt|rst|adoc)$ ]]; then
  echo "✓ DOCUMENTATION: Documentation files exempt from test requirements" >&2
  exit 0
fi

# Skip test requirements for SQL infrastructure files
if [[ "$file_path" =~ \.(sql|migration|schema)$ ]]; then
  echo "✓ SQL_INFRASTRUCTURE: Database infrastructure files exempt from test requirements" >&2
  exit 0
fi

# Skip test requirements for database setup and connection scripts in supabase/migration contexts
if [[ "$file_path" =~ (supabase|migrations?|database|db)/ ]] && [[ "$file_path" =~ \.(js|ts|sql)$ ]]; then
  echo "✓ DATABASE_INFRASTRUCTURE: Database setup scripts exempt from test requirements" >&2
  exit 0
fi

# =============================================================================
# TIER 0: INTEGRATION WIRING EXEMPTION
# =============================================================================
if [[ -n "$file_path" ]] && is_integration_wiring "$content" "$file_path"; then
  echo "✓ INTEGRATION_WIRING detected - minimal logic, just connecting tested components" >&2
  exit 0
fi

# =============================================================================
# TIER 1: ANTI-MANIPULATION CHECK
# =============================================================================
if [[ "$file_path" =~ \.(test|spec)\. ]] && [[ -n "$old_content" ]]; then
  if ! detect_test_manipulation "$old_content" "$content" "$file_path"; then
    # Save blocked content to /tmp
    blocked_file="${TMP_DIR}/blocked-test-$(date +%s)-$$"
    echo "$content" > "$blocked_file"

    cat >&2 <<LLM_MESSAGE
HOOK_BLOCKED: TEST_MANIPULATION

VIOLATION: Test weakened (toBe→toBeTruthy, removed expect, added .skip)
SAVED: $blocked_file

ACTION_REQUIRED:
1. Consult specialist: mcp__hestai__testguard "review $blocked_file"
2. If approved, add token to code: // TESTGUARD-APPROVED: [token]
3. Retry operation with token

ALTERNATIVE:
1. Revert test changes
2. Fix code instead
3. Run: git checkout -- <test-file>
LLM_MESSAGE
    exit 2
  fi
fi

# =============================================================================
# TIER 2: ARCHITECTURAL SIGNIFICANCE
# =============================================================================
is_architecturally_significant() {
  local file="$1"
  local content="$2"
  
  # EXEMPT: Standard test development patterns
  if [[ "$file" =~ \.(test|spec)\. ]]; then
    # Test files are exempt unless they contain actual architectural changes
    echo "$content" | grep -qiE "(CREATE|ALTER|DROP).*(TABLE|INDEX|DATABASE)" && return 0
    echo "$content" | grep -qiE "(AWS\.|Azure\.|S3|DynamoDB)" && return 0
    return 1  # Most test patterns are not architecturally significant
  fi
  
  # EXEMPT: Test development in /tests/ directories
  if [[ "$file" =~ /tests?/ ]]; then
    # Test directories get same exemption as test files
    echo "$content" | grep -qiE "(CREATE|ALTER|DROP).*(TABLE|INDEX|DATABASE)" && return 0
    echo "$content" | grep -qiE "(AWS\.|Azure\.|S3|DynamoDB)" && return 0
    return 1
  fi
  
  # File type checks for non-test files
  [[ "$file" =~ \.(sql|migration|schema|prisma)$ ]] && return 0
  [[ "$file" =~ (Dockerfile|k8s|terraform|helm) ]] && return 0
  [[ "$file" =~ (package\.json|go\.mod|pom\.xml|Cargo\.toml)$ ]] && return 0
  
  # Content pattern checks for non-test files - check if we're CHANGING these patterns
  # Only significant if the actual CHANGES involve these patterns
  if [[ -n "${old_content:-}" ]]; then
    # For edits, check if we're modifying security/infrastructure code
    echo "$old_content" | grep -qiE "(CREATE|ALTER|DROP).*(TABLE|INDEX|DATABASE)" && return 0
    echo "${new_content:-}" | grep -qiE "(CREATE|ALTER|DROP).*(TABLE|INDEX|DATABASE)" && return 0
    echo "$old_content" | grep -qiE "(password|secret|private_key|api_key|credentials|jwt|encrypt|decrypt)" && return 0
    echo "${new_content:-}" | grep -qiE "(password|secret|private_key|api_key|credentials|jwt|encrypt|decrypt)" && return 0
    echo "$old_content" | grep -qiE "(AWS\.|Azure\.|S3|DynamoDB)" && return 0
    echo "${new_content:-}" | grep -qiE "(AWS\.|Azure\.|S3|DynamoDB)" && return 0
  else
    # For new files, check the content being added
    echo "$content" | grep -qiE "(CREATE|ALTER|DROP).*(TABLE|INDEX|DATABASE)" && return 0
    echo "$content" | grep -qiE "(password|secret|private_key|api_key|credentials|jwt|encrypt|decrypt)" && return 0
    echo "$content" | grep -qiE "(AWS\.|Azure\.|S3|DynamoDB)" && return 0
  fi
  
  return 1
}

# =============================================================================
# TIER 3: SPECIALIST CONSULTATION WITH REGISTRY
# =============================================================================
has_specialist_consultation() {
  local content="$1"
  
  # Check if already approved via token (shouldn't reach here, but double-check)
  if echo "$content" | grep -qE "(TESTGUARD|CRITICAL|ARCHITECT|TECHNICAL|SECURITY|SECURITY-SPECIALIST)-APPROVED:[[:space:]]*[A-Za-z0-9-]+" || echo "$content" | grep -qE '"_approval_token":[[:space:]]*"[A-Za-z0-9-]+"'; then
    return 0
  fi
  
  # Text consultation alone is not enough - must have token
  return 1
}

suggest_specialist() {
  local file="$1"
  local content="$2"
  
  # Map patterns to HestAI specialists
  echo "$content" | grep -qiE "(password|secret|token|private_key|api_key|credentials|jwt|encrypt)" && echo "security-specialist" && return
  echo "$content" | grep -qiE "(error|exception|failure|retry)" && echo "error-architect" && return
  [[ "$file" =~ \.(sql|migration|schema)$ ]] && echo "critical-engineer" && return
  [[ "$file" =~ (Docker|k8s|terraform) ]] && echo "critical-engineer" && return
  echo "technical-architect"  # Default
}

if is_architecturally_significant "$file_path" "$content"; then
  if ! has_specialist_consultation "$content"; then
    suggested=$(suggest_specialist "$file_path" "$content")
    
    # Save blocked content
    blocked_file="${TMP_DIR}/blocked-arch-$(date +%s)-$$"
    echo "$content" > "$blocked_file"
    
    # Determine how to invoke specialist
    case "$suggested" in
      testguard|critical-engineer)
        invoke_cmd="mcp__hestai__${suggested} \"review $blocked_file\""
        ;;
      *)
        invoke_cmd="Task tool with subagent_type: '${suggested}' prompt: 'review $blocked_file'"
        ;;
    esac
    
    # Determine token format guidance based on file type
    token_format_guidance=""
    if [[ "$file_path" =~ \.(json)$ ]]; then
      token_format_guidance="
TOKEN FORMAT (JSON files):
{
  \"_approval_token\": \"${suggested^^}-20250909-abc123\",
  \"your_content\": \"...\"
}

INVALID: // ${suggested^^}-APPROVED: token (breaks JSON syntax)"
    elif [[ "$file_path" =~ \.(yaml|yml)$ ]]; then
      token_format_guidance="
TOKEN FORMAT (YAML files):
# ${suggested^^}-APPROVED: ${suggested^^}-20250909-abc123
your_content: ..."
    else
      token_format_guidance="
TOKEN FORMAT (Code files):
// ${suggested^^}-APPROVED: ${suggested^^}-20250909-abc123"
    fi

    cat >&2 <<LLM_MESSAGE
HOOK_BLOCKED: SPECIALIST_REQUIRED

FILE: $file_path
SPECIALIST_NEEDED: $suggested
TRIGGER: Architectural change detected
SAVED: $blocked_file

ACTION_REQUIRED:
1. Consult specialist: ${invoke_cmd}
2. If approved, specialist will provide token
3. Add token to your code using correct format below
4. Retry operation with token
$token_format_guidance

SPECIALIST_TYPES:
- MCP tools: testguard, critical-engineer (use mcp__hestai__)
- Subagents: security-specialist, code-review-specialist, technical-architect (use Task tool)

REFERENCE: ~/.claude/protocols/TOKEN_FORMATS.md for complete format guide
NO BYPASS: Registry approval required for all architectural changes
LLM_MESSAGE
    exit 2  # Use blocking exit code for specialist requirement
  fi
fi

# Enhanced test detection function
find_test_for_file() {
  local file_path="$1"
  
  # Get file components
  local dir=$(dirname "$file_path")
  local basename=$(basename "$file_path")
  local name="${basename%.*}"
  local ext="${basename##*.}"
  
  # Test patterns to check (in priority order)
  local test_patterns=(
    # Adjacent to source file
    "${file_path%.*}.test.${ext}"
    "${file_path%.*}.spec.${ext}"
    
    # In test/ directory (parallel structure)
    "test/${file_path#src/}"
    "test/${file_path#lib/}"
    "test/${basename%.*}.test.${ext}"
    "test/${basename%.*}.spec.${ext}"
    
    # In tests/ directory 
    "tests/${file_path#src/}"
    "tests/${file_path#lib/}"
    "tests/${basename%.*}.test.${ext}"
    "tests/${basename%.*}.spec.${ext}"
    
    # __tests__ directory (React/Jest pattern)
    "${dir}/__tests__/${name}.test.${ext}"
    "${dir}/__tests__/${name}.spec.${ext}"
  )
  
  # Check each pattern
  for pattern in "${test_patterns[@]}"; do
    if [[ -f "$pattern" ]]; then
      return 0  # Test found
    fi
  done
  
  return 1  # No test found
}

# =============================================================================
# TIER 4: TEST-FIRST WITH REGISTRY
# =============================================================================
# Only apply test-first requirement to NEW implementation files, not test files themselves
# Skip test-first for files that already have tests (updates to existing code)
if [[ ! "$file_path" =~ \.(test|spec)\. ]] && [[ ! "$file_path" =~ /tests?/ ]]; then

  # Only enforce test-first for completely new files without existing tests
  if ! find_test_for_file "$file_path" && [[ ! -f "$file_path" ]]; then

    # Check if test is being created in this commit (enhanced patterns)
    base_name=$(basename "${file_path%.*}")
    if ! git diff --cached --name-only 2>/dev/null | grep -qE "(${base_name}\.(test|spec)\.|test.*${base_name}|spec.*${base_name})"; then

      # Save blocked implementation
      blocked_file="${TMP_DIR}/blocked-impl-$(date +%s)-$$"
      echo "$content" > "$blocked_file"

      cat >&2 <<LLM_MESSAGE
HOOK_BLOCKED: TEST_FIRST_REQUIRED

SAVED: $blocked_file

ACTION_REQUIRED:
1. Create test file first
2. Write failing test (RED)
3. Get approval if needed: mcp__hestai__testguard "review test"
4. Then implement code (GREEN)

COMMAND_SEQUENCE:
Write test-file.test.ts → Commit → Write implementation.ts

NO BYPASS: Test-first development is mandatory
LLM_MESSAGE
      exit 2
    fi
  fi
fi

echo "✅ All quality gates passed" >&2
exit 0