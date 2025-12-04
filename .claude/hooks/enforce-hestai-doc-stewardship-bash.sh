#!/bin/bash
# HestAI Document Stewardship Hook - Bash Operations
# Enforces document governance through registry-based approval system
# Works in conjunction with enforce-hestai-doc-stewardship.sh

set -e

# Parse JSON input from Claude Code
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only process Bash tool
if [[ "$TOOL_NAME" != "Bash" ]]; then
    exit 0
fi

# Check if command operates on protected HestAI documentation areas ONLY
# Protected paths: /Volumes/HestAI/docs/, /Volumes/HestAI/reports/, /Volumes/HestAI/templates/
if echo "$COMMAND" | grep -E "(echo|cat|tee|printf).*>.*\/Volumes\/HestAI\/(docs|reports|templates)\/" >/dev/null || \
   echo "$COMMAND" | grep -E "(rm|mv|cp|touch|mkdir|rmdir).*\/Volumes\/HestAI\/(docs|reports|templates)\/" >/dev/null; then
    
    # Extract potential file path from command
    FILE_PATH=$(echo "$COMMAND" | grep -oE '/Volumes/HestAI/[^ ]+' | head -1)
    FILENAME=$(basename "$FILE_PATH" 2>/dev/null || echo "unknown")
    
    # Allow standard project files
    if echo "$COMMAND" | grep -E "(README|CLAUDE|CONTRIBUTING|LICENSE)(\.(md|txt))?" >/dev/null; then
        exit 0
    fi
    
    # Allow registry operations for hestai-doc-steward
    if echo "$COMMAND" | grep -E "\/Volumes\/HestAI\/docs\/\.registry" >/dev/null; then
        # Check if hestai-doc-steward is active
        if ls /tmp/active_role_hestai-doc-steward_* 2>/dev/null | head -1 >/dev/null; then
            echo "✅ HestAI-Doc-Steward registry operation allowed" >&2
            exit 0
        fi
    fi
    
    # REGISTRY CHECK: For file operations, check the registry
    REGISTRY="/Volumes/HestAI/docs/.registry/index.json"
    if [[ -f "$REGISTRY" ]] && [[ "$FILENAME" != "unknown" ]]; then
        # Check if filename exists in approved_docs
        if jq -e ".approved_docs | has(\"$FILENAME\")" "$REGISTRY" >/dev/null 2>&1; then
            echo "✅ Document found in HestAI registry - bash operation approved" >&2
            exit 0
        fi
    fi
    
    # Block the operation
    {
        echo "BLOCKED::BASH_OPS_FORBIDDEN"
        echo "COMMAND::$COMMAND"
        echo "USE::Write/Edit_tools_instead"
        echo "PROTOCOL::/Users/shaunbuswell/.claude/protocols/HESTAI-DOC-PROTOCOL.md"
    } >&2
    
    exit 2
fi

exit 0