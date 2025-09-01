# Practical Workflow Execution Chains

**Purpose**: Step-by-step execution walkthrough showing actual agent calls, MCP tools, subagent consultations, and document production chains.

**Format**: Practical execution sequences, not theoretical RACI matrices.

## ORCHESTRATION PATTERNS

### Pattern A: Direct Agent Execution (Manual Orchestration)
```
User → /role {specialist} → Agent executes phase tasks directly
```

### Pattern B: Holistic Orchestrator Meta-Management (Automated Orchestration)  
```
User → /role holistic-orchestrator → @/Users/shaunbuswell/.claude/commands/{COMMAND}.md {context}
     → Holistic orchestrator executes command protocol
     → Command protocol invokes appropriate phase agents via Task tool
     → Agents execute their specific responsibilities
```

**Available Command Protocols**:
- `@/Users/shaunbuswell/.claude/commands/design.md` - D1→D3 design phases
- `@/Users/shaunbuswell/.claude/commands/build.md` - B0→B4 build phases  
- `@/Users/shaunbuswell/.claude/commands/deploy.md` - B4_D1→B4_D3 deployment phases
- `@/Users/shaunbuswell/.claude/commands/enhance.md` - B5 enhancement execution
- `@/Users/shaunbuswell/.claude/commands/workflow.md` - Complete D0→B5 workflow

**Pattern B Execution Examples**:
1. **Design Phase**: 
   - **User**: `/role holistic-orchestrator`
   - **User**: `@/Users/shaunbuswell/.claude/commands/design.md Task management web app`
   - **holistic-orchestrator**: Executes D1→D3 design protocol with idea-clarifier, research-analyst, ideator, etc.

2. **Build Phase**:
   - **User**: `@/Users/shaunbuswell/.claude/commands/build.md --phase=B2 "Implement core features"`
   - **holistic-orchestrator**: Executes B2 implementation with TDD enforcement and specialist coordination

3. **Complete Workflow**:
   - **User**: `@/Users/shaunbuswell/.claude/commands/workflow.md "Social media management platform"`
   - **holistic-orchestrator**: Executes complete D0→B5 workflow with phase transitions and quality gates

This document covers **both patterns** - direct specialist execution and orchestrated build protocol execution.

---

## D0: IDEATION SETUP - Practical Execution

**Context**: User has an idea, needs formal project setup

**Lead Agent**: `sessions-manager`
1. User runs `/role sessions-manager` in `/Volumes/HestAI-Projects/0-ideation/`
2. sessions-manager creates session structure:
   ```
   Task(subagent_type="directory-curator", prompt="Create session directory structure YYYY-MM-DD-TOPIC_NAME with manifest.json, messages/, context-stream/, artifacts/")
   ```
3. sessions-manager initializes `manifest.json` with schema v1.1
4. User presents initial idea in `A01-SHAUNOS-initial-requirements.md`
5. sessions-manager assesses graduation readiness criteria
6. sessions-manager documents graduation assessment (not execution)

**Documents Produced**: Session structure, manifest.json, graduation readiness assessment

---

## D1: UNDERSTANDING ESTABLISHMENT - Practical Execution

### D1_01: idea-clarifier

**Lead Agent**: `idea-clarifier`
1. Reads initial user requirements from session
2. Engages user directly to flesh out the idea:
   - Asks clarifying questions
   - Identifies assumptions
   - Documents scope boundaries
3. Creates problem statement with user validation
4. Documents requirements outline with flagged assumptions
5. Validates understanding with user
6. Produces message: `A02-IDEA-CLARIFIER-clarification-response.md`

### D1_02: research-analyst

**Lead Agent**: `research-analyst`
1. Reads clarified requirements from D1_01
2. Calls `mcp__Context7__resolve-library-id` for relevant technologies
3. Calls `mcp__Context7__get-library-docs` for technical research
4. Uses `WebSearch` for existing solutions and approaches
5. Calls `mcp__hestai__chat` for technical feasibility discussions
6. Consults `technical-architect` via Task tool for architectural feasibility
7. Produces comprehensive research analysis
8. Documents: `A03-RESEARCH-ANALYST-feasibility-analysis.md`

### D1_03: idea-clarifier (North Star creation)

**Lead Agent**: `idea-clarifier`
1. Reads research analysis from D1_02
2. Synthesizes user requirements + technical research
3. Calls `critical-engineer` via Task tool for completeness validation
4. Creates `200-PROJECT-{TOPIC}-D1-NORTH-STAR.md` in session artifacts/
5. Documents immutable requirements and success criteria
6. Produces message: `A04-IDEA-CLARIFIER-north-star-synthesis.md`

### D1_04: requirements-steward

**Lead Agent**: `requirements-steward`
1. Reviews entire D1 conversation thread
2. Validates North Star against user intent
3. Performs assumption risk assessment
4. Calls `critical-engineer` via Task tool for requirement integrity validation
5. Flags any assumption risks or gaps
6. Approves D1→D2 transition
7. Documents: `A05-REQUIREMENTS-STEWARD-validation-report.md`

**Documents Produced**: 200-PROJECT-{TOPIC}-D1-NORTH-STAR.md, comprehensive requirements validation

---

## D2: IDEATION - Practical Execution

### D2_01: ideator

**Lead Agent**: `ideator`
1. Reads approved North Star from D1_04
2. Calls `mcp__hestai__chat` for creative brainstorming on solutions
3. Uses `mcp__hestai__planner` for solution approach planning
4. Generates multiple creative approaches within North Star boundaries
5. Documents innovative enhancements beyond minimum requirements
6. Consults `requirements-steward` via Task tool for North Star alignment verification
7. Creates `D2_01-IDEAS.md` in session artifacts/
8. Produces message: `A06-IDEATOR-creative-solutions.md`

### D2_02: validator

**Lead Agent**: `validator`
1. Reads creative solutions from D2_01
2. Calls `mcp__Context7__resolve-library-id` and `mcp__Context7__get-library-docs` for implementation reality checks
3. Uses `mcp__hestai__critical-engineer` for technical feasibility validation
4. Consults `technical-architect` via Task tool for technical constraints analysis
5. Applies real-world constraints to creative solutions
6. Documents implementation challenges and resource requirements
7. Creates `D2_02-CONSTRAINTS.md` in session artifacts/
8. Produces message: `A07-VALIDATOR-feasibility-analysis.md`

### D2_02B: edge-optimizer (OPTIONAL)

**Lead Agent**: `edge-optimizer` (triggered if breakthrough potential identified)
1. Reads validated approaches from D2_02
2. Uses `mcp__hestai__thinkdeep` for boundary exploration analysis
3. Calls `mcp__hestai__chat` for breakthrough innovation discussions
4. Explores constraint boundaries for breakthrough opportunities
5. Consults `critical-engineer` via Task tool for breakthrough feasibility
6. Documents edge discoveries and optimization beyond standard constraints
7. Creates `D2_02B-EDGE_DISCOVERIES.md` in session artifacts/ (if triggered)
8. Produces message: `A08-EDGE-OPTIMIZER-breakthrough-analysis.md` (if triggered)

### D2_03: synthesiser

**Lead Agent**: `synthesiser`
1. Reads validated approaches from D2_02 and optional edge discoveries from D2_02B
2. Uses `mcp__hestai__consensus` for multi-perspective approach synthesis
3. Merges best elements into unified coherent design approach
4. Consults both `ideator` and `validator` via Task tool for synthesis approval (REQUIRED)
5. Calls `critical-engineer` via Task tool for synthesis completeness validation
6. Consults `requirements-steward` via Task tool for North Star alignment
7. Creates `D2_03-DESIGN.md` in session artifacts/
8. Documents synthesis rationale and design approach
9. Approves D2→D3 transition
10. Produces message: `A09-SYNTHESISER-unified-design.md`

**Documents Produced**: D2_01-IDEAS.md, D2_02-CONSTRAINTS.md, D2_02B-EDGE_DISCOVERIES.md (optional), D2_03-DESIGN.md

---

## D3: ARCHITECTURE - Practical Execution

### D3_01: design-architect

**Lead Agent**: `design-architect`
1. Reads validated design from D2_03
2. Uses `mcp__hestai__planner` for technical architecture planning
3. Calls `mcp__Context7__resolve-library-id` and `mcp__Context7__get-library-docs` for technology stack research
4. Consults `technical-architect` via Task tool for architectural validation
5. Creates detailed technical architecture specification
6. Documents component specifications and interface definitions
7. Produces message: `A10-DESIGN-ARCHITECT-technical-architecture.md`

### D3_02: visual-architect

**Lead Agent**: `visual-architect`
1. Reads technical architecture from D3_01
2. Creates visual mockups and prototypes based on architecture
3. Presents mockups to user for validation
4. **IF significant changes needed**:
   - Consults `design-architect` via Task tool for architecture impact
   - Consults `requirements-steward` via Task tool for North Star updates
   - Iterates on design until approval
5. Calls `critical-engineer` via Task tool for visual approval
6. Creates `D3-MOCKUPS.md` in session artifacts/
7. Documents visual decisions and user validation results
8. Produces message: `A11-VISUAL-ARCHITECT-mockup-validation.md`

### D3_03: technical-architect

**Lead Agent**: `technical-architect`
1. Reads architecture and approved visuals from D3_01 + D3_02
2. Uses `mcp__hestai__critical-engineer` for production readiness validation
3. Validates architectural decisions for scalability and maintainability
4. Ensures architecture supports approved visual designs
5. Calls `critical-engineer` via Task tool for production readiness confirmation
6. Produces message: `A12-TECHNICAL-ARCHITECT-architecture-validation.md`

### D3_04: security-specialist

**Lead Agent**: `security-specialist`
1. Reads validated architecture from D3_03
2. Uses `mcp__hestai__secaudit` for comprehensive security analysis
3. Reviews architecture for security considerations and compliance requirements
4. Documents security audit findings and recommendations
5. Creates `D3-BLUEPRINT.md` (complete specification) in session artifacts/
6. Creates `D3-VISUAL-DECISIONS.md` (rationale) in session artifacts/
7. Approves D3→B0 transition
8. Produces message: `A13-SECURITY-SPECIALIST-security-audit.md`

**Documents Produced**: D3-BLUEPRINT.md, D3-MOCKUPS.md, D3-VISUAL-DECISIONS.md

---

## HOLISTIC ORCHESTRATOR COMMAND EXECUTION PATTERNS

### HO-DESIGN: Orchestrated Design Phases (D1→D3)

**User Command**: `@/Users/shaunbuswell/.claude/commands/design.md "Social media management platform"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** reads design.md command protocol
2. **holistic-orchestrator** executes D1→D3 design sequence:
   ```
   # D1 Understanding
   Task(subagent_type="idea-clarifier", prompt="D1_01: Clarify social media platform requirements")
   Task(subagent_type="research-analyst", prompt="D1_02: Research technical possibilities and approaches")
   Task(subagent_type="idea-clarifier", prompt="D1_03: Create immutable North Star document")
   Task(subagent_type="requirements-steward", prompt="D1_04: Validate requirements completeness")
   
   # D2 Ideation  
   Task(subagent_type="ideator", prompt="D2_01: Generate creative solutions within boundaries")
   Task(subagent_type="validator", prompt="D2_02: Apply constraints and validate feasibility")
   Task(subagent_type="edge-optimizer", prompt="D2_02B: Explore breakthrough opportunities") # Optional
   Task(subagent_type="synthesiser", prompt="D2_03: Merge approaches into unified design")
   
   # D3 Architecture
   Task(subagent_type="design-architect", prompt="D3_01: Create detailed technical architecture")
   Task(subagent_type="visual-architect", prompt="D3_02: Create mockups and validate with user")
   Task(subagent_type="technical-architect", prompt="D3_03: Validate architectural decisions")
   Task(subagent_type="security-specialist", prompt="D3_04: Security review and compliance")
   ```
3. **holistic-orchestrator** coordinates user validation during visual design
4. **holistic-orchestrator** ensures artifact production: NORTH-STAR.md, DESIGN.md, BLUEPRINT.md

### HO-BUILD: Orchestrated Build Phases (B0→B4)

**User Command**: `@/Users/shaunbuswell/.claude/commands/build.md --phase=B0 "Validate task management architecture"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** reads build.md command protocol
2. **holistic-orchestrator** detects B0 validation phase requirements
3. **holistic-orchestrator** executes build.md B0 sequence:
   ```
   # From build.md EXECUTION_PHASES
   Task(subagent_type="critical-design-validator", prompt="B0_01: Validate architectural completeness for task management system")
   Task(subagent_type="requirements-steward", prompt="B0_02: Confirm North Star alignment for task management")
   Task(subagent_type="technical-architect", prompt="B0_03: Technical feasibility validation")
   mcp__hestai__critical-engineer(prompt="B0_04: Integrate validations into GO/NO-GO decision")
   ```
4. **holistic-orchestrator** monitors each agent execution and coordinates handoffs
5. **holistic-orchestrator** ensures T.R.A.C.E.D. compliance throughout
6. **holistic-orchestrator** validates B0-VALIDATION.md creation and GO/NO-GO decision

### HO-B1: Orchestrated Build Planning

**User Command**: `@/Users/shaunbuswell/.claude/commands/build.md --phase=B1 "Plan implementation for task management"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** executes build.md B1 planning sequence:
   ```
   Task(subagent_type="task-decomposer", prompt="B1_01: Break down task management architecture into atomic tasks")
   Task(subagent_type="workspace-architect", prompt="B1_02: Execute project graduation with workspace setup")
   Task(subagent_type="implementation-lead", prompt="B1_03: Optimize task sequencing and development flow")
   Task(subagent_type="build-plan-checker", prompt="B1_04: Validate build plan completeness")
   ```
2. **holistic-orchestrator** coordinates workspace migration using Document 007 protocols
3. **holistic-orchestrator** ensures CI/CD pipeline setup for quality gates
4. **holistic-orchestrator** validates B1 deliverables creation

### HO-B2: Orchestrated Implementation Hub

**User Command**: `@/Users/shaunbuswell/.claude/commands/build.md --phase=B2 "Implement core features"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** enforces T.R.A.C.E.D. discipline:
   ```
   mcp__hestai__testguard(prompt="B2_00: Establish test methodology and integrity monitoring")
   Task(subagent_type="implementation-lead", prompt="B2_01: Coordinate development with TDD workflow")
   ```
2. **holistic-orchestrator** manages TDD workflow enforcement:
   - Monitors RED→GREEN→REFACTOR cycle completion
   - Enforces test-before-code discipline
   - Triggers `TodoWrite` documentation at each phase
3. **holistic-orchestrator** coordinates specialist invocations:
   ```
   # For each development task:
   Task(subagent_type="universal-test-engineer", prompt="B2_02: Create test suites for {component}")
   # After each code creation:
   Task(subagent_type="code-review-specialist", prompt="B2_03: Review {component} implementation")
   # For errors:
   Task(subagent_type="error-resolver", prompt="B2_04: Resolve component-level issue in {component}")
   # OR for system errors:
   Task(subagent_type="error-architect", prompt="B2_04: Address system-level cascading failure")
   ```
4. **holistic-orchestrator** ensures quality gates before session completion

### HO-B3: Orchestrated Integration Excellence

**User Command**: `@/Users/shaunbuswell/.claude/commands/build.md --phase=B3 "Integrate and validate system"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** orchestrates integration sequence:
   ```
   Task(subagent_type="completion-architect", prompt="B3_01: Orchestrate component integration")
   Task(subagent_type="universal-test-engineer", prompt="B3_02: Execute integration and E2E testing")
   # Optional breakthrough optimization:
   Task(subagent_type="edge-optimizer", prompt="B3_02B: Identify system breakthrough optimizations")
   Task(subagent_type="security-specialist", prompt="B3_03: Security audit and penetration testing")
   Task(subagent_type="coherence-oracle", prompt="B3_04: Validate cross-system consistency")
   ```
2. **holistic-orchestrator** coordinates optional edge-optimizer evaluation
3. **holistic-orchestrator** ensures production readiness validation
4. **holistic-orchestrator** validates integration criteria completion

### HO-B4: Orchestrated Production Handoff

**User Command**: `@/Users/shaunbuswell/.claude/commands/build.md --phase=B4 "Prepare for production deployment"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** coordinates handoff specialist sequence:
   ```
   Task(subagent_type="solution-steward", prompt="B4_01: Package solution and create handoff documentation")
   Task(subagent_type="system-steward", prompt="B4_02: Document system architecture and operations")
   Task(subagent_type="workspace-architect", prompt="B4_03: Clean project structure for publication")
   Task(subagent_type="security-specialist", prompt="B4_04: Final security review and hardening")
   mcp__hestai__critical-engineer(prompt="B4_05: Final production readiness validation and sign-off")
   ```
2. **holistic-orchestrator** coordinates MCP deployment phases (B4_D1→B4_D2→B4_D3)
3. **holistic-orchestrator** ensures complete handoff documentation
4. **holistic-orchestrator** validates production deployment success

### HO-DEPLOY: Orchestrated Deployment Phases (B4_D1→B4_D3)

**User Command**: `@/Users/shaunbuswell/.claude/commands/deploy.md "Deploy task management system to production"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** reads deploy.md command protocol
2. **holistic-orchestrator** coordinates MCP deployment sequence:
   ```
   # B4_D1: Staging Deploy
   mcp__hestai__critical-engineer(prompt="Execute staging deployment with validation")
   # Executes: mcp-server validate-config --profile=staging
   # Executes: mcp-server deploy --profile=staging --validate-first
   
   # B4_D2: Live Deploy  
   mcp__hestai__critical-engineer(prompt="Execute production deployment with gradual traffic migration")
   # Executes: load-balancer set-traffic-split primary:90 secondary:10
   # Monitors and increases: 10% → 50% → 100%
   
   # B4_D3: Deployment Validation
   mcp__hestai__critical-engineer(prompt="Validate post-deployment system health and performance")
   ```
3. **holistic-orchestrator** monitors deployment health and rollback triggers
4. **holistic-orchestrator** validates deployment success criteria

### HO-ENHANCE: Orchestrated Enhancement Phase (B5)

**User Command**: `@/Users/shaunbuswell/.claude/commands/enhance.md "Add real-time notifications to task management system"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** reads enhance.md command protocol
2. **holistic-orchestrator** executes B5 enhancement sequence:
   ```
   Task(subagent_type="requirements-steward", prompt="B5_01: Analyze enhancement against North Star")
   Task(subagent_type="technical-architect", prompt="B5_02: Assess architectural impact of notifications")
   Task(subagent_type="implementation-lead", prompt="B5_03: Execute enhancement with existing quality standards")
   mcp__hestai__critical-engineer(prompt="B5_04: Validate enhancement integration and stability")
   ```
3. **holistic-orchestrator** ensures enhancement preserves system stability
4. **holistic-orchestrator** validates backward compatibility and integration

### HO-WORKFLOW: Complete Orchestrated Workflow (D0→B5)

**User Command**: `@/Users/shaunbuswell/.claude/commands/workflow.md "Personal finance tracking application"`

**Holistic Orchestrator Execution**:
1. **holistic-orchestrator** reads workflow.md command protocol
2. **holistic-orchestrator** executes complete D0→B5 sequence:
   ```
   # D0: Ideation Setup
   Task(subagent_type="sessions-manager", prompt="D0: Set up ideation session structure")
   
   # D1-D3: Design Phases (same as HO-DESIGN above)
   
   # B0: Validation Gate
   Task(subagent_type="critical-design-validator", prompt="B0_01: Validate design completeness")
   # ... complete B0 sequence
   
   # B1-B4: Build Phases (same as HO-BUILD above)
   
   # B5: Enhancement Ready
   # System ready for future enhancements
   ```
3. **holistic-orchestrator** manages phase transitions and quality gates
4. **holistic-orchestrator** coordinates project graduation at B1_02
5. **holistic-orchestrator** ensures complete workflow artifact production

### Orchestration Benefits

**Pattern B Advantages**:
- **Consistent Protocol Execution**: Command protocols (design/build/deploy/enhance/workflow.md) ensure T.R.A.C.E.D. compliance
- **Comprehensive Phase Coverage**: Complete D0→B5 workflow orchestration with all command variations
- **Automatic Phase Detection**: Holistic orchestrator reads artifacts to determine current phase and appropriate command
- **Error Coordination**: Systematic error handling via error-resolver/error-architect chains across all phases
- **Quality Gate Enforcement**: Automated quality validation at each phase transition
- **Agent Accountability**: Proper RACI execution via required Task tool invocations for all workflow phases
- **Command Flexibility**: Choose specific phase focus (design, build, deploy) or complete workflow execution

**Command Protocol Selection Guide**:
- **design.md**: D1→D3 phases only (requirements through architecture)
- **build.md**: B0→B4 phases only (validation through production handoff)  
- **deploy.md**: B4_D1→B4_D3 deployment phases only (staging through validation)
- **enhance.md**: B5 phase only (post-delivery enhancements)
- **workflow.md**: Complete D0→B5 workflow (full project lifecycle)

**Usage Decision**:
- **Pattern A (Direct)**: For focused specialist work, debugging specific issues, or single-agent consultation
- **Pattern B (Orchestrated)**: For systematic phase progression with full protocol compliance and quality gates

---

## B0: VALIDATION GATE - Practical Execution

### B0_01: critical-design-validator

**Lead Agent**: `critical-design-validator`
1. Reads all D-phase artifacts (NORTH-STAR, DESIGN, BLUEPRINT, MOCKUPS)
2. Uses `mcp__hestai__analyze` for comprehensive design analysis
3. Validates completeness and identifies potential failure modes
4. Documents design validation findings
5. Produces message: `B01-CRITICAL-VALIDATOR-completeness-analysis.md`

### B0_02: requirements-steward

**Lead Agent**: `requirements-steward`
1. Reads validation findings from B0_01
2. Confirms North Star → Design → Blueprint alignment maintained
3. Validates that all requirements are addressed in final blueprint
4. Documents alignment confirmation
5. Produces message: `B02-REQUIREMENTS-STEWARD-alignment-confirmation.md`

### B0_03: technical-architect

**Lead Agent**: `technical-architect`
1. Reads design validation and alignment confirmation from B0_01 + B0_02
2. Uses `mcp__hestai__critical-engineer` for final technical feasibility validation
3. Validates scalability, implementability, and resource requirements
4. Documents technical feasibility assessment
5. Produces message: `B03-TECHNICAL-ARCHITECT-feasibility-confirmation.md`

### B0_04: critical-engineer

**Lead Agent**: `critical-engineer`
1. Reads all validation reports from B0_01, B0_02, B0_03
2. Uses `mcp__hestai__critical-engineer` for integration of all validations
3. Consults `security-specialist` via Task tool for final security confirmation
4. Consults `error-architect` via Task tool for failure mode analysis
5. Makes GO/NO-GO decision based on validation criteria
6. Creates `B0-VALIDATION.md` in project @build/reports/
7. **IF GO**: Approves B0→B1 transition
8. **IF NO-GO**: Returns to appropriate D-phase with specific remediation requirements
9. Produces message: `B04-CRITICAL-ENGINEER-go-nogo-decision.md`

**Documents Produced**: B0-VALIDATION.md with GO/NO-GO decision

---

---

## B1: BUILD PLANNING - Practical Execution

**Context**: Design validated, ready for build planning and workspace setup

### B1_01: task-decomposer

**Lead Agent**: `task-decomposer`
1. Reads B0-VALIDATION.md (GO decision) and D3-BLUEPRINT.md
2. Uses `mcp__hestai__planner` for task breakdown planning
3. Calls `mcp__hestai__analyze` for component analysis and dependencies
4. Consults `technical-architect` via Task tool for technical guidance
5. Breaks architecture into atomic, implementable tasks
6. Maps dependencies and critical path
7. Creates task sequences with effort estimates
8. Creates `B1-BUILD-PLAN.md` in project @build/reports/
9. Documents: `B01-TASK-DECOMPOSER-task-breakdown.md`

### B1_02: workspace-architect

**Lead Agent**: `workspace-architect`
1. Reads graduation assessment from sessions-manager (D0) and task breakdown from B1_01
2. Executes project migration from `0-ideation/` → `{project-name}/sessions/`
3. Uses the commands from 005-WORKFLOW-WORKSPACE-COORDINATION-SETUP.md:
   ```bash
   PROJECT_NAME="project-name"
   PROJECT_BASE="/Volumes/HestAI-Projects/${PROJECT_NAME}"
   mkdir -p "${PROJECT_BASE}"/{coordination,build}
   ```
4. Creates coordination repository structure with git init
5. Creates build repository structure with git init  
6. Sets up CLAUDE.md with project-specific development standards
7. Configures CI/CD pipeline foundations
8. Creates symlink infrastructure for worktrees
9. Tests workspace setup with validation checklist
10. Creates `B1-WORKSPACE.md` in project @build/reports/
11. Documents: `B02-WORKSPACE-ARCHITECT-migration-execution.md`

### B1_03: implementation-lead

**Lead Agent**: `implementation-lead`
1. Reads task breakdown and workspace setup from B1_01 + B1_02
2. Uses `mcp__hestai__planner` for development flow optimization
3. Sequences tasks for optimal development workflow
4. Plans team coordination and resource allocation
5. Consults `critical-engineer` via Task tool for resource validation
6. Documents development standards and quality gates
7. Creates implementation schedule with buffers
8. Updates `B1-BUILD-PLAN.md` with sequencing information
9. Documents: `B03-IMPLEMENTATION-LEAD-development-flow.md`

### B1_04: build-plan-checker

**Lead Agent**: `build-plan-checker`
1. Reads build plan, workspace setup, and development flow from B1_01 + B1_02 + B1_03
2. Uses `mcp__hestai__analyze` for build plan completeness validation
3. Validates task coverage against blueprint requirements
4. Checks dependency mapping and critical path accuracy
5. Verifies resource estimates and timeline feasibility
6. Consults `critical-engineer` via Task tool for final build plan approval
7. Creates `B1-DEPENDENCIES.md` with dependency map and critical path
8. Documents: `B04-BUILD-PLAN-CHECKER-validation-report.md`

**Documents Produced**: B1-BUILD-PLAN.md, B1-WORKSPACE.md, B1-DEPENDENCIES.md, TRACED artifacts, complete project migration

---

## B2: IMPLEMENTATION - Practical Execution

**Context**: Build plan approved, development begins with TRACED discipline

### B2_00: test-methodology-guardian

**Lead Agent**: `test-methodology-guardian`
1. Reads build plan and workspace setup from B1 phase
2. Uses `mcp__hestai__testguard` for test strategy establishment
3. Establishes TDD methodology and compliance framework
4. Defines coverage requirements (80% guideline, behavior focus)
5. Sets up test integrity monitoring and anti-manipulation guards
6. Consults `universal-test-engineer` via Task tool for framework alignment
7. Creates test strategy documentation aligned with project needs
8. Creates `B2-TEST-STRATEGY.md` in project @build/reports/
9. Documents: `B05-TESTGUARD-methodology-establishment.md`

### B2_01: implementation-lead (Development Coordination Hub)

**Lead Agent**: `implementation-lead`
1. Reads test strategy from B2_00 and coordinates all development activities
2. Uses `TodoWrite` extensively for task tracking and progress management
3. Manages development task flow following build plan sequences
4. **For each development task**:
   - Ensures failing test exists before implementation (TESTGUARD discipline)
   - Coordinates with appropriate specialists based on task type
   - Monitors quality gates (lint, typecheck, tests) continuously
   - Ensures TRACED protocol compliance throughout
5. Calls appropriate error handlers:
   - `error-resolver` via Task tool for component-level issues
   - `error-architect` via Task tool for system-level cascades
6. Maintains `B2-IMPLEMENTATION-LOG.md` with ongoing updates
7. Coordinates code review processes with code-review-specialist
8. Documents: Multiple `B0X-IMPLEMENTATION-LEAD-coordination-updates.md`

### B2_02: universal-test-engineer

**Lead Agent**: `universal-test-engineer`
1. Reads test strategy from B2_00 and receives task assignments from implementation-lead
2. Uses `mcp__zen__testgen` for comprehensive test suite generation
3. Creates test suites within established methodology framework
4. **For each component being implemented**:
   - Creates failing tests before implementation begins (RED state)
   - Validates test coverage focuses on behavior, not just lines
   - Implements integration tests for component interactions
   - Maintains test suite health and performance
5. Consults `test-methodology-guardian` via Task tool for methodology compliance
6. Uses `mcp__Context7__get-library-docs` for testing framework best practices
7. Monitors coverage diagnostically (80% guideline, not gate)
8. Updates test documentation and suite organization
9. Documents: Multiple test suite creation and maintenance messages

### B2_03: code-review-specialist

**Lead Agent**: `code-review-specialist`
1. Receives code review requests from implementation-lead coordination
2. Uses `mcp__hestai__analyze` for comprehensive code quality assessment
3. **For each code change**:
   - Reviews code quality, security, and architectural compliance
   - Validates test coverage and test intent (meaningful behavior assertions)
   - Checks adherence to project coding standards
   - Verifies TRACED protocol compliance evidence
4. Consults `security-specialist` via Task tool for security-sensitive changes
5. Consults `technical-architect` via Task tool for architectural decisions
6. Provides review comments and approval/rejection decisions
7. Maintains code review quality standards and patterns
8. Documents: Code review outcomes and quality metrics

### B2_04: error-resolver

**Lead Agent**: `error-resolver` (Called when component-level issues arise)
1. Receives error reports from implementation-lead coordination
2. Uses `mcp__hestai__debug` for systematic error investigation
3. **For component-level errors** (test failures, CI breaks, integration issues, library conflicts):
   - Diagnoses root cause using systematic investigation
   - Implements fixes following TDD discipline
   - Validates fix doesn't break other components
   - Documents resolution approach and lessons learned
4. **Escalation triggers**:
   - If error affects multiple components → escalates to `error-architect` via Task tool
   - If error requires architectural changes → escalates to `error-architect` via Task tool
   - If resolution time >4 hours → escalates to `error-architect` via Task tool
5. Updates implementation log with error resolution patterns
6. Documents: Error investigation and resolution reports

**Quality Gates Enforced**:
- Coverage 80%+ (diagnostic, not blocking)
- All tests passing in CI
- Code review approval for every change  
- No critical security vulnerabilities
- Performance benchmarks met
- Documentation updated with changes

**Documents Produced**: B2-TEST-STRATEGY.md, B2-IMPLEMENTATION-LOG.md (ongoing), source code + tests, CI pipeline configuration, TRACED compliance artifacts

---

## B3: INTEGRATION - Practical Execution

**Context**: Components implemented, ready for system integration and validation

### B3_01: completion-architect

**Lead Agent**: `completion-architect`
1. Reads implementation log and component status from B2 phase
2. Uses `mcp__hestai__analyze` for system integration analysis
3. **Integration orchestration**:
   - Maps component interfaces and integration points
   - Validates data flow and state management across components
   - Ensures error handling and recovery patterns work system-wide
   - Tests component compatibility and communication
4. Consults `technical-architect` via Task tool for architectural compliance
5. Coordinates integration testing with universal-test-engineer
6. **If integration issues found**:
   - Works with `error-resolver` for component fixes
   - Escalates to `error-architect` for system-level issues
7. Creates `B3-INTEGRATION-REPORT.md` documenting integration status
8. Documents: `B06-COMPLETION-ARCHITECT-integration-orchestration.md`

### B3_02: universal-test-engineer (Integration & E2E Testing)

**Lead Agent**: `universal-test-engineer`
1. Reads integration report from B3_01
2. Uses `mcp__zen__testgen` for integration and E2E test generation
3. Receives guidance from `test-methodology-guardian` via Task tool for integration methodology
4. **Integration testing execution**:
   - Tests all component interface interactions
   - Validates end-to-end user journey workflows
   - Performs performance benchmarking under load
   - Tests error handling and recovery scenarios
   - Validates cross-platform compatibility
5. Uses `mcp__Context7__get-library-docs` for testing framework optimization
6. **Performance validation**:
   - Executes load testing and stress testing
   - Validates performance benchmarks are achieved
   - Identifies bottlenecks and optimization opportunities
7. Creates `B3-PERFORMANCE.md` with benchmarking results
8. Documents: Integration and performance testing results

### B3_02B: edge-optimizer (OPTIONAL - Breakthrough System Optimization)

**Lead Agent**: `edge-optimizer` (triggered if system performance below potential or elegance opportunities detected)
1. Reads integration results and performance data from B3_01 + B3_02
2. Uses `mcp__hestai__thinkdeep` for system optimization analysis
3. **Breakthrough optimization exploration**:
   - Identifies system performance bottlenecks and optimization pathways
   - Explores elegance improvements and architectural refinements
   - Discovers breakthrough integration patterns
   - Develops performance enhancement strategies beyond standard integration
4. Uses `mcp__hestai__critical-engineer` for breakthrough feasibility validation
5. Consults `completion-architect` via Task tool for integration evaluation
6. **If breakthrough optimizations identified**:
   - Documents optimization approaches and implementation strategies
   - Validates optimization impact on system stability
   - Provides implementation recommendations
7. Creates `B3_02B-BREAKTHROUGH_OPTIMIZATIONS.md` (if optimizations found)
8. Documents: `B07-EDGE-OPTIMIZER-breakthrough-analysis.md` (if triggered)

### B3_03: security-specialist

**Lead Agent**: `security-specialist`
1. Reads integration status and performance results from B3_01 + B3_02 + B3_02B
2. Uses `mcp__hestai__secaudit` for comprehensive security audit
3. **Security audit execution**:
   - Performs penetration testing on integrated system
   - Validates authentication and authorization across all components
   - Tests data encryption and security controls
   - Audits access control and privilege management
   - Validates security compliance requirements
4. Uses `WebSearch` for latest security threat patterns and mitigation strategies
5. **Security validation**:
   - Tests security under various attack scenarios
   - Validates secure communication between components
   - Ensures security audit trail completeness
6. Creates `B3-SECURITY.md` with security audit findings
7. Documents: `B08-SECURITY-SPECIALIST-security-audit.md`

### B3_04: coherence-oracle

**Lead Agent**: `coherence-oracle`
1. Reads all B3 phase results (integration, performance, security, optional optimizations)
2. Uses `mcp__hestai__analyze` for cross-system consistency validation
3. **System coherence validation**:
   - Validates architectural alignment across all components
   - Ensures consistent patterns and conventions throughout system
   - Checks for architectural drift or inconsistencies
   - Validates system meets original North Star requirements
4. Consults `requirements-steward` via Task tool for requirement fulfillment validation
5. Consults `error-architect` via Task tool for system-level failure mode analysis
6. **Coherence assessment**:
   - Documents system-wide consistency and alignment
   - Identifies any architectural inconsistencies or gaps
   - Validates system readiness for production handoff
7. Final integration validation and B3→B4 approval
8. Documents: `B09-COHERENCE-ORACLE-system-coherence.md`

**Integration Validation Criteria**:
- Component interface compatibility verified
- Data flow and state management validated
- Error handling and recovery tested
- Performance benchmarks achieved
- Security vulnerabilities addressed
- Cross-platform compatibility confirmed
- System coherence and architectural alignment maintained

**Documents Produced**: B3-INTEGRATION-REPORT.md, B3-PERFORMANCE.md, B3-BREAKTHROUGH_OPTIMIZATIONS.md (optional), B3-SECURITY.md, fully integrated system with comprehensive test suites

---

## B4: PRODUCTION HANDOFF - Practical Execution

**Context**: System integrated and validated, ready for production deployment

### B4_01: solution-steward

**Lead Agent**: `solution-steward`
1. Reads all B3 integration and validation results
2. **Solution packaging and documentation**:
   - Creates comprehensive user documentation and guides
   - Packages solution for deployment with all dependencies
   - Develops training materials for end users
   - Creates troubleshooting guides and FAQ documentation
3. Uses `mcp__Context7__get-library-docs` for deployment best practices research
4. **Handoff material preparation**:
   - Prepares solution deployment packages
   - Creates user onboarding materials
   - Develops support documentation and escalation procedures
5. Consults `system-steward` via Task tool for operational documentation coordination
6. Creates `B4-HANDOFF.md` with complete handoff package
7. Creates `B4-USER-GUIDE.md` for end users
8. Documents: `B10-SOLUTION-STEWARD-solution-packaging.md`

### B4_02: system-steward

**Lead Agent**: `system-steward`
1. Reads solution packaging from B4_01 and system integration results
2. **System architecture and operations documentation**:
   - Documents system architecture and operational procedures
   - Creates maintenance guides and troubleshooting runbooks
   - Develops monitoring and alerting configurations
   - Prepares disaster recovery and backup procedures
3. **Operational readiness preparation**:
   - Creates operational runbooks for common scenarios
   - Documents system dependencies and requirements
   - Prepares capacity planning and scaling guidance
   - Creates incident response procedures
4. Consults `technical-architect` via Task tool for architecture documentation validation
5. Creates `B4-OPERATIONS.md` with operational runbooks
6. Creates `B4-MAINTENANCE.md` with maintenance procedures
7. Documents: `B11-SYSTEM-STEWARD-operations-documentation.md`

### B4_03: workspace-architect

**Lead Agent**: `workspace-architect`
1. Reads operational documentation from B4_02
2. **Project cleanup and publication readiness**:
   - Organizes project artifacts and documentation structure
   - Ensures clean repository structure and proper gitignore
   - Validates artifact placement follows organizational standards
   - Prepares project for potential open source publication
3. Uses `directory-curator` via Task tool for final organization validation
4. **Publication readiness preparation**:
   - Cleans up development artifacts and temporary files
   - Ensures documentation completeness and organization
   - Validates all sensitive information is properly secured
   - Creates publication-ready project structure
5. Creates `B4-WORKSPACE.md` documenting clean project structure
6. Documents: `B12-WORKSPACE-ARCHITECT-publication-readiness.md`

### B4_04: security-specialist

**Lead Agent**: `security-specialist`
1. Reads handoff, operations, and workspace preparation from B4_01 + B4_02 + B4_03
2. Uses `mcp__hestai__secaudit` for final security review
3. **Final security review and hardening**:
   - Performs final security scan of complete system
   - Reviews operational security procedures and runbooks
   - Validates production security configurations
   - Ensures security compliance requirements are met
4. **Production security hardening**:
   - Reviews deployment security configurations
   - Validates access controls and authentication systems
   - Ensures security monitoring and alerting are configured
   - Reviews incident response procedures for security events
5. Final security clearance for production deployment
6. Documents: `B13-SECURITY-SPECIALIST-final-security-clearance.md`

### B4_05: critical-engineer

**Lead Agent**: `critical-engineer`
1. Reads all B4 preparation work from B4_01 through B4_04
2. Uses `mcp__hestai__critical-engineer` for final production readiness validation
3. **Production readiness validation and signoff**:
   - Validates all handoff materials are complete and accurate
   - Reviews operational procedures and incident response plans
   - Ensures system meets production quality standards
   - Validates deployment procedures and rollback plans
4. **Deployment phases coordination**:
   - **B4_D1 - Staging Deploy**: Coordinates staging deployment and validation
   - **B4_D2 - Live Deploy**: Oversees production deployment with traffic migration
   - **B4_D3 - Deployment Validation**: Validates post-deployment system health
5. **Final authority for production release**:
   - Makes final GO/NO-GO decision for production deployment
   - Provides production release authorization
   - Ensures monitoring and alerting are active
   - Validates rollback procedures are tested and ready
6. Documents final production signoff and deployment authority
7. Documents: `B14-CRITICAL-ENGINEER-production-signoff.md`

### B4_D1: STAGING-DEPLOY (MCP Deployment Phase)

**Lead Agent**: `critical-engineer` (deployment authority)
1. Executes staging deployment following 006-WORKFLOW-MCP-DEPLOYMENT-PHASES.md
2. **Pre-deployment validation**:
   ```bash
   mcp-server validate-config --profile=staging
   mcp-server deploy --profile=staging --validate-first
   mcp-server health-check --profile=staging --timeout=30s
   ```
3. **Staging validation execution**:
   - MCP protocol handshake completion within 5 seconds
   - All tools available and responding with correct parameters
   - Performance benchmarks meet SLA requirements
   - Security audit trail and logging confirmed
4. Documents staging deployment results and validation
5. Approves or blocks progression to B4_D2 based on staging results

### B4_D2: LIVE-DEPLOY (Production Deployment)

**Lead Agent**: `critical-engineer` (deployment authority)
1. Executes production deployment with gradual traffic migration
2. **Production deployment process**:
   ```bash
   # Deploy to secondary instance
   mcp-server deploy --profile=production-secondary --validate-first
   
   # Gradual traffic migration: 10% → 50% → 100%
   load-balancer set-traffic-split primary:90 secondary:10
   # Monitor for 10 minutes, then increase to 50-50
   # Monitor for 20 minutes, then full migration
   ```
3. **Continuous monitoring during deployment**:
   - Health checks passing consistently
   - Performance metrics within acceptable ranges
   - Error rates below production thresholds
   - User experience validation
4. **Rollback authority**:
   - Immediate rollback capability if issues detected
   - Automatic rollback triggers configured and active
   - Manual rollback procedures tested and documented

### B4_D3: DEPLOYMENT-VALIDATION (Post-Deployment)

**Lead Agent**: `critical-engineer` (validation authority)
1. **Comprehensive post-deployment validation**:
   - End-to-end workflow execution validation
   - All critical user journeys tested and passing
   - Integration points verified and stable
   - Data consistency and integrity confirmed
2. **Performance and security validation**:
   - Response time measurements within SLA
   - Throughput capacity confirmed under load
   - Security validation and access controls verified
   - Monitoring and alerting fully operational
3. **Production readiness confirmation**:
   - All functional tests passing
   - Performance within 95% of baseline
   - Zero critical security vulnerabilities
   - Complete audit trail and logging active
4. Final production deployment success confirmation

**Production Readiness Criteria**:
- Infrastructure provisioned and tested
- Deployment procedures validated with rollback tested
- Monitoring and alerting systems active
- Security scanning complete with no critical issues
- Load testing passed under production conditions
- Documentation approved and support trained
- Incident response procedures tested and ready

**Documents Produced**: B4-HANDOFF.md, B4-OPERATIONS.md, B4-USER-GUIDE.md, B4-MAINTENANCE.md, B4-WORKSPACE.md, deployment packages, training materials, complete production-ready system

---

## B5: ENHANCEMENT - Practical Execution

**Context**: Core system delivered and stable, ready for feature expansion or improvements

**Decision Matrix**: 
- **B5 Enhancement**: Extends existing system without fundamental architectural changes
- **New D1→B4**: Requires architectural pivot or represents separate system

### B5_01: requirements-steward

**Lead Agent**: `requirements-steward`
1. Receives enhancement request and evaluates against original North Star
2. **Enhancement requirements analysis**:
   - Validates enhancement aligns with original project vision
   - Ensures enhancement doesn't violate architectural principles
   - Confirms enhancement builds upon existing stable foundation
   - Assesses impact on system stability and performance
3. Uses `mcp__hestai__analyze` for enhancement impact assessment
4. **Enhancement vs. New Project decision**:
   - **B5 Criteria**: Works within architectural framework, low destabilization risk, completable within scope limits
   - **New Project Triggers**: Architectural changes, new external integrations, core business logic changes, timeline exceeds enhancement capacity
5. Consults original project agents via Task tool for context and constraints
6. Creates `B5-ENHANCEMENT-PLAN.md` with requirements and scope
7. Documents: `B15-REQUIREMENTS-STEWARD-enhancement-analysis.md`

### B5_02: technical-architect

**Lead Agent**: `technical-architect`
1. Reads enhancement plan from B5_01
2. Uses `mcp__hestai__critical-engineer` for architectural impact analysis
3. **Architectural assessment**:
   - Evaluates enhancement impact on existing architecture
   - Ensures enhancement maintains system integrity
   - Plans integration approach with minimal disruption
   - Validates technical feasibility within existing constraints
4. **Integration planning**:
   - Maps enhancement integration points with existing system
   - Plans development approach that preserves stability
   - Ensures backward compatibility maintenance
   - Documents architectural decisions and rationale
5. Consults `security-specialist` via Task tool for security impact assessment
6. Updates architectural documentation for enhancement
7. Documents: `B16-TECHNICAL-ARCHITECT-enhancement-architecture.md`

### B5_03: implementation-lead

**Lead Agent**: `implementation-lead`
1. Reads enhancement plan and architectural assessment from B5_01 + B5_02
2. Uses existing quality standards and TRACED methodology from original project
3. **Enhancement execution**:
   - Follows same TDD discipline and quality gates as original project
   - Maintains code review standards and testing protocols
   - Ensures enhancement integrates cleanly with existing codebase
   - Preserves system performance and stability characteristics
4. Coordinates with original project specialists:
   - `code-review-specialist` for code quality maintenance
   - `universal-test-engineer` for testing protocol consistency
   - `test-methodology-guardian` via Task tool for testing discipline
5. **Quality maintenance**:
   - Maintains architectural principles from original project
   - Preserves stability and performance characteristics
   - Follows established testing and quality protocols
   - Documents changes and impact analysis
6. Updates `B5-IMPLEMENTATION.md` with enhancement progress
7. Documents: `B17-IMPLEMENTATION-LEAD-enhancement-execution.md`

### B5_04: critical-engineer

**Lead Agent**: `critical-engineer`
1. Reads enhancement implementation from B5_03
2. Uses `mcp__hestai__critical-engineer` for enhancement integration validation
3. **Enhancement integration and stability validation**:
   - Validates enhancement integrates properly with existing system
   - Ensures system stability is maintained or improved
   - Confirms performance characteristics are preserved
   - Validates backward compatibility is maintained
4. **Production integration validation**:
   - Tests enhancement in staging environment
   - Validates integration points and system coherence
   - Ensures monitoring and alerting cover new functionality
   - Confirms rollback procedures account for enhancement
5. Consults original project security and system specialists for validation
6. **Enhancement approval or remediation**:
   - Approves enhancement for production integration
   - OR identifies issues requiring remediation
   - Documents integration validation results
7. Documents: `B18-CRITICAL-ENGINEER-enhancement-validation.md`

**B5 Enhancement Standards**:
- Maintain architectural principles from original project
- Preserve system stability and performance characteristics
- Follow same testing and quality protocols as original
- Document all changes with impact analysis
- Maintain backward compatibility
- Ensure enhancement adds value without technical debt

**Documents Produced**: B5-ENHANCEMENT-PLAN.md, B5-IMPLEMENTATION.md, updated system documentation, integration testing results, enhanced system with preserved stability

---

## ERROR HANDLING CHAINS - Practical Execution

### Component-Level Error Resolution

**Lead Agent**: `error-resolver` (Hermes pattern - quick resolution focus)

**Triggered by**: Test failures, CI breaks, integration issues, library conflicts, build failures, config problems

**Execution Chain**:
1. Receives error report from `implementation-lead` or system detection
2. Uses `mcp__hestai__debug` for systematic root cause investigation
3. **Quick Fix Assessment** (≤30 minutes):
   - Syntax/config errors with obvious root cause
   - Single file fixes with zero architectural implications
   - Simple dependency or library conflicts
4. **Complex Error Investigation** (30 min - 4 hours):
   - Multi-component issues requiring investigation
   - Performance degradation with unclear cause
   - Integration issues between components
5. **Escalation Triggers** (automatic escalation to error-architect):
   - Resolution time >4 hours
   - Error affects multiple components
   - Architectural changes required
   - High business impact or risk

### System-Level Error Architecture

**Lead Agent**: `error-architect` (Zeus pattern - system authority and escalation)

**Triggered by**: Architectural violations, cross-component failures, performance degradation, security vulnerabilities, cascading failures

**Execution Chain**:
1. Receives escalation from `error-resolver` or direct system-level error detection
2. Uses `mcp__hestai__debug` for comprehensive system analysis
3. **System Impact Assessment**:
   - Maps error impact across system components
   - Identifies cascading failure patterns
   - Assesses architectural integrity impact
4. **Specialist Coordination**:
   - Consults `technical-architect` via Task tool for architectural guidance
   - Consults `security-specialist` via Task tool for security implications
   - Consults `requirements-steward` via Task tool for requirement impact
5. **Resolution Strategy**:
   - Coordinates multi-component fixes
   - Manages architectural changes if required
   - Oversees system stability restoration
6. **Emergency Protocol** (for critical errors):
   - STOP all work immediately
   - Acts as incident commander
   - Coordinates specialist team response
   - Prioritizes system stabilization before root cause analysis
   - Manages post-mortem and preventive measures

### Design Error Stewardship

**Lead Agent**: `requirements-steward` (Athena pattern - wisdom and alignment)

**Triggered by**: North Star misalignment, missing requirements, scope creep detection, assumption violations

**Execution Chain**:
1. Detects design drift or requirement misalignment
2. **Alignment Analysis**:
   - Compares current implementation against original North Star
   - Identifies scope creep or requirement violations
   - Assesses impact on project success criteria
3. **Stakeholder Consultation**:
   - Engages user for requirement clarification
   - Consults original D-phase agents for context
   - Validates assumption changes with critical-engineer
4. **Resolution Coordination**:
   - Determines if changes require North Star updates
   - Coordinates requirement adjustments with affected phases
   - Ensures changes maintain project coherence and value

**User Unavailability Protocol** (>24 hours no response):
- Document current state, assumptions, and outstanding questions
- Preserve work with detailed commit messages
- Set status to WAITING_USER_INPUT
- Create resume instructions for seamless continuity
- Maintain system in stable state during waiting period

---

## MCP TOOLS & SUBAGENT PATTERNS REFERENCE

### Core MCP Tool Usage Patterns

**Context7 Library Research**:
```
mcp__Context7__resolve-library-id(libraryName="technology-name")
→ mcp__Context7__get-library-docs(context7CompatibleLibraryID="/org/project", tokens=10000, topic="specific-area")
```
Used by: research-analyst, validator, design-architect, universal-test-engineer

**HestAI Thinking Tools**:
```
mcp__hestai__chat(prompt="collaborative-discussion", model="best-for-task")
mcp__hestai__planner(step="planning-content", model="reasoning-model")  
mcp__hestai__thinkdeep(step="investigation-content", model="analysis-model")
mcp__hestai__consensus(step="multi-model-consensus", models=[...])
mcp__hestai__debug(step="systematic-investigation", model="debug-model")
mcp__hestai__analyze(step="comprehensive-analysis", model="analysis-model")
```

**Critical Validation Tools**:
```
mcp__hestai__critical-engineer(prompt="technical-validation-request")
mcp__hestai__testguard(prompt="test-methodology-validation") 
mcp__hestai__secaudit(step="security-audit-analysis")
```

**Test Generation**:
```
mcp__zen__testgen(specification="component-to-test", language="target-language")
```

### Subagent Consultation Patterns

**Via Task Tool**:
```
Task(subagent_type="agent-name", prompt="specific-consultation-request")
```

**Common Consultation Chains**:
- **Architecture Decisions**: technical-architect → critical-engineer
- **Code Changes**: code-review-specialist → security-specialist (if needed)
- **Testing Issues**: testguard → universal-test-engineer
- **Error Escalation**: error-resolver → error-architect
- **Requirements**: requirements-steward → critical-engineer
- **Workspace**: workspace-architect → directory-curator

### Artifact Flow Patterns

**D-Phase Artifacts** → `@coordination/docs/workflow/`:
- 200-PROJECT-{TOPIC}-D1-NORTH-STAR.md
- D2_01-IDEAS.md, D2_02-CONSTRAINTS.md, D2_03-DESIGN.md
- D3-BLUEPRINT.md, D3-MOCKUPS.md, D3-VISUAL-DECISIONS.md

**B-Phase Artifacts** → `@build/reports/`:
- B0-VALIDATION.md through B4-HANDOFF.md
- B5-ENHANCEMENT-PLAN.md, B5-IMPLEMENTATION.md

**Session Messages** → `{session}/messages/`:
- Thread-based: A01-PARTICIPANT-topic.md, B01-PARTICIPANT-topic.md
- Context progression: A01-context.md, B01-context.md

---

**Status**: COMPLETE - Full workflow execution chains documented from D0 through B5 with error handling, MCP tools, and artifact flows.

**This document serves as the single source of truth for practical workflow execution in the HestAI system.**