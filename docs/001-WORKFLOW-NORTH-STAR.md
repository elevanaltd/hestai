# Workflow North Star

## RACI Framework

- **R (Responsible)**: Agent who performs the work and owns execution
- **A (Accountable)**: Agent with final decision authority and overall accountability
- **C (Consulted)**: Domain experts who must provide input before decisions
- **I (Informed)**: Agents who need to be kept informed of outcomes

## Workflow Phases

### D1: UNDERSTANDING → NORTH STAR ESTABLISHMENT
Clarify problem and requirements to establish the immutable North Star foundation.

**Sub-Phases & Specialists:**
- **D1_01: IDEA_CLARIFIER** - Flesh out idea to understand exactly what user wants
- **D1_02: RESEARCH_ANALYST** - Research possibilities and explore options  
- **D1_03: IDEA_CLARIFIER** - Finalize findings into immutable North Star document
- **D1_04: REQUIREMENTS_STEWARD** - Review conversation and validate against user intent, flag assumptions

**RACI:**
- **R**: idea-clarifier (D1_01, D1_03), research-analyst (D1_02), requirements-steward (D1_04)
- **A**: critical-engineer (final approval that North Star is complete/correct)
- **C**: *(none needed - we're not building yet)*
- **I**: *(none needed - no implementation teams involved)*

**Key Deliverable:** `2xx-PROJECT[-{NAME}]-NORTH-STAR.md` - Immutable requirements with assumption audit highlighting where interpretations were made

### D2: IDEATION → SOLUTION APPROACHES
Generate and refine creative solutions within North Star boundaries.

**Sub-Phases & Specialists:**
- **D2_01: IDEATOR** - Generate creative solutions that enhance North Star fulfillment
- **D2_02: VALIDATOR** - Apply constraints and test feasibility against real-world limits
- **D2_03: SYNTHESIZER** - Merge validated ideas into coherent, unified design approach

**RACI:**
- **R**: ideator (D2_01), validator (D2_02), synthesizer (D2_03)
- **A**: critical-engineer (validates synthesis completeness and feasibility)
- **C**: requirements-steward (North Star alignment), technical-architect (technical feasibility)
- **I**: *(none needed - still in design phase)*

**Key Deliverable:** `2xx-PROJECT[-{NAME}]-D2-DESIGN.md` - Unified design approach with clear rationale and assumption audit

**Sign-off Required:** D2_01 (ideator) and D2_02 (validator) must approve D2_03 synthesis before D3 phase begins

### D3: ARCHITECTURE → TECHNICAL BLUEPRINT
Transform design approach into comprehensive, buildable architecture specification with visual validation.

**Sub-Phases & Specialists:**
- **D3_01: DESIGN_ARCHITECT** - Create detailed technical architecture from validated design approach
- **D3_02: VISUAL_ARCHITECT** - Create visual mockups/prototypes and validate with user
- **D3_03: TECHNICAL_ARCHITECT** - Validate architectural decisions and ensure scalability/maintainability
- **D3_04: SECURITY_SPECIALIST** - Review architecture for security considerations and compliance requirements

**Visual Validation Process (D3_02):**
- Visual-architect creates mockups based on D3_01 technical architecture
- Presents to user for validation
- If user requests significant changes:
  - **Consults DESIGN-ARCHITECT** for technical architecture updates
  - **Consults REQUIREMENTS-STEWARD** for potential North Star updates
  - Coordinates changes before proceeding
- Iterates until visual approval obtained

**RACI:**
- **R**: design-architect (D3_01), visual-architect (D3_02), technical-architect (D3_03), security-specialist (D3_04)
- **A**: critical-engineer (validates architecture completeness and production readiness)
- **C**: requirements-steward (North Star alignment), design-architect (consulted by visual-architect for changes)
- **I**: implementation-lead (for build preparation)

**Key Deliverables:** 
- `2xx-PROJECT[-{NAME}]-D3-BLUEPRINT.md` - Complete architectural specification ready for B0 validation
- `2xx-PROJECT[-{NAME}]-D3-MOCKUPS.md` - Visual mockups with user validation notes
- `2xx-PROJECT[-{NAME}]-D3-VISUAL-DECISIONS.md` - UI/UX decisions and rationale

**Dependencies:** Requires approved D2 design approach and North Star alignment validation

### B0: VALIDATION GATE
Critical design validation against requirements with GO/NO-GO decision for build phase entry.

**Purpose:** Comprehensive validation that D1-D3 deliverables form a coherent, buildable, and aligned solution ready for implementation.

**Sub-Phases & Specialists:**
- **B0_01: CRITICAL-DESIGN-VALIDATOR** - Validate architectural completeness and identify failure modes
- **B0_02: REQUIREMENTS-STEWARD** - Confirm end-to-end North Star → Design → Blueprint alignment 
- **B0_03: TECHNICAL-ARCHITECT** - Final technical feasibility and scalability validation
- **B0_04: CRITICAL-ENGINEER** - Integrate all validations into GO/NO-GO decision

**RACI:**
- **R**: critical-design-validator (B0_01), requirements-steward (B0_02), technical-architect (B0_03), critical-engineer (B0_04)
- **A**: critical-engineer (final GO/NO-GO authority)
- **C**: security-specialist (security validation), error-architect (failure mode analysis)
- **I**: implementation-lead, solution-steward, task-decomposer

**Entry Requirements:**
- `2xx-PROJECT[-{NAME}]-NORTH-STAR.md` (approved and immutable)
- `2xx-PROJECT[-{NAME}]-D2-DESIGN.md` (validated design approach)  
- `2xx-PROJECT[-{NAME}]-D3-BLUEPRINT.md` (complete architectural specification)
- All assumption audits completed and user-validated

**Key Deliverable:** `2xx-PROJECT[-{NAME}]-B0-VALIDATION.md` - Comprehensive validation report with GO/NO-GO decision and any required design iterations

**Validation Criteria:**
- North Star alignment maintained through all design phases
- Technical architecture is sound, scalable, and implementable
- Security considerations addressed and approved
- All critical assumptions documented and validated
- Resource requirements realistic and available
- No blocking technical or business risks identified

**Exit Conditions:**
- **GO**: All validations pass → proceed to B1 Planning
- **NO-GO**: Critical issues identified → return to appropriate D-phase for iteration

### B1: PLANNING → BUILD EXECUTION ROADMAP
Task decomposition, sequencing, and build plan creation.

**Purpose:** Transform validated architecture into actionable implementation plan with clear task sequencing, dependencies, and resource allocation.

**Sub-Phases & Specialists:**
- **B1_01: TASK-DECOMPOSER** - Break down architecture into atomic, implementable tasks with dependencies
- **B1_02: WORKSPACE-ARCHITECT** - Set up project structure, environments, and tooling requirements
- **B1_03: IMPLEMENTATION-LEAD** - Review and refine task sequencing for optimal development flow
- **B1_04: BUILD-PLAN-CHECKER** - Validate completeness and feasibility of build plan

**RACI:**
- **R**: task-decomposer (B1_01), workspace-architect (B1_02), implementation-lead (B1_03), build-plan-checker (B1_04)
- **A**: critical-engineer (approves final build plan)
- **C**: technical-architect (technical guidance), requirements-steward (scope validation)
- **I**: solution-steward, code-review-specialist, universal-test-engineer

**Entry Requirements:**
- GO decision from B0 validation
- `2xx-PROJECT[-{NAME}]-B0-VALIDATION.md` (approved)
- All design documentation complete and validated

**Key Deliverables:**
- `2xx-PROJECT[-{NAME}]-B1-BUILD-PLAN.md` - Detailed task breakdown with sequencing
- `2xx-PROJECT[-{NAME}]-B1-WORKSPACE.md` - Environment and tooling setup documentation  
- `2xx-PROJECT[-{NAME}]-B1-DEPENDENCIES.md` - Dependency map and critical path analysis
- TRACED protocol execution artifacts

**Planning Criteria:**
- All architectural components have corresponding tasks
- Dependencies clearly mapped and sequenced
- Test requirements identified for each component
- Resource requirements and allocations defined
- Risk mitigation strategies documented
- Timeline realistic with buffer for unknowns

**Exit Conditions:**
- Build plan approved by critical-engineer
- Workspace and environments configured
- Team assignments and responsibilities clear
- Ready to begin B2 implementation

### B2: IMPLEMENTATION → CODE CONSTRUCTION
Core development with test-first practices and quality gates.

**Purpose:** Execute build plan through disciplined development with continuous quality validation and architectural compliance.

**Sub-Phases & Specialists:**
- **B2_00: TESTGUARD/TEST-METHODOLOGY-GUARDIAN** - Establish test strategy, methodology, and compliance framework
- **B2_01: IMPLEMENTATION-LEAD/TECHNICAL-ARCHITECT** - Coordinate development, manage task flow, ensure quality standards
- **B2_02: UNIVERSAL-TEST-ENGINEER** - Create comprehensive test suites within approved methodology
- **B2_03: CODE-REVIEW-SPECIALIST** - Review all code changes for quality, security, and standards
- **B2_04: ERROR-RESOLVER** - Address integration issues, CI failures, and blocking problems

**RACI:**
- **R**: testguard/test-methodology-guardian (B2_00), implementation-lead/technical-architect (B2_01), universal-test-engineer (B2_02), code-review-specialist (B2_03), error-resolver (B2_04)
- **A**: critical-engineer (maintains production standards)
- **C**: technical-architect (architecture compliance), Context7 (library usage), testguard/test-methodology-guardian (ongoing methodology compliance)
- **I**: solution-steward, completion-architect, security-specialist

**Entry Requirements:**
- Approved B1 build plan and workspace
- Development environments configured
- Test frameworks and CI/CD pipeline ready
- Team onboarded with clear task assignments

**B2_00 Test Methodology Requirements:**
- Establish test strategy aligned with project requirements
- Define coverage requirements and testing patterns
- Set up methodology compliance validation
- Approve testing frameworks and approaches
- Create test integrity monitoring procedures

**Key Deliverables:**
- `2xx-PROJECT[-{NAME}]-B2-IMPLEMENTATION-LOG.md` - Development progress and decision record
- `2xx-PROJECT[-{NAME}]-B2-TEST-STRATEGY.md` - Test methodology and compliance framework
- Source code with comprehensive test coverage
- CI/CD pipeline with all quality gates passing
- Code review evidence and architectural compliance documentation
- TRACED protocol compliance artifacts

**Implementation Standards:**
- TEST METHODOLOGY FIRST: testguard consultation before any test creation
- TEST FIRST: No code without failing test (within approved methodology)
- TRACED METHODOLOGY: Follow T-R-A-C-E-D protocol (Test→Review→Analyze→Consult→Execute→Document)
- Context7 consultation for all library usage
- Code review for every change
- Continuous integration with immediate failure resolution
- Continuous methodology compliance validation
- Architecture compliance validation
- Security scanning and vulnerability assessment

**Quality Gates:**
- Test coverage minimum 80%
- All tests passing in CI
- Code review approval required
- No critical security vulnerabilities
- Performance benchmarks met
- Documentation updated with code

**Exit Conditions:**
- All planned features implemented
- Quality gates passing consistently
- Technical debt documented and manageable
- Ready for B3 integration

### B3: INTEGRATION → SYSTEM UNIFICATION
Component integration, system testing, and validation.

**Purpose:** Unify all components into cohesive system, validate end-to-end functionality, and ensure production readiness.

**Sub-Phases & Specialists:**
- **B3_01: COMPLETION-ARCHITECT** - Orchestrate component integration and system coherence
- **B3_02: UNIVERSAL-TEST-ENGINEER** - Execute integration, E2E, and performance testing (with testguard/test-methodology-guardian guidance for complex test scenarios)
- **B3_03: SECURITY-SPECIALIST** - Conduct security audit and penetration testing
- **B3_04: COHERENCE-ORACLE** - Validate cross-system consistency and architectural alignment

**RACI:**
- **R**: completion-architect (B3_01), universal-test-engineer (B3_02), security-specialist (B3_03), coherence-oracle (B3_04)
- **A**: critical-engineer (production readiness authority)
- **C**: technical-architect (system architecture), error-architect (failure mode analysis), requirements-steward (requirement fulfillment), testguard/test-methodology-guardian (integration test methodology)
- **I**: implementation-lead, solution-steward, system-steward

**Entry Requirements:**
- All B2 components complete and tested individually
- Integration environment available
- Performance testing infrastructure ready
- Security testing tools configured

**Key Deliverables:**
- `2xx-PROJECT[-{NAME}]-B3-INTEGRATION-REPORT.md` - System integration validation results
- `2xx-PROJECT[-{NAME}]-B3-PERFORMANCE.md` - Performance testing results and optimization record
- `2xx-PROJECT[-{NAME}]-B3-SECURITY.md` - Security audit findings and remediation
- Fully integrated system passing all E2E tests

**Integration Validation:**
- Component interface compatibility verified
- Data flow and state management validated
- Error handling and recovery tested
- Performance under load confirmed
- Security vulnerabilities addressed
- Cross-browser/platform compatibility verified

**System Testing Requirements:**
- Integration tests covering all component interactions
- End-to-end user journey validation
- Performance benchmarks achieved
- Security penetration testing passed
- Disaster recovery procedures validated
- Monitoring and observability confirmed

**Exit Conditions:**
- System fully integrated and stable
- All testing phases passed
- Performance SLAs met
- Security sign-off obtained
- Ready for B4 delivery preparation

### B4: DELIVERY → PRODUCTION HANDOFF
Production preparation, documentation, and operational readiness.

**Purpose:** Prepare complete solution for production deployment with comprehensive documentation, operational procedures, and stakeholder handoff.

**Sub-Phases & Specialists:**
- **B4_01: SOLUTION-STEWARD** - Package solution, create user documentation, prepare handoff materials
- **B4_02: SYSTEM-STEWARD** - Document system architecture, operational procedures, and maintenance guides
- **B4_03: SECURITY-SPECIALIST** - Final security review and production hardening
- **B4_04: CRITICAL-ENGINEER** - Final production readiness validation and sign-off

**RACI:**
- **R**: solution-steward (B4_01), system-steward (B4_02), security-specialist (B4_03), critical-engineer (B4_04)
- **A**: critical-engineer (production release authority)
- **C**: technical-architect (architecture documentation), implementation-lead (knowledge transfer)
- **I**: workspace-architect, completion-architect, requirements-steward

**Entry Requirements:**
- B3 integration complete and stable
- All testing phases passed
- Performance and security validated
- Production infrastructure ready

**Key Deliverables:**
- `2xx-PROJECT[-{NAME}]-B4-HANDOFF.md` - Complete handoff documentation
- `2xx-PROJECT[-{NAME}]-B4-OPERATIONS.md` - Operational runbooks and procedures
- `2xx-PROJECT[-{NAME}]-B4-USER-GUIDE.md` - End-user documentation
- `2xx-PROJECT[-{NAME}]-B4-MAINTENANCE.md` - Maintenance and troubleshooting guide
- Deployment packages and configuration
- Training materials and knowledge transfer sessions

**Delivery Requirements:**
- Complete documentation suite
- Operational runbooks with common scenarios
- Monitoring and alerting configuration
- Backup and recovery procedures
- Security compliance documentation
- Performance baselines and SLAs
- Support escalation procedures
- Knowledge transfer completed

**Production Readiness Checklist:**
- Infrastructure provisioned and tested
- Deployment procedures validated
- Rollback procedures tested
- Monitoring and alerting active
- Security scanning completed
- Load testing passed
- Documentation reviewed and approved
- Support team trained

**Exit Conditions:**
- Solution deployed to production or ready for deployment
- All documentation delivered and approved
- Knowledge transfer completed
- Support procedures in place
- Stakeholder sign-off obtained
- Project successfully delivered