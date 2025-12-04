#!/usr/bin/env bash
# North Star Authorization Command
# Creates session-specific authorization for North Star document changes

set -euo pipefail

# Get reason from arguments or prompt
reason="$*"
if [[ -z "$reason" ]]; then
  echo "Enter reason for North Star modification:"
  read -r reason
fi

# Create session-specific token
session_token="/tmp/north_star_unlock_$$"
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Write authorization with metadata
cat > "$session_token" <<EOF
AUTHORIZED: $timestamp
REASON: $reason
SESSION: $$
USER: ${USER:-unknown}
PWD: $(pwd)
EOF

# Log to audit trail
audit_log="/Users/shaunbuswell/.claude/logs/north-star-authorizations.log"
mkdir -p "$(dirname "$audit_log")"
echo "[$timestamp] SESSION:$$ USER:${USER:-unknown} REASON:$reason PWD:$(pwd)" >> "$audit_log"

cat <<EOF

✅ NORTH STAR MODIFICATION AUTHORIZED

Session: $$  
Timestamp: $timestamp
Reason: $reason

⚠️  Authorization Details:
- Valid for this session only (PID $$)
- Expires when session ends
- Logged to audit trail
- Use responsibly for legitimate scope evolution

🎯 You can now modify North Star documents.
   The authorization will be automatically validated by hooks.

EOF