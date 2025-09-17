# HestAI Quick Reference

## Build Quality Policy
**Reference**: `/Volumes/HestAI/docs/standards/106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md`
- Zero-tolerance for warnings/errors
- Suppressions require inline justification
- Enforced at B1_02 workspace setup
- See violation handling matrix in doc

## FILE_STANDARDS (B2→B3 Integration Enhancement)
**Purpose**: Prevent incomplete integration patterns that cause build failures
- **ALWAYS_ADD_FINAL_NEWLINE**: true (EOF consistency)
- **IMPORT_ORDERING**: external→internal→types (dependency clarity)
- **NO_ANY_TYPE**: use unknown or specific types (type safety preservation)
- **COMPLETE_INTEGRATIONS**: no unused validation declarations (validation-to-execution flow)
- **TYPE_SAFETY_PRESERVATION**: validated types flow through execution without casting
- **STRUCTURED_ERROR_HANDLING**: preserve error structure, never flatten to strings
- **INTEGRATION_TESTING**: every validation layer must have execution flow test

### Integration Validation Requirements
- **Pre-commit Hook**: Check for unused validation variables
- **TypeScript Config**: `noUnusedLocals: true`, `noUnusedParameters: true`
- **Integration Tests**: Verify validation-to-execution flow completeness
- **Error Pattern Detection**: Scan for TYPE_SAFETY_THEATER anti-patterns

## What is HestAI?
**Multi-agent workflow orchestration system** - coordinates specialized AI agents through D1→B4 phases to deliver systematic project results.

## Quick Start
**Need to start a project?** → Begin in `/Volumes/HestAI-Projects/0-ideation/sessions/`  
**Working on existing project?** → Check coordination docs first: `Read(".coord/PROJECT_NORTH_STAR.md")`  
**Need an agent?** → Use `/role {agent-name}` or check capability lookup

## Agent Selection (Common Tasks)
- **Fix failing tests** → `test-methodology-guardian`
- **Review code** → `code-review-specialist` 
- **Architecture decisions** → `technical-architect`
- **Debug complex issues** → `mcp__hestai__debug`
- **Break down tasks** → `task-decomposer`
- **Validate designs** → `critical-engineer`
- **Integration work** → `completion-architect`
- **Documentation** → `hestai-doc-steward` (for /docs/ area)
- **Project workspace setup** → `workspace-architect`
- **Session setup** → `sessions-manager`
- **Single component errors** → `error-resolver`
- **System-wide/cascade errors** → `error-architect`

## Workflow Phases (Quick Reference)
- **D0** - Ideation setup → sessions-manager
- **D1** - Understand problem → idea-clarifier
- **D2** - Generate solutions → ideator + validator  
- **D3** - Create blueprint → design-architect + technical-architect
- **B0** - Validate design → critical-design-validator
- **B1** - Plan build → task-decomposer + workspace-architect
- **B2** - Implement → implementation-lead (hub) + specialists
- **B3** - Integrate → completion-architect + universal-test-engineer
- **B4** - Deliver → solution-steward + system-steward
- **B5** - Enhance → requirements-steward + implementation-lead

## Critical Rules
- **Always read coordination docs first** (if `.coord` exists)
- **Test before code** - write failing test first
- **Get code reviewed** - every change needs review
- **Consult specialists** - use accountable agents for their domains
- **Follow TRACED** - Test→Review→Analyze→Consult→Execute→Document

## Project Structure
- **HestAI-Projects** - Active projects and ideation
- **HestAI/docs** - Governance and workflow standards (protected by hestai-doc-steward)
- **Coordination** - Project-specific context (symlinked as `.coord`)

## When Stuck
- **Need different approach?** → `ideator-catalyst`
- **Complex problem?** → `mcp__hestai__consensus` (multi-model)
- **System broken?** → `mcp__hestai__debug`
- **Architecture questions?** → `mcp__hestai__critical-engineer`

## Error Handling
- **ERROR TRIAGE PROTOCOL** → `/Users/shaunbuswell/.claude/protocols/ERROR-TRIAGE-LOOP.md`
- **ANY errors** → `error-architect` (unified handler for simple to complex)
- **CI failures** → Run triage loop: Fix Build→Types→Unused→Async→Logic→Tests
- **Error classification** → error-architect self-classifies: SIMPLE/COMPLEX/ESCALATION
- **12+ errors from one source** → `error-architect`
- **CI/CD pipeline issues** → `error-architect`
- **Config/environment errors** → `error-architect`
- **Framework integration problems** → `error-architect`

## Authority Chain
**Domain questions** → Domain specialist → `critical-engineer` → `requirements-steward` → Human

## Documentation
- **Agent capabilities**: `docs/guides/102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md`
- **Accountability matrix**: `docs/guides/101-DOC-AGENT-ACCOUNTABILITY-MATRIX.md`  
- **Full workflow**: `docs/workflow/001-WORKFLOW-NORTH-STAR.md`