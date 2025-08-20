// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: sequential-101-102-numbering /docs/guides/-placement agent-governance-scope

# Agent Accountability Matrix

## Overview

This matrix establishes clear ownership and responsibility chains for critical domains in the HestAI workflow, preventing diffusion of responsibility identified in production readiness assessments while maintaining our constraint-catalysis principles.

**Purpose**: Transform agent coordination from ad-hoc consultation to systematic accountability
**Pattern**: Leverages proven Matrix Protocol System approach (REP007 87% efficiency gain)
**Integration**: Enhances TRACED protocol C::CONSULT triggers with domain-specific ownership

## RACI Definitions

- **R (Responsible)**: Agent who performs the work and owns execution
- **A (Accountable)**: Agent with final decision authority and overall accountability  
- **C (Consulted)**: Domain experts who must provide input before decisions
- **I (Informed)**: Agents who need to be kept informed of outcomes

## Critical Domain Matrix

### Core Infrastructure Domains

| Domain | Responsible | Accountable | Consulted | Informed |
|--------|-------------|-------------|-----------|----------|
| **AUTH_DOMAIN** | security-specialist | critical-engineer | requirements-steward | implementation-lead |
| **CRDT_PROVIDER** | technical-architect | critical-engineer | universal-test-engineer | quality-observer |
| **DB_MIGRATIONS** | implementation-lead | critical-engineer | technical-architect | system-steward |
| **SECRETS_MANAGEMENT** | security-specialist | critical-engineer | eav-admin | system-steward |
| **DEPLOYMENT_PIPELINE** | implementation-lead | critical-engineer | solution-steward | eav-admin |

### Quality Assurance Domains

| Domain | Responsible | Accountable | Consulted | Informed |
|--------|-------------|-------------|-----------|----------|
| **TEST_INFRASTRUCTURE** | universal-test-engineer | test-methodology-guardian | critical-engineer | implementation-lead |
| **PERFORMANCE_MONITORING** | quality-observer | critical-engineer | technical-architect | implementation-lead |
| **SECURITY_SCANNING** | security-specialist | critical-engineer | test-methodology-guardian | requirements-steward |
| **COMPLIANCE_VALIDATION** | requirements-steward | critical-engineer | security-specialist | solution-steward |

### Development Workflow Domains

| Domain | Responsible | Accountable | Consulted | Informed |
|--------|-------------|-------------|-----------|----------|
| **ARCHITECTURE_DECISIONS** | technical-architect | critical-engineer | requirements-steward | implementation-lead |
| **CODE_REVIEW_STANDARDS** | code-review-specialist | critical-engineer | test-methodology-guardian | quality-observer |
| **IMPLEMENTATION_VALIDATION** | critical-implementation-validator | critical-engineer | technical-architect | implementation-lead |
| **INTEGRATION_PATTERNS** | implementation-lead | technical-architect | critical-engineer | solution-steward |
| **DOCUMENTATION_STANDARDS** | workspace-architect | solution-steward | system-steward | requirements-steward |

## Decision TTL (Time-To-Live) Enforcement

### Architectural Decisions
- **TTL**: 72 hours from decision to code/CI implementation
- **Trigger**: Decision not encoded → automatic review required
- **Accountable**: critical-engineer
- **Process**: Create ADR + implement enforcement rule within TTL

### Security Decisions  
- **TTL**: 24 hours from identification to enforcement
- **Trigger**: Security gap identified → immediate mitigation required
- **Accountable**: critical-engineer
- **Process**: Implement guard + validation within TTL

### Testing Standards
- **TTL**: Immediate implementation required
- **Trigger**: Test integrity issue → block until resolved
- **Accountable**: test-methodology-guardian
- **Process**: Fix root cause, no workarounds permitted

## Integration with TRACED Protocol

### Enhanced Consultation Triggers

```yaml
CONSULTATION_TRIGGERS_ENHANCED:
  architecture_decisions: 
    responsible: technical-architect
    accountable: critical-engineer
    consulted: [requirements-steward]
    
  code_changes:
    responsible: code-review-specialist  
    accountable: critical-engineer
    consulted: [test-methodology-guardian]
    
  test_issues:
    responsible: universal-test-engineer
    accountable: test-methodology-guardian
    consulted: [critical-engineer]
    
  north_star_conflicts:
    responsible: requirements-steward
    accountable: critical-engineer
    consulted: [solution-steward]
    
  complexity_violations:
    responsible: complexity-guard
    accountable: critical-engineer
    consulted: [technical-architect]
```

### Artifact Receipt Requirements

Each RACI role must provide evidence of execution:

- **Responsible**: Implementation artifacts (code, tests, configs)
- **Accountable**: Decision rationale and approval records
- **Consulted**: Input documentation and expert opinions
- **Informed**: Acknowledgment receipts and status updates

## Escalation Protocols

### Standard Escalation Path
1. **Responsible** → **Accountable** (domain-level resolution)
2. **Accountable** → **critical-engineer** (cross-domain conflicts)  
3. **critical-engineer** → **requirements-steward** (North Star alignment)
4. **requirements-steward** → **User** (fundamental requirements conflicts)

### Emergency Escalation
- **Production Issues**: Direct to critical-engineer + implementation-lead
- **Security Incidents**: Direct to security-specialist + critical-engineer
- **North Star Violations**: Direct to requirements-steward + critical-engineer

## Validation Theater Prevention

### Evidence Requirements by Role

**Responsible Agents**:
- Link to CI job showing successful execution
- Test output demonstrating functionality
- Code review demonstrating quality standards

**Accountable Agents**:
- Decision documentation with rationale
- Approval records with timestamp
- Risk assessment and mitigation plans

**Consulted Agents**:
- Expert opinion documentation
- Technical feasibility assessment
- Integration impact analysis

**Informed Agents**:
- Status acknowledgment records
- Awareness confirmation
- Downstream impact assessment

## Implementation Guidelines

### Phase Integration

**B0 (Validation Gate)**:
- **Accountable**: critical-engineer validates VAD against all domain requirements
- **Consulted**: Domain owners provide feasibility assessment
- **Evidence**: GO/NO-GO decision with rationale from each domain

**B1 (Planning)**:
- **Responsible**: task-decomposer creates implementation breakdown
- **Accountable**: critical-engineer approves task priorities
- **Consulted**: Domain owners validate task feasibility

**B2 (Implementation)**:
- **Responsible**: implementation-lead coordinates domain work
- **Accountable**: Domain owners approve changes in their areas
- **Evidence**: Code review + test evidence for each domain change

**B3 (Integration)**:
- **Responsible**: completion-architect integrates domain components
- **Accountable**: critical-engineer validates system coherence
- **Consulted**: All domain owners validate integration integrity

**B4 (Delivery)**:
- **Responsible**: solution-steward creates handoff documentation
- **Accountable**: critical-engineer approves production readiness
- **Evidence**: Domain-specific operational runbooks

### Known Failures Management

**Ownership Assignment**:
- Every known failure requires a designated **Responsible** agent
- **Accountable** agent must provide expiry date (max 30 days)
- **TTL Enforcement**: CI blocks if expiry passes without resolution

**Tracking Matrix**:
```yaml
known_failures:
  auth_timeout_edge_case:
    responsible: security-specialist
    accountable: critical-engineer
    expiry: 2024-09-15
    ticket: AUTH-142
    
  crdt_sync_race_condition:
    responsible: technical-architect
    accountable: critical-engineer  
    expiry: 2024-09-10
    ticket: CRDT-089
```

## Success Metrics

### Accountability Metrics
- **Response Time**: <2 hours for domain-specific questions
- **Decision Speed**: 95% of decisions within TTL
- **Escalation Rate**: <10% of issues require escalation beyond domain level

### Quality Metrics  
- **Validation Theater**: 0% hollow checkmarks (evidence required)
- **Domain Expertise**: 100% domain changes reviewed by designated experts
- **Integration Drift**: 0% service boundary violations

### Workflow Efficiency
- **Context Switching**: <5 minutes to identify domain owner
- **Decision Clarity**: 100% decisions have clear accountable agent
- **Responsibility Gaps**: 0% critical tasks without assigned ownership

## Conclusion

The Agent Accountability Matrix transforms our multi-agent coordination from consultation-based to ownership-based, ensuring clear responsibility chains while preserving the creative constraint-catalysis that drives our workflow excellence.

**Integration**: Enhances existing TRACED protocol without disruption
**Validation**: Prevents theater through concrete evidence requirements  
**Scalability**: Systematic approach scales with workflow complexity
**Alignment**: Maintains North Star focus through clear accountability

This matrix is the foundation for production-grade multi-agent orchestration that delivers reliable results through systematic responsibility distribution.