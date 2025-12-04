#!/usr/bin/env bash
# Lightweight cleanup functions for registry database
# Called by hook during normal operations

set -euo pipefail

# Probabilistic cleanup - only run occasionally to avoid overhead
should_cleanup() {
  # Run cleanup ~1% of the time (1 in 100 calls)
  [[ $((RANDOM % 100)) -eq 0 ]]
}

# Quick cleanup of old entries (non-blocking)
quick_cleanup() {
  local db="$1"
  
  # Run in background to avoid blocking hook
  (
    # Only proceed if we get lock quickly (don't block)
    if mkdir "/tmp/registry-cleanup.lock" 2>/dev/null; then
      trap 'rmdir /tmp/registry-cleanup.lock 2>/dev/null' EXIT
      
      # Delete used tokens older than 24 hours
      sqlite3 "$db" "
        DELETE FROM blocked_changes 
        WHERE token_used = 1 
        AND julianday('now') - julianday(last_accessed_at) > 1
        LIMIT 10
      " 2>/dev/null || true
      
      # Delete old blocked entries without tokens (>7 days)
      sqlite3 "$db" "
        DELETE FROM blocked_changes 
        WHERE status = 'blocked' 
        AND token IS NULL
        AND julianday('now') - julianday(created_at) > 7
        LIMIT 10
      " 2>/dev/null || true
      
      # Delete old rejected entries (>3 days)
      sqlite3 "$db" "
        DELETE FROM blocked_changes 
        WHERE status = 'rejected'
        AND julianday('now') - julianday(created_at) > 3
        LIMIT 10
      " 2>/dev/null || true
      
      # Clean old /tmp files
      find /tmp -name "blocked-*" -mtime +1 -delete 2>/dev/null || true
      
      # Vacuum only if database is getting large (>1MB)
      if [[ $(stat -f%z "$db" 2>/dev/null || stat -c%s "$db" 2>/dev/null || echo 0) -gt 1048576 ]]; then
        sqlite3 "$db" "VACUUM" 2>/dev/null || true
      fi
    fi
  ) &
  
  # Return immediately - cleanup happens in background
  return 0
}

# Export functions
export -f should_cleanup
export -f quick_cleanup