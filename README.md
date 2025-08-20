# HestAI Platform

<!-- HestAI-Doc-Steward: consulted for document-creation-and-placement -->
<!-- Approved: STEW-003 [root-level-infrastructure] [platform-visibility] [registry-documentation] -->

## Document Governance System

This platform operates under a sophisticated document governance system with automated sequence management and conflict prevention.

### Registry System
The `.registry/` system maintains three core files for document governance:

- **sequence-tracker.json**: Manages sequence numbers and directory ranges
- **naming-conflicts.json**: Tracks and resolves naming conflicts  
- **governance-matrix.json**: Logs steward approvals and governance decisions

### Sequence Management
Documents follow strict sequence ranges by directory:

- `docs/workflow/`: **000-099** - Project lifecycle processes and operational workflows
- `docs/standards/`: **100-199** - Documentation standards and quality enforcement  
- `docs/future-phases/`: **200-299** - Planned developments and architectural evolution
- `docs/security/`: **400-499** - Security architecture and integration patterns
- `reports/`: **800-899** - Analysis reports and system observations

### Document Creation Process
1. **Registry Validation**: All document creation checks sequence availability
2. **Range Enforcement**: Sequences must comply with directory-specific ranges
3. **Steward Approval**: System-steward approval required via governance-matrix.json
4. **Hook Integration**: Enforcement hooks validate compliance automatically

### Governance Hooks
Active enforcement through:
- `~/.claude/hooks/enforce-doc-governance.sh`: Reads approval from governance-matrix.json
- `~/.claude/hooks/enforce-doc-naming.sh`: Validates sequence against range boundaries

## Directory Structure

### Current Project Location
**New projects are located at `/Volumes/HestAI-Projects/`**

### Core Platform Structure (`/Volumes/HestAI/`)

#### Documentation (`docs/`)
- `standards/` - Documentation standards, naming conventions, and enforcement rules
- `workflow/` - Workflow processes, error handling, and coordination patterns  
- `security/` - Security architecture and implementation guides
- `future-phases/` - Planned features and architectural proposals
- `.registry/` - Document governance system files

#### Platform Resources
- `reports/` - Analysis reports and system assessments
- `templates/` - Project templates and scaffolding
- `src/` - Core platform source code
- `worktrees/` - Git worktrees for parallel development branches

#### Archive
- `_archive/` - Archived documentation and legacy files

## Project Organization

### New Project Structure (HestAI-Projects)
```
project-name/
├── build/           # Build artifacts and deployment files
├── docs/            # Project-specific documentation
├── sessions/        # Development session logs and artifacts
├── coordination/    # Project coordination documents
│   ├── CHARTER.md
│   ├── PROJECT_CONTEXT.md
│   └── ASSIGNMENTS.md
└── src/            # Source code
```

### Legacy Project Structure (builds/)
```
project-name/
├── src/            # Source code
├── tests/          # Test suites
├── docs/           # Documentation
├── scripts/        # Build and deployment scripts
├── worktrees/      # Development branches
└── analysis/       # Code analysis reports
```

## Platform Standards

### Naming Conventions
Documents follow the pattern: `{SEQUENCE}-{CONTEXT}-{DESCRIPTOR}.md`

Projects follow semantic naming patterns defined in `docs/standards/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md`

### Quality Gates
All projects implement TRACED protocol:
- **T**est-first development
- **R**eview-based quality assurance  
- **A**rchitectural validation
- **C**onsultation with specialists
- **E**xecution of quality gates
- **D**ocumentation throughout

### Workflow Phases
- **D1-D3**: Design phases
- **B0-B4**: Build phases

## Registry Integrity

### Steward Authorities
- **system-steward**: Document creation, sequence resolution, structural reorganization
- **STEW-XXX approval_id**: Required for all document creation operations

### Conflict Resolution
The system maintains strict conflict prevention:
- Immediate detection via naming-conflicts.json monitoring
- Automatic blocking of sequence violations
- Mandatory steward intervention for resolution
- Complete audit trail in governance-matrix.json

### Range Enforcement
- Hooks validate sequence numbers against directory ranges
- Cross-directory sequence conflicts prevented
- Automatic next-available sequence calculation
- Structural integrity maintained through governance rules

## Getting Started

1. **New Projects**: Create in `/Volumes/HestAI-Projects/`
2. **Document Creation**: Follow registry validation process with steward approval
3. **Platform Documentation**: Reference `docs/` for standards and workflows
4. **Templates**: Use `templates/` for project scaffolding
5. **Legacy Reference**: Examine `builds/smartsuite-mcp-server/` for comprehensive implementation examples

## Migration Note

Projects in the `builds/` directory represent the earlier development approach and remain for reference. All new development should follow the structure established in `/Volumes/HestAI-Projects/` with proper coordination documents and standardized project layout.

The document governance system ensures consistent organization and prevents conflicts through automated registry management and steward oversight.