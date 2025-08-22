# Workflow North Star

## RACI Framework

- **R (Responsible)**: Agent who performs the work and owns execution
- **A (Accountable)**: Agent with final decision authority and overall accountability
- **C (Consulted)**: Domain experts who must provide input before decisions
- **I (Informed)**: Agents who need to be kept informed of outcomes

## Pre-D1: Ideation Stage Entry

**Purpose:** Establish structured ideation foundation before formal workflow entry, following the ideation→graduation→execution pattern defined in Document 007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md.

**Ideation Process:** All projects begin in the central ideation container (`/Volumes/HestAI-Projects/0-ideation/sessions/`) with session-based coordination and thread-based messaging before graduation to formal project structure.

**Ideation Requirements:**
- Session established in `0-ideation/sessions/YYYY-MM-DD-TOPIC_NAME/`
- Thread-based messaging (A01-SHAUNOS, A02-ROLE_NAME pattern)
- Manifest tracking with schema v1.1
- Initial context development and exploration
- Viability assessment for potential graduation

**Graduation Criteria:** Session demonstrates sufficient value and viability to warrant formal project structure and workflow execution.

## Scope Gate Entry Requirement

**Purpose:** Calibrate workflow execution and deliverable expectations based on actual system complexity to prevent validation theater and ensure proportional effort allocation.

**Entry Process:** Following successful ideation and project graduation (Document 007), formal D1 phase entry requires scope classification to set appropriate output expectations throughout all workflow phases.

**Scope Classification Triggers:**
- System component count and interdependencies
- User base size and usage patterns  
- Data sensitivity and compliance requirements
- Integration complexity and external dependencies
- Business criticality and risk tolerance
- Technical complexity and architectural requirements

**Scope Determination Authority:** 
- **R**: idea-clarifier (initial assessment)
- **A**: critical-engineer (final scope validation)
- **C**: requirements-steward (alignment validation)

**Dispute Resolution:** In cases where the responsible and accountable parties cannot reach consensus on scope classification, escalation proceeds to the Architecture Review Board or designated technical lead for final determination.

## Output Calibration Matrix

**Guiding Principle:** This matrix provides the standard baseline for deliverables. The accountable critical-engineer may adjust requirements with documented rationale to suit unique project contexts while maintaining appropriate rigor levels.

### SIMPLE Scope
**Characteristics:** Single component, <100 users, low business risk, minimal integrations
**Deliverable Format:** 
- Consolidated documents (combine D2+D3 into single design-blueprint)
- Bullet-point specifications sufficient
- Informal review processes acceptable
- Essential testing only (unit + basic integration)

### STANDARD Scope  
**Characteristics:** 2-5 components, 100-10K users, moderate business impact, standard integrations
**Deliverable Format:**
- Standard document set as specified in workflow phases
- Structured documentation with rationale sections
- Formal review gates maintained
- Comprehensive testing (unit + integration + basic E2E)

### COMPLEX Scope
**Characteristics:** 5+ components, 10K+ users, high business impact, complex integrations, regulatory requirements  
**Deliverable Format:**
- Enhanced documentation with detailed technical appendices
- Architecture decision records (ADRs) for all major decisions
- Extended security and compliance documentation
- Comprehensive testing including performance and security validation
- Additional stakeholder review cycles

### ENTERPRISE Scope
**Characteristics:** System-of-systems, >100K users, mission-critical, complex regulatory/compliance, extensive integrations
**Deliverable Format:**
- Full documentation suite with detailed technical specifications
- Formal architecture review boards and sign-offs
- Comprehensive security audit and penetration testing
- Full compliance documentation and audit trails
- Extended validation phases with formal gate reviews
- Risk assessment and mitigation planning
- Formalized operational runbooks and support hand-off criteria

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

**Artifact Location:** Post-graduation distribution per Document 007: D-phase artifacts stored in `@coordination/docs/workflow/`

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

**Artifact Location:** Post-graduation distribution per Document 007: D-phase artifacts stored in `@coordination/docs/workflow/`

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

**Artifact Location:** Post-graduation distribution per Document 007: D-phase artifacts stored in `@coordination/docs/workflow/`

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

**Artifact Location:** Per Document 007: B-phase artifacts stored in `@build/reports/`

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
- **B1_02: WORKSPACE-ARCHITECT** - Execute project graduation process from ideation, establish formal project structure, set up environments and tooling requirements per Document 007 coordination pattern
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
- `2xx-PROJECT[-{NAME}]-B1-WORKSPACE.md` - Environment and tooling setup documentation (includes project graduation execution per Document 007)
- `2xx-PROJECT[-{NAME}]-B1-DEPENDENCIES.md` - Dependency map and critical path analysis
- TRACED protocol execution artifacts

**Artifact Location:** Per Document 007: B-phase artifacts stored in `@build/reports/`

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

**Artifact Location:** Per Document 007: B-phase artifacts stored in `@build/reports/`

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

**Artifact Location:** Per Document 007: B-phase artifacts stored in `@build/reports/`

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
- **B4_03: WORKSPACE-ARCHITECT** - Clean up project structure, organize artifacts for publication readiness
- **B4_04: SECURITY-SPECIALIST** - Final security review and production hardening
- **B4_05: CRITICAL-ENGINEER** - Final production readiness validation and sign-off

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-21T19:47:00Z - Added B4_03 workspace-architect phase for publication readiness -->

**RACI:**
- **R**: solution-steward (B4_01), system-steward (B4_02), workspace-architect (B4_03), security-specialist (B4_04), critical-engineer (B4_05)
- **A**: critical-engineer (production release authority)
- **C**: technical-architect (architecture documentation), implementation-lead (knowledge transfer)
- **I**: completion-architect, requirements-steward

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
- `2xx-PROJECT[-{NAME}]-B4-WORKSPACE.md` - Publication-ready project structure and organization
- Deployment packages and configuration
- Training materials and knowledge transfer sessions

**Artifact Location:** Per Document 007: B-phase artifacts stored in `@build/reports/`

**Delivery Requirements:**
- Complete documentation suite
- Operational runbooks with common scenarios
- Monitoring and alerting configuration
- Backup and recovery procedures
- Security compliance documentation
- Performance baselines and SLAs
- Support escalation procedures
- Knowledge transfer completed
- Project structure cleaned and publication-ready

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

<!-- HESTAI_DOC_STEWARD_BYPASS: Adding B5 enhancement phase to workflow methodology per system-steward analysis of SmartSuite project evolution requirements from data operations to solution management capabilities -->

## B5: ENHANCEMENT → POST-DELIVERY EVOLUTION
**Purpose:** Handle feature expansion and architectural enhancement of delivered systems without requiring full D1→B4 cycle restart.

**Enhancement Trigger Conditions:**
- Core system delivered (B4 complete) and stable in production
- New feature requirements that build on existing architecture
- Performance optimization or scalability improvements
- Integration with new systems or APIs
- User experience enhancements

**Enhancement vs Sub-Project Decision Matrix:**
- **B5 Enhancement:** Extends existing architecture without fundamental changes
- **New D1→B4 Cycle:** Requires architectural pivot or separate system creation

**Sub-Phases & Specialists:**
- **B5_01: REQUIREMENTS-STEWARD** - Analyze enhancement requirements and validate against existing North Star
- **B5_02: TECHNICAL-ARCHITECT** - Assess architectural impact and integration approach
- **B5_03: IMPLEMENTATION-LEAD** - Execute enhancement with existing quality standards
- **B5_04: CRITICAL-ENGINEER** - Validate enhancement integration and stability

**RACI:**
- **R**: requirements-steward (B5_01), technical-architect (B5_02), implementation-lead (B5_03), critical-engineer (B5_04)
- **A**: critical-engineer (enhancement approval authority)
- **C**: original-project-agents (context preservation), security-specialist (impact assessment)
- **I**: solution-steward, system-steward

**Entry Requirements:**
- B4 delivery complete with stable production system
- Enhancement request documented and scoped
- Architectural impact assessment completed
- Resource availability confirmed

**Key Deliverables:**
- `2xx-PROJECT[-{NAME}]-B5-ENHANCEMENT-PLAN.md` - Enhancement scope and approach
- `2xx-PROJECT[-{NAME}]-B5-IMPLEMENTATION.md` - Enhancement implementation record
- Updated system documentation reflecting enhancements
- Integration testing results validating system stability

**Enhancement Standards:**
- Maintain existing architectural principles
- Preserve system stability and performance
- Follow established testing and quality protocols
- Document all changes with impact analysis
- Maintain backward compatibility where possible

**Exit Conditions:**
- Enhancement successfully integrated
- System stability validated
- Documentation updated
- No regression in existing functionality
- Ready for additional B5 cycles or maintenance mode

## Cross-Reference Integration

**Document 007 Integration:** This workflow integrates with the ideation→graduation→execution pattern defined in Document 007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md:

- **Pre-D1:** All projects begin in `0-ideation/sessions/` with thread-based coordination
- **Project Graduation:** B1_02 workspace-architect executes migration from ideation to formal project structure
- **Artifact Distribution:** D-phase artifacts → `@coordination/docs/workflow/`, B-phase artifacts → `@build/reports/`
- **Session Preservation:** Complete ideation history preserved in `{project}/sessions/` for context continuity

**Migration Protocol:** `0-ideation/sessions/YYYY-MM-DD-TOPIC_NAME/` → `{project-name}/sessions/` with artifact distribution per Document 007 coordination pattern.

<!-- HestAI-Doc-Steward: consulted for document-integration-with-007-coordination-pattern -->
<!-- Approved: existing-001-numbering workflow-continuity-integration coordination-pattern-alignment -->