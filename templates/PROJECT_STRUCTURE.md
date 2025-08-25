# HestAI Project Structure Template

// HestAI-Doc-Steward: consulted for project-structure-standardization
// Approved: template-creation project-standardization system-governance

## Purpose

This template defines the standard directory structure for all HestAI projects, ensuring consistent organization across ideation, graduation, and execution phases.

## Standard Project Structure

```
{project-name}/
├── sessions/                   # Thread-based conversation history
│   └── YYYY-MM-DD-TOPIC_NAME/ # Migrated from 0-ideation
├── @coordination/             # Project management coordination
│   ├── .coord -> ../coordination/ # Symlink to coordination/
│   ├── docs/workflow/         # D-phase artifacts (D1-D3)
│   ├── PROJECT_CONTEXT.md     # Current project context
│   ├── PROJECT_STATUS.md      # Status tracking template
│   └── CHARTER.md            # Project charter/mission
├── @build/                   # Implementation workspace
│   ├── .coord -> ../coordination/ # Symlink to coordination/
│   ├── reports/              # B-phase artifacts (B1-B4)
│   ├── src/                  # Source code
│   ├── tests/                # Test files
│   ├── docs/                 # Technical documentation
│   └── worktrees/           # Feature development branches
├── staging/                  # Pre-production validation
│   ├── .coord -> ../coordination/ # Symlink to coordination/
│   ├── deploy/               # Staging deployment configs
│   ├── test-reports/         # Integration test results
│   └── validation/           # User acceptance testing
├── production/               # Live system management
│   ├── .coord -> ../coordination/ # Symlink to coordination/
│   ├── deploy/               # Production deployment
│   ├── monitoring/           # System health monitoring
│   └── backups/             # Data backup management
└── coordination/            # Central coordination hub
    ├── docs/                # All project documentation
    ├── reports/             # All project reports
    ├── status/              # Status tracking
    ├── artifacts/           # Project deliverables
    └── manifest.json       # Project manifest tracking
```

## Directory Purpose Definitions

### Core Directories

**sessions/** - Thread-based conversation history
- Preserves complete ideation and decision context
- Migrated from 0-ideation during project graduation
- Maintains manifest.json tracking schema v1.1

**@coordination/** - Project management hub
- Contains PROJECT_CONTEXT.md and PROJECT_STATUS.md
- Houses D-phase workflow artifacts (D1-D3)
- Central coordination through symlink to coordination/

**@build/** - Implementation workspace
- Active development environment
- Contains B-phase implementation artifacts (B1-B4)
- Source code, tests, and technical documentation

### Environment Directories

**staging/** - Pre-production validation
- Integration testing environment
- User acceptance testing space
- Deployment validation and staging configs

**production/** - Live system management
- Production deployment configurations
- System monitoring and health checks
- Backup and disaster recovery management

**coordination/** - Central coordination hub
- Master coordination directory
- Accessible via .coord symlinks from all environments
- Houses all project documentation and reports

## .coord Symlink Pattern

Each environment directory contains `.coord -> ../coordination/` symlink:
- Provides unified access to project coordination
- Maintains separation between environment-specific and shared resources
- Enables consistent documentation patterns across all phases

## Artifact Placement Rules

### D-Phase Artifacts (Design/Planning)
- **Location:** `coordination/docs/workflow/`
- **Examples:** D1-NORTH-STAR.md, D2-DESIGN.md, D3-BLUEPRINT.md
- **Access:** Via `.coord/docs/workflow/` from any environment

### B-Phase Artifacts (Build/Implementation)
- **Location:** `coordination/reports/build/`
- **Examples:** B1-implementation.md, B2-testing.md, B3-deployment.md
- **Access:** Via `.coord/reports/build/` from any environment

### Status and Tracking
- **Location:** `coordination/status/`
- **Files:** PROJECT_STATUS.md, phase-tracking.json, issue-registry.md
- **Access:** Via `.coord/status/` from any environment

## Integration with HestAI Standards

### Naming Convention Compliance
All artifacts follow **101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md**:
- Workflow documents: `{SEQUENCE}-PROJECT-{MODULE}-[{PHASE}]-{CONTENT_TYPE}.md`
- Session artifacts: `{SEQUENCE}-{PHASE}-{ROLE}-{DESCRIPTOR}.md`
- Status documents: `PROJECT_STATUS.md`, `PHASE_PROGRESS.md`

### Session Integration
Session history preservation:
- Complete thread-based conversations from ideation
- Context-stream progression tracking
- Artifact traceability to originating discussions

### Agent Coordination
Standard structure supports all HestAI agents:
- **workspace-architect:** Project structure creation and organization
- **sessions-manager:** Session history and manifest management
- **directory-curator:** Structure validation and maintenance

## Implementation Notes

### Project Creation
1. Use workspace-architect for initial structure creation
2. Establish .coord symlinks during setup
3. Initialize PROJECT_CONTEXT.md and PROJECT_STATUS.md
4. Create manifest.json with project metadata

### Migration Support
- Supports graduation from 0-ideation sessions
- Maintains artifact traceability through structure
- Preserves decision context via session history

### Scalability
- Structure scales from small projects to enterprise systems
- Environment separation supports complex deployment patterns
- Coordination hub prevents information silos

This structure ensures consistent project organization while maintaining the flexibility needed for different project types and scales within the HestAI ecosystem.