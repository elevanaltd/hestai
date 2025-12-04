# Simplified Workflow Command

## Usage
```bash
/workflow              # Auto-detect phase from artifacts
/workflow --D3        # Enter at specific phase
/workflow --fork      # Request fork for significant pivot
```

## Execution Protocol

### 1. ACTIVATE HOLISTIC ORCHESTRATOR
```bash
/role holistic-orchestrator
```

### 2. PHASE DETECTION (Automatic)
The HO will:
- Scan for essential artifacts
- Determine current phase
- Validate constitutional requirements
- Report phase status

### 3. EXECUTE WITH MIP
The HO applies Minimal Intervention Principle:
- **62% essential execution** (phase work)
- **38% maximum coordination** (overhead)
- **Skip accumulative steps** (duplicate validations, coordination theater)
- **Preserve constitutional essentials** (quality gates, RACI consultations)

### 4. CONSTITUTIONAL ESSENTIALS (Cannot Skip)

#### Phase Gates (Required Artifacts)
- **D1**: NORTH-STAR.md (immutable requirements)
- **D2**: DESIGN.md (synthesized approach)
- **D3**: BLUEPRINT.md (technical specification)
- **B0**: VALIDATION.md (GO/NO-GO decision)
- **B1**: BUILD-PLAN.md + WORKSPACE.md
- **B2**: Tests + Implementation (TDD evidence)
- **B3**: INTEGRATION-REPORT.md
- **B4**: HANDOFF.md + OPERATIONS.md

#### Quality Gates (Non-Negotiable)
- TDD: Failing test BEFORE code
- Code Review: Every change reviewed
- Tests: Must pass before proceeding
- Security: Vulnerability scan required

#### RACI Consultations (Mandatory)
- critical-engineer: Architecture decisions
- security-specialist: Security reviews
- requirements-steward: North Star alignment
- test-methodology-guardian: Test discipline

### 5. PHASE EXECUTION PATTERNS

#### D-Phases (Design)
```
D0 → D1 → D2 → D3
Natural ideation → Understanding → Solution approaches → Technical blueprint
```

#### B-Phases (Build)
```
B0 → B1 → B2 → B3 → B4
Validation gate → Planning → Implementation → Integration → Handoff
```

#### B5 (Enhancement)
```
Post-delivery feature expansion (requires stable core system)
```

### 6. FORK PROTOCOL
When significant pivot needed:
```bash
/workflow --fork
```
- HO detects divergence from North Star
- Proposes fork with justification
- **REQUIRES HUMAN APPROVAL**
- Creates new branch for exploration

### 7. SIMPLIFIED EXECUTION

The HO will:
1. **Detect** current phase from artifacts
2. **Validate** constitutional essentials present
3. **Filter** accumulative steps (remove up to 38%)
4. **Execute** essential steps only (minimum 62%)
5. **Produce** required artifacts
6. **Request** human approval for forks

### Philosophy
**MIP Application**: "What capability would be lost if this step were removed?"
- Remove duplicate validations
- Eliminate coordination theater
- Simplify handoffs
- Preserve all quality gates
- Maintain RACI accountability

### Buck Stops Here
The Holistic Orchestrator has:
- **Final orchestration authority**
- **Cannot violate constitutional essentials**
- **Must request human approval for forks**
- **Applies MIP to reduce complexity**

## Quick Start Examples

### New Project
```bash
/workflow "Task management application"
# HO detects no artifacts → starts at D0
```

### Resume Work
```bash
/workflow
# HO detects D2-DESIGN.md exists → continues at D3
```

### Jump to Phase
```bash
/workflow --B2
# HO validates B1 artifacts exist → starts implementation
```

### Request Fork
```bash
/workflow --fork "Pivot to mobile-first approach"
# HO proposes fork → awaits human approval
```

---
**Authority**: Holistic Orchestrator with MIP enforcement
**Protection**: Constitutional essentials cannot be skipped
**Simplification**: Removes up to 38% accumulative complexity