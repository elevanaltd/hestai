#!/bin/bash
# Supabase Migration Guard - Global PreToolUse Hook
# Enforces safety checks before apply_migration or execute_sql
# Version: 2.0.0 (Hybrid Global/Project Architecture)
# Authority: supabase-expert + skills-expert validation
# Reference: .claude/skills/supabase-operations/ (project-specific)

set -euo pipefail

# ============================================================================
# AUTO-DETECT PROJECT CONFIGURATION
# ============================================================================

PROJECT_ID=""
MIGRATIONS_DIR="supabase/migrations"
SKILL_NAME="supabase-operations"
CUSTOM_PATTERNS=()
DISABLED_CHECKS=()

# Method 1: Project-specific .claude/supabase.yaml (preferred)
if [[ -f ".claude/supabase.yaml" ]]; then
  # Parse YAML manually (avoid yq dependency)
  PROJECT_ID=$(grep '^project_id:' .claude/supabase.yaml | sed 's/project_id:[[:space:]]*//' || echo "")
  MIGRATIONS_DIR=$(grep '^migrations_dir:' .claude/supabase.yaml | sed 's/migrations_dir:[[:space:]]*//' || echo "supabase/migrations")
  SKILL_NAME=$(grep '^skill_name:' .claude/supabase.yaml | sed 's/skill_name:[[:space:]]*//' || echo "supabase-operations")

  # Read disabled checks if present
  if grep -q '^disable_checks:' .claude/supabase.yaml; then
    while IFS= read -r line; do
      if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.+) ]]; then
        DISABLED_CHECKS+=("${BASH_REMATCH[1]}")
      fi
    done < <(sed -n '/^disable_checks:/,/^[^ ]/p' .claude/supabase.yaml | grep '^  -')
  fi
fi

# Method 2: Fallback to supabase/config.toml (Supabase CLI config)
if [[ -z "$PROJECT_ID" ]] && [[ -f "supabase/config.toml" ]]; then
  PROJECT_ID=$(grep 'project_id' supabase/config.toml | sed 's/.*project_id[[:space:]]*=[[:space:]]*"\([^"]*\)".*/\1/' || echo "")
fi

# Method 3: Last resort - warn and continue with limited validation
if [[ -z "$PROJECT_ID" ]]; then
  echo "⚠️  WARNING: No project configuration found (.claude/supabase.yaml or supabase/config.toml)" >&2
  echo "⚠️  State sync validation will be skipped. Create .claude/supabase.yaml for full protection." >&2
fi

# ============================================================================
# PARSE MCP TOOL INVOCATION
# ============================================================================

MCP_TOOL_NAME="${1:-}"
MCP_TOOL_PARAMS="${2:-{}}"

# Exit early if not targeting Supabase MCP tools
if [[ ! "$MCP_TOOL_NAME" =~ ^mcp__supabase__(apply_migration|execute_sql)$ ]]; then
  exit 0
fi

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

is_check_disabled() {
  local check="$1"
  for disabled in "${DISABLED_CHECKS[@]}"; do
    if [[ "$disabled" == "$check" ]]; then
      return 0
    fi
  done
  return 1
}

block_with_guidance() {
  local reason="$1"
  echo "BLOCKED: Supabase migration safety check failed." >&2
  echo "CONSULT: Invoke $SKILL_NAME skill for proper migration workflow." >&2
  echo "REASON: $reason" >&2
  exit 2
}

warn() {
  local message="$1"
  echo "⚠️  WARNING: $message" >&2
}

info() {
  local message="$1"
  echo "ℹ️  $message" >&2
}

# ============================================================================
# VALIDATION: apply_migration
# ============================================================================

if [[ "$MCP_TOOL_NAME" == "mcp__supabase__apply_migration" ]]; then
  info "Validating apply_migration safety checks..."

  # Extract parameters
  MIGRATION_NAME=$(echo "$MCP_TOOL_PARAMS" | jq -r '.name // empty')
  SQL_QUERY=$(echo "$MCP_TOOL_PARAMS" | jq -r '.query // empty')

  if [[ -z "$MIGRATION_NAME" ]]; then
    block_with_guidance "Migration name parameter missing"
  fi

  MIGRATION_FILE="${MIGRATIONS_DIR}/${MIGRATION_NAME}.sql"

  # -------------------------------------------------------------------------
  # CHECK 1: Local migration file exists
  # -------------------------------------------------------------------------

  if [[ ! -f "$MIGRATION_FILE" ]]; then
    block_with_guidance "No local migration file found at ${MIGRATION_FILE}. Create and commit the migration file first."
  fi

  # -------------------------------------------------------------------------
  # CHECK 2: Migration file is committed to git
  # -------------------------------------------------------------------------

  if ! git ls-files --error-unmatch "$MIGRATION_FILE" >/dev/null 2>&1; then
    block_with_guidance "Migration file exists but is not committed to git. Run: git add ${MIGRATION_FILE} && git commit"
  fi

  if ! git diff --quiet "$MIGRATION_FILE" 2>/dev/null; then
    block_with_guidance "Migration file has uncommitted changes. Commit changes before applying migration."
  fi

  # -------------------------------------------------------------------------
  # CHECK 3: Migration naming convention (YYYYMMDDHHMMSS_description.sql)
  # -------------------------------------------------------------------------

  MIGRATION_BASENAME=$(basename "$MIGRATION_NAME" .sql)
  if ! [[ "$MIGRATION_BASENAME" =~ ^[0-9]{14}_.+ ]]; then
    block_with_guidance "Invalid migration name format. Must follow: YYYYMMDDHHMMSS_description.sql (Found: ${MIGRATION_NAME})"
  fi

  # -------------------------------------------------------------------------
  # CHECK 4: State sync validation (local vs remote)
  # -------------------------------------------------------------------------

  if ! is_check_disabled "state_sync"; then
    if [[ -n "$PROJECT_ID" ]]; then
      if command -v supabase &> /dev/null; then
        info "Checking migration state sync..."

        # Get remote migrations
        if ! REMOTE_MIGRATIONS=$(supabase migration list --project-ref "$PROJECT_ID" 2>/dev/null | tail -n +3); then
          warn "Could not verify remote migration state (API error or auth issue)"
          warn "Proceeding with local-only validation"
        else
          # Get local migrations
          LOCAL_MIGRATIONS=$(ls -1 "$MIGRATIONS_DIR"/*.sql 2>/dev/null | xargs -n1 basename | sed 's/\.sql$//' || echo "")

          # Check for divergence: remote has migrations not in local
          while IFS= read -r remote_migration; do
            if [[ -n "$remote_migration" ]] && ! echo "$LOCAL_MIGRATIONS" | grep -q "^${remote_migration}$"; then
              block_with_guidance "State divergence detected: Remote has migration '${remote_migration}' not found in local ${MIGRATIONS_DIR}/. Run 'supabase migration list' to investigate and sync."
            fi
          done <<< "$(echo "$REMOTE_MIGRATIONS" | awk '{print $1}')"

          info "✓ Migration state sync validated"
        fi
      else
        block_with_guidance "Supabase CLI not found. Install Supabase CLI to verify migration state sync: https://supabase.com/docs/guides/cli"
      fi
    else
      warn "Skipping state sync validation (no project_id configured)"
    fi
  else
    info "State sync validation disabled by project configuration"
  fi

  # -------------------------------------------------------------------------
  # CHECK 5: ADR-003 destructive pattern detection
  # -------------------------------------------------------------------------

  MIGRATION_CONTENT=$(cat "$MIGRATION_FILE")

  # Define destructive patterns
  DESTRUCTIVE_PATTERNS=(
    "DROP TABLE"
    "DROP COLUMN"
    "DROP CONSTRAINT"
    "TRUNCATE"
    "ALTER.*TYPE"
    "RENAME COLUMN"
    "RENAME TABLE"
    "DELETE FROM.*WHERE"
    "ALTER.*NOT NULL"
    "ALTER.*DROP DEFAULT"
  )

  # Add custom patterns from project config
  DESTRUCTIVE_PATTERNS+=("${CUSTOM_PATTERNS[@]}")

  DESTRUCTIVE_FOUND=false
  DETECTED_PATTERNS=()

  for pattern in "${DESTRUCTIVE_PATTERNS[@]}"; do
    if echo "$MIGRATION_CONTENT" | grep -qiE "$pattern"; then
      DESTRUCTIVE_FOUND=true
      DETECTED_PATTERNS+=("$pattern")
    fi
  done

  if [[ "$DESTRUCTIVE_FOUND" == true ]]; then
    # Check for SAFETY_OVERRIDE comment pattern
    if grep -q "^-- SAFETY_OVERRIDE:" "$MIGRATION_FILE"; then
      warn "Destructive operation detected with SAFETY_OVERRIDE approval:"
      for pattern in "${DETECTED_PATTERNS[@]}"; do
        warn "  - Pattern: $pattern"
      done
      warn "Proceeding with forced operation - ensure proper approval and backup exists"

      # Verify override includes required fields
      if ! grep -q "^-- APPROVED_BY:" "$MIGRATION_FILE"; then
        warn "SAFETY_OVERRIDE missing APPROVED_BY field - add human operator approval"
      fi
      if ! grep -q "^-- ROLLBACK_PLAN:" "$MIGRATION_FILE"; then
        warn "SAFETY_OVERRIDE missing ROLLBACK_PLAN field - document recovery procedure"
      fi
    else
      # No override - block destructive operation
      PATTERN_LIST=$(printf '  - %s\n' "${DETECTED_PATTERNS[@]}")
      block_with_guidance "Destructive operation detected without SAFETY_OVERRIDE:
${PATTERN_LIST}

ADR-003 requires 14-day deprecation cycle for breaking changes.

To override for emergency operations, add to migration file:
-- SAFETY_OVERRIDE: Emergency production fix for [ISSUE-123]
-- APPROVED_BY: human operator
-- RISK_ACCEPTED: Data loss possible, backup verified
-- ROLLBACK_PLAN: Restore from backup taken [timestamp]"
    fi
  fi

  # -------------------------------------------------------------------------
  # CHECK 6: Concurrent operation safety (non-blocking indexes)
  # -------------------------------------------------------------------------

  if ! is_check_disabled "concurrent_indexes"; then
    if echo "$MIGRATION_CONTENT" | grep -iE "CREATE\s+INDEX\s+" | grep -qvE "CONCURRENTLY"; then
      block_with_guidance "CREATE INDEX without CONCURRENTLY detected. This locks the table and blocks reads/writes. Use: CREATE INDEX CONCURRENTLY"
    fi
  else
    info "Concurrent index validation disabled by project configuration"
  fi

  # -------------------------------------------------------------------------
  # CHECK 7: Transaction safety (advisory warning)
  # -------------------------------------------------------------------------

  if ! echo "$MIGRATION_CONTENT" | grep -q "BEGIN;" || ! echo "$MIGRATION_CONTENT" | grep -q "COMMIT;"; then
    warn "Migration lacks explicit transaction block (BEGIN...COMMIT)"
    warn "Consider wrapping DDL in transaction for atomic rollback capability"
  fi

  # -------------------------------------------------------------------------
  # CHECK 8: Description comment presence (advisory)
  # -------------------------------------------------------------------------

  if ! echo "$MIGRATION_CONTENT" | grep -qE "^-- Migration:|^-- Description:"; then
    warn "Migration lacks description comment. Add: -- Migration: [description]"
  fi

  # -------------------------------------------------------------------------
  # All checks passed
  # -------------------------------------------------------------------------

  info "✓ All safety checks passed for apply_migration"
  if [[ -n "$PROJECT_ID" ]]; then
    info "Reminder: Run 'get_advisors' after migration to validate RLS policies and performance"
  fi
  exit 0
fi

# ============================================================================
# VALIDATION: execute_sql
# ============================================================================

if [[ "$MCP_TOOL_NAME" == "mcp__supabase__execute_sql" ]]; then
  info "Validating execute_sql safety checks..."

  # Extract SQL query
  SQL_QUERY=$(echo "$MCP_TOOL_PARAMS" | jq -r '.query // empty')

  if [[ -z "$SQL_QUERY" ]]; then
    block_with_guidance "SQL query parameter missing"
  fi

  # -------------------------------------------------------------------------
  # CHECK 1: Block ALL DDL operations
  # -------------------------------------------------------------------------

  # DDL operations must go through apply_migration for tracking
  if echo "$SQL_QUERY" | grep -qiE '^\s*(CREATE|ALTER|DROP|TRUNCATE)'; then
    block_with_guidance "DDL operations (CREATE, ALTER, DROP, TRUNCATE) must use apply_migration, not execute_sql.

REASON: Migration tracking, rollback capability, version control, reproducibility.

DDL operations bypass migration history and violate I12 (single migration source).
Create a migration file and use apply_migration instead."
  fi

  # -------------------------------------------------------------------------
  # CHECK 2: Warn about dangerous DML patterns
  # -------------------------------------------------------------------------

  # DELETE without WHERE
  if echo "$SQL_QUERY" | grep -qiE '^\s*DELETE\s+FROM\s+\w+\s*;'; then
    warn "DELETE without WHERE clause detected - this deletes ALL rows"
    warn "Add WHERE clause or use TRUNCATE via apply_migration if intentional"
  fi

  # UPDATE without WHERE
  if echo "$SQL_QUERY" | grep -qiE '^\s*UPDATE\s+\w+\s+SET.*;\s*$' && ! echo "$SQL_QUERY" | grep -qiE '\sWHERE\s'; then
    warn "UPDATE without WHERE clause detected - this updates ALL rows"
    warn "Add WHERE clause to limit scope"
  fi

  # -------------------------------------------------------------------------
  # All checks passed
  # -------------------------------------------------------------------------

  info "✓ execute_sql validation passed (DML operations allowed)"
  exit 0
fi

# ============================================================================
# FALLBACK: Should never reach here
# ============================================================================

exit 0
