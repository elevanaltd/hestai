# Workflow North Star Command

**MANDATORY: COORDINATION FIRST, THEN PROTOCOL**

## 🚨 UNIVERSAL NORTH STAR RULE
**EVERY AGENT INVOCATION MUST INCLUDE PROJECT NORTH STAR**

When invoking ANY agent for project work, you MUST:
1. Read the project North Star document first
2. Include North Star context in the agent prompt
3. Ensure agent has project context for coherent decisions

```python
# MANDATORY PATTERN for all agent invocations:
Read(".coord/PROJECT_CONTEXT.md")  # Contains project context
Read(".coord/docs/2xx-PROJECT[-{NAME}]-NORTH-STAR.md")  # North Star document (actual location)

Task(subagent_type="any-agent",
     prompt="[Agent task description]
     
     PROJECT NORTH STAR CONTEXT:
     {north_star_summary}
     
     PROJECT CONTEXT:
     {project_context_summary}")
```

**RATIONALE**: Every agent decision must align with project North Star to prevent drift and ensure coherent progress toward the same goal.

## 🚨 IMMEDIATE EXECUTION STEPS

### STEP 1: Read Coordination Context (MANDATORY)
```bash
# Check for coordination repository
if [ -d ".coord" ] || [ -d "../../../coordination" ]; then
  echo "📁 Reading coordination documents..."
  # Read project context from coordination/
else
  echo "⚠️  No coordination found - may be working outside project context"
fi
```

**YOU MUST**: Read all coordination documents BEFORE proceeding:
- Project North Star (docs/2xx-PROJECT[-{NAME}]-NORTH-STAR.md)
- PROJECT_CONTEXT.md
- Current assignments  
- Phase status
- Technical decisions

### STEP 2: Identify Current Phase
Based on coordination docs and existing artifacts:
- **D1-D3**: Discovery/Design phases
- **B0**: Validation gate
- **B1**: Planning/Workspace
- **B2**: Build/Implementation
- **B3**: Integration
- **B4**: Delivery
- **B4_DEPLOY**: MCP Deployment (B4_D1: Staging, B4_D2: Live, B4_D3: Validation)
- **B5**: Enhancement

### STEP 3: Get Scope-Calibrated Workflow
```python
# Get both workflow facts AND scope calibration
Task(subagent_type="workflow-scope-calibrator",
     description="Scope-aware workflow guidance",
     prompt="Current phase: {phase}, Predicted scope: {scope_estimate}")
```

This provides:
- Complete RACI governance matrix
- Phase transition requirements  
- **SCOPE GATE enforcement**
- Reality checks and proportionality validation
- Adaptive workflow routing based on project complexity

### STEP 4: Execute With Execution Mode

**DEPLOY MODE** (`/workflow --deploy`):
```python
# Execute B4_DEPLOY phases for MCP server deployment
current_phase = "B4_DEPLOY"

# Execute staging deployment
Task(subagent_type="system-steward",
     prompt="Execute B4_D1 staging deployment.
     
     MCP DEPLOYMENT CONTEXT:
     - Update staging config
     - Validate handshake, tools/list
     - Check logs: ~/Library/Logs/Claude/mcp*.log
     
     PROJECT NORTH STAR CONTEXT:
     {north_star_summary}")

# Execute production deployment after validation
Task(subagent_type="solution-steward",
     prompt="Execute B4_D2 production deployment after staging validation.")

# Final validation
Task(subagent_type="system-steward",
     prompt="Execute B4_D3 deployment validation.")
```

**PHASE MODE** (`/workflow --phase`):
```python
# Execute single phase with automatic recalibration
current_phase = "{identified_phase}"

# Execute current phase with North Star context
Task(subagent_type="{phase_lead}",
     prompt="Execute {current_phase} with scope constraints.
     
     PROJECT NORTH STAR CONTEXT:
     {north_star_summary}
     
     SCOPE CONSTRAINTS: {scope_constraints}
     
     Complete phase deliverables then STOP for validation.")

# AUTOMATIC RECALIBRATION after phase completion
Task(subagent_type="workflow-scope-calibrator", 
     description="Post-phase scope recalibration",
     prompt="RECALIBRATION: {current_phase} completed. 
     
     PHASE RESULTS: {phase_outcomes}
     PROJECT CONTEXT: {coordination_summary}
     
     Assess scope changes and provide next phase guidance.")

# PAUSE for human validation/continuation decision
```

**FULL MODE** (`/workflow --full`):
```python
# Execute D1→B4 with automatic recalibration at each boundary
phases = ["D1", "D2", "D3", "B0", "B1", "B2", "B3", "B4"]

for phase in phases:
    # Execute phase with scope constraints
    Task(subagent_type="{phase_lead}",
         prompt="Execute {phase} with scope constraints.
         
         PROJECT NORTH STAR CONTEXT: {north_star_summary}
         SCOPE CONSTRAINTS: {current_scope_constraints}")
    
    # AUTOMATIC RECALIBRATION after each phase
    recalibration = Task(subagent_type="workflow-scope-calibrator",
                        description="Post-phase scope recalibration", 
                        prompt="RECALIBRATION: {phase} completed.
                        RESULTS: {phase_outcomes}
                        Assess scope evolution for next phase.")
    
    # PAUSE only at critical gates (B0, B3) or if scope elevation detected
    if phase in ["B0", "B3"] or recalibration.scope_elevation_detected:
        # Pause for human validation
        break
```

### STEP 3.1: Validate PROJECT_CONTEXT (MANDATORY)
**AFTER** receiving workflow-scope-calibrator response:

```python
# CHECK: Did workflow-scope-calibrator read PROJECT_CONTEXT.md?
# Look for "Files read:" in their response
if "PROJECT_CONTEXT.md" not in calibrator_response:
    # REDO: Re-run workflow-scope-calibrator with explicit instruction
    Task(subagent_type="workflow-scope-calibrator",
         description="Scope calibration with project context",
         prompt="CRITICAL: You MUST read .coord/PROJECT_CONTEXT.md first. Current phase: {phase}, Predicted scope: {scope_estimate}")
```

**VALIDATION RULE**: The workflow-scope-calibrator MUST read PROJECT_CONTEXT.md to provide accurate scope calibration. Their response should list all files read. If PROJECT_CONTEXT.md is missing from their file list, re-run the calibrator with explicit instruction to read project context first.

### STEP 5: Legacy Single-Phase Execution (Use STEP 4 execution modes instead)

## Quick Phase Reference

| Phase | Lead Agent | Entry Requirement | Key Action |
|-------|------------|-------------------|------------|
| **D1** | idea-clarifier | Read coordination | Understand problem |
| **D2** | research-analyst | D1 complete | Explore options |
| **D3** | design-architect | D2 complete | Create blueprint |
| **D3_USER** | prototype-validator | D3 complete | User validation of design |
| **B0** | critical-design-validator | D3_USER complete | GO/NO-GO decision |
| **B1** | task-decomposer → workspace-architect | B0 approved | Plan & setup |
| **B2** | implementation-lead + technical-architect | B1 complete, Read coordination | Build with TRACED |
| **B3** | completion-architect → sequence | B2 complete, 80% coverage | Integration sequence |
| **B3_USER** | user-acceptance-tester | B3 complete | User acceptance testing |
| **B4** | solution-steward → sequence | B3_USER complete | Production handoff |
| **B4_USER** | user-signoff-validator | B4 complete | Final user validation |
| **B4_D1** | system-steward | B4_USER approved | Staging deployment |
| **B4_D2** | solution-steward | B4_D1 validated | Production deployment |
| **B4_D3** | system-steward | B4_D2 complete | Deployment validation |
| **B5** | requirements-steward + implementation-lead | B4_D3 approved | User-driven enhancements |

## TRACED Protocol (Always Active)
- **T**est: Failing test first
- **R**eview: Every code change  
- **A**nalyze: Architecture validation
- **C**onsult: Specialist triggers
- **E**xecute: Quality gates + ERROR_RESOLUTION protocol for failures
- **D**ocument: TodoWrite tracking

## Common Execution Patterns

### Starting New Phase Work:
```python
# 1. Read coordination
Read(".coord/PROJECT_CONTEXT.md")
Read(".coord/docs/2xx-PROJECT[-{NAME}]-NORTH-STAR.md")  # Actual North Star location
Read(".coord/ASSIGNMENTS.md")

# 2. Identify current phase from coordination docs
current_phase = "{phase_from_coordination}"
project_scope = "{scope_from_context}"

# 3. Get scope-calibrated workflow
Task(subagent_type="workflow-scope-calibrator",
     prompt="Current phase: {current_phase}, Project scope: {project_scope}")

# 3.1. Validate PROJECT_CONTEXT was read (check calibrator response for "Files read:")
if "PROJECT_CONTEXT.md" not in calibrator_response:
    Task(subagent_type="workflow-scope-calibrator",
         prompt="CRITICAL: Read .coord/PROJECT_CONTEXT.md first. Current phase: {current_phase}, Project scope: {project_scope}")

# 4. Invoke phase lead with scope awareness AND North Star context
Task(subagent_type="{phase_lead}",
     prompt="Leading {current_phase} per scope-calibrated workflow.
     
     PROJECT NORTH STAR CONTEXT:
     {north_star_summary}
     
     PROJECT CONTEXT:
     {coordination_summary}
     
     SCOPE: {project_scope}")
```

### Continuing Existing Work:
```python
# 1. Read coordination for context
Read(".coord/PROJECT_CONTEXT.md")
Read(".coord/docs/2xx-PROJECT[-{NAME}]-NORTH-STAR.md")  # Actual North Star location
Read(".coord/ASSIGNMENTS.md")

# 2. Identify current phase and check existing deliverables
current_phase = "{phase_from_coordination}"
Read(".coord/BUILD_STATUS.md")  # or relevant status docs

# 3. Get scope-calibrated workflow for current phase
Task(subagent_type="workflow-scope-calibrator",
     prompt="Current phase: {current_phase}, Project scope: {project_scope}, Status: continuing existing work")

# 3.1. Validate PROJECT_CONTEXT was read (check calibrator response for "Files read:")
if "PROJECT_CONTEXT.md" not in calibrator_response:
    Task(subagent_type="workflow-scope-calibrator",
         prompt="CRITICAL: Read .coord/PROJECT_CONTEXT.md first. Current phase: {current_phase}, Project scope: {project_scope}, Status: continuing existing work")

# 4. Resume with appropriate agent AND North Star context
Task(subagent_type="{current_phase_lead}",
     prompt="Continuing {current_phase} work.
     
     PROJECT NORTH STAR CONTEXT:
     {north_star_summary}
     
     PROJECT CONTEXT:
     {coordination_summary}
     
     STATUS: {current_status}")
```

### Phase Transition:
```python
# Current lead completes deliverables
# Then coordinates handoff WITH North Star context:
Task(subagent_type="{next_phase_lead}",
     prompt="Taking over from {current_phase}.
     
     PROJECT NORTH STAR CONTEXT:
     {north_star_summary}
     
     PROJECT CONTEXT:
     {coordination_summary}
     
     HANDOFF STATE: {briefing}")
```

## Critical Reminders

✅ **ALWAYS**: Read coordination first  
✅ **ALWAYS**: Include North Star context in agent invocations
✅ **ALWAYS**: Follow RACI assignments  
✅ **ALWAYS**: Use TRACED protocol  
✅ **ALWAYS**: Recalibrate scope after each phase completion
✅ **ALWAYS**: Run workspace-architect after user feedback to organize artifacts
✅ **NEVER**: Skip phase sequences  
✅ **NEVER**: Proceed without deliverables
✅ **NEVER**: Continue without scope validation
✅ **NEVER**: Leave user feedback reports scattered in build directory

## Scope Gate Integration
**MANDATORY BEFORE EXECUTION**: Every agent must declare:
```
SCOPE: [actual system description]
EFFORT: [proportional effort level] 
ADAPTATION: [which standard sections to skip/modify]
```

**Reality Check Questions**:
- "Would a senior engineer laugh at this?"
- "Am I creating theater or value?"
- "Is this appropriate for the deployment model?"

## Full Workflow Reference
**Authoritative Source**: `/Volumes/HestAI/docs/workflow/001-WORKFLOW-NORTH-STAR.md`  
**Scope Calibration**: `workflow-scope-calibrator` agent
**Knowledge Engine**: `workflow-engine` agent

This command provides **scope-aware workflow routing** preventing validation theater while maintaining quality standards.

---

## Command Usage

```bash
# Simple case - provide workflow context
/workflow Continue implementing task management system

# With specific mode
/workflow --phase "Complete B2 implementation for task manager"
/workflow --full "Execute full workflow for inventory system"
/workflow --deploy "Deploy SmartSuite MCP server to production"

# Other operations
/workflow --status  # Show current state without execution

# Full examples
/workflow Build collaborative documentation platform
/workflow --phase "Resume B3 integration for e-commerce platform"
/workflow --deploy "Deploy HestAI workflow MCP server"
```

## Context Passing

The command accepts workflow context in three ways:

1. **Everything after command** (simplest, most common):
   ```bash
   /workflow Build task management system with team features
   ```

2. **Quoted when using flags**:
   ```bash
   /workflow --phase "Build task management system with team features"
   ```

3. **After separator for complex cases**:
   ```bash
   /workflow --full -- Execute workflow for: multi-tenant SaaS platform with billing, analytics, and API
   ```

**EXECUTION SEQUENCE**:
1. READ coordination documents
2. IDENTIFY current phase from coordination 
3. GET scope-calibrated workflow for that phase
4. EXECUTE with chosen mode (--phase or --full)
   - Automatic recalibration after each phase
   - North Star context in every agent invocation
   - Critical gate validation (B0, B3)
   - User validation phases (D3_USER, B3_USER, B4_USER)
   - Workspace-architect cleanup after user feedback
   - Scope elevation detection and pause