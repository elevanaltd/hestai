# Workflow Directory Structure

**Status:** Final  
**Purpose:** Define directory organization separating HestAI organizational standards from project execution  
**Scope:** All HestAI repositories and project structures  
**Authority:** Eliminates nesting confusion and establishes clear boundaries

## Problem Statement

Previous structure created unnecessary nesting:
```
/Volumes/HestAI/builds/eav-orchestrator/  (bridge)
/Volumes/HestAI/builds/eav-orchestrator/??? (actual code repo)
```

This resulted in 4+ levels of nesting to reach actual work and confusion between organizational standards and project artifacts.

## Solution Architecture

### Two-Repository Separation

**HestAI Repository: Organizational Standards**
```
/Volumes/HestAI/
├── docs/                              # EXTERNAL - org workflows & roles
│   ├── 001-WORKFLOW-NORTH-STAR.md
│   ├── 101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md
│   ├── 103-DOC-OCTAVE-COMPRESSION-RULES.md
│   ├── 104-DOC-ENFORCEMENT-GATES.md
│   └── 005-WORKFLOW-DIRECTORY-STRUCTURE.md
├── reports/                           # Organizational analyses
├── sessions/                          # Cross-project strategy sessions
└── builds/ → DEPRECATED (migrate to HestAI-Projects)
```

**HestAI-Projects Repository: Project Execution**
```
/Volumes/HestAI-Projects/
├── eav-orchestrator/
│   ├── docs/                          # BRIDGE - project state index only
│   │   ├── PROJECT_CONTEXT.md         # Current phase, priorities, links
│   │   └── 201-PROJECT-NORTH-STAR.md  # If project needs own North Star
│   ├── build/                         # IN-REPO - Git repository root
│   │   ├── src/                       # Source code
│   │   ├── tests/                     # Test suites
│   │   ├── docs/                      # Code-coupled documentation
│   │   │   ├── 201-PROJECT-B0-VAD.md
│   │   │   ├── 201-PROJECT-B1-BUILD-PLAN.md
│   │   │   ├── 201-PROJECT-IMPLEMENTATION-LOG.md
│   │   │   └── adr/                   # Architectural Decision Records
│   │   ├── README.md                  # Project overview
│   │   └── CLAUDE.md                  # Development instructions
│   └── sessions/                      # Project conversations
│       └── 2025-08-xx-SESSION-NAME/
└── other-project/
    ├── docs/
    ├── build/
    └── sessions/
```

## Bridge vs. Truth Boundaries

### Bridge Documents (HestAI-Projects/{project}/docs/)

**Purpose:** State index and navigation - NOT content storage

**Allowed Content:**
- `PROJECT_CONTEXT.md` - Current phase, priorities, blockers, links
- `2xx-PROJECT-NORTH-STAR.md` - Only if project needs own immutable requirements
- Index files linking to build/docs/ content

**Forbidden Content:**
- Implementation details (belongs in build/docs/)
- Duplicate specifications or plans
- Detailed documentation (use links to build/docs/)
- Development logs or decision records

**Example PROJECT_CONTEXT.md:**
```markdown
# Project Context: EAV Orchestrator

**Current Phase:** B2 Implementation  
**Last Updated:** 2025-08-19

## Current Priorities
- Complete user authentication module
- Implement data validation layer
- Set up CI/CD pipeline

## Active Blockers
- Waiting for Supabase schema approval
- Performance testing environment needed

## Key Links
- [Build Repository README](./build/README.md)
- [Implementation Log](./build/docs/201-PROJECT-IMPLEMENTATION-LOG.md)
- [Build Plan](./build/docs/201-PROJECT-B1-BUILD-PLAN.md)
- [Architecture Decisions](./build/docs/adr/)

## Team
- **Implementation Lead:** [Assignment]
- **Technical Architect:** [Assignment]
```

### Truth Documents (HestAI-Projects/{project}/build/docs/)

**Purpose:** Single source of truth for all implementation artifacts

**Required Content:**
- Implementation logs with evidence receipts
- Build plans and task breakdowns
- Architectural Decision Records (ADR)
- Code-coupled documentation
- Technical specifications

**Git Integration:**
- `build/` directory is the Git repository root
- All implementation artifacts version with code
- Links from bridge docs point here
- No content duplication between bridge and build

## Naming Compliance

### Bridge Documents
- Follow organizational naming: `{CATEGORY}{NN}-{CONTEXT}-{NAME}.md`
- Example: `201-PROJECT-NORTH-STAR.md`

### Build Documents
- Follow same naming pattern within build/docs/
- ADRs in build/docs/adr/ with consistent naming
- Implementation logs track all development evidence

## Migration Strategy

### For New Projects
1. Create project folder in HestAI-Projects/
2. Set up bridge docs/ with PROJECT_CONTEXT.md
3. Initialize build/ as Git repository
4. Place all implementation artifacts in build/docs/
5. Configure sessions/ for project conversations

### For Existing Projects
- No migration required initially
- New projects use correct structure
- Existing builds migrate when convenient
- Maintain current workflows during transition

## Enforcement

### Automated Validation
- Bridge docs must link, not duplicate content
- Build docs contain all implementation truth
- No cross-contamination between bridge and build
- Proper naming pattern enforcement

### Quality Gates
- Bridge docs stay under 2 pages total
- All substantial content lives in build/docs/
- Links verified during CI/CD
- No orphaned documentation

## Benefits

### Eliminated Problems
- **Nesting Confusion:** Maximum 3 levels to reach code
- **Dual Truth:** Clear boundary between index and content
- **Context Mixing:** Project sessions isolated from organizational
- **Git Complexity:** Clean repository boundaries

### Operational Advantages
- **Clear Separation:** Organizational vs. project concerns
- **Scalable Structure:** Easy to add new projects
- **Git Simplicity:** Each build is clean repository
- **Session Locality:** Conversations belong with projects

## Success Metrics

### Immediate (Week 1)
- New projects follow structure 100%
- Bridge docs remain index-only
- No content duplication detected

### Medium Term (Month 1)
- Navigation time to relevant docs <30 seconds
- Zero confusion about document location
- Clean Git history in build repositories

### Long Term (Quarter 1)
- All projects using consistent structure
- Documentation findability score >90%
- Developer onboarding time reduced 50%

---

**Implementation Authority:** System Steward  
**Enforcement:** Directory structure validation hooks  
**Review Cycle:** Structure effectiveness quarterly assessment