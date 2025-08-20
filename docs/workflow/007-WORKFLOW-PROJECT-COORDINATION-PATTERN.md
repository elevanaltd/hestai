# Project Coordination Pattern

// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: [007-sequence-numbering] [workflow-directory-placement] [comprehensive-pattern-documentation]

**Status:** Production  
**Purpose:** Solve coordination vs build artifact separation while maintaining LLM access to project management documents  
**Scope:** All HestAI projects using Crystal.app worktrees  
**Authority:** Standardizes project setup, replaces complex submodule patterns

## Problem Statement

LLMs working in Crystal.app worktrees need access to:
- Project coordination artifacts (PROJECT_CONTEXT.md, CHARTER.md, ASSIGNMENTS.md)
- Live project management documents (not stale copies)
- Private project management information (not in public repos)

**Challenges Solved:**
- Coordination docs must remain private (separate from public build repos)
- Crystal.app creates isolated worktrees deep in directory structures
- Multiple worktrees need access to same live coordination files
- LLMs don't reliably read CLAUDE.md instructions for manual setup
- Previous submodule approaches were complex and error-prone

## Solution Architecture

### Two-Repository Pattern

**Project Structure:**
```
/Volumes/HestAI-Projects/{project-name}/
├── coordination/           # Private git repo for project management
│   ├── .git/              # Private git repository
│   ├── PROJECT_CONTEXT.md  # Current phase, priorities, blockers
│   ├── CHARTER.md         # Project charter and objectives
│   ├── ASSIGNMENTS.md     # Team assignments and responsibilities
│   └── README.md          # Coordination repo overview
│
└── build/                  # Public git repo for code
    ├── .git/              # Public git repository
    ├── src/               # Source code
    ├── tests/             # Test suites  
    ├── docs/              # Implementation artifacts
    ├── README.md          # Build repo overview
    ├── CLAUDE.md          # Development instructions
    ├── .gitignore         # Must include: .coord/
    └── worktrees/         # Crystal.app creates these
        └── {feature}/     # LLM works here
            ├── .coord/    # SYMLINK → ../../../coordination
            └── (code)     # Feature implementation
```

### Key Innovation: Automatic Symlink Creation

**The Path Logic:**
- Worktree location: `build/worktrees/{feature}/`
- Coordination location: `coordination/`
- Required symlink: `.coord → ../../../coordination`
- Path traversal: worktree → worktrees → build → project → coordination

**Why Symlinks, Not Copies:**
- **Zero Maintenance:** Updates appear instantly across all worktrees
- **Single Source of Truth:** No synchronization issues
- **Live Data:** Real-time coordination changes visible to all LLMs
- **Git Safe:** Symlinks don't interfere with either repository

## Implementation Components

### 1. Automatic Workspace Setup

**Location:** `/Users/shaunbuswell/.claude/commands/role.md`

**Function:** BEFORE role activation, automatically:
```bash
if [ -d "../../../coordination" ]; then
  if [ ! -e ".coord" ]; then
    ln -sfn ../../../coordination .coord
    echo "✓ Coordination linked: .coord → ../../../coordination"
  else
    echo "✓ Coordination already linked"
  fi
else
  echo "ℹ️  No coordination repository found (working outside project context)"
fi
```

**Behavior:**
- Runs silently if no coordination repo exists (for non-project work)
- Creates symlink if coordination repo present but link missing
- Reports status but doesn't fail if already linked
- Integrates seamlessly with existing role activation workflow

### 2. Enforcement Hook

**Location:** `/Users/shaunbuswell/.claude/hooks/enforce-workspace-setup.sh`

**Function:** Blocks role file reading until workspace setup complete

**Trigger Conditions:**
- Tool: Read
- File: `*.oct.md` in `/agents/` directory (role activation attempt)
- Missing: `.coord` symlink when `../../../coordination` exists

**Enforcement Action:**
```
🚨 WORKSPACE SETUP REQUIRED

❌ Missing coordination link: .coord → ../../../coordination

REQUIRED ACTION:
Run workspace setup first:
[provides exact commands]

Then retry role activation.
```

**Purpose:** Ensures coordination access is available during role execution, prevents LLMs from proceeding without project context.

### 3. Git Repository Configuration

**Build Repository (.gitignore):**
```
# Project Coordination Pattern
.coord/
```

**Coordination Repository:**
- Standard private git repository
- Contains all project management artifacts
- No special configuration required
- Shared across all build worktrees via symlinks

## Setting Up a New Project

### Step 1: Create Project Structure
```bash
mkdir -p /Volumes/HestAI-Projects/{project-name}/{coordination,build}
cd /Volumes/HestAI-Projects/{project-name}
```

### Step 2: Initialize Repositories
```bash
# Initialize coordination repo
cd coordination
git init
echo "# Project Coordination" > README.md

# Initialize build repo  
cd ../build
git init
echo ".coord/" >> .gitignore
echo "# Project Build" > README.md
```

### Step 3: Create Coordination Artifacts
```bash
cd coordination

# PROJECT_CONTEXT.md
cat > PROJECT_CONTEXT.md << 'EOF'
# Project Context: {Project Name}

**Current Phase:** D1 Planning  
**Last Updated:** YYYY-MM-DD

## Current Priorities
- [Define current focus areas]

## Active Blockers
- [List any blocking issues]

## Key Links
- [Build Repository README](../build/README.md)
- [Implementation Log](../build/docs/xxx-PROJECT-IMPLEMENTATION-LOG.md)

## Team
- **Project Lead:** [Assignment]
- **Technical Lead:** [Assignment]
EOF

# CHARTER.md
cat > CHARTER.md << 'EOF'
# Project Charter: {Project Name}

## Objectives
[Project goals and success criteria]

## Scope
[What's included and excluded]

## Stakeholders
[Key stakeholders and their roles]

## Success Metrics
[How success will be measured]
EOF

# ASSIGNMENTS.md
cat > ASSIGNMENTS.md << 'EOF'
# Team Assignments: {Project Name}

## Core Team
- **Project Lead:** [Name/Role]
- **Technical Lead:** [Name/Role]
- **Implementation Team:** [Names/Roles]

## Specialist Consultants
- **Critical Engineer:** [As needed]
- **Security Specialist:** [As needed]
- **Test Guardian:** [As needed]

## Phase Assignments
[Current phase specific assignments]
EOF
```

### Step 4: Configure Build Repository
```bash
cd ../build

# CLAUDE.md with project-specific instructions
cat > CLAUDE.md << 'EOF'
# {Project Name} Development Instructions

**Project:** {Project Name}  
**Repository:** `/Volumes/HestAI-Projects/{project-name}/build/`  
**Last Updated:** YYYY-MM-DD

## Project Context
Refer to `.coord/PROJECT_CONTEXT.md` for current phase and priorities.

## Development Standards
[Project-specific development guidelines]

## Reference Documentation
- [PROJECT_CONTEXT](.coord/PROJECT_CONTEXT.md)
- [CHARTER](.coord/CHARTER.md)  
- [ASSIGNMENTS](.coord/ASSIGNMENTS.md)
EOF
```

### Step 5: Test the Setup
```bash
cd build
mkdir -p worktrees/test-feature
cd worktrees/test-feature

# Simulate workspace setup (normally done by /role command)
if [ -d "../../../coordination" ]; then
  ln -sfn ../../../coordination .coord
  echo "✓ Test setup successful"
fi

# Verify access
ls -la .coord/
cat .coord/PROJECT_CONTEXT.md
```

## How It Works

### Crystal.app Workflow Integration

1. **Crystal creates worktree:** `build/worktrees/{feature-name}/`
2. **LLM runs /role command:** Workspace setup executes before role activation
3. **Symlink created:** `.coord → ../../../coordination`
4. **Role activation:** Hook verifies setup before allowing role file access
5. **Work begins:** LLM has access to live coordination artifacts

### Path Resolution Example

**Worktree location:** `/Volumes/HestAI-Projects/eav-orchestrator/build/worktrees/script-module/`

**Symlink path breakdown:**
- `../` → `worktrees/`
- `../../` → `build/`  
- `../../../` → `eav-orchestrator/`
- `../../../coordination` → `eav-orchestrator/coordination/`

**Result:** `.coord/PROJECT_CONTEXT.md` resolves to live coordination file

### File Access Patterns

**From LLM perspective in worktree:**
```bash
# Access coordination files
cat .coord/PROJECT_CONTEXT.md
cat .coord/CHARTER.md
cat .coord/ASSIGNMENTS.md

# Normal build repo access
cat README.md
cat CLAUDE.md
cat docs/xxx-IMPLEMENTATION-LOG.md
```

**From build repo root:**
```bash
# Coordination not directly accessible (by design)
# Must work through worktree symlinks
cd worktrees/some-feature
cat .coord/PROJECT_CONTEXT.md
```

## Enforcement and Validation

### Automatic Enforcement

**Hook Triggers:**
- ANY role activation attempt
- Detects missing `.coord` when coordination repo exists
- Blocks with clear instructions if setup incomplete

**Error Prevention:**
- Cannot activate role without coordination access
- Cannot skip workspace setup accidentally
- Clear recovery instructions provided

### Manual Validation

**Verify Setup:**
```bash
cd /Volumes/HestAI-Projects/{project}/build/worktrees/{feature}

# Check symlink exists and points correctly
ls -la .coord
readlink .coord

# Verify coordination access
cat .coord/PROJECT_CONTEXT.md
```

**Troubleshooting:**
```bash
# If symlink missing or broken
rm -f .coord
ln -sfn ../../../coordination .coord

# If coordination repo missing
echo "Working outside project context (normal for some tasks)"
```

## Benefits and Rationale

### Problems Eliminated

**Complex Submodules:** 
- Previous approach required git submodule management
- Submodules create sync issues and complexity
- Symlinks are simpler and more reliable

**Manual Setup Overhead:**
- LLMs don't reliably follow CLAUDE.md instructions
- Automatic setup ensures consistency
- Hook enforcement prevents skipped setup

**Stale Information:**
- Copied files become outdated quickly
- Symlinks provide live data access
- Zero maintenance coordination

**Context Isolation:**
- Worktrees were isolated from project management context
- Coordination artifacts now available in every worktree
- Consistent project context across all work sessions

### Operational Advantages

**Zero Maintenance:**
- Symlinks automatically reflect coordination changes
- No synchronization required between worktrees
- Live updates visible immediately

**Privacy Preservation:**
- Coordination repo remains private
- Build repo can be public without exposing sensitive information
- Clean separation of concerns

**Developer Experience:**
- Automatic setup with `/role` command
- Clear error messages if setup incomplete
- Familiar file access patterns

**Scalability:**
- Pattern works for any number of worktrees
- Each worktree gets same coordination access
- No performance impact from multiple symlinks

## File Organization Standards

### Coordination Repository Files

**Required Files:**
- `PROJECT_CONTEXT.md` - Current phase, priorities, blockers, key links
- `CHARTER.md` - Project objectives, scope, stakeholders
- `ASSIGNMENTS.md` - Team assignments and responsibilities
- `README.md` - Coordination repository overview

**Optional Files:**
- Meeting notes and decision logs
- Stakeholder communication records
- Project-specific templates
- Phase transition checklists

**Naming Pattern:**
- Follow organizational naming standards
- Use descriptive, stable names
- Avoid date-based naming (coordination is ongoing)

### Build Repository Integration

**Required Configuration:**
- `.gitignore` must include `.coord/`
- `CLAUDE.md` should reference `.coord/` files
- No duplication of coordination content

**Access Patterns:**
```markdown
# In CLAUDE.md
## Project Context
Refer to `.coord/PROJECT_CONTEXT.md` for current phase and priorities.

## Team Assignments  
Current team assignments are in `.coord/ASSIGNMENTS.md`.

## Project Charter
Project objectives and scope defined in `.coord/CHARTER.md`.
```

## Testing and Validation

### Production Test Case

**Location:** `/Volumes/HestAI-Projects/test-project/`

**Structure Verification:**
```bash
test-project/
├── coordination/          # ✓ Private git repo
│   ├── ASSIGNMENTS.md     # ✓ Team assignments
│   ├── CHARTER.md         # ✓ Project charter
│   ├── PROJECT_CONTEXT.md # ✓ Current context
│   └── README.md          # ✓ Coordination overview
└── build/                 # ✓ Public git repo
    ├── worktrees/         # ✓ Crystal.app worktrees
    │   ├── test-co-ord-1/ # ✓ Test worktree 1
    │   ├── test-co-ord-2/ # ✓ Test worktree 2
    │   └── test-co-ord-3/ # ✓ Test worktree 3
    ├── .gitignore         # ✓ Contains .coord/
    ├── CLAUDE.md          # ✓ References .coord/
    └── README.md          # ✓ Build overview
```

**Functional Testing:**
1. Create new worktree with Crystal.app
2. Run `/role {some-role}` 
3. Verify workspace setup executes
4. Confirm `.coord` symlink created
5. Validate coordination file access
6. Test role activation succeeds

### Integration Points

**Crystal.app Compatibility:**
- ✓ Works with existing Crystal worktree creation
- ✓ No interference with git operations
- ✓ Symlinks preserved across worktree operations

**Role System Integration:**
- ✓ Workspace setup runs before every role activation
- ✓ Hook enforcement prevents incomplete setup
- ✓ Clear error messaging for troubleshooting

**Git Workflow Compatibility:**
- ✓ Symlinks ignored by build repo git
- ✓ Coordination repo git operations unaffected  
- ✓ No conflicts with existing workflows

## Troubleshooting Guide

### Common Issues

**"No coordination repository found"**
- **Cause:** Working outside project context
- **Resolution:** Normal behavior for non-project work
- **Action:** No action needed

**"Coordination already linked"**  
- **Cause:** Setup previously completed
- **Resolution:** Normal behavior
- **Action:** Continue with role activation

**Hook blocks role activation**
- **Cause:** Missing `.coord` symlink when coordination repo exists
- **Resolution:** Run workspace setup commands
- **Action:** Execute provided setup commands, retry role activation

**Symlink points to wrong location**
- **Cause:** Worktree created in unexpected location
- **Resolution:** Recreate symlink with correct path
- **Action:** `rm .coord && ln -sfn ../../../coordination .coord`

**Cannot access coordination files**
- **Cause:** Coordination repo not initialized or moved
- **Resolution:** Verify coordination repo exists and contains expected files
- **Action:** Check `/Volumes/HestAI-Projects/{project}/coordination/`

### Recovery Procedures

**Complete Setup Recovery:**
```bash
cd /Volumes/HestAI-Projects/{project}/build/worktrees/{feature}

# Remove any broken symlink
rm -f .coord

# Recreate with correct path
if [ -d "../../../coordination" ]; then
  ln -sfn ../../../coordination .coord
  echo "✓ Coordination link restored"
else
  echo "❌ Coordination repository not found"
fi
```

**Coordination Repository Recovery:**
```bash
cd /Volumes/HestAI-Projects/{project}

# Verify coordination repo exists
if [ ! -d "coordination" ]; then
  echo "Creating coordination repository..."
  mkdir coordination
  cd coordination
  git init
  # Recreate coordination files as needed
fi
```

## Migration Guide

### For New Projects
- **Recommended:** Use Project Coordination Pattern from project start
- **Setup:** Follow "Setting Up a New Project" section above
- **Benefits:** Full pattern benefits from day one

### For Existing Projects

**Option 1: Full Migration (Recommended)**
1. Create `coordination/` repo with current project artifacts
2. Move project management docs from build repo to coordination
3. Update build repo `.gitignore` to exclude `.coord/`
4. Update `CLAUDE.md` to reference `.coord/` files
5. Test with new worktree creation

**Option 2: Gradual Adoption**
1. Keep existing structure for current work
2. Use Project Coordination Pattern for new feature branches
3. Migrate gradually as convenient
4. Full migration when major project phase transitions

**Option 3: No Migration**
- Existing projects can continue current patterns
- Pattern is for new projects and major restructuring
- No forced migration timeline

## Success Metrics

### Implementation Success (Week 1)
- [ ] All new projects use Project Coordination Pattern
- [ ] Workspace setup runs automatically on role activation
- [ ] Hook enforcement prevents incomplete setup
- [ ] No manual symlink creation required

### Operational Success (Month 1)  
- [ ] Zero coordination access issues reported
- [ ] LLMs consistently access live project context
- [ ] No sync issues between worktrees
- [ ] Developer setup time reduced

### Long-term Success (Quarter 1)
- [ ] Pattern adopted for all active projects
- [ ] Project coordination consistency across teams
- [ ] Reduced project context confusion
- [ ] Improved LLM effectiveness in project work

## Reference Implementation

### Working Example
**Location:** `/Volumes/HestAI-Projects/test-project/`
- Complete implementation with both repositories
- Multiple test worktrees demonstrating pattern
- Validated with Crystal.app workflow

### Key Files
- **Workspace Setup:** `/Users/shaunbuswell/.claude/commands/role.md`
- **Enforcement Hook:** `/Users/shaunbuswell/.claude/hooks/enforce-workspace-setup.sh`
- **Directory Standards:** `/Volumes/HestAI/docs/workflow/005-WORKFLOW-DIRECTORY-STRUCTURE.md`

### Integration Points
- Crystal.app worktree creation
- Role activation system
- Git workflow compatibility
- HestAI organizational standards

---

**Implementation Authority:** System Steward  
**Enforcement:** Automatic via hook system  
**Review Cycle:** Pattern effectiveness and adoption quarterly assessment  
**Status:** Production ready, validated with test implementation