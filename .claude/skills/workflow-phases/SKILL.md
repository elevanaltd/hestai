---
name: workflow-phases
description: Core HestAI workflow map (D0-B5) and Build phase execution (B0-B5). For detailed Design phase instructions (D0-D3), load 'workflow-phases-design'.
allowed-tools: Read
---

# Workflow Phases (Core)

## Phase Map

**Design Phases** (Details: `workflow-phases-design`)
| Ph | Lead | Deliverable |
|----|------|-------------|
| **D0** | sessions-manager | Graduation pkg |
| **D1** | idea-clarifier | North Star |
| **D2** | ideator→synthesizer | Design Doc |
| **D3** | design-architect | Blueprint |

**Build Phases** (Execution)
| Ph | Lead | Deliverable |
|----|------|-------------|
| **B0** | critical-design-validator | GO/NO-GO |
| **B1** | workspace-architect | Build Plan |
| **B2** | implementation-lead | Code+Tests |
| **B3** | completion-architect | Integration |
| **B4** | solution-steward | Delivery Pkg |

**Deploy Phases** (B4_DEPLOY)
| Ph | Lead | Deliverable |
|----|------|-------------|
| **B4_D1** | system-steward | Staging |
| **B4_D2** | solution-steward | Production |
| **B4_D3** | system-steward | Ops Confirm |

---

## Build Phase Execution (B0-B5)

### B0: Design Validation
**Entry**: D3 Blueprint | **Lead**: critical-design-validator
**Action**: Validate feasibility/risks | **Deliverable**: GO/NO-GO Document

### B1: Build Planning
**Entry**: B0 GO | **Lead**: task-decomposer → workspace-architect
**Action**: Decompose tasks, setup workspace | **Gate**: Manual migration of D3 docs to `dev/`

### B2: Implementation
**Entry**: B1 Ready | **Lead**: implementation-lead
**Action**: TDD, Feature dev | **Gate**: `npm run test` PASS
**Pattern**: implementation-lead coordinates specialist agents (hub)

### B3: Integration
**Entry**: B2 Complete | **Lead**: completion-architect
**Action**: System integration, E2E tests

### B4: Delivery
**Entry**: B3 Complete | **Lead**: solution-steward
**Action**: Final docs, production packaging

### B5: Enhancement
**Scope**: ≤3 days | **Entry**: Issue/Feedback
**Process**: Follow B2→B4 logic + B4_DEPLOY
**Protocol**: `~/.claude/protocols/ENHANCEMENT_LIFECYCLE.md`

---

## Coordination & Structure

**Discovery** (Run First):
```bash
COORD=$(readlink .coord 2>/dev/null || echo "./coordination")
Read "$COORD/PROJECT_STATUS.md"  # Get Phase, Issues, Blocks
```

**Structure**:
```
{project}/
├── .coord → coordination/
├── dev/                    # B2-B5 work
└── coordination/
    ├── workflow-docs/      # D1-B0 deliverables
    ├── phase-reports/      # B1-B4 reports
    └── PROJECT_STATUS.md   # Status board
```

---

## Critical Rules

1. **Coordination First**: Always read `PROJECT_STATUS.md` before starting
2. **Phase Gates**: Deliverables + Tests must pass before transition
3. **B1 Migration**: Human moves D3 Blueprint to `dev/docs/`
4. **B4_DEPLOY Required**: For ALL deployments (staging→prod→confirm)
5. **B5 Scope**: ≤3 days or start new project

---

## Agent Invocation Pattern

```python
Task(subagent_type="{lead_agent}",
     prompt="""
     CONTEXT:
     - Protocols: ~/.claude/protocols/
     - Coordination: {readlink .coord}
     - Current Phase: {from PROJECT_STATUS.md}

     TASK: [Action] aligning with Phase [X] deliverables.
     """)
```

---

*Reference: For full phase details, read `docs/workflow/001-WORKFLOW-NORTH-STAR.md`*
*For Design phase patterns (D0-D3), load skill: `workflow-phases-design`*
