# Deploy Command

Execute B4_DEPLOY phases for MCP server deployment.

## Usage

```bash
# Simple case - provide deployment context
/deploy SmartSuite MCP server with enhanced table operations

# With specific stage
/deploy --stage=staging "SmartSuite MCP server to staging"
/deploy --stage=live "SmartSuite MCP server to production"

# Other operations
/deploy --validate        # B4_D3: Run validation suite
/deploy --rollback        # Emergency rollback to previous version
/deploy --status          # Check current deployment status

# Full examples
/deploy HestAI workflow MCP server with new project init tools
/deploy --stage=staging "Test zendesk integration in staging"
/deploy --rollback "Revert SmartSuite server to previous version"
```

## Context Passing

The command accepts deployment context in three ways:

1. **Everything after command** (simplest, most common):
   ```bash
   /deploy SmartSuite MCP server with table structure tools
   ```

2. **Quoted when using flags**:
   ```bash
   /deploy --stage=staging "SmartSuite MCP server with table structure tools"
   ```

3. **After separator for complex cases**:
   ```bash
   /deploy --stage=live -- Deploy server with: enhanced caching, new table tools, and undo functionality
   ```

## Deployment Phases

### B4_D1: STAGING-DEPLOY
**Lead**: system-steward
**Purpose**: Test deployment in staging environment

1. Update staging config (`claude_desktop_config_staging.json`)
2. Add serverInfo.version from config.py
3. Restart Claude Desktop
4. Validate:
   - Handshake completes (initialize ↔ initialized)
   - tools/list returns expected tools
   - Happy-path tool execution
   - Zero errors in logs
5. Check logs: `~/Library/Logs/Claude/mcp*.log`

### B4_D2: LIVE-DEPLOY  
**Lead**: solution-steward
**Purpose**: Deploy to production environment

1. Version pin in production config
2. Blue/green preparation (keep old version ready)
3. Update `claude_desktop_config.json`
4. Restart Claude Desktop
5. Immediate smoke tests

### B4_D3: DEPLOYMENT-VALIDATION
**Lead**: system-steward
**Purpose**: Confirm operational success

1. Verify serverInfo.version matches expected
2. Run full validation suite
3. Monitor logs for errors
4. Update PROJECT_STATUS.md
5. Document deployment artifacts

## Rollback Procedure

```bash
/deploy --rollback
```

1. Swap config to previous version
2. Restart Claude Desktop  
3. Validate recovery
4. Investigate failure cause
5. Document in coordination/reports/

## Configuration Management

### Staging Config
```json
{
  "mcpServers": {
    "project-staging": {
      "command": "npx",
      "args": ["@company/server@1.2.3-staging"],
      "env": { "NODE_ENV": "staging" }
    }
  }
}
```

### Production Config
```json
{
  "mcpServers": {
    "project": {
      "command": "npx",
      "args": ["@company/server@1.2.3"],
      "env": { "NODE_ENV": "production" }
    }
  }
}
```

## Validation Checklist

- [ ] Handshake completes successfully
- [ ] tools/list returns all expected tools
- [ ] No duplicate tool names across servers
- [ ] Happy-path tool execution succeeds
- [ ] Zero errors in mcp*.log files
- [ ] serverInfo.version matches expected
- [ ] Performance within SLOs

## Multiple Instance Management

Check running instances:
```bash
ps aux | grep mcp
```

Note: Each Claude Code window spawns its own MCP server process.

## Log Locations

- Main logs: `~/Library/Logs/Claude/mcp.log`
- Server logs: `~/Library/Logs/Claude/mcp-server-*.log`
- Auto-created and rotated by Claude

## Protocol Reference

Full deployment procedures: `/Users/shaunbuswell/.claude/protocols/MCP_DEPLOYMENT_LIFECYCLE.md`

## RACI

- **R**: system-steward (B4_D1, B4_D3), solution-steward (B4_D2)
- **A**: critical-engineer (all deployment decisions)
- **C**: implementation-lead (technical guidance)
- **I**: requirements-steward (North Star alignment)

## Emergency Contacts

If deployment fails and rollback doesn't work:
1. Check logs for specific errors
2. Invoke error-architect for resolution
3. If blocked, escalate to human decision

---

**REMEMBER**: All deployments must follow B4_DEPLOY phases. No shortcuts to production!