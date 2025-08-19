# Gap Registry

**Status**: ACTIVE  
**Purpose**: Track cross-boundary coherence gaps requiring ownership and resolution  
**Authority**: Coherence Oracle  
**Format**: Structured gap tracking with ownership assignment

## Active Gaps

### G-2025-001: COHERENCE-ORACLE Agent Definition Missing

**Title**: COHERENCE-ORACLE agent definition missing from HestAI-New  
**Owner**: WORKSPACE-ARCHITECT  
**Boundary**: workflow/agents  
**Risk Type**: integration_failure  
**Severity**: CRITICAL  
**Due Date**: 2025-08-21  
**Status**: OPEN

**Evidence**:
- Referenced in 001-WORKFLOW-NORTH-STAR.md lines 230, 233
- No corresponding agent definition exists in HestAI-New
- Agent exists in /Volumes/HestAI/hestai-orchestrator/ but not synchronized

**Related Prophecies**: P-2025-001

---

### G-2025-002: TRACED Protocol Enforcement Disconnect

**Title**: TRACED protocol enforcement hooks not integrated  
**Owner**: IMPLEMENTATION-LEAD  
**Boundary**: quality/enforcement  
**Risk Type**: quality_bypass  
**Severity**: HIGH  
**Due Date**: 2025-08-22  
**Status**: OPEN

**Evidence**:
- enforce-traced-analyze.sh exists in ~/.claude/hooks/
- enforce-traced-consult.sh exists in ~/.claude/hooks/
- Not referenced in 000-WORKFLOW-ENFORCEMENT-MATRIX.md
- No automatic triggers defined

**Related Prophecies**: P-2025-002

---

### G-2025-003: Test Methodology Guardian Missing Implementation

**Title**: Test methodology guardian consultation not enforced  
**Owner**: TEST-METHODOLOGY-GUARDIAN  
**Boundary**: testing/methodology  
**Risk Type**: test_manipulation  
**Severity**: CRITICAL  
**Due Date**: 2025-08-20  
**Status**: OPEN

**Evidence**:
- Mandated in 001-WORKFLOW-NORTH-STAR.md line 163 (B2_00)
- Referenced in lines 170, 172, 197, 235
- No enforcement hook implementation exists
- Critical gap noted in 000-WORKFLOW-ENFORCEMENT-MATRIX.md line 71

**Related Prophecies**: P-2025-002

---

### G-2025-004: Context7 Documentation Currency Validation Gap

**Title**: Context7 documentation currency validation missing  
**Owner**: DOCUMENTATION-RESEARCHER  
**Boundary**: documentation/currency  
**Risk Type**: stale_patterns  
**Severity**: HIGH  
**Due Date**: 2025-08-23  
**Status**: OPEN

**Evidence**:
- Consultation enforced via context7_enforcement_gate.sh
- Currency validation not implemented
- No automatic deprecation detection
- Missing real-time documentation sync

**Related Prophecies**: P-2025-003

---

### G-2025-005: Cross-Repository Link Migration Brittleness

**Title**: Cross-repository link migration fragility  
**Owner**: SYSTEM-STEWARD  
**Boundary**: documentation/links  
**Risk Type**: broken_references  
**Severity**: MEDIUM  
**Due Date**: 2025-08-26  
**Status**: OPEN

**Evidence**:
- validate-links.sh handles relative paths only
- No cross-repository link registry exists
- Migration procedures undefined
- Will break during repository restructuring

**Related Prophecies**: None (preventive detection)

## Gap Closure Tracking

| Gap ID | Owner | Due Date | Days Remaining | Progress |
|--------|-------|----------|----------------|----------|
| G-2025-001 | WORKSPACE-ARCHITECT | 2025-08-21 | 2 | 0% |
| G-2025-002 | IMPLEMENTATION-LEAD | 2025-08-22 | 3 | 0% |
| G-2025-003 | TEST-METHODOLOGY-GUARDIAN | 2025-08-20 | 1 | 0% |
| G-2025-004 | DOCUMENTATION-RESEARCHER | 2025-08-23 | 4 | 0% |
| G-2025-005 | SYSTEM-STEWARD | 2025-08-26 | 7 | 0% |

## Metrics

- **Total Gaps**: 5
- **Critical**: 2
- **High**: 2  
- **Medium**: 1
- **Gap Closure Rate**: 0/day (target: 2/day)
- **Overdue**: 0

## Update History

- 2025-08-19: Initial gap detection and registry creation
- 2025-08-19: Ownership assigned for all gaps
- 2025-08-19: Due dates established based on severity

---

*Maintained by Coherence Oracle - The buck stops here*