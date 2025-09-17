# Context Preservation in Agent Delegation Pattern

## Pattern Observed: Context Loss in Stateless Agent Spawning

### Problem
When agents delegate work through the Task tool, spawned agents start with no conversation history or context, leading to:
- Implementation drift from requirements
- Loss of architectural decisions
- Redundant investigations
- Inconsistent approaches

### Solution: Context Preservation Pattern

## Approved Orchestrator Write Locations

The holistic-orchestrator can write to these locations for context preservation:

1. **`.coord/` directory** - Coordination context files
   - `.coord/current-task.md` - Active task requirements
   - `.coord/delegation-context.md` - Full context for delegation
   - `.coord/findings.md` - Investigation results to pass forward

2. **`.anchor/` directory** - Odyssean anchor for drift prevention
   - `.anchor/architectural-decisions.md`
   - `.anchor/phase-context.md`

3. **`sessions/` directory** - Session documentation
   - Only `.md` and `.txt` files
   - For preserving findings and decisions

4. **Documentation files** - Any `.md`, `.txt`, `.json`, `.yaml` files
   - Configuration and context files
   - Not code files

## Delegation Patterns

### Pattern 1: Context File Reference
```bash
# Orchestrator writes context
Write(".coord/auth-implementation.md", """
## Requirements
- Implement AsyncLocalStorage for auth context
- Files: src/audit/audit-context.ts
- Test first: src/audit/audit-context.test.ts
- Fields: userId, sessionId, requestId, ipAddress
""")

# Then delegates with reference
Task(implementation-lead, "Implement auth context per .coord/auth-implementation.md")
```

### Pattern 2: Rich Inline Context
```bash
Task(implementation-lead, """
PHASE: Week 1, Day 1-2 of stabilization
CONTEXT: Auth context missing from audit logs (P0 critical)
REQUIREMENTS:
  - Use AsyncLocalStorage from node:async_hooks
  - Extend AuditLogger in src/audit/audit-logger.ts
  - TDD: Write failing tests first
  - Include: userId, sessionId, requestId, ipAddress
ACCEPTANCE:
  - All tests passing
  - Context propagates through async operations
  - No memory leaks
""")
```

### Pattern 3: Hybrid Approach
```bash
# Complex context in file
Write(".coord/investigation-findings.md", "...detailed findings...")

# Brief delegation with file reference
Task(implementation-lead, """
Fix the auth context issue identified in .coord/investigation-findings.md
Follow TDD approach, tests before implementation
""")
```

## Anti-Patterns to Avoid

❌ **Vague Delegation**
```bash
Task(implementation-lead, "Fix auth context")  # No context!
```

❌ **Orchestrator Writing Code**
```bash
Write("src/auth.ts", "...")  # Blocked by hook!
```

❌ **Context in Wrong Location**
```bash
Write("/tmp/context.md", "...")  # Not in approved location
```

## Hook Enforcement

The `enforce-orchestrator-delegation.sh` hook ensures:
- ✅ Orchestrator can write context files
- ❌ Orchestrator cannot write code (including tests)
- ✅ Clear error messages guide proper delegation

## System Steward Observation

This pattern emerged from observing role confusion where holistic-orchestrator performed implementation work directly. The enhanced hook now enforces proper delegation while allowing context preservation, preventing both role violation and context loss.

---
*Pattern documented by system-steward after observing delegation context loss*
*Hook enhanced to support context preservation pattern*

<!-- HDS-APPROVED-2025-09-15 -->
<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-09-15T12:34:45-05:00 -->