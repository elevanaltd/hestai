#!/bin/bash

# Document Governance Enforcement Hook
# Blocks unauthorized document creation in /Volumes/HestAI/ 
# Requires system-steward approval for document creation

FILE_PATH="$1"
AGENT_ROLE="${2:-unknown}"
OPERATION="${3:-create}"

# Only check document creation operations
if [[ "$OPERATION" != "create" ]] && [[ "$OPERATION" != "write" ]]; then
    exit 0
fi

# Only check HestAI repository documents
if [[ ! "$FILE_PATH" =~ ^/Volumes/HestAI/docs/ ]]; then
    exit 0
fi

# Allow system-steward unrestricted access
if [[ "$AGENT_ROLE" == "system-steward" ]]; then
    exit 0
fi

# Check if this is a registry file (always allowed for system operations)
if [[ "$FILE_PATH" =~ /.registry/ ]]; then
    exit 0
fi

# Load sequence tracker to check for conflicts
REGISTRY_DIR="/Volumes/HestAI/docs/.registry"
SEQUENCE_TRACKER="$REGISTRY_DIR/sequence-tracker.json"
CONFLICTS_TRACKER="$REGISTRY_DIR/naming-conflicts.json"

# Create registry if it doesn't exist
if [[ ! -d "$REGISTRY_DIR" ]]; then
    mkdir -p "$REGISTRY_DIR"
fi

# Initialize trackers if they don't exist
if [[ ! -f "$SEQUENCE_TRACKER" ]]; then
    echo '{"last_sequences": {}, "active_conflicts": []}' > "$SEQUENCE_TRACKER"
fi

if [[ ! -f "$CONFLICTS_TRACKER" ]]; then
    echo '{"conflicts": [], "resolved": []}' > "$CONFLICTS_TRACKER"
fi

# Extract filename components for analysis
FILENAME=$(basename "$FILE_PATH")
if [[ "$FILENAME" =~ ^([0-9]{3})-(.+)\.md$ ]]; then
    SEQUENCE_NUM="${BASH_REMATCH[1]}"
    DOC_NAME="${BASH_REMATCH[2]}"
    
    # Validate sequence number against directory ranges
    DIR_NAME=$(basename "$(dirname "$FILE_PATH")")
    case "$DIR_NAME" in
        "workflow")
            if [[ "$SEQUENCE_NUM" -lt 0 || "$SEQUENCE_NUM" -gt 99 ]]; then
                cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Use sequence number 000-099 for workflow directory

2. Update your filename to use correct range

3. Retry your document creation

⚠️  DO NOT use sequence $SEQUENCE_NUM - workflow directory requires 000-099 range.
EOF
                exit 2  # Using successful blocking exit code pattern
            fi
            ;;
        "standards")
            if [[ "$SEQUENCE_NUM" -lt 100 || "$SEQUENCE_NUM" -gt 199 ]]; then
                cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Use sequence number 100-199 for standards directory

2. Update your filename to use correct range

3. Retry your document creation

⚠️  DO NOT use sequence $SEQUENCE_NUM - standards directory requires 100-199 range.
EOF
                exit 2  # Using successful blocking exit code pattern
            fi
            ;;
        "future-phases")
            if [[ "$SEQUENCE_NUM" -lt 200 || "$SEQUENCE_NUM" -gt 299 ]]; then
                cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Use sequence number 200-299 for future-phases directory

2. Update your filename to use correct range

3. Retry your document creation

⚠️  DO NOT use sequence $SEQUENCE_NUM - future-phases directory requires 200-299 range.
EOF
                exit 2  # Using successful blocking exit code pattern
            fi
            ;;
        "security")
            if [[ "$SEQUENCE_NUM" -lt 400 || "$SEQUENCE_NUM" -gt 499 ]]; then
                cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Use sequence number 400-499 for security directory

2. Update your filename to use correct range

3. Retry your document creation

⚠️  DO NOT use sequence $SEQUENCE_NUM - security directory requires 400-499 range.
EOF
                exit 2  # Using successful blocking exit code pattern
            fi
            ;;
    esac
    
    # Check for sequence conflicts within the same directory
    EXISTING_DOCS=$(find "$(dirname "$FILE_PATH")" -name "${SEQUENCE_NUM}-*.md" 2>/dev/null | head -5)
    if [[ -n "$EXISTING_DOCS" ]]; then
        cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Run this command first:
   /role system-steward

2. Check next available sequence number in $(dirname "$FILE_PATH")

3. Use the next available sequence number instead of ${SEQUENCE_NUM}

4. Retry your document creation

⚠️  DO NOT override existing sequence numbers - this breaks document governance.

Attempted: $FILE_PATH
Conflicts with: $EXISTING_DOCS
EOF
        exit 2  # Using successful blocking exit code pattern
    fi
fi

# Block non-steward document creation
cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Run this command first:
   /role system-steward

2. Validate naming follows HestAI conventions

3. Retry your document creation operation

⚠️  DO NOT create documents without steward oversight - this prevents document chaos.

File: $FILE_PATH
Current Role: $AGENT_ROLE

This maintains document governance and prevents unauthorized proliferation.
EOF
exit 2  # Using successful blocking exit code pattern