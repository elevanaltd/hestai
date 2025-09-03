# WORKFLOW-CONSTITUTIONAL-ESSENTIALS

**Status**: Active  
**Purpose**: Define non-negotiable constitutional essentials that MIP (Minimal Intervention Principle) cannot remove  
**Scope**: System integrity boundaries for workflow optimization  
**Authority**: Holistic Orchestrator enforcement, hestai-doc-steward governance

## Constitutional Essentials (CANNOT BE SKIPPED)

### 1. Phase Gate Artifacts (Mandatory)
```
D1: PROJECT-{NAME}-D1-NORTH-STAR.md
D2: PROJECT-{NAME}-D2-DESIGN.md  
D3: PROJECT-{NAME}-D3-BLUEPRINT.md
B0: PROJECT-{NAME}-B0-VALIDATION.md
B1: PROJECT-{NAME}-B1-PLAN.md
B2: PROJECT-{NAME}-B2-IMPLEMENTATION-LOG.md
B3: PROJECT-{NAME}-B3-INTEGRATION-REPORT.md
B4: PROJECT-{NAME}-B4-DELIVERY.md
B5: PROJECT-{NAME}-B5-ENHANCEMENT.md (when applicable)
```

**Enforcement**: Each phase MUST produce its artifact before progression  
**Exception Authority**: requirements-steward (with justification)  
**Validation**: Artifact exists + meets minimum content requirements

### 2. Quality Gates (Non-Negotiable)
```
TDD_DISCIPLINE: Test before code (RED→GREEN→REFACTOR)
CODE_REVIEW: Every implementation change reviewed
TEST_EXECUTION: All tests pass before merge
SECURITY_SCANNING: Security-specialist consultation for auth/data
TRACED_PROTOCOL: Test→Review→Analyze→Consult→Execute→Document
```

**Enforcement**: Automated gates + specialist consultation triggers  
**Exception Authority**: critical-engineer (emergency only)  
**Evidence Required**: CI job links, review comments, test outputs

### 3. RACI Consultations (Accountability)
```
MANDATORY_CONSULTATIONS:
- critical-engineer: Architecture decisions, technical risk assessment  
- security-specialist: Authentication, authorization, data handling
- requirements-steward: Scope changes, north star conflicts
- test-methodology-guardian: Testing approach, coverage strategy
- error-architect: System-wide failures, cascade errors (12+ errors)
- error-resolver: Component-specific failures, config issues
```

**Enforcement**: Consultation evidence required in decision artifacts  
**Exception Authority**: holistic-orchestrator (crisis only)  
**Evidence Format**: "// CONSULTED: {agent} - {outcome} - {timestamp}"

### 4. Phase Progression Rules (Sequential)
```
GATE_ENFORCEMENT: D0→D1→D2→D3→B0→B1→B2→B3→B4→B5
FORK_AUTHORITY: Only requirements-steward can authorize non-sequential phases
BACKTRACK_RULES: Return to last valid gate, re-validate progression
EMERGENCY_BYPASS: holistic-orchestrator only (with full justification)
```

**Enforcement**: Phase artifacts must exist before progression  
**Validation**: Git history shows sequential artifact creation  
**Exception Process**: Formal bypass request + stakeholder approval

## What MIP CAN Remove (Accumulative Complexity)

### 1. Process Theater
- Duplicate status updates for same milestone
- Multiple approval requests for identical decisions  
- Re-validating already validated artifacts
- Coordination meetings without outcome impact
- Documentation without implementation relevance

### 2. Redundant Communications
- Status reports that duplicate artifact content
- Multiple notifications for same event
- Cross-posting to multiple channels unnecessarily
- Approval chains longer than RACI requirements

### 3. Validation Theater
- Re-reviewing already approved designs
- Multiple sign-offs for same component
- Redundant testing of unchanged functionality
- Duplicate security scans without code changes

### 4. Administrative Overhead
- Process documentation without outcome impact
- Coordination handoffs that add no value
- Meeting minutes that duplicate artifact content
- Status tracking beyond necessary checkpoints

## Enforcement Mechanism

### 1. Holistic Orchestrator Authority
- **Primary Enforcement**: Constitutional essentials cannot be bypassed
- **MIP Application**: Aggressive removal of accumulative complexity
- **Resource Allocation**: 62% minimum essential, 38% maximum coordination
- **Override Authority**: Emergency situations only (with justification)

### 2. MIP Application Rules
```
KEEP_ESSENTIAL: Phase gates, quality gates, RACI consultations, artifacts
REMOVE_ACCUMULATIVE: Duplicate processes, redundant approvals, theater
VALIDATE_REDUCTION: Essential functionality preserved after optimization
MEASURE_IMPACT: Track resource allocation (62/38 target)
```

### 3. 62/38 Resource Allocation
- **62% Minimum**: Essential work (artifacts, implementation, quality gates)
- **38% Maximum**: Coordination overhead (meetings, updates, handoffs)
- **Measurement**: Time tracking across essential vs coordination activities
- **Enforcement**: Monthly review with stakeholder approval for deviations

### 4. Constitutional Violation Response
```
SEVERITY_1: Missing phase gate artifact → BLOCK progression
SEVERITY_2: Quality gate bypass → ROLLBACK + re-validation  
SEVERITY_3: RACI consultation skipped → CONSULTATION + justification
SEVERITY_4: Phase sequence violation → RETURN to last valid gate
```

## Verification Checklist

### Constitutional Compliance Audit
```
□ Phase Gate Artifacts: All required artifacts exist and current
□ Quality Gates: TDD, review, testing, security protocols active
□ RACI Consultations: Evidence exists for all mandatory consultations
□ Phase Progression: Sequential order maintained, no unauthorized forks
□ Resource Allocation: 62/38 ratio maintained (essential/coordination)
□ Exception Handling: All bypasses properly authorized and documented
```

### MIP Optimization Validation  
```
□ Process Theater: Eliminated duplicate and redundant processes
□ Communication Overhead: Streamlined to essential notifications only
□ Validation Theater: Removed unnecessary re-approvals and duplicate checks
□ Administrative Burden: Process documentation serves implementation outcomes
□ Essential Preservation: Core functionality and quality maintained
□ Stakeholder Approval: Changes reviewed and approved by affected parties
```

### Emergency Override Procedures
```
CRISIS_AUTHORITY: holistic-orchestrator
JUSTIFICATION_REQUIRED: Document reason, impact, recovery plan
TIME_LIMIT: 48 hours maximum before normal process restoration
VALIDATION_REQUIRED: Post-crisis audit of all decisions and bypasses
STAKEHOLDER_NOTIFICATION: All affected parties informed within 6 hours
```

## B1 Phase Directory Context Amendment

**EFFECTIVE**: 2025-09-03  
**AUTHORITY**: System Steward + Workflow Observation  
**VIOLATION_EVIDENCE**: B1 phase continuation in ideation directory

### CORRECTED B1 PHASE STRUCTURE

```
B1_HERMES_COORDINATION::BUILD_EXECUTION_ROADMAP:
  PURPOSE: "Validated architecture→actionable implementation plan"
  
  CRITICAL_AMENDMENT: Directory context violations observed requiring correction
  
  SUBPHASES:
    B1_01[task-decomposer:atomic_tasks+dependencies]::EXECUTE_IN[ideation_directory]
    B1_02[workspace-architect:project_migration_execution]::EXECUTE_IN[ideation_directory]
    
    MIGRATION_GATE::MANDATORY_HUMAN_CHECKPOINT:
      "STOP - Human authorization required"
      "Migration completed to /Volumes/HestAI-Projects/{PROJECT}/build/"
      "Awaiting confirmation to continue in new directory"
    
    B1_03[workspace-architect:build_directory_validation]::EXECUTE_IN[build_directory]
    B1_04[implementation-lead:task_sequencing]::EXECUTE_IN[build_directory]
    B1_05[build-plan-checker:completeness+feasibility]::EXECUTE_IN[build_directory]
  
  DIRECTORY_ENFORCEMENT:
    IDEATION_WORK: "B1_01-B1_02 ONLY in ideation directory"
    MANDATORY_STOP: "NO progression past B1_02 without human confirmation"
    BUILD_WORK: "B1_03-B1_05 ONLY in build directory"
    CLEANUP_RESPONSIBILITY: "workspace-architect owns both-end cleanup"
```

### BUILD COMMAND MODIFICATIONS

The `/build --phase-B1` command MUST:

1. **Execute B1_01 and B1_02** in current (ideation) directory
2. **STOP COMPLETELY** after B1_02 with message:
   ```
   ⚠️ MIGRATION GATE REACHED
   Project migrated to: /Volumes/HestAI-Projects/{PROJECT}/build/
   
   Human authorization required to continue.
   Please:
   1. cd /Volumes/HestAI-Projects/{PROJECT}/build/
   2. Run: /build --phase-B1 --continue
   ```
3. **REFUSE** to execute B1_03-B1_05 unless in build directory
4. **Validate** directory context before each subphase execution

### WORKSPACE-ARCHITECT EXTENDED RESPONSIBILITIES

B1_03 NEW TASK - Build Directory Validation:
- Verify all artifacts properly migrated
- Validate coordination symlinks
- Clean up ideation directory artifacts
- Confirm build directory structure
- Test CI/CD pipeline initialization
- Document migration completeness

### ENFORCEMENT PATTERNS

```
DIRECTORY_VALIDATION:
  CHECK_BEFORE_EXECUTION: "pwd must match expected phase directory"
  BLOCK_WRONG_CONTEXT: "Refuse execution if directory incorrect"
  EVIDENCE_REQUIREMENT: "Log directory context in all artifacts"

MIGRATION_CLEANUP:
  IDEATION_END:
    - "Archive session artifacts"
    - "Preserve graduation assessment"
    - "Update session manifest"
  BUILD_END:
    - "Validate all migrations"
    - "Test coordination links"
    - "Verify artifact accessibility"
```

### RATIONALE

Directory context violations cause:
- Misplaced artifacts
- Invalid task sequencing
- Broken coordination links
- Lost work products
- Confusion in phase progression

This amendment ensures:
- Clear separation of concerns
- Proper artifact placement
- Valid execution context
- Human oversight at critical transitions
- Complete cleanup at both ends

## Integration Points

### With Existing Workflow Documents
- **001-WORKFLOW-NORTH-STAR**: Constitutional essentials support north star objectives
- **003-WORKFLOW-ENFORCEMENT-MATRIX**: Quality gates integrate with enforcement matrix
- **004-WORKFLOW-PROJECT-COORDINATION**: MIP optimization applies to coordination patterns
- **005-WORKFLOW-WORKSPACE-COORDINATION**: Constitutional artifacts part of workspace setup

### With Agent Accountability
- **RACI Matrix**: Constitutional consultations align with agent accountability
- **Specialist Triggers**: Quality gates trigger appropriate specialist consultations  
- **Authority Chain**: Constitutional enforcement follows established authority patterns

### With Quality Systems
- **TDD Protocol**: Constitutional TDD requirement integrates with quality systems
- **Security Gates**: Constitutional security consultations align with security protocols
- **Review Requirements**: Constitutional code review integrates with review systems

---

// HestAI-Doc-Steward: quality assessment complete  
// Value density: 85% | Evidence ratio: 90% | Redundancy: 0%  
// Decision: APPROVED  
// Rationale: Defines critical system integrity boundaries for MIP optimization

// System-Steward: B1 phase amendment added 2025-09-03
// Pattern Recognition: Directory context violations require constitutional enforcement
// Wisdom Preserved: Phase-appropriate execution prevents cascading failures

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-09-02T16:55:23-07:00 -->
<!-- AMENDMENT_AUTHORITY: system-steward 2025-09-03T09:45:00-07:00 -->