# Workflow Hooks Guide

**Status:** Final  
**Purpose:** Complete guide to managing and referencing all validation hooks and enforcement mechanisms  
**Scope:** All automated checks, gates, and validators across the HestAI system  
**Authority:** Single source of truth for hook management, locations, and implementation status

## Overview

This document defines the universal hooks management system that ensures quality gates (especially TDD) remain enforced by default while allowing controlled, temporary bypasses for specific administrative tasks.

---

## CORE PRINCIPLE: DEFAULT-SECURE ARCHITECTURE

### The Safety Cascade
```
Main Repository (e.g., /Volumes/HestAI/builds/project/)
├── .git/config → NO local override → Uses global hooks ✓
└── When new worktree created:
    └── New worktree inherits from main
        └── Starts with NO local override
            └── AUTOMATICALLY PROTECTED! ✓
```

### Why This Architecture Works
1. **Default-Secure**: Every new session/worktree starts protected
2. **No Drift**: Can't accidentally leave hooks disabled globally  
3. **Self-Healing**: Each new worktree resets to secure state
4. **Audit Trail**: Bypasses are worktree-specific and temporary
5. **Isolation**: Disabling in one worktree doesn't affect others

---

## HOOK INVENTORY

### Active Claude Hooks ✅

| Hook Name                     | Location         | Purpose                                                        |
|-------------------------------|------------------|----------------------------------------------------------------|
| enforce-doc-naming.sh         | ~/.claude/hooks/ | Blocks files with invalid naming patterns AND PROJECT phases  |
| context7_enforcement_gate.sh  | ~/.claude/hooks/ | Blocks external imports without Context7 consultation evidence |
| enforce-phase-dependencies.sh | ~/.claude/hooks/ | Blocks PROJECT phase creation without prerequisites           |
| enforce-traced-analyze.sh     | ~/.claude/hooks/ | Blocks architecture changes without critical-engineer consultation (TRACED A) |
| enforce-traced-consult.sh     | ~/.claude/hooks/ | Blocks test methodology changes without testguard consultation (TRACED C) |
| suggest-octave-compression.sh | ~/.claude/hooks/ | Suggests OCTAVE compression for large, pattern-heavy files    |
| validate-links.sh             | ~/.claude/hooks/ | Validates relative links exist and cross-repo references      |
| enforce-archive-headers.sh    | ~/.claude/hooks/ | Ensures archived files have required Status/Date/Path headers |

### Active Git Hooks ✅

| Hook Name  | Location      | Purpose                                           |
|------------|---------------|---------------------------------------------------|
| pre-commit | ~/.githooks/  | Enforces test-first requirement (TRACED T)       |
| commit-msg | ~/.githooks/  | Suggests review evidence (TRACED R)              |

### Planned Hooks 📋

| Hook Name                     | Location         | Purpose                                                       |
|-------------------------------|------------------|---------------------------------------------------------------|
| enforce-bridge-boundaries.sh  | ~/.claude/hooks/ | Prevents content duplication between bridge and build docs    |

---

## WORKSPACE SETUP & MANAGEMENT

### B1_02: WORKSPACE-ARCHITECT Requirements

When setting up any new project workspace, the WORKSPACE-ARCHITECT must:

1. **Create hooks management script** at `scripts/hooks.sh`
2. **Add npm scripts** for hook control (if Node.js project)
3. **Document** hook bypass procedures in project README
4. **Verify** global hooks are active by default

### Standard Implementation

**File: `scripts/hooks.sh`**
```bash
#!/bin/bash
# Git Hook Management Script
# Provides controlled flexibility while maintaining quality standards

GLOBAL_HOOKS_PATH="/Users/shaunbuswell/.githooks"
LOCAL_HOOKS_DIR=".githooks"

# Core functions (see full implementation in appendix)
disable_hooks()  # Disable for this repository only
enable_global()  # Re-enable global hooks (TDD enforcement)
enable_local()   # Enable project-specific permissive hooks
bypass_once()    # Single-commit bypass with ALLOW_NO_TESTS=1
```

**Add to `package.json` (Node.js projects):**
```json
{
  "scripts": {
    "hooks:status": "./scripts/hooks.sh status",
    "hooks:disable": "./scripts/hooks.sh disable",
    "hooks:enable": "./scripts/hooks.sh enable",
    "hooks:bypass": "ALLOW_NO_TESTS=1",
    "commit:bypass": "ALLOW_NO_TESTS=1 git commit"
  }
}
```

---

## WHEN TO USE HOOK OVERRIDES

### Legitimate Bypass Scenarios

**Administrative Tasks:**
- Git history cleanup (rebase, squash)
- Large refactoring with test updates in separate commit
- Emergency hotfixes with follow-up test commit
- Documentation-only changes
- Configuration file updates

**Process Requirements:**
1. Document WHY bypass is needed
2. Use worktree-specific override only
3. Re-enable immediately after task
4. Never bypass in main branch

### Bypass Methods (In Order of Preference)

**Method 1: Worktree Isolation (PREFERRED)**
```bash
# In worktree only
npm run hooks:disable
# Do administrative work
git rebase -i HEAD~5
# Re-enable when done
npm run hooks:enable
```

**Method 2: Single Commit Bypass**
```bash
# For one commit only
ALLOW_NO_TESTS=1 git commit -m "docs: update README"
```

**Method 3: Justified Bypass with Trailer**
```bash
git commit -m "hotfix: critical production issue

No-Test-Justification: Emergency fix, tests following in next commit"
```

---

## TRACED PROTOCOL ENFORCEMENT

Complete TRACED protocol implementation ensures quality discipline:

- **T** (Test-First): Pre-commit hooks block commits without test files
- **R** (Review): Git hooks suggest code review evidence
- **A** (Analyze): Critical-engineer consultation required for architectural decisions
- **C** (Consult): Testguard consultation required for testing discipline changes  
- **E** (Execute): Quality gates (lint/typecheck/tests) enforced
- **D** (Document): Documentation requirements enforced throughout

**TRACED Triggers:**
- **Analyze triggers**: Database schemas, performance-critical code, security components, architecture patterns
- **Consult triggers**: Test framework changes, coverage modifications, test quarantine, new test domains

### PROJECT Phase Enforcement

The workflow automatically enforces:
- **Phase naming**: PROJECT documents must include phase (D1-B4)
- **Phase progression**: Cannot skip phases (D1→D2→D3→B0→B1→B2→B3→B4)
- **File existence**: Each phase requires its immediate predecessor

---

## TESTING & TROUBLESHOOTING

### Test Individual Hooks
```bash
# Test filename and PROJECT phase validation
echo '{"tool_name": "Write", "tool_input": {"file_path": "/path/to/201-PROJECT-TEST.md"}}' | ~/.claude/hooks/enforce-doc-naming.sh

# Test PROJECT phase dependencies
echo '{"tool_name": "Write", "tool_input": {"file_path": "/docs/201-PROJECT-TEST-D2-DESIGN.md"}}' | ~/.claude/hooks/enforce-phase-dependencies.sh

# Test TRACED analyze triggers
echo '{"tool_name": "Write", "tool_input": {"file_path": "/src/migrations/001-schema.sql", "content": "CREATE TABLE users..."}}' | ~/.claude/hooks/enforce-traced-analyze.sh

# Test TRACED consult triggers  
echo '{"tool_name": "Write", "tool_input": {"file_path": "/test/new-framework.test.js", "content": "import vitest from \"vitest\""}}' | ~/.claude/hooks/enforce-traced-consult.sh

# Test Context7 consultation enforcement
echo '{"tool_name": "Write", "tool_input": {"file_path": "/test/file.js", "content": "import lodash from \"lodash\""}}' | ~/.claude/hooks/context7_enforcement_gate.sh

# Test git hooks (in a git repository)
git commit -m "test commit" --dry-run
```

### List All Hooks
```bash
# Show all hook files
ls -la ~/.claude/hooks/

# Show executable hooks only
find ~/.claude/hooks/ -name "*.sh" -executable -type f
```

### Hook Status Check
```bash
# Check which hooks are configured in Claude
cat ~/.claude/settings.local.json | grep -A 10 "hooks"

# Check current git hooks status
./scripts/hooks.sh status
```

### Hook Not Running
```bash
# Check hook permissions
ls -la ~/.claude/hooks/hook-name.sh

# Make executable if needed
chmod +x ~/.claude/hooks/hook-name.sh
```

### Hook Failing
```bash
# Run hook manually to see errors
~/.claude/hooks/hook-name.sh "test-file.md"

# Check Claude settings
cat ~/.claude/settings.local.json
```

---

## PROTECTION VERIFICATION

### At Workspace Creation (B1_02)

The WORKSPACE-ARCHITECT must verify:

```bash
# Check current status
./scripts/hooks.sh status

# Expected output:
# ✓ Status: Global hooks ACTIVE (TDD enforcement ON)
```

### Before Major Operations

```bash
# Verify main branch still protected
cd /main/repository/path
git config --get core.hooksPath
# Should return: /Users/shaunbuswell/.githooks
```

### After Worktree Operations

```bash
# Create new worktree
git worktree add -b new-feature ../new-feature

# Verify it starts protected
cd ../new-feature
./scripts/hooks.sh status
# ✓ Automatically protected
```

---

## INTEGRATION WITH ERROR HANDLING

When ERROR-RESOLVER or ERROR-ARCHITECT need to fix urgent issues:

1. **Create fix in worktree** (not main)
2. **Temporarily disable if needed** for complex rebasing
3. **Re-enable before final commit**
4. **Document in error resolution report**

```markdown
## Error Resolution Report
...
### Hook Override Used
- Temporarily disabled in worktree for: [SPECIFIC REASON]
- Re-enabled after: [WHAT WAS DONE]
- Verification: All tests added in commit [SHA]
```

---

## ANTI-PATTERNS TO PREVENT

❌ **Global Disable**: Never disable hooks globally
❌ **Permanent Override**: Never leave hooks disabled in main
❌ **Unjustified Bypass**: Always document why bypass needed
❌ **Skip Review**: Bypassed commits still need review
❌ **Test Later™**: "Will add tests later" without tracking

---

## QUICK REFERENCE CARD

```bash
# Check status
npm run hooks:status

# Temporary disable (worktree only)
npm run hooks:disable
# ... do work ...
npm run hooks:enable

# Single commit bypass
ALLOW_NO_TESTS=1 git commit -m "message"

# With justification
git commit -m "fix: urgent issue
No-Test-Justification: emergency fix"

# Never in main branch!
cd /main/repo
npm run hooks:disable  # ❌ DON'T DO THIS
```

---

## IMPLEMENTATION CHECKLIST

For WORKSPACE-ARCHITECT (B1_02):
- [ ] Copy hooks.sh to scripts/ directory
- [ ] Make executable: `chmod +x scripts/hooks.sh`
- [ ] Add npm scripts to package.json
- [ ] Test all hook commands work
- [ ] Document in project README
- [ ] Verify global hooks active by default
- [ ] Commit hooks.sh as part of workspace setup

For All Developers:
- [ ] Understand worktree isolation principle
- [ ] Know when bypass is legitimate
- [ ] Always re-enable after bypass
- [ ] Document bypass usage
- [ ] Never bypass in main branch

---

## CONFIGURATION LOCATIONS

### User Configuration
```
~/.claude/
├── settings.local.json     # Hook configuration
└── hooks/
    ├── enforce-doc-naming.sh         ✅ Active
    ├── context7_enforcement_gate.sh  ✅ Active  
    ├── enforce-phase-dependencies.sh ✅ Active
    ├── enforce-traced-analyze.sh     ✅ Active
    ├── enforce-traced-consult.sh     ✅ Active
    ├── suggest-octave-compression.sh ✅ Active
    ├── validate-links.sh             ✅ Active
    ├── enforce-archive-headers.sh    ✅ Active
    └── enforce-bridge-boundaries.sh  📋 Planned

~/.githooks/
├── pre-commit                     # TDD enforcement
└── commit-msg                     # Review evidence suggestions
```

### Repository Configuration
```
Repository/
├── .pre-commit-config.yaml    # Pre-commit integration
├── scripts/
│   ├── hooks.sh               # Hook management script
│   └── validate_docs.py       # Batch validation
└── .github/workflows/
    └── documentation.yml      # CI/CD validation
```

---

## APPENDIX: Full Implementation

The complete `hooks.sh` script is maintained at:
`/Volumes/HestAI/builds/smartsuite-mcp-server/scripts/hooks.sh`

This script provides:
- Status checking
- Worktree-specific disable
- Global hooks enable  
- Local permissive mode
- Single-session bypass
- Git aliases setup

Copy this script to all new projects during B1_02 workspace setup.

---

**Implementation Priority:** Active hooks provide core protection, planned hooks add quality enhancement  
**Maintenance:** Review hook effectiveness quarterly, update based on violation patterns  
**Documentation:** See ../standards/104-DOC-ENFORCEMENT-GATES.md for detailed implementation examples