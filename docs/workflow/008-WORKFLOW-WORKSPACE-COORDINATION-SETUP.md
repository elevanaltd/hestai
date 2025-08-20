# Workspace Coordination Infrastructure Setup

// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: [008-sequence-numbering] [workflow-directory-placement] [workspace-setup-implementation-guide]
// Consultation ID: cf5cf6c5-d3ba-4f70-8abb-323978e28cb7

**Status:** Production  
**Purpose:** Implementation guide for workspace-architect to set up two-repository coordination infrastructure  
**Scope:** All HestAI projects requiring coordination/build separation  
**Authority:** Implements Project Coordination Pattern (007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md)

## Overview

This guide enables workspace-architect to quickly set up the two-repository coordination structure during B1 workspace creation. Provides step-by-step commands, validation procedures, and handoff protocols.

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
PROJECT_NAME="your-project-name"
PROJECT_BASE="/Volumes/HestAI-Projects/${PROJECT_NAME}"

# Create project structure
mkdir -p "${PROJECT_BASE}"/{coordination,build}
cd "${PROJECT_BASE}"

# Initialize coordination repository (private)
cd coordination
git init
git config user.email "workspace-architect@hestai.local"
git config user.name "HestAI Workspace Architect"

# Initialize build repository (public)
cd ../build
git init
git config user.email "workspace-architect@hestai.local"
git config user.name "HestAI Workspace Architect"

# Configure build repo gitignore
echo ".coord/" >> .gitignore
echo "worktrees/" >> .gitignore
```

### Coordination Repository Setup
```bash
cd "${PROJECT_BASE}/coordination"

# Create PROJECT_CONTEXT.md
cat > PROJECT_CONTEXT.md << EOF
# Project Context: ${PROJECT_NAME}

**Current Phase:** B1 Workspace Creation  
**Last Updated:** $(date +%Y-%m-%d)

## Current Priorities
- Complete workspace setup and initial tooling
- Finalize technology stack decisions
- Establish development workflow

## Active Blockers
- None (initial setup)

## Key Links
- [Build Repository README](../build/README.md)
- [Implementation Log](../build/docs/xxx-PROJECT-IMPLEMENTATION-LOG.md)

## Team
- **Project Lead:** [To be assigned]
- **Technical Lead:** [To be assigned]
- **Workspace Architect:** workspace-architect (setup phase)
EOF

# Create CHARTER.md
cat > CHARTER.md << EOF
# Project Charter: ${PROJECT_NAME}

**Created:** $(date +%Y-%m-%d)  
**Status:** Active Development

## Objectives
[Project goals and success criteria - to be filled by project team]

## Scope
[What's included and excluded - to be filled by project team]

## Stakeholders
[Key stakeholders and their roles - to be filled by project team]

## Success Metrics
[How success will be measured - to be filled by project team]

## Notes
This charter was created during workspace setup. Project team should review and update all sections marked [to be filled] during first team meeting.
EOF

# Create ASSIGNMENTS.md
cat > ASSIGNMENTS.md << EOF
# Team Assignments: ${PROJECT_NAME}

**Last Updated:** $(date +%Y-%m-%d)

## Core Team
- **Project Lead:** [To be assigned]
- **Technical Lead:** [To be assigned]
- **Implementation Team:** [To be assigned]

## Specialist Consultants
- **Critical Engineer:** [As needed for architecture decisions]
- **Security Specialist:** [As needed for security review]
- **Test Guardian:** [As needed for testing discipline]

## Phase Assignments

### B1 Workspace Creation (Current)
- **Workspace Architect:** workspace-architect
- **Responsibility:** Infrastructure setup, initial repository structure

### B2+ Implementation (Pending)
- **Assignments:** To be determined by project lead
- **Dependencies:** Technology stack decisions, team availability

## Notes
Initial assignments created during workspace setup. Project lead should review and finalize all team assignments.
EOF

# Create coordination README
cat > README.md << EOF
# ${PROJECT_NAME} - Project Coordination

This repository contains project coordination artifacts for ${PROJECT_NAME}.

## Purpose
- Project management documents (context, charter, assignments)
- Private project information (not suitable for public build repo)
- Live coordination data shared across all build worktrees

## Structure
- \`PROJECT_CONTEXT.md\` - Current phase, priorities, blockers
- \`CHARTER.md\` - Project objectives and scope
- \`ASSIGNMENTS.md\` - Team assignments and responsibilities

## Access Pattern
Build worktrees access these files via \`.coord/\` symlinks:
- \`build/worktrees/{feature}/.coord/\` → \`coordination/\`

## Maintenance
- Update PROJECT_CONTEXT.md as project progresses
- Review ASSIGNMENTS.md when team changes
- Charter typically stable after initial project setup

---
**Repository Type:** Private coordination  
**Created:** $(date +%Y-%m-%d) by workspace-architect  
**Pattern:** [Project Coordination Pattern](../../docs/workflow/007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md)
EOF

# Initial commit
git add .
git commit -m "feat: initial project coordination structure

- PROJECT_CONTEXT.md with B1 phase status
- CHARTER.md template for project team completion
- ASSIGNMENTS.md with workspace setup responsibilities
- README.md documenting coordination pattern usage

Created by workspace-architect during B1 workspace creation.
Project team should review and update marked sections."
```

### Build Repository Setup
```bash
cd "${PROJECT_BASE}/build"

# Create CLAUDE.md with project instructions
cat > CLAUDE.md << EOF
# ${PROJECT_NAME} Development Instructions

**Project:** ${PROJECT_NAME}  
**Repository:** \`/Volumes/HestAI-Projects/${PROJECT_NAME}/build/\`  
**Last Updated:** $(date +%Y-%m-%d)

These instructions guide Claude Code in developing the ${PROJECT_NAME} system following HestAI organizational standards.

## Project Context & Constraints

### Current Status
- **Phase:** B1 Workspace Creation (initial setup)
- **Technology Stack:** [To be determined]
- **Architecture:** [To be determined]

Refer to \`.coord/PROJECT_CONTEXT.md\` for current phase and priorities.

## Development Standards

### TRACED Protocol Compliance
All development activities must follow TRACED protocol with evidence receipts:

- **T**est: RED-GREEN-REFACTOR cycle, failing tests before implementation
- **R**eview: Code review specialist consultation for all changes
- **A**nalyze: Critical engineer consultation for architectural decisions
- **C**onsult: Specialist consultation at mandatory trigger points
- **E**xecute: Quality gates (lint, typecheck, tests) with CI/CD evidence
- **D**ocument: TodoWrite throughout, Implementation Log updates

### Quality Gates
- **TDD Mandatory:** Write failing test before implementation
- **No Code Without Tests:** All new files must have corresponding test files
- **Coverage Diagnostic:** 80% guideline (not gate), focus on behavior validation
- **Evidence Required:** Links to CI jobs, review comments, test execution receipts

### Consultation Triggers
- **Architecture decisions:** \`technical-architect\` or \`critical-engineer\`
- **Code changes:** \`code-review-specialist\`
- **Testing issues:** \`testguard\` (mandatory for test manipulation prevention)
- **Complex systems:** \`complexity-guard\` for >3 layers
- **North Star conflicts:** \`requirements-steward\`

## File Organization & Naming

### Directory Structure
\`\`\`
build/                       # Git repository root
├── src/                     # Source code (structure TBD)
├── tests/                   # Test suites
├── docs/                    # Implementation artifacts
│   ├── adr/                 # Architectural Decision Records
│   └── xxx-PROJECT-IMPLEMENTATION-LOG.md
├── README.md
└── CLAUDE.md               # This file
\`\`\`

### Naming Conventions
- **Implementation Docs:** \`{CATEGORY}{NN}-{CONTEXT}[-{QUALIFIER}]-{NAME}.{EXT}\`
- **ADR Files:** Follow organizational naming pattern
- **Source Files:** [To be determined in B2+ phases]

## Reference Documentation

### Project Coordination
- [PROJECT_CONTEXT](.coord/PROJECT_CONTEXT.md)
- [CHARTER](.coord/CHARTER.md)  
- [ASSIGNMENTS](.coord/ASSIGNMENTS.md)

### Organizational Standards
- [HestAI Complete Workflow](/Volumes/HestAI/docs/HESTAI_COMPLETE_WORKFLOW.md)
- [Agent Capability Lookup](/Volumes/HestAI/docs/guides/AGENT_CAPABILITY_LOOKUP.oct.md)
- [Project Coordination Pattern](/Volumes/HestAI/docs/workflow/007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md)

## Git Workflow

### Repository Status
- **Initialized:** Yes (main branch)
- **Remote:** [To be configured]
- **Branch Strategy:** [To be defined in B2+ phases]

### Commit Standards
- **Format:** Conventional commits (feat|fix|docs|style|refactor|test|chore)
- **Atomic:** One task = one commit
- **Evidence Links:** Reference CI jobs, review comments in commit messages

---

**Development Team:** Update this document as project evolves  
**Review Cycle:** Each phase transition and major decision  
**Enforcement:** TRACED protocol validation and quality gates
EOF

# Create build README
cat > README.md << EOF
# ${PROJECT_NAME} - Build Repository

This repository contains the implementation code and build artifacts for ${PROJECT_NAME}.

## Project Status
**Current Phase:** B1 Workspace Creation  
**Technology Stack:** [To be determined]

See [\`CLAUDE.md\`](./CLAUDE.md) for complete development instructions.

## Project Coordination
Project coordination files are accessed via \`.coord/\` symlinks in worktrees:
- Current phase and priorities: \`.coord/PROJECT_CONTEXT.md\`
- Project objectives and scope: \`.coord/CHARTER.md\`
- Team assignments: \`.coord/ASSIGNMENTS.md\`

## Repository Structure
\`\`\`
build/
├── src/                # Source code (structure TBD)
├── tests/              # Test suites
├── docs/               # Implementation artifacts
├── worktrees/          # Crystal.app creates feature worktrees here
├── README.md          # This file
├── CLAUDE.md          # Development instructions
└── .gitignore         # Excludes .coord/ symlinks
\`\`\`

## Getting Started

### For Development Work
1. Create feature worktree with Crystal.app
2. Run \`/role {appropriate-role}\` in worktree
3. Workspace setup automatically creates \`.coord/\` symlink
4. Access project coordination via \`.coord/\` files

### For Project Management
- Coordination files are in separate private repository
- Updates to coordination automatically visible in all worktrees
- No duplication or sync issues

## Quality Standards
- TRACED protocol compliance required
- TDD methodology mandatory
- Code review and specialist consultation as appropriate
- Evidence-based quality gates

---
**Repository Type:** Public build  
**Created:** $(date +%Y-%m-%d) by workspace-architect  
**Pattern:** [Project Coordination Pattern](../coordination/../docs/workflow/007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md)
EOF

# Create docs directory with placeholder
mkdir -p docs/adr

# Create implementation log placeholder
cat > docs/201-PROJECT-${PROJECT_NAME^^}-IMPLEMENTATION-LOG.md << EOF
# ${PROJECT_NAME} Implementation Log

**Project:** ${PROJECT_NAME}  
**Created:** $(date +%Y-%m-%d)  
**Maintained by:** Implementation team

## Purpose
This log tracks implementation decisions, technical choices, and development progress for ${PROJECT_NAME}.

## Implementation Progress

### B1 Workspace Creation - $(date +%Y-%m-%d)
- **Completed by:** workspace-architect
- **Deliverables:**
  - ✅ Two-repository coordination structure
  - ✅ Initial CLAUDE.md with development standards
  - ✅ Project coordination templates
  - ✅ Git repository initialization
  - ✅ Crystal.app worktree compatibility

### B2+ Implementation Phases
*To be updated by implementation team*

## Technical Decisions
*Implementation team should document major technical decisions here*

## Architecture Evolution
*Track architectural changes and decisions*

## Quality Metrics
*Record test coverage, performance metrics, quality gate results*

---
**Update Frequency:** After each major milestone or technical decision  
**Audience:** Development team, technical stakeholders  
**Format:** Chronological log with clear decision rationale
EOF

# Initial commit
git add .
git commit -m "feat: initial build repository structure

- CLAUDE.md with HestAI development standards
- README.md documenting repository purpose and structure
- .gitignore configured for coordination pattern
- docs/ directory with implementation log placeholder
- Crystal.app worktree compatibility

Created by workspace-architect during B1 workspace creation.
Ready for project team to begin implementation work."
```

## Validation Checklist

### Repository Structure Verification
```bash
cd "${PROJECT_BASE}"

echo "=== Repository Structure Validation ==="
echo "✓ Project structure:"
tree -L 3 . 2>/dev/null || find . -type d -maxdepth 3 | sort

echo -e "\n✓ Coordination repository:"
ls -la coordination/

echo -e "\n✓ Build repository:"
ls -la build/

echo -e "\n✓ Git status - coordination:"
cd coordination && git status --porcelain
echo "Coordination commits:" && git log --oneline

echo -e "\n✓ Git status - build:"
cd ../build && git status --porcelain
echo "Build commits:" && git log --oneline
```

### Symlink Infrastructure Test
```bash
cd "${PROJECT_BASE}/build"

echo "=== Symlink Infrastructure Test ==="
mkdir -p worktrees/test-setup
cd worktrees/test-setup

# Simulate workspace setup (normally done by /role command)
if [ -d "../../../coordination" ]; then
  ln -sfn ../../../coordination .coord
  echo "✓ Test symlink created: .coord → ../../../coordination"
else
  echo "❌ Coordination repository not found"
  exit 1
fi

# Verify access
echo "✓ Symlink target:" && readlink .coord
echo "✓ Coordination files accessible:"
ls -la .coord/
echo "✓ PROJECT_CONTEXT.md preview:"
head -n 5 .coord/PROJECT_CONTEXT.md

# Cleanup test
cd .. && rm -rf test-setup
echo "✓ Test cleanup completed"
```

### Content Validation
```bash
echo "=== Content Validation ==="

# Check required coordination files
COORD_FILES=("PROJECT_CONTEXT.md" "CHARTER.md" "ASSIGNMENTS.md" "README.md")
for file in "${COORD_FILES[@]}"; do
  if [ -f "${PROJECT_BASE}/coordination/${file}" ]; then
    echo "✅ coordination/${file} exists"
  else
    echo "❌ coordination/${file} missing"
  fi
done

# Check required build files
BUILD_FILES=("README.md" "CLAUDE.md" ".gitignore")
for file in "${BUILD_FILES[@]}"; do
  if [ -f "${PROJECT_BASE}/build/${file}" ]; then
    echo "✅ build/${file} exists"
  else
    echo "❌ build/${file} missing"
  fi
done

# Check .gitignore content
echo "✓ .gitignore contains coordination exclusions:"
grep -E "(\.coord/|worktrees/)" "${PROJECT_BASE}/build/.gitignore"
```

## Common Setup Issues

### Issue: "Permission denied" during git init
**Symptoms:** Git initialization fails with permission errors
**Cause:** Incorrect directory permissions or disk space
**Resolution:**
```bash
# Check permissions
ls -la /Volumes/HestAI-Projects/
chmod 755 /Volumes/HestAI-Projects/${PROJECT_NAME}

# Check disk space
df -h /Volumes/HestAI-Projects/
```

### Issue: "Project already exists"
**Symptoms:** Directory creation fails, project path occupied
**Cause:** Previous incomplete setup or naming conflict
**Resolution:**
```bash
# Check what exists
ls -la /Volumes/HestAI-Projects/${PROJECT_NAME}/

# If incomplete setup, remove and restart
rm -rf /Volumes/HestAI-Projects/${PROJECT_NAME}
# Then restart setup process
```

### Issue: Symlink test fails
**Symptoms:** Cannot access coordination files through symlink
**Cause:** Incorrect relative path or missing coordination repository
**Resolution:**
```bash
cd "${PROJECT_BASE}/build/worktrees/test-setup"

# Check symlink path
readlink .coord
# Should show: ../../../coordination

# Verify target exists
ls -la ../../../coordination/
# Should list coordination files

# Recreate symlink if incorrect
rm .coord
ln -sfn ../../../coordination .coord
```

### Issue: Git commits fail
**Symptoms:** Git operations hang or fail with authentication errors
**Cause:** Git configuration missing or incorrect
**Resolution:**
```bash
# Set local git config
cd "${PROJECT_BASE}/coordination"
git config user.email "workspace-architect@hestai.local"
git config user.name "HestAI Workspace Architect"

cd "${PROJECT_BASE}/build"
git config user.email "workspace-architect@hestai.local"  
git config user.name "HestAI Workspace Architect"
```

## Handoff Protocol

### Workspace Architect Responsibilities (Complete)
- ✅ Two-repository structure created
- ✅ Initial coordination templates provided
- ✅ Build repository configured for development
- ✅ Crystal.app worktree compatibility verified
- ✅ Documentation structure established

### Project Team Responsibilities (Next Steps)
1. **Project Lead:**
   - Review and complete coordination templates
   - Update CHARTER.md with project-specific objectives
   - Finalize team assignments in ASSIGNMENTS.md
   - Schedule initial team meeting

2. **Technical Lead:**
   - Review CLAUDE.md development standards
   - Make technology stack decisions
   - Update PROJECT_CONTEXT.md with technical priorities
   - Plan B2 implementation approach

3. **Implementation Team:**
   - Familiarize with coordination pattern
   - Test worktree creation and symlink access
   - Begin implementation work following TRACED protocol
   - Update implementation log with progress

### Transition Checklist
- [ ] Project lead contacted about workspace completion
- [ ] Access to coordination repository confirmed
- [ ] Team assignments communicated
- [ ] CLAUDE.md reviewed by technical lead
- [ ] Next phase planning scheduled
- [ ] workspace-architect responsibilities concluded

## Integration with Crystal Worktrees

### Automatic Workspace Setup
The `/role` command automatically creates `.coord` symlinks:
```bash
# In /Users/shaunbuswell/.claude/commands/role.md
if [ -d "../../../coordination" ]; then
  if [ ! -e ".coord" ]; then
    ln -sfn ../../../coordination .coord
    echo "✓ Coordination linked: .coord → ../../../coordination"
  fi
fi
```

### Enforcement Hook
Hook prevents role activation without coordination access:
```bash
# /Users/shaunbuswell/.claude/hooks/enforce-workspace-setup.sh
# Blocks role file reading until workspace setup complete
```

### Expected Workflow
1. Crystal.app creates worktree: `build/worktrees/{feature-name}/`
2. Developer runs `/role {role-name}`
3. Workspace setup executes automatically
4. Symlink created: `.coord → ../../../coordination`
5. Role activation proceeds with coordination access

## Troubleshooting Reference

### Diagnostic Commands
```bash
# Check project structure
find /Volumes/HestAI-Projects/${PROJECT_NAME} -type d -maxdepth 3

# Verify git repositories
cd /Volumes/HestAI-Projects/${PROJECT_NAME}/coordination && git status
cd /Volumes/HestAI-Projects/${PROJECT_NAME}/build && git status

# Test symlink creation
cd /Volumes/HestAI-Projects/${PROJECT_NAME}/build
mkdir -p worktrees/diagnostic
cd worktrees/diagnostic
ln -sfn ../../../coordination .coord
ls -la .coord/
```

### Recovery Commands
```bash
# Reset coordination repository
cd /Volumes/HestAI-Projects/${PROJECT_NAME}/coordination
git reset --hard HEAD
git clean -fd

# Reset build repository  
cd /Volumes/HestAI-Projects/${PROJECT_NAME}/build
git reset --hard HEAD
git clean -fd

# Recreate symlink
cd worktrees/{feature}
rm -f .coord
ln -sfn ../../../coordination .coord
```

## Success Metrics

### Immediate Success (Setup Complete)
- ✅ Two repositories initialized with correct structure
- ✅ Coordination templates contain project-specific information
- ✅ Build repository configured for development standards
- ✅ Symlink infrastructure tested and working
- ✅ Git commits successful in both repositories

### Operational Success (First Week)
- [ ] Project team successfully accesses coordination files
- [ ] First feature worktree created and tested
- [ ] Role activation works with coordination access
- [ ] No symlink or access issues reported
- [ ] Team updates coordination templates

### Integration Success (First Month)
- [ ] Multiple worktrees using coordination pattern
- [ ] No maintenance required for symlink infrastructure
- [ ] Project team comfortable with pattern
- [ ] Quality standards implemented in build repository
- [ ] Implementation log actively maintained

---

**Authority:** workspace-architect role  
**Implementation:** B1 workspace creation phase  
**Pattern Reference:** [007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md](007-WORKFLOW-PROJECT-COORDINATION-PATTERN.md)  
**Support:** Contact system-steward for pattern modifications or issues