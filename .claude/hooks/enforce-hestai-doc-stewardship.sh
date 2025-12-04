#!/bin/bash
# HestAI Document Stewardship Hook - Write/Edit Operations
# Enforces document governance through registry-based approval system
# Works in conjunction with enforce-hestai-doc-stewardship-bash.sh

set -e

# Parse JSON input from Claude Code
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Only process Write, MultiEdit, and Edit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "MultiEdit" && "$TOOL_NAME" != "Edit" ]]; then
    exit 0
fi

# Check if file is in protected HestAI documentation areas ONLY
# Protected paths: /Volumes/HestAI/docs/, /Volumes/HestAI/reports/, /Volumes/HestAI/templates/
if [[ "$FILE_PATH" =~ ^/Volumes/HestAI/(docs|reports|templates)/ ]]; then

    # Extract filename for analysis
    FILENAME=$(basename "$FILE_PATH")

    # Allow standard project files
    if [[ "$FILENAME" =~ ^(README|CLAUDE|CONTRIBUTING|LICENSE)(\.(md|txt))?$ ]]; then
        exit 0
    fi

    # Check if this is a documentation file
    if [[ "$FILE_PATH" =~ \.(md|oct\.md)$ ]]; then
        
        # REGISTRY CHECK: Is this file approved in the registry?
        REGISTRY="/Volumes/HestAI/docs/.registry/index.json"
        if [[ -f "$REGISTRY" ]]; then
            # Check if filename exists in approved_docs
            if jq -e ".approved_docs | has(\"$FILENAME\")" "$REGISTRY" >/dev/null 2>&1; then
                echo "✅ Document found in HestAI registry - approved" >&2
                exit 0
            fi
        fi
        
        # Extract content for saving to /tmp
        if [[ "$TOOL_NAME" == "Write" ]]; then
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
        elif [[ "$TOOL_NAME" == "Edit" ]]; then
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // empty' 2>/dev/null || echo "")
        elif [[ "$TOOL_NAME" == "MultiEdit" ]]; then
            # For MultiEdit, combine all edits
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.edits[].new_string // empty' 2>/dev/null | tr '\n' ' ' || echo "")
        fi
        
        # EMERGENCY BYPASS: Still allow for critical situations
        if echo "$CONTENT" | grep -qE "HESTAI_DOC_STEWARD_BYPASS:" 2>/dev/null; then
            echo "⚠️  Emergency bypass detected - allowing operation" >&2
            exit 0
        fi
        
        # Save attempt to /tmp for preservation
        TMP_FILE="/tmp/hestai-doc-attempt-$(date +%s)-$$-$(echo "$FILENAME" | tr '/' '-')"
        echo "$CONTENT" > "$TMP_FILE"
        
        # Block and provide guidance
        {
            echo "BLOCKED::DOC_APPROVAL_REQUIRED"
            echo "SAVED::$TMP_FILE"
            echo "PROTOCOL::/Users/shaunbuswell/.claude/protocols/HESTAI-DOC-PROTOCOL.md"
            echo "ACTION::Task(subagent_type='hestai-doc-steward', prompt='APPROVAL_REQUEST FILE:$FILE_PATH SAVED:$TMP_FILE REASON:[necessity]')"
        } >&2
        
        exit 2
    fi
fi

exit 0