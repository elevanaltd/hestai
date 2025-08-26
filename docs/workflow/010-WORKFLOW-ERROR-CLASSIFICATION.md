# Error Classification and Handling

<!-- HESTAI_DOC_STEWARD_BYPASS: Creating Section 1 workflow documentation per authorized system stewardship directive -->

## Overview

Unified error handling approach under single error-architect authority with self-classification, evidence requirements, and escalation procedures.

## Unified Error Architecture

### Single Point of Authority
**Error-Architect Responsibilities:**
- All error classification and resolution decisions
- Self-assessment of complexity and scope
- Resource allocation and escalation determination
- Solution strategy and implementation oversight

**Consolidation Rationale:**
- Eliminates confusion between error-resolver and error-architect roles
- Provides consistent error handling methodology across all project phases
- Reduces coordination overhead and decision conflicts
- Enables comprehensive error pattern recognition and prevention

## Error Classification Matrix

### Quick Fix Errors (≤30 minutes)
**Characteristics:**
- Simple syntax or configuration errors
- Missing imports or dependencies
- Basic API endpoint or parameter issues
- Straightforward documentation corrections

**Self-Classification Criteria:**
- Root cause immediately obvious
- Solution requires single file or configuration change
- No architectural or design changes needed
- Zero risk of breaking existing functionality

**Evidence Requirements:**
- Error log snippet showing exact failure
- Proposed fix with before/after code
- Confirmation of isolated scope impact

**Resolution Process:**
```bash
# Quick identification and fix
1. Identify root cause (max 5 minutes)
2. Implement fix with test validation
3. Verify resolution with minimal testing
4. Document fix for pattern recognition
```

### Complex Errors (30 minutes - 4 hours)
**Characteristics:**
- Multi-component integration issues
- Performance degradation or resource problems
- Logic errors requiring debugging investigation
- Configuration conflicts across environments

**Self-Classification Criteria:**
- Root cause requires investigation or debugging
- Solution involves multiple files or components
- Risk of side effects or regression
- Testing required across integration points

**Evidence Requirements:**
- Detailed error analysis with investigation steps
- Root cause identification with supporting evidence
- Comprehensive fix plan with risk assessment
- Testing strategy covering affected components

**Resolution Process:**
```bash
# Systematic investigation and resolution
1. Error reproduction and analysis (max 30 minutes)
2. Root cause investigation with evidence collection
3. Solution design with risk assessment
4. Implementation with comprehensive testing
5. Validation and monitoring setup
```

### Escalation Errors (>4 hours or high risk)
**Characteristics:**
- Architectural or design flaws requiring major changes
- Security vulnerabilities with system-wide impact
- Performance issues requiring infrastructure changes
- Errors blocking critical business functions

**Self-Classification Criteria:**
- Solution requires architectural changes
- Multiple team coordination needed
- High risk of system instability or data loss
- Business impact or deadline implications

**Evidence Requirements:**
- Comprehensive impact analysis
- Multiple solution approaches with trade-offs
- Resource requirement assessment
- Stakeholder communication plan

**Resolution Process:**
```bash
# Formal escalation and coordination
1. Impact assessment and documentation
2. Stakeholder notification with timeline
3. Solution architecture and approval process
4. Coordinated implementation with validation gates
5. Post-resolution analysis and prevention measures
```

## Self-Classification Process

### Classification Decision Tree
```
Error Encountered
    ├── Root cause obvious? 
    │   ├── Yes → Single file fix?
    │   │   ├── Yes → QUICK FIX
    │   │   └── No → COMPLEX
    │   └── No → Investigation needed?
    │       ├── <30min investigation → COMPLEX  
    │       └── >30min investigation → ESCALATION
```

### Classification Validation
**Quick Fix Validation:**
- "Can I fix this in one commit with confidence?"
- "Is the scope completely isolated?"
- "Are there zero architectural implications?"

**Complex Error Validation:**
- "Do I understand the full scope of impact?"
- "Can I test this thoroughly within 4 hours?"
- "Are the risks manageable and documented?"

**Escalation Validation:**
- "Does this require coordination with other teams?"
- "Could this impact system stability or performance?"
- "Are there business implications or deadline risks?"

## Evidence Requirements by Type

### Quick Fix Evidence
**Minimum Required:**
- Error message and location
- Proposed fix (code diff or configuration change)
- Verification that change is isolated

**Documentation Format:**
```markdown
## Quick Fix: [Brief Description]
**Error:** [Exact error message]
**Location:** [File:Line or component]
**Root Cause:** [One sentence explanation]
**Fix:** [Code change or configuration update]
**Verification:** [How fix was confirmed]
```

### Complex Error Evidence
**Comprehensive Required:**
- Investigation steps and findings
- Root cause analysis with supporting data
- Solution approach with alternatives considered
- Risk assessment and mitigation strategies
- Testing plan and results

**Documentation Format:**
```markdown
## Complex Error Resolution: [Description]
**Error Investigation:**
- Symptoms: [What was observed]
- Investigation: [Steps taken to identify root cause]
- Root Cause: [Detailed explanation with evidence]

**Solution Design:**
- Approach: [Chosen solution with rationale]
- Alternatives: [Other options considered and why rejected]
- Risks: [Potential issues and mitigation strategies]

**Implementation:**
- Changes Made: [Detailed change description]
- Testing: [Testing approach and results]
- Verification: [How resolution was confirmed]
```

### Escalation Error Evidence
**Executive Summary Required:**
- Business impact assessment
- Technical complexity analysis
- Resource requirement breakdown
- Timeline and milestone implications
- Communication and coordination plan

**Documentation Format:**
```markdown
## Escalation Error: [Description]
**Executive Summary:**
- Impact: [Business and technical impact]
- Complexity: [Why this requires escalation]
- Timeline: [Expected resolution timeline]
- Resources: [Teams and skills required]

**Technical Analysis:**
- Root Cause: [Detailed technical analysis]
- Solution Architecture: [High-level approach]
- Risk Assessment: [Comprehensive risk analysis]

**Coordination Plan:**
- Stakeholders: [Who needs to be involved]
- Communication: [Update schedule and channels]
- Validation: [Approval and testing requirements]
```

## Human Escalation Triggers

### Automatic Escalation Conditions
**Business Impact:**
- Production system down or degraded >2 hours
- Data loss or corruption detected
- Security breach or vulnerability exploited
- Customer-facing functionality broken >4 hours

**Technical Complexity:**
- Architectural changes affecting multiple systems
- Performance issues requiring infrastructure scaling
- Integration failures with external systems
- Database schema or migration issues

**Resource Constraints:**
- Solution requires skills outside current team
- Timeline conflicts with project milestones
- Budget implications for infrastructure or tooling
- Coordination with external vendors required

### Escalation Communication Protocol

**Immediate Escalation (Critical Issues):**
```
Subject: CRITICAL: [System] - [Brief Description]
Priority: High
Recipients: [Technical Lead, Product Owner, Stakeholders]

SITUATION: [What is broken/not working]
IMPACT: [Business impact and affected users]
TIMELINE: [Expected resolution timeline]
ACTIONS: [What is being done now]
NEXT UPDATE: [When next communication will be sent]
```

**Standard Escalation (Complex Issues):**
```
Subject: ESCALATION: [System] - [Brief Description] 
Priority: Medium
Recipients: [Technical Lead, Product Owner]

ISSUE: [Technical problem description]
ANALYSIS: [Investigation findings and root cause]
OPTIONS: [Proposed solutions with trade-offs]
RECOMMENDATION: [Preferred approach with rationale]
RESOURCES: [Required team members and timeline]
APPROVAL NEEDED: [What decisions are required]
```

## Error Pattern Recognition

### Pattern Tracking
**Common Error Categories:**
- Configuration management issues
- Dependency version conflicts
- API integration failures
- Performance bottlenecks
- Security configuration problems

**Pattern Analysis:**
- Monthly error classification review
- Root cause frequency analysis
- Prevention opportunity identification
- Tool and process improvement recommendations

### Prevention Strategies
**Proactive Measures:**
- Configuration validation automation
- Dependency management policies
- Integration testing enhancement
- Performance monitoring alerts
- Security scanning automation

**Knowledge Sharing:**
- Error pattern documentation
- Solution template library
- Team training on common issues
- Best practices documentation updates

## Quality Assurance

### Error Resolution Validation
**Quick Fix Verification:**
- Automated test validation
- Code review for non-trivial changes
- Documentation update confirmation

**Complex Error Verification:**
- Comprehensive testing across integration points
- Performance impact assessment
- Security review for security-related fixes
- Stakeholder validation for business impact

### Success Metrics
**Resolution Efficiency:**
- Time to resolution by error type
- First-time fix success rate
- Escalation accuracy (properly classified)
- Recurrence rate for fixed errors

**Quality Indicators:**
- Zero regression errors from fixes
- Complete documentation compliance
- Stakeholder satisfaction with communication
- Pattern recognition and prevention effectiveness

## User Availability Constraint

### Work Stoppage Rules
**User Unavailable Conditions:**
- User has not responded within 24 hours to critical questions
- User explicitly states unavailability for specific period
- User has set out-of-office or unavailable status

**Immediate Actions When User Unavailable:**
1. **Document Current State:** Complete documentation of work in progress, including assumptions made and questions pending
2. **Preserve Work:** Commit all work to version control with detailed commit messages
3. **Update Status:** Update project status and next steps clearly documented
4. **Set Waiting State:** Mark project as "WAITING_USER_INPUT" with resume instructions

**Work Resumption Protocol:**
1. **Context Review:** User reviews documented state and pending questions
2. **Validation Session:** Brief session to confirm direction and resolve questions
3. **Resume Execution:** Continue work based on validated direction
4. **Communication Cadence:** Establish regular check-in schedule to prevent future blocks

### Critical Decision Handling
**When User Input Required:**
- Architectural direction changes
- Feature scope modifications
- Performance vs. complexity trade-offs
- Security vs. usability decisions
- Timeline or priority adjustments

**Emergency Override Conditions:**
- Security vulnerabilities requiring immediate action
- Production system failures affecting users
- Legal or compliance requirements with fixed deadlines

**Override Documentation:**
```markdown
## Emergency Override: [Decision Made]
**Reason:** [Why override was necessary]
**Decision:** [What was decided and implemented]
**Impact:** [Potential consequences and monitoring]
**User Review Required:** [What needs validation when user returns]
```