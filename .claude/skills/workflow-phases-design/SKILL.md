---
name: workflow-phases-design
description: Detailed Design phase execution (D0-D3) including ideation, North Star definition, design generation, and blueprint creation. Load when doing Design work, not needed for Build phases.
allowed-tools: Read
---

# Workflow Phases - Design Extension

Load this skill when working on D0-D3 phases. For Build phases (B0-B5), use core `workflow-phases`.

---

## D0: Ideation Setup

**Purpose**: Capture raw idea, explore possibilities, determine viability
**Lead**: sessions-manager
**Entry**: New idea or concept
**Deliverable**: Graduation package with manifest.json
**Location**: `/Volumes/HestAI-Projects/0-ideation/{topic}/`

**Key Activities**:
- Create session directory structure
- Exploration and research
- Feasibility assessment
- Graduation decision

---

## D1: North Star Definition

**Purpose**: Define problem, requirements, success criteria
**Lead**: idea-clarifier
**Entry**: Graduated D0 package
**Deliverable**: `2xx-PROJECT-NORTH-STAR.md`
**Location**: `coordination/workflow-docs/`

**Key Activities**:
- Problem statement clarity
- Success criteria definition
- Constraint identification
- North Star documentation

### D1 PARALLEL EXPLORATION PATTERN (RECOMMENDED)

**Purpose**: Accelerate D1 understanding through parallel codebase exploration

**When to Use**:
- D1 phase for projects involving existing codebase
- Understanding patterns, architecture, or prior art needed
- Multiple aspects require investigation

**Pattern**:
```python
# Launch 2-3 agents in parallel (max 3 for context overhead)
Task(subagent_type='Explore', prompt="Find similar features/patterns in codebase relevant to [problem]")
Task(subagent_type='Explore', prompt="Map high-level architecture relevant to [problem area]")
Task(subagent_type='research-analyst', prompt="Investigate external solutions/prior art for [problem type]")

# After all return:
# 1. Collect findings from all agents
# 2. Read key files identified by explorers
# 3. Synthesize into comprehensive picture for idea-clarifier
```

**Agent Prompts (Examples)**:
- "Find features similar to [feature] and trace their implementation comprehensively"
- "Map the architecture and abstractions for [feature area], tracing through the code comprehensively"
- "Analyze the current implementation of [existing feature/area], tracing through the code comprehensively"
- "Identify UI patterns, testing approaches, or extension points relevant to [feature]"

**Benefits**:
- **Breadth**: Multiple perspectives simultaneously
- **Speed**: Parallel ≠ sequential exploration
- **Coverage**: Architecture + patterns + external prior art

**Constraint**: Max 3 parallel agents (context overhead)

**Output**: Each agent should return list of 5-10 key files to read for deep understanding

---

## D2: Design Generation

**Purpose**: Generate solution alternatives, evaluate options
**Lead**: ideator → validator → synthesizer
**Entry**: D1 North Star complete
**Deliverable**: `2xx-PROJECT-D2-DESIGN.md`
**Location**: `coordination/workflow-docs/`

**Key Activities**:
- Solution brainstorming (ideator)
- Option validation (validator)
- Approach synthesis (synthesizer)
- Design documentation

---

## D3: Blueprint Creation

**Purpose**: Detailed technical design, architecture specification
**Lead**: design-architect → visual-architect
**Entry**: D2 Design complete
**Deliverable**: `2xx-PROJECT-D3-BLUEPRINT.md`
**Location**: `coordination/workflow-docs/` → moves to `dev/docs/architecture/` at B1 gate

**Key Activities**:
- Architecture design (design-architect)
- Visual mockups (visual-architect)
- Technical specification
- Blueprint documentation

---

## Phase Transition: D3 → B0 → B1

```bash
# D3 complete: Blueprint created in coordination/workflow-docs/
# B0: Validate blueprint with critical-design-validator, GO/NO-GO decision
# B1: Create build plan, setup workspace
# B1 Migration Gate: Human moves D3 Blueprint to dev/docs/architecture/
```

**Critical**: B1_02 completes in ideation/, B1_03 starts in dev/ after manual migration

---

## Design Phase Checklists

### Before Starting Design Phase

1. ✅ Previous phase deliverable complete
2. ✅ Entry requirements met
3. ✅ Coordination context read
4. ✅ Current phase understood
5. ✅ Lead agent identified

### Before Completing Design Phase

1. ✅ Deliverable created and documented
2. ✅ Phase report written
3. ✅ Next phase entry requirements met
4. ✅ Handoff to next lead agent prepared

---

*For Build phase execution, use core skill: `workflow-phases`*
