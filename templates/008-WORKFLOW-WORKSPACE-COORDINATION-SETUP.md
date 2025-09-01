# Workspace Coordination Infrastructure Setup

// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: [008-sequence-numbering] [templates-directory-placement] [workspace-setup-implementation-guide]

**Status:** Production  
**Purpose:** Implementation guide for workspace-architect to set up two-repository coordination infrastructure  
**Scope:** All HestAI projects requiring coordination/build separation  
**Authority:** Implements Project Coordination Pattern integrated into 001-WORKFLOW-NORTH-STAR.md

## Overview

This guide enables workspace-architect to quickly set up the two-repository coordination structure during B1_02 workspace creation. Provides step-by-step commands, validation procedures, and handoff protocols.

**Prerequisites:**
- Project approved through D1 planning phase
- Project name and location confirmed
- Team assignments defined

**Deliverable:**
- Functional coordination + build repository structure
- Crystal.app compatible worktree foundation
- Symlink infrastructure ready for role activation

## Quick Setup Commands

### Initial Repository Creation
```bash
# Set project variables
export PROJECT_NAME="your-project-name"
export PROJECT_PATH="/Volumes/HestAI-Projects/${PROJECT_NAME}"
export BUILD_PATH="${PROJECT_PATH}/build"

# Create coordination structure
mkdir -p "${PROJECT_PATH}/docs"
mkdir -p "${PROJECT_PATH}/sessions"

# Initialize build repository
mkdir -p "${BUILD_PATH}"
cd "${BUILD_PATH}"
git init
```

### Coordination Infrastructure Setup
```bash
# Create coordination symlink for easy access
cd "${PROJECT_PATH}"
ln -sf "../coordination" .coord

# Set up build documentation structure
mkdir -p "${BUILD_PATH}/docs"
mkdir -p "${BUILD_PATH}/docs/adr"
mkdir -p "${BUILD_PATH}/src"
mkdir -p "${BUILD_PATH}/tests"
```

### Bridge Document Creation
```bash
# Create PROJECT_CONTEXT.md in bridge docs
cat > "${PROJECT_PATH}/docs/PROJECT_CONTEXT.md" << 'EOF'
# Project Context: ${PROJECT_NAME}

**Current Phase:** B1 Planning  
**Last Updated:** $(date +%Y-%m-%d)

## Current Priorities
- [To be updated by project team]

## Active Blockers  
- [To be updated by project team]

## Key Links
- [Build Repository README](../build/README.md)
- [Implementation Log](../build/docs/201-PROJECT-IMPLEMENTATION-LOG.md)
- [Build Plan](../build/docs/201-PROJECT-B1-BUILD-PLAN.md)
- [Architecture Decisions](../build/docs/adr/)

## Team
- **Implementation Lead:** [Assignment TBD]
- **Technical Architect:** [Assignment TBD]
EOF
```

### Build Repository Setup
```bash
# Create basic build structure files
cd "${BUILD_PATH}"

# README.md for build repo
cat > README.md << 'EOF'
# ${PROJECT_NAME}

## Getting Started
[Development setup instructions]

## Architecture
[Link to architecture decisions in docs/adr/]

## Development
[Development workflow and guidelines]
EOF

# Basic CLAUDE.md for development context
cat > CLAUDE.md << 'EOF'
# Development Instructions

## Project Context
- Phase: B1 Planning → Implementation
- Architecture: [Reference docs/adr/ for decisions]
- Testing: Test-first development required

## Key Files
- Implementation log: docs/201-PROJECT-IMPLEMENTATION-LOG.md
- Build plan: docs/201-PROJECT-B1-BUILD-PLAN.md
- Architecture decisions: docs/adr/

## Development Standards
- Follow HestAI TRACED protocol
- All changes require code review
- Test coverage minimum 80%
EOF
```

### Session Structure Migration
```bash
# If migrating from ideation, preserve session history
if [ -d "/Volumes/HestAI-Projects/0-ideation/sessions/$(date +%Y-%m-%d)-${PROJECT_NAME}" ]; then
  cp -r "/Volumes/HestAI-Projects/0-ideation/sessions/$(date +%Y-%m-%d)-${PROJECT_NAME}" \
        "${PROJECT_PATH}/sessions/"
fi
```

## Validation Checklist

### Structure Validation
```bash
# Verify directory structure is correct
cd "${PROJECT_PATH}"
echo "Checking structure..."

# Required directories
[ -d "docs" ] && echo "✅ Bridge docs directory created"
[ -d "build" ] && echo "✅ Build directory created"  
[ -d "sessions" ] && echo "✅ Sessions directory created"
[ -L ".coord" ] && echo "✅ Coordination symlink created"

# Required files
[ -f "docs/PROJECT_CONTEXT.md" ] && echo "✅ PROJECT_CONTEXT.md created"
[ -f "build/README.md" ] && echo "✅ Build README.md created"
[ -f "build/CLAUDE.md" ] && echo "✅ Build CLAUDE.md created"
```

### Git Validation  
```bash
cd "${BUILD_PATH}"
[ -d ".git" ] && echo "✅ Build repository initialized"
git status > /dev/null 2>&1 && echo "✅ Git repository functional"
```

### Link Integrity Check
```bash
# Verify symlink targets exist
cd "${PROJECT_PATH}"
[ -L ".coord" ] && [ -d "$(readlink .coord)" ] && echo "✅ Coordination symlink valid"
```

## Integration Procedures

### Phase Integration Points
1. **D1 North Star Integration:** Reference North Star document from PROJECT_CONTEXT.md
2. **B1 Build Plan Integration:** Create build plan in build/docs/ and link from bridge
3. **B2 Implementation Integration:** All development artifacts go in build/docs/
4. **Session Integration:** Preserve ideation history in project sessions/

### Artifact Distribution Setup
```bash
# Create artifact distribution directories
mkdir -p "${PROJECT_PATH}/coordination/docs/workflow"  # D-phase artifacts
mkdir -p "${BUILD_PATH}/reports"                       # B-phase artifacts

# Set up coordination symlink for easy artifact access
cd "${BUILD_PATH}"
ln -sf "../coordination" .coord
```

## Handoff Protocol

### Team Notification
```markdown
## Workspace Setup Complete

**Project:** ${PROJECT_NAME}
**Location:** ${PROJECT_PATH}
**Build Repository:** ${PROJECT_PATH}/build/

### Next Steps
1. **Implementation Lead:** Review build plan and set up development environment
2. **Technical Architect:** Validate architecture decisions and create ADRs
3. **Team:** Clone build repository and review CLAUDE.md for development standards

### Key Access Points
- Bridge Context: ${PROJECT_PATH}/docs/PROJECT_CONTEXT.md
- Build Repository: ${PROJECT_PATH}/build/
- Coordination Access: Use .coord symlink in any directory
- Session History: ${PROJECT_PATH}/sessions/
```

### Documentation Handoff
1. Update PROJECT_CONTEXT.md with team assignments
2. Create initial implementation log in build/docs/
3. Set up first architecture decision records in build/docs/adr/
4. Establish development workflow in build repository

## Troubleshooting

### Common Issues
**Symlink Problems:**
```bash
# Fix broken coordination symlink
rm .coord
ln -sf "../coordination" .coord
```

**Permission Issues:**
```bash
# Fix directory permissions
chmod -R 755 "${PROJECT_PATH}"
```

**Git Repository Issues:**
```bash
cd "${BUILD_PATH}"
git status || git init  # Re-initialize if needed
```

### Validation Failures
If validation fails, review:
1. Directory structure matches two-repository pattern
2. All required files created with proper content
3. Symlinks point to correct locations
4. Git repository properly initialized

## Success Criteria

**Infrastructure Complete When:**
- ✅ Two-repository structure established
- ✅ Bridge/truth boundaries clearly defined  
- ✅ Coordination symlinks functional
- ✅ Git repository initialized and functional
- ✅ Team has clear access points and next steps
- ✅ Artifact distribution paths configured
- ✅ Session history preserved from ideation phase

**Ready for B2 Implementation Phase**

---

**Implementation Authority:** workspace-architect during B1_02 phase  
**Integration Reference:** 001-WORKFLOW-NORTH-STAR.md B1_02 procedures
**Template Version:** 1.0 - Production Ready

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-29T12:00:00Z -->