# Workflow Hooks Management Protocol

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

## MANDATORY WORKSPACE SETUP

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

## CRYSTAL.APP WORKFLOW PROTECTION

### Session-Based Safety

```
Crystal Session 1: B2-implementation worktree
  → Temporarily disable for rebase
  → Squash & merge to main  
  → Delete worktree (protection gone with it)

Crystal Session 2: B3-new-feature worktree
  → Starts FRESH with hooks ENABLED
  → Must explicitly disable if needed
  → Protection from line 1
```

### The Key Insight

Each Crystal session typically uses a fresh worktree, which means:
- Previous session's overrides don't persist
- New session starts with full protection
- Main branch never loses protection
- Accidents in one session don't affect the next

---

## ENFORCEMENT IN MAIN WORKFLOW

### Add to Every Phase's Workspace Setup

When any phase involves code changes, verify hooks are active:

```bash
# Part of B1_02, B2, or any coding phase
echo "🔒 Verifying quality gates..."
./scripts/hooks.sh status || {
    echo "⚠️ Hooks not properly configured!"
    echo "Run: npm run hooks:enable"
    exit 1
}
```

### Code Review Requirements

CODE-REVIEW-SPECIALIST must verify:
- If bypass was used, was it justified?
- Are tests present in final merged code?
- Was bypass temporary and isolated?

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