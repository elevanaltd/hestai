#!/bin/bash
# Agent Stewardship Hook
# Prevents unauthorized agent modifications in /Users/shaunbuswell/.claude/agents/ without proper review
# Enforces agent ecosystem governance through subagent-creator consultation

set -e

# Parse JSON input from Claude Code
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")

# Only process Write, MultiEdit, and Edit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "MultiEdit" && "$TOOL_NAME" != "Edit" ]]; then
    exit 0
fi

# Check if file is in protected agent ecosystem area
if [[ "$FILE_PATH" =~ ^/Users/shaunbuswell/\.claude/agents/ ]]; then
    
    # Extract just the filename for analysis
    FILENAME=$(basename "$FILE_PATH")
    
    # Check if this is an agent file (.oct.md) or agent configuration
    if [[ "$FILE_PATH" =~ \.oct\.md$ ]] || [[ "$FILENAME" == "settings.json" && "$FILE_PATH" =~ ^/Users/shaunbuswell/\.claude/settings\.json$ ]]; then
        
        # Check for subagent-creator consultation evidence - handle different tool types
        TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
        if [[ "$TOOL_NAME" == "Write" ]]; then
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
        elif [[ "$TOOL_NAME" == "Edit" ]]; then
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.new_string // empty' 2>/dev/null || echo "")
        elif [[ "$TOOL_NAME" == "MultiEdit" ]]; then
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.edits[].new_string // empty' 2>/dev/null | tr '\n' ' ' || echo "")
        else
            CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty' 2>/dev/null || echo "")
        fi
        
        # REGISTRY CHECK: Enhanced registry-based approval system  
        AGENT_NAME=$(basename "$FILE_PATH" .oct.md)
        REGISTRY="@.agents/registry.json"
        if [[ -f "$REGISTRY" ]]; then
            if jq -e ".agents | has(\"$AGENT_NAME\")" "$REGISTRY" >/dev/null 2>&1; then
                AGENT_STATUS=$(jq -r ".agents[\"$AGENT_NAME\"].status" "$REGISTRY" 2>/dev/null || echo "unknown")
                if [[ "$AGENT_STATUS" == "approved" ]]; then
                    echo "✅ Agent registry approval verified for $AGENT_NAME" >&2
                    exit 0
                fi
            fi
        fi
        
        # SUBAGENT AUTHORITY: Check for subagent-creator authority marker
        if echo "$CONTENT" | grep -qE "SUBAGENT_AUTHORITY: subagent-creator [0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}" 2>/dev/null; then
            echo "✅ Subagent-Creator subagent authority verified" >&2
            exit 0
        fi
        
        # FALLBACK: Check for emergency bypass in content
        if echo "$CONTENT" | grep -qE "AGENT_STEWARD_BYPASS:" 2>/dev/null; then
            echo "✅ Emergency bypass detected - allowing operation" >&2
            exit 0
        fi
        
        # Save attempt to /tmp for preservation and subagent-creator review
        TMP_FILE="/tmp/agent-steward-$(date +%s)-$$-$(echo "$AGENT_NAME" | tr '/' '-')"
        echo "$CONTENT" > "$TMP_FILE"
        
        # Save operation metadata for subagent-creator
        cat > "${TMP_FILE}.meta" <<EOF
{
    "agent_name": "$AGENT_NAME",
    "file_path": "$FILE_PATH",
    "operation": "$([[ "$TOOL_NAME" == "Write" ]] && echo "create" || echo "modify")",
    "timestamp": "$(date -Iseconds)",
    "tool": "$TOOL_NAME"
}
EOF
        
        # Fallback: Check legacy patterns (YAML frontmatter and inline comments)
        if ! echo "$CONTENT" | grep -E "(Subagent-Creator: consulted|# Subagent-Creator: consulted|AGENT-STEWARD: approved|# AGENT-STEWARD: approved|AGENT_STEWARD_BYPASS:|# AGENT_STEWARD_BYPASS:|subagent-creator consultation completed)" >/dev/null; then
            
            {
                echo "🚨 BLOCKED: AGENT ECOSYSTEM STEWARDSHIP REQUIRED"
                echo "SAVED: $TMP_FILE"
                echo "AGENT: $AGENT_NAME" 
                echo ""
                echo "REGISTRY-BASED WORKFLOW:"
                echo "Task(subagent_type='subagent-creator', prompt='AGENT_STEWARD_REQUEST AGENT:$AGENT_NAME SAVED:$TMP_FILE META:${TMP_FILE}.meta - Please review and create final approved version')"
                echo ""
                echo "SUBAGENT-CREATOR WILL:"
                echo "- Review the proposed agent modification"
                echo "- Create optimized OCTAVE version" 
                echo "- Update registry with approval"
                echo "- Handle the file operation"
                echo ""
                echo "File: $FILE_PATH"
                echo ""
                echo "EMERGENCY BYPASS (add to content):"
                echo "<!-- AGENT_STEWARD_BYPASS: critical-justification -->"
            } >&2
            
            exit 2
        fi
        
        echo "✅ Agent ecosystem stewardship consultation evidence found"
    fi
fi

exit 0