# Workflow Hooks Reference

**Status:** Final  
**Purpose:** Complete inventory of all validation hooks and enforcement mechanisms  
**Scope:** All automated checks, gates, and validators across the HestAI system  
**Authority:** Single source of truth for hook locations and implementation status

## Hook Inventory

### Active Hooks ✅

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

### Git Hooks (Global) ✅

| Hook Name  | Location      | Purpose                                           |
|------------|---------------|---------------------------------------------------|
| pre-commit | ~/.githooks/  | Enforces test-first requirement (TRACED T)       |
| commit-msg | ~/.githooks/  | Suggests review evidence (TRACED R)              |

### Planned Hooks 📋

| Hook Name                     | Location         | Purpose                                                       |
|-------------------------------|------------------|---------------------------------------------------------------|
| enforce-bridge-boundaries.sh  | ~/.claude/hooks/ | Prevents content duplication between bridge and build docs    |

### Configuration Files

| File                    | Location            | Purpose                                           |
|-------------------------|---------------------|---------------------------------------------------|
| settings.local.json     | ~/.claude/          | Claude Code hook configuration and triggers       |
| .pre-commit-config.yaml | Repository root     | Pre-commit hook integration for CI/CD             |
| validate_docs.py        | Repository scripts/ | Python validator for batch documentation checking |

## Quick Commands

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

# Test OCTAVE compression suggestion
echo '{"tool_name": "Write", "tool_input": {"file_path": "/path/to/large-file.md"}}' | ~/.claude/hooks/suggest-octave-compression.sh

# Test link validation
echo '{"tool_name": "Write", "tool_input": {"file_path": "/test/doc.md", "content": "[broken link](nonexistent.md)"}}' | ~/.claude/hooks/validate-links.sh

# Test archive header enforcement
echo '{"tool_name": "Write", "tool_input": {"file_path": "/test/_archive/old.md", "content": "No headers"}}' | ~/.claude/hooks/enforce-archive-headers.sh

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

# Test pre-commit hooks
pre-commit run --all-files
```

## Integration Points

### Claude Code Integration
- **Pre-write hooks:** Block file creation with invalid patterns
- **Pre-commit hooks:** Validate before git commits
- **Advisory hooks:** Suggest improvements without blocking

### Git Integration
- **Pre-commit:** Run validation before commits
- **Pre-push:** Check cross-repository links before push
- **CI/CD:** Full validation suite on pull requests

### Documentation Enforcement
- **101-DOC-STRUCTURE:** Filename and directory validation
- **102-DOC-ARCHIVAL:** Archive header requirements  
- **006-WORKFLOW-LINK:** Link validation and cross-references
- **005-WORKFLOW-DIRECTORY:** Bridge/build boundary enforcement

## Implementation Status

### Blocking Enforcement (Active)
- ✅ **Filename patterns** - Invalid names and missing PROJECT phases blocked
- ✅ **PROJECT phase dependencies** - Phase progression enforced (D1→D2→D3→B0→B1→B2→B3→B4)
- ✅ **TRACED analyze** - Architecture changes require critical-engineer consultation
- ✅ **TRACED consult** - Test methodology changes require testguard consultation
- ✅ **Test-first** - Code requires accompanying test file (TRACED T)
- ✅ **Context7 consultation** - External imports require consultation evidence
- ✅ **Link validation** - Broken links detected and blocked
- ✅ **Archive headers** - Missing headers blocked for archived files

### Advisory Enforcement (Active)
- ✅ **OCTAVE compression** - Large files suggested for compression

### Boundary Enforcement (Planned)  
- 📋 **Bridge boundaries** - Content duplication prevented
- 📋 **Cross-repo links** - Migration-safe link validation

## Hook Locations

### User Configuration
```
~/.claude/
├── settings.local.json     # Hook configuration
└── hooks/
    ├── enforce-doc-naming.sh         ✅ Active (includes depth checking)
    ├── enforce-context7-consultation.sh ✅ Active  
    ├── suggest-octave-compression.sh ✅ Active
    ├── validate-links.sh             ✅ Active
    ├── enforce-archive-headers.sh    ✅ Active
    └── enforce-bridge-boundaries.sh  📋 Planned
```

### Repository Configuration
```
Repository/
├── .pre-commit-config.yaml    # Pre-commit integration
├── scripts/
│   └── validate_docs.py       # Batch validation
└── .github/workflows/
    └── documentation.yml      # CI/CD validation
```

## Troubleshooting

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

### Bypass Hook (Emergency)
```bash
# Temporarily disable specific hook (edit settings.local.json)
# Or use git commit --no-verify for pre-commit bypass
```

---

**Implementation Priority:** Active hooks provide core protection, planned hooks add quality enhancement  
**Maintenance:** Review hook effectiveness quarterly, update based on violation patterns  
**Documentation:** See 104-DOC-ENFORCEMENT-GATES.md for detailed implementation examples