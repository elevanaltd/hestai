# 104: HestAI Workflow Quick Reference

**Status:** Active Guide  
**Owner:** HestAI-Doc-Steward  
**Last Updated:** 2025-08-25  

> This guide is a high-level, quick reference for the HestAI workflow. It is designed for rapid lookups and provides links to detailed documentation, not comprehensive explanations.

---

## 1. Common Workflows (High-Level)

High-level patterns for the most frequent development lifecycles.

### New Project Setup
```bash
# 1. Initialize session in ideation space
/role sessions-manager
# Creates: /Volumes/HestAI-Projects/0-ideation/sessions/YYYY-MM-DD-PROJECT/

# 2. Execute D1 discovery phase  
/workflow load
# Phases: D1→D2→D3→B0→B1→B2→B3→B4→B4_DEPLOY→B5

# 3. Graduate to dedicated workspace (B1_02)
/role workspace-architect  
# Creates: /Volumes/HestAI-Projects/PROJECT-workspace/
```

### Bug Fix Lifecycle  
```bash
# 1. Single component error
/role error-resolver

# 2. System cascade error  
/role error-architect

# 3. Apply TRACED protocol
# T: Test-first validation R: Review code changes A: Architecture validation
```

### Enhancement Lifecycle (B5)
```bash
# Post-delivery feature expansion
/role enhancement-specialist  
# Uses existing project workspace, maintains architecture
```

**Detailed References:**
- [001-WORKFLOW-NORTH-STAR.md](../workflow/001-WORKFLOW-NORTH-STAR.md) - Complete lifecycle philosophy
- [101-DOC-AGENT-ACCOUNTABILITY-MATRIX.md](./101-DOC-AGENT-ACCOUNTABILITY-MATRIX.md) - Agent responsibility mapping

---

## 2. Essential Command Cheat Sheet

| Command | Description | Example Usage |
|---------|-------------|---------------|
| `/workflow` | Load complete workflow context | `/workflow` |
| `/role {agent}` | Activate specific agent | `/role critical-engineer` |
| `/.coord` | Access coordination folder | Navigate to @coordination/ |
| `/anchor` | Cognitive realignment checkpoint | Use at phase boundaries |

### Key MCP Commands (via tools)
| Tool Pattern | Purpose | Trigger |
|--------------|---------|---------|
| `mcp__hestai__critical-engineer` | Technical validation | Before major decisions |
| `mcp__hestai__testguard` | Test methodology guardian | When fixing tests vs code |
| `mcp__hestai__debug` | Root cause analysis | Complex bug investigation |
| `mcp__hestai__planner` | Sequential planning | Multi-step task breakdown |

**Full Command Reference:** [102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md](./102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md)

---

## 3. Phase Transition Requirements (Summary)

Key deliverables required to move between lifecycle phases.

| Phase | Purpose | Key Deliverable(s) | Agent Lead |
|-------|---------|-------------------|------------|
| **D1** | Discovery | Problem definition, requirements gathering | requirements-steward |
| **D2** | Design | Architecture decisions, technical specs | technical-architect |  
| **D3** | Detailed Design | Implementation plan, dependency mapping | task-decomposer |
| **B0** | Build Gate | Validated design, resource allocation | critical-design-validator |
| **B1** | Build Setup | Workspace creation, tool configuration | workspace-architect |
| **B2** | Implementation | Code creation with TRACED protocol | implementation-lead |
| **B3** | Integration | System unification, component testing | completion-architect |
| **B4** | Build Complete | Code review, quality gates passed | code-review-specialist |
| **B4_DEPLOY** | Deployment | Successful staging deployment | deployment-specialist |
| **B5** | Live/Enhancement | Production ready, post-delivery features | solution-steward |

**Phase Gate Specifications:** [001-WORKFLOW-NORTH-STAR.md](../workflow/001-WORKFLOW-NORTH-STAR.md)

---

## 4. Quick Troubleshooting (Top 3 Issues)

### Issue 1: MCP Server Connection Failed
**Symptoms:** Agent tools not responding, "connection refused" errors
**Quick Fix:**
```bash
# Check MCP server status
mcp-server --status

# Restart if needed  
mcp-server --restart

# Re-establish session
# Restart Claude Code session completely
```

### Issue 2: Agent Not Loading Properly  
**Symptoms:** `/role agent-name` doesn't activate expected behavior
**Quick Fix:**
```bash
# Check agent availability
/role list

# Verify agent definition exists
/role status {agent-name}

# Clear role cache and retry
/role clear-cache
```

### Issue 3: Build Artifacts Scattered
**Symptoms:** Reports and docs created in wrong locations  
**Quick Fix:**
```bash
# Invoke workspace organization
/role workspace-architect
# Request: "organize build artifacts to coordination folder"

# Check coordination folder
ls .coord/ or ls @coordination/
```

**Comprehensive Troubleshooting:** [105-DOC-TROUBLESHOOTING-GUIDE.md](./105-DOC-TROUBLESHOOTING-GUIDE.md) *(to be created)*

---

## 5. Key Protocol Definitions

| Protocol | Acronym | Purpose | Deep-Dive |
|----------|---------|---------|-----------|
| **TRACED** | **T**est **R**eview **A**nalyze **C**onsult **E**xecute **D**ocument | Quality enforcement with artifact verification | [TRACED Protocol Spec](#) |
| **RACI** | **R**esponsible **A**ccountable **C**onsulted **I**nformed | Role clarity matrix for task ownership | [RACI Implementation Guide](#) |

### TRACED Quick Reference
```
T: TEST_FIRST (write failing test before code → RED_STATE_ENFORCEMENT)
R: REVIEW (code-review-specialist after creation → TEST_INTENT_REVIEW)  
A: ANALYZE (critical-engineer for architecture decisions)
C: CONSULT (specialists at mandatory triggers → testguard for testing)
E: EXECUTE (quality gates: lint+typecheck+tests → BEHAVIOR_VALIDATION)
D: DOCUMENT (todowrite throughout execution)
```

### Critical Consultation Triggers
- Architecture decisions → `critical-engineer`
- Code changes → `code-review-specialist`
- Test issues → `testguard` 
- Testing discipline violations → `testguard`
- North star conflicts → `requirements-steward`

---

## 6. Essential Documentation Links

### Core Philosophy & Structure
- **[001-WORKFLOW-NORTH-STAR.md](../workflow/001-WORKFLOW-NORTH-STAR.md)** - Complete lifecycle methodology
- **[101-DOC-AGENT-ACCOUNTABILITY-MATRIX.md](./101-DOC-AGENT-ACCOUNTABILITY-MATRIX.md)** - Agent responsibility mapping
- **[102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md](./102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md)** - Rapid agent selection (LLM optimized)
- **[103-DOC-LLM-DOCUMENTATION-BLOAT-PREVENTION.md](./103-DOC-LLM-DOCUMENTATION-BLOAT-PREVENTION.md)** - Quality standards

### Protocols & Standards  
- **[WORKFLOW-NORTH-STAR Protocol](~/.claude/protocols/WORKFLOW-NORTH-STAR.md)** - D1→B4 execution patterns
- **[PROJECT-WORKSPACE Protocol](~/.claude/protocols/PROJECT-WORKSPACE.md)** - Two-repository coordination
- **[CI_ERROR_RESOLUTION Protocol](~/.claude/protocols/CI_ERROR_RESOLUTION.md)** - Autonomous error resolution

### HestAI Knowledge Base
- **[HestAI Framework Library](/Volumes/HestAI/hestai-framework/library/)** - Reusable components
- **[HestAI Guides](/Volumes/HestAI/docs/guides/)** - Comprehensive reference materials  
- **[Role Protocols - Finalised](/Volumes/HestAI/hestai-orchestrator/assembly/protocols/finalised-roles/)** - Production-ready agents
- **[Role Protocols - Gold](/Volumes/HestAI/hestai-orchestrator/assembly/protocols/gold/)** - Premium agent definitions

---

## Quick Start Checklist

For new users getting started with HestAI workflow:

- [ ] Read [001-WORKFLOW-NORTH-STAR.md](../workflow/001-WORKFLOW-NORTH-STAR.md)
- [ ] Understand phase progression: D1→D2→D3→B0→B1→B2→B3→B4→B4_DEPLOY→B5
- [ ] Learn key commands: `/workflow`, `/role {agent}`, `/.coord`
- [ ] Know TRACED protocol: Test→Review→Analyze→Consult→Execute→Document
- [ ] Identify your common workflow pattern (new project vs bug fix vs enhancement)
- [ ] Bookmark [102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md](./102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md) for agent selection

---

*This guide maintains the "link, don't replicate" principle. For detailed procedures, always consult the canonical documentation referenced above.*

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-25T10:30:00-04:00 -->