#!/bin/bash
# Agent Stewardship Hook - Bash Version
# Prevents unauthorized agent operations in /Users/shaunbuswell/.claude/agents/ via Bash commands
# Enforces agent ecosystem governance through subagent-creator consultation

set -e

# Parse JSON input from Claude Code
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || echo "")

# Only process Bash tool
if [[ "$TOOL_NAME" != "Bash" ]]; then
    exit 0
fi

# Check if command operates on agent ecosystem
if echo "$COMMAND" | grep -E "(rm|mv|cp|touch|mkdir|rmdir).*\/Users\/shaunbuswell\/\.claude\/(agents|settings\.json)" >/dev/null; then
    
    # Extract agent information if possible
    AGENT_NAME="unknown"
    if echo "$COMMAND" | grep -oE '/Users/shaunbuswell/\.claude/agents/[^/]+\.oct\.md' >/dev/null; then
        FILE_PATH=$(echo "$COMMAND" | grep -oE '/Users/shaunbuswell/\.claude/agents/[^/]+\.oct\.md' | head -1)
        AGENT_NAME=$(basename "$FILE_PATH" .oct.md)
        
        # REGISTRY CHECK: For agent operations, check registry approval
        REGISTRY="@.agents/registry.json"
        if [[ -f "$REGISTRY" ]] && [[ "$AGENT_NAME" != "unknown" ]]; then
            if jq -e ".agents | has(\"$AGENT_NAME\")" "$REGISTRY" >/dev/null 2>&1; then
                AGENT_STATUS=$(jq -r ".agents[\"$AGENT_NAME\"].status" "$REGISTRY" 2>/dev/null || echo "unknown")
                if [[ "$AGENT_STATUS" == "approved" ]]; then
                    echo "✅ Agent registry approval verified - bash operation allowed for $AGENT_NAME" >&2
                    exit 0
                fi
            fi
        fi
    fi
    
    # ROLE-BASED AUTHORITY: Check for active subagent-creator role
    ACTIVE_ROLE_SESSION=$(ls /tmp/active_role_subagent-creator_* 2>/dev/null | head -1)
    if [[ -n "$ACTIVE_ROLE_SESSION" ]]; then
        echo "✅ Subagent-Creator role authority verified for bash operations" >&2
        exit 0
    fi
    {
        echo "🚨 BLOCKED: AGENT ECOSYSTEM BASH OPERATIONS FORBIDDEN"
        echo ""
        echo "COMMAND BLOCKED: $COMMAND"
        echo "AGENT: $AGENT_NAME"
        echo ""
        echo "REGISTRY-BASED WORKFLOW:"
        echo "Task(subagent_type='subagent-creator', prompt='Need bash operation: $COMMAND for agent: $AGENT_NAME - Please review and approve')"
        echo ""
        echo "ALTERNATIVE: Activate subagent-creator role first"
        echo "/role subagent-creator"
        echo ""
        echo "OR: Use Write/Edit tools instead of direct file operations"
    } >&2
    
    exit 2
fi

exit 0