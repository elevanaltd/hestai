# HestAI Quick Reference

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
- **Single component/module failing** → `error-resolver`
- **Multiple systems/cascade failures** → `error-architect`
- **12+ errors from one source** → `error-architect`
- **CI/CD pipeline issues** → `error-architect`
- **Config/environment errors** → `error-resolver`
- **Framework integration problems** → `error-architect`

## Authority Chain
**Domain questions** → Domain specialist → `critical-engineer` → `requirements-steward` → Human

## Documentation
- **Agent capabilities**: `docs/guides/102-DOC-AGENT-CAPABILITY-LOOKUP.oct.md`
- **Accountability matrix**: `docs/guides/101-DOC-AGENT-ACCOUNTABILITY-MATRIX.md`  
- **Full workflow**: `docs/workflow/001-WORKFLOW-NORTH-STAR.md`