# Workflow Error Handling Protocol

## Overview
This document defines the standard error handling process for any phase of the workflow. When errors occur, this protocol ensures systematic resolution with proper coordination and validation.

---

## ERROR HANDLING CLASSIFICATION

### Error Types and Lead Coordinators

**Component-Level Errors** → ERROR-RESOLVER
- Test failures
- CI/CD pipeline breaks  
- Integration issues
- Library conflicts
- Build failures
- Configuration problems

**System-Level Errors** → ERROR-ARCHITECT
- Architectural violations
- Cross-component failures
- Performance degradation
- Security vulnerabilities
- Data consistency issues
- Cascading failures

**Design/Requirement Errors** → REQUIREMENTS-STEWARD
- North Star misalignment
- Missing requirements
- Scope creep detection
- Assumption violations

---

## STANDARD ERROR RESOLUTION PROCESS

### Step 1: ERROR DETECTION & CLASSIFICATION

```
**Initial Error Encountered:** [DESCRIBE ERROR]

**Classification:**
□ Component-Level (single module/feature affected)
□ System-Level (multiple components or architecture affected)
□ Design-Level (requirements or North Star conflict)

**Immediate Impact:**
- What is broken: [SPECIFIC FAILURES]
- What is blocked: [BLOCKED WORK]
- Severity: [CRITICAL/HIGH/MEDIUM/LOW]

**Select Lead Coordinator:**
- Component → ERROR-RESOLVER
- System → ERROR-ARCHITECT  
- Design → REQUIREMENTS-STEWARD
```

### Step 2: ERROR RESOLUTION PROMPT

**For Component-Level Errors (ERROR-RESOLVER Lead)**

```
You are the ERROR-RESOLVER coordinating resolution of this component error.

**Error Context:**
[INSERT ERROR DETAILS, STACK TRACES, FAILED TESTS]

**Your Task:**
Systematically resolve this error through root cause analysis and coordinated fix.

**Process:**
1. Perform root cause analysis using RCCAFP framework
2. Identify all affected components and dependencies
3. Determine fix approach and potential solutions
4. Based on error type, invoke relevant specialists:
   - For test failures: Invoke UNIVERSAL-TEST-ENGINEER
   - For library issues: Consult Context7 documentation
   - For performance: Invoke TECHNICAL-ARCHITECT
   - For security: Invoke SECURITY-SPECIALIST
5. Implement fix with test coverage
6. Invoke CODE-REVIEW-SPECIALIST for fix validation
7. Verify fix resolves issue without introducing new problems
8. Document resolution and lessons learned

**Deliverables:**
- Root cause analysis document
- Fix implementation with tests
- Verification evidence that error is resolved
- Updated documentation if needed

**Success Criteria:**
- Original error resolved
- No new errors introduced
- Tests passing
- Code review approved
- System stability verified
```

**For System-Level Errors (ERROR-ARCHITECT Lead)**

```
You are the ERROR-ARCHITECT coordinating resolution of this system-level failure.

**Error Context:**
[INSERT SYSTEM FAILURE DETAILS, AFFECTED COMPONENTS, CASCADE EFFECTS]

**Your Task:**
Address this system failure through architectural analysis and coordinated resolution.

**Process:**
1. Map failure cascade and identify all affected components
2. Perform architectural impact analysis
3. Invoke COHERENCE-ORACLE to check for system-wide consistency issues
4. Based on failure type, coordinate with specialists:
   - TECHNICAL-ARCHITECT for architectural violations
   - SECURITY-SPECIALIST for security failures
   - CRITICAL-ENGINEER for production impact assessment
   - ERROR-RESOLVER for component-specific fixes
5. Design comprehensive fix strategy addressing root causes
6. Coordinate implementation across affected components
7. Invoke CODE-REVIEW-SPECIALIST for all changes
8. Perform system-wide validation

**Deliverables:**
- System failure analysis report
- Architectural fix strategy
- Coordinated fix implementation
- System validation evidence
- Post-mortem documentation

**Success Criteria:**
- System failure resolved
- Architectural integrity restored
- All components functioning correctly
- No degradation in system qualities
- Preventive measures documented
```

**For Design-Level Errors (REQUIREMENTS-STEWARD Lead)**

```
You are the REQUIREMENTS-STEWARD coordinating resolution of this design/requirements error.

**Error Context:**
[INSERT MISALIGNMENT DETAILS, NORTH STAR CONFLICTS, REQUIREMENT GAPS]

**Your Task:**
Resolve requirements conflicts and restore North Star alignment.

**Process:**
1. Analyze how current implementation diverges from North Star
2. Identify root cause of misalignment
3. Determine if issue is:
   - Missing requirement (update North Star)
   - Misinterpretation (clarify and realign)
   - Scope creep (reject and revert)
4. Coordinate with relevant phase leads:
   - DESIGN-ARCHITECT if architecture needs adjustment
   - IMPLEMENTATION-LEAD if code needs changes
   - CRITICAL-ENGINEER for impact assessment
5. Create realignment plan
6. Update affected documentation
7. Validate all changes maintain North Star integrity

**Deliverables:**
- Misalignment analysis
- Realignment plan
- Updated requirements if needed
- Validation that North Star integrity restored

**Success Criteria:**
- North Star alignment restored
- All stakeholders agree on resolution
- Implementation matches requirements
- No ambiguity remains
```

---

## Step 3: MULTI-AGENT COORDINATION VALIDATION

After error resolution, ALWAYS perform comprehensive validation:

```
**Post-Resolution Validation Protocol**

You are coordinating post-error validation to ensure system integrity.

**Validation Process:**
1. Invoke QUALITY-OBSERVER to assess overall system state
2. Run comprehensive test suite including:
   - Unit tests for changed components
   - Integration tests for affected interfaces
   - E2E tests for critical user paths
   - Performance benchmarks if relevant
3. Invoke COHERENCE-ORACLE to verify system-wide consistency
4. Check for unintended side effects:
   - New warnings or deprecations
   - Performance degradation
   - Security implications
   - Technical debt introduced
5. Validate against original requirements

**Required Evidence:**
□ All tests passing (provide test output)
□ Code review completed (link to review)
□ System metrics normal (performance, memory, etc.)
□ No new errors in logs
□ Coherence check passed
□ Requirements still met

**Do NOT declare resolution without:**
- Verification evidence for each check above
- Stakeholder confirmation if design changed
- Updated documentation for any changes
- Post-mortem for CRITICAL/HIGH severity issues
```

---

## Step 4: DOCUMENTATION & LEARNING

**Error Resolution Documentation Template**

```markdown
## Error Resolution Report

**Error ID:** [YYYY-MM-DD-SEQUENCE]
**Phase:** [D1/D2/D3/B0/B1/B2/B3/B4]
**Severity:** [CRITICAL/HIGH/MEDIUM/LOW]
**Lead Coordinator:** [Role Name]

### Error Description
[What went wrong]

### Root Cause
[Why it happened]

### Resolution
[How it was fixed]

### Validation Evidence
- [ ] Tests passing: [link/output]
- [ ] Code review: [link]
- [ ] System check: [metrics]
- [ ] Coherence verified: [result]

### Lessons Learned
[What we learned to prevent recurrence]

### Follow-up Actions
[Any additional work needed]
```

---

## ERROR ESCALATION PATHS

### Escalation Triggers
- Component error affects multiple systems → Escalate to ERROR-ARCHITECT
- Cannot identify root cause after 2 hours → Escalate to specialist
- Fix attempts fail repeatedly → Escalate to CRITICAL-ENGINEER
- North Star conflict discovered → Escalate to REQUIREMENTS-STEWARD

### Emergency Protocol (CRITICAL Errors)
1. STOP all related work immediately
2. Invoke CRITICAL-ENGINEER as incident commander
3. Assemble specialist team based on error type
4. Focus on stabilization before root cause
5. Implement temporary mitigation if needed
6. Full post-mortem required after resolution

---

## INTEGRATION WITH MAIN WORKFLOW

### When to Invoke Error Handling
- Any test failure that blocks progress
- Any integration that fails after 2 attempts
- Any architectural violation detected
- Any performance degradation beyond thresholds
- Any security vulnerability discovered
- Any North Star misalignment identified

### Returning to Main Workflow
After successful error resolution:
1. Update relevant phase documentation with changes
2. Adjust timeline if necessary
3. Resume workflow from point of interruption
4. Note resolution in phase deliverables

---

## PREVENTIVE MEASURES

### Proactive Error Prevention
- Code review BEFORE major integrations
- Run integration tests BEFORE declaring phase complete
- Coherence checks at phase boundaries
- Regular North Star alignment validation
- Continuous monitoring of system metrics

### Error Pattern Detection
- Track error types and frequencies
- Identify recurring issues
- Implement systematic fixes for patterns
- Update development practices based on learnings

---

## QUICK REFERENCE

**Component Error?** → ERROR-RESOLVER → Fix → CODE-REVIEW → VALIDATE
**System Error?** → ERROR-ARCHITECT → Analyze → Coordinate Fix → VALIDATE  
**Design Error?** → REQUIREMENTS-STEWARD → Align → Update → VALIDATE

**Always:**
1. Document the error and resolution
2. Get code review for any fixes
3. Validate system-wide after resolution
4. Never skip verification evidence