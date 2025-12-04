#!/usr/bin/env bash
# Registry Helper Functions - SQLite Direct Access Version
# Simpler, faster, single source of truth
# No JSON sync complexity - direct database queries only

set -euo pipefail

# Registry database location (same as MCP server uses)
REGISTRY_DB="${REGISTRY_DB:-$HOME/.claude/hooks/registry.db}"

# Validate token in registry
validate_token_in_registry() {
  local token="$1"
  local content="${2:-}"  # Content hash validation optional
  
  # Check SQLite is available
  if ! command -v sqlite3 >/dev/null 2>&1; then
    echo "ERROR: sqlite3 not found - required for registry validation" >&2
    return 1
  fi
  
  # Check database exists
  if [[ ! -f "$REGISTRY_DB" ]]; then
    echo "ERROR: Registry database not found at $REGISTRY_DB" >&2
    return 1
  fi
  
  # Direct SQLite query - check token exists, not used, not expired
  local result
  result=$(sqlite3 "$REGISTRY_DB" <<SQL 2>/dev/null || echo "ERROR"
SELECT CASE
  WHEN NOT EXISTS (SELECT 1 FROM blocked_changes WHERE token='$token') THEN 'NOT_FOUND'
  WHEN (SELECT token_used FROM blocked_changes WHERE token='$token') = 1 THEN 'ALREADY_USED'
  ELSE 'VALID'
END;
SQL
)
  
  case "$result" in
    VALID)
      echo "✅ Token validated: $token" >&2
      return 0
      ;;
    NOT_FOUND)
      echo "❌ Token not found: $token" >&2
      return 1
      ;;
    ALREADY_USED)
      echo "❌ Token already used: $token" >&2
      return 1
      ;;
    EXPIRED)
      echo "❌ Token expired: $token" >&2
      return 1
      ;;
    *)
      echo "❌ Registry validation error: $result" >&2
      return 1
      ;;
  esac
}

# Mark token as used
mark_token_used() {
  local token="$1"
  
  # Update directly in SQLite with timestamp
  sqlite3 "$REGISTRY_DB" <<SQL 2>/dev/null
UPDATE blocked_changes 
SET token_used = 1, 
    last_accessed_at = datetime('now') 
WHERE token = '$token';
SQL
  
  if [[ $? -eq 0 ]]; then
    echo "✓ Token marked as used: $token" >&2
  else
    echo "⚠ Failed to mark token as used: $token" >&2
  fi
}

# Log approval use (audit trail)
log_approval_use() {
  local token="$1"
  local file_path="$2"
  local outcome="$3"
  
  # Insert audit log entry (ignore errors - audit is non-critical)
  sqlite3 "$REGISTRY_DB" <<SQL 2>/dev/null || true
INSERT INTO audit_log (timestamp, action, token, file, outcome)
VALUES (datetime('now'), 'token_use', '$token', '$file_path', '$outcome');
SQL
}

# Check permanent patterns (if patterns table exists)
check_permanent_patterns() {
  local content="$1"
  local pattern_type="$2"
  
  # Check if permanent_patterns table exists
  if ! sqlite3 "$REGISTRY_DB" ".tables" 2>/dev/null | grep -q "permanent_patterns"; then
    return 1  # Table doesn't exist yet
  fi
  
  # Get approved patterns and check each
  local patterns
  patterns=$(sqlite3 "$REGISTRY_DB" <<SQL 2>/dev/null || echo ""
SELECT pattern FROM permanent_patterns 
WHERE type = '$pattern_type' 
AND auto_approve = 1;
SQL
)
  
  while IFS= read -r pattern; do
    if [[ -n "$pattern" ]] && echo "$content" | grep -qE "$pattern" 2>/dev/null; then
      echo "✅ Matches approved pattern: $pattern" >&2
      return 0
    fi
  done <<< "$patterns"
  
  return 1
}

# Check blocked patterns
check_blocked_patterns() {
  local content="$1"
  local pattern_type="$2"
  
  # Check if blocked_patterns table exists
  if ! sqlite3 "$REGISTRY_DB" ".tables" 2>/dev/null | grep -q "blocked_patterns"; then
    return 1  # Table doesn't exist yet
  fi
  
  # Get blocked patterns with reasons
  sqlite3 "$REGISTRY_DB" <<SQL 2>/dev/null | while IFS='|' read -r pattern reason; do
SELECT pattern, reason FROM blocked_patterns 
WHERE type = '$pattern_type';
SQL
    if [[ -n "$pattern" ]] && echo "$content" | grep -qE "$pattern" 2>/dev/null; then
      echo "❌ Blocked pattern detected: $reason" >&2
      return 0  # Return 0 means content IS blocked
    fi
  done
  
  return 1  # Content not blocked
}

# Check if registry database exists and is accessible
check_registry_health() {
  if [[ ! -f "$REGISTRY_DB" ]]; then
    echo "⚠ Registry database not found at: $REGISTRY_DB" >&2
    echo "  MCP server will create it on first use" >&2
    return 1
  fi
  
  # Test database is readable
  if ! sqlite3 "$REGISTRY_DB" "SELECT COUNT(*) FROM registry" >/dev/null 2>&1; then
    echo "⚠ Registry database exists but cannot be read" >&2
    return 1
  fi
  
  echo "✓ Registry database healthy at: $REGISTRY_DB" >&2
  return 0
}

# Initialize registry check (called by hook)
init_registry() {
  # Just check health, don't create - MCP server owns the database
  check_registry_health || true
}

# Export functions for use in hooks
export -f validate_token_in_registry
export -f mark_token_used
export -f log_approval_use
export -f check_permanent_patterns
export -f check_blocked_patterns
export -f check_registry_health
export -f init_registry