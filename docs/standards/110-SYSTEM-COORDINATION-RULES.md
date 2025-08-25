# 110: System Coordination Rules and Directory Standards

// HestAI-Doc-Steward: consulted for coordination-standardization
// Approved: standards-creation coordination-rules system-governance

## Purpose

This document defines the rules governing what content goes in each directory of the HestAI project structure, document naming conventions, status update frequency, and agent context handoff procedures.

## Directory Content Rules

### build/ Directory
**Purpose:** Active development workspace and implementation artifacts

**Contains:**
- Source code (`src/`, `lib/`, `components/`)
- Test files (`tests/`, `__tests__/`, `*.test.*`)
- Technical documentation (`docs/api/`, `docs/technical/`)
- B-phase implementation reports (`reports/build/`)
- Development worktrees (`worktrees/feature-branches/`)
- Package files (`package.json`, `requirements.txt`, `Cargo.toml`)
- Build configurations (`.eslintrc`, `tsconfig.json`, `webpack.config.*`)

**Excludes:**
- Project planning documents (use `coordination/docs/workflow/`)
- User feedback reports (use `coordination/reports/user-testing/`)
- Status tracking (use `coordination/status/`)
- Cross-environment documentation (use `coordination/docs/`)

### staging/ Directory
**Purpose:** Pre-production validation and integration testing

**Contains:**
- Staging deployment configurations (`deploy/staging/`)
- Integration test results (`test-reports/integration/`)
- User acceptance testing artifacts (`validation/uat/`)
- Staging-specific environment files (`.env.staging`)
- Performance testing results (`performance/`)
- Security testing reports (`security-scan/`)

**Excludes:**
- Development source code (use `build/src/`)
- Production configurations (use `production/deploy/`)
- Project documentation (use `coordination/docs/`)

### production/ Directory
**Purpose:** Live system management and production operations

**Contains:**
- Production deployment configurations (`deploy/production/`)
- System monitoring configurations (`monitoring/`)
- Backup and recovery procedures (`backups/`)
- Production incident reports (`incidents/`)
- Production-specific environment files (`.env.production`)
- Scaling and capacity planning (`capacity/`)

**Excludes:**
- Development artifacts (use `build/`)
- Testing results (use `staging/test-reports/`)
- Project planning (use `coordination/docs/workflow/`)

### coordination/ Directory
**Purpose:** Central coordination hub for all project management

**Contains:**
- **`docs/workflow/`** - D-phase planning artifacts (D1-D3)
- **`docs/api/`** - Cross-environment API documentation
- **`docs/architecture/`** - System architecture documentation
- **`reports/build/`** - B-phase implementation reports (B1-B4)
- **`reports/user-testing/`** - User feedback and testing reports
- **`reports/analysis/`** - System analysis and performance reports
- **`status/`** - PROJECT_STATUS.md and tracking files
- **`artifacts/`** - Deliverables and milestone artifacts
- **`sessions/`** - Links to session history and context

**Excludes:**
- Environment-specific code (use respective environment directories)
- Build artifacts (use `build/` unless they're cross-environment deliverables)
- Temporary files (use environment-specific temp directories)

## Document Naming Conventions

### Workflow Documents (D-Phase)
**Pattern:** `{SEQUENCE}-PROJECT-{MODULE}-[{PHASE}]-{CONTENT_TYPE}.md`
**Location:** `coordination/docs/workflow/`

Examples:
- `200-PROJECT-SMARTSUITE-D1-NORTH-STAR.md`
- `201-PROJECT-SMARTSUITE-D2-DESIGN-ARCHITECTURE.md`
- `202-PROJECT-SMARTSUITE-D3-TECHNICAL-BLUEPRINT.md`

### Implementation Reports (B-Phase)
**Pattern:** `{SEQUENCE}-REPORT-{MODULE}-[{PHASE}]-{CONTENT_TYPE}.md`
**Location:** `coordination/reports/build/`

Examples:
- `800-REPORT-IMPLEMENTATION-B1-DEVELOPMENT-START.md`
- `801-REPORT-INTEGRATION-B2-API-TESTING.md`
- `802-REPORT-DEPLOYMENT-B3-STAGING-VALIDATION.md`

### Status and Tracking Documents
**Pattern:** Standardized names for consistency
**Location:** `coordination/status/`

Required Files:
- `PROJECT_STATUS.md` (primary status tracking)
- `PHASE_PROGRESS.md` (detailed phase progression)
- `ISSUE_REGISTRY.md` (blocking issues and resolutions)

### Session Messages
**Pattern:** `{THREAD}{SEQUENCE}-{PARTICIPANT}-{TITLE}.md`
**Location:** `sessions/YYYY-MM-DD-TOPIC/messages/`

Examples:
- `A01-SHAUNOS-initial-requirements.md`
- `A02-DESIGN-ARCHITECT-blueprint-response.md`
- `B01-SHAUNOS-security-concerns.md`

## Status Update Frequency Rules

### Mandatory Update Intervals

**Daily Updates Required:**
- Active development phases (B1-B4)
- Critical issue resolution
- Production incident response
- Sprint-based development cycles

**Weekly Updates Required:**
- Planning phases (D1-D3)
- Enhancement phases (B5)
- Maintenance mode projects
- Long-term strategic initiatives

**Phase Transition Updates:**
- Required at every phase boundary (D0→D1, D1→D2, etc.)
- Must include handoff context for next agent
- Update phase completion status
- Validate all dependencies met

### Update Content Requirements

**Minimum Status Update Must Include:**
1. Current task progress with specific metrics
2. Any new blocking issues identified
3. Next actions with responsible agents
4. System integration status changes
5. Quality gate compliance status

**Phase Transition Update Must Include:**
1. Complete phase deliverables validation
2. Agent context handoff documentation  
3. Next phase readiness assessment
4. Risk register updates
5. Integration status verification

## Agent Context Handoff Procedures

### Mandatory Handoff Documentation

**Context Transfer Requirements:**
1. **Current Understanding** - What has been accomplished and validated
2. **Key Decisions Made** - Critical decisions with rationale
3. **Pending Items** - Outstanding tasks requiring attention
4. **Important Context** - Domain knowledge and constraints
5. **Session Continuity** - Reference to relevant session messages

**Handoff Validation:**
- Receiving agent must acknowledge context received
- Review of critical artifacts and decisions
- Validation of understanding through questioning
- Confirmation of next actions and priorities

### Agent-Specific Handoff Patterns

**From requirements-steward to design-architect:**
- Complete D1 North Star validation
- Stakeholder requirement clarity confirmation  
- Technical constraint documentation
- Success criteria definition

**From design-architect to technical-architect:**
- System architecture decisions documented
- Integration pattern selections justified
- Technology stack rationale provided
- Scalability considerations addressed

**From technical-architect to workspace-architect:**
- Complete D3 blueprint validation
- Repository structure requirements defined
- Development environment specifications
- Deployment architecture documented

**From workspace-architect to development agents:**
- Build environment validated and operational
- All quality gates configured and passing
- Repository structure matches requirements
- Development workflow procedures established

### Context Handoff Quality Gates

**Handoff Blocked Until:**
- [ ] All phase deliverables validated and artifacts created
- [ ] Current status fully documented in PROJECT_STATUS.md
- [ ] Context transfer section completed with required details
- [ ] Receiving agent confirms understanding and acceptance
- [ ] Any blocking issues properly documented and assigned

## Integration with HestAI Standards

### Compliance Requirements

**101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md Alignment:**
- All artifacts follow established naming patterns
- Sequential numbering maintained across project lifecycle
- Phase identifiers used consistently (D1-D3, B0-B5)
- Content type categories respected (NORTH-STAR, DESIGN, BLUEPRINT, etc.)

**007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md Integration:**
- Session history preserved and accessible via coordination/
- Thread-based messaging patterns maintained
- Artifact traceability from sessions to deliverables
- Manifest tracking schema v1.1 compliance

**TRACED Protocol Enforcement:**
- Test-first development documented in build/ reports
- Code review requirements tracked in coordination/status/
- Quality gate compliance validated at each handoff
- Documentation requirements met throughout process

## Quality Assurance and Validation

### Directory Structure Validation

**Automated Checks:**
- .coord symlinks present and functional
- Required status files exist and current
- Naming convention compliance verified
- Artifact placement rules followed

**Manual Review Requirements:**
- Agent handoff documentation completeness
- Context transfer quality assessment
- Integration status verification
- Risk and issue tracking accuracy

### Continuous Improvement

**Feedback Integration:**
- Agent feedback on handoff procedure effectiveness
- Status update frequency optimization based on project velocity
- Directory organization refinement based on usage patterns
- Documentation template improvements from user experience

This coordination rule system ensures consistent project organization, clear communication patterns, and effective collaboration across all HestAI projects while maintaining integration with established standards and protocols.