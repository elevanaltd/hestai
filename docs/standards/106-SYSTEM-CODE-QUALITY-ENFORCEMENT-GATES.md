# Code Quality Enforcement Gates

**Status:** Final  
**Purpose:** Enforce code quality standards through automated validation and prevent validation theater  
**Scope:** ESLint, TypeScript, testing, and CI/CD validation consistency  
**Authority:** Prevents code quality failures through automatic validation alignment

## Problem Statement

Code quality validation failures occur when:
- Local validation commands differ from CI/CD commands
- Agents claim success without using identical validation
- Validation theater occurs (checking passes but CI fails)
- Missing enforcement of test-driven development
- No quality gates prevent false positive claims

## Enforcement Architecture

### Gate 1: CI Command Consistency

**Problem:** Agents use different ESLint commands than CI/CD pipeline  
**Solution:** Force identical validation commands in all contexts

**Hook Location:** `~/.claude/hooks/enforce-ci-consistency.sh`
```bash
#!/bin/bash
PROJECT_ROOT="$1"
COMMAND_TYPE="$2"  # lint, typecheck, test

# Only check in project directories with package.json
if [[ ! -f "$PROJECT_ROOT/package.json" ]]; then
  exit 0
fi

# Extract CI commands from package.json
LINT_CHECK=$(node -p "JSON.parse(require('fs').readFileSync('package.json')).scripts['lint:check'] || 'Not found'" 2>/dev/null)
TYPECHECK=$(node -p "JSON.parse(require('fs').readFileSync('package.json')).scripts['typecheck'] || 'Not found'" 2>/dev/null)
TEST_CMD=$(node -p "JSON.parse(require('fs').readFileSync('package.json')).scripts['test'] || 'Not found'" 2>/dev/null)

case "$COMMAND_TYPE" in
  "lint")
    if [[ "$LINT_CHECK" == "Not found" ]]; then
      echo "⚠️  WARNING: No lint:check script found in package.json"
      echo "Add: \"lint:check\": \"eslint src --ext .ts\" (or appropriate)"
      exit 0
    fi
    echo "✅ ENFORCED: Use 'npm run lint:check' for validation"
    echo "CI Command: $LINT_CHECK"
    ;;
  "typecheck")
    if [[ "$TYPECHECK" == "Not found" ]]; then
      echo "⚠️  WARNING: No typecheck script found in package.json"
      exit 0
    fi
    echo "✅ ENFORCED: Use 'npm run typecheck' for validation"
    echo "CI Command: $TYPECHECK"
    ;;
  "test")
    if [[ "$TEST_CMD" == "Not found" ]]; then
      echo "⚠️  WARNING: No test script found in package.json"
      exit 0
    fi
    echo "✅ ENFORCED: Use 'npm test' for validation"
    echo "CI Command: $TEST_CMD"
    ;;
esac
```

### Gate 2: Validation Claim Verification

**Problem:** Agents claim "all ESLint issues fixed" without evidence  
**Solution:** Require evidence artifacts for quality claims

**Hook Location:** `~/.claude/hooks/require-validation-evidence.sh`
```bash
#!/bin/bash
MESSAGE="$1"

# Detect quality claims without evidence
CLAIM_PATTERNS=(
  "all.*eslint.*fixed"
  "no.*errors.*warnings"
  "lint.*clean"
  "typecheck.*passes"
  "all.*tests.*pass"
  "validation.*complete"
)

for PATTERN in "${CLAIM_PATTERNS[@]}"; do
  if echo "$MESSAGE" | grep -qiE "$PATTERN"; then
    echo "🚨 BLOCKING: Quality claims require evidence"
    echo "Detected claim: $(echo "$MESSAGE" | grep -iE "$PATTERN")"
    echo ""
    echo "Required evidence formats:"
    echo "  ✅ Command output: \`npm run lint:check\` (0 errors, 0 warnings)"
    echo "  ✅ Test results: \`npm test\` (98 tests passed)"
    echo "  ✅ TypeCheck: \`npm run typecheck\` (no errors)"
    echo ""
    echo "NEVER claim success without running exact CI commands"
    exit 1
  fi
done
```

### Gate 3: Test-First Discipline

**Problem:** Code written before tests (violates TDD)  
**Solution:** Enforce test file existence before implementation

**Hook Location:** `~/.claude/hooks/enforce-test-first.sh`
```bash
#!/bin/bash
FILE_PATH="$1"

# Only check implementation files
if [[ ! "$FILE_PATH" =~ ^src/.*\.(ts|js)$ ]]; then
  exit 0
fi

# Skip test files themselves
if [[ "$FILE_PATH" =~ \.(test|spec)\.(ts|js)$ ]]; then
  exit 0
fi

# Derive expected test file path
DIR_PATH=$(dirname "$FILE_PATH")
FILE_NAME=$(basename "$FILE_PATH" .ts)
POSSIBLE_TEST_PATHS=(
  "${DIR_PATH}/${FILE_NAME}.test.ts"
  "tests/unit/$(basename "$FILE_PATH" .ts).test.ts"
  "test/$(basename "$FILE_PATH" .ts).test.ts"
  "__tests__/$(basename "$FILE_PATH" .ts).test.ts"
)

# Check if test file exists
TEST_EXISTS=false
for TEST_PATH in "${POSSIBLE_TEST_PATHS[@]}"; do
  if [[ -f "$TEST_PATH" ]]; then
    TEST_EXISTS=true
    break
  fi
done

if [[ "$TEST_EXISTS" == "false" ]]; then
  echo "🚨 BLOCKING: No test file found for implementation"
  echo "Implementation: $FILE_PATH"
  echo "Expected test locations:"
  for TEST_PATH in "${POSSIBLE_TEST_PATHS[@]}"; do
    echo "  - $TEST_PATH"
  done
  echo ""
  echo "TDD Requirement: Write failing test BEFORE implementation"
  exit 1
fi
```

### Gate 4: Error Resolution Validation

**Problem:** Claiming error resolution without proper investigation  
**Solution:** Require systematic error analysis for error claims

**Hook Location:** `~/.claude/hooks/enforce-error-resolution.sh`
```bash
#!/bin/bash
MESSAGE="$1"

# Detect error resolution claims
ERROR_PATTERNS=(
  "fixed.*error"
  "resolved.*issue"
  "error.*corrected"
  "bug.*fixed"
  "issue.*resolved"
)

REQUIRES_INVESTIGATION=(
  "unhandled.*rejection"
  "typescript.*error"
  "lint.*error"
  "test.*fail"
  "ci.*fail"
)

for PATTERN in "${ERROR_PATTERNS[@]}"; do
  if echo "$MESSAGE" | grep -qiE "$PATTERN"; then
    # Check if this is a complex error requiring investigation
    for COMPLEX_PATTERN in "${REQUIRES_INVESTIGATION[@]}"; do
      if echo "$MESSAGE" | grep -qiE "$COMPLEX_PATTERN"; then
        echo "💡 SUGGESTION: Complex error requires systematic investigation"
        echo "Error type: $(echo "$MESSAGE" | grep -iE "$COMPLEX_PATTERN")"
        echo ""
        echo "Consider using error-resolver agent for:"
        echo "  - Root cause analysis (RCCAFP framework)"
        echo "  - Evidence-based investigation"
        echo "  - Prevention mechanism implementation"
        echo ""
        echo "Pattern: Claim → Investigation → Evidence → Fix → Verification"
        # Non-blocking suggestion
      fi
    done
  fi
done
```

## Hook Integration

### Claude.md Integration
```markdown
# Code Quality Enforcement

## TRACED Protocol Enhancement
- **T** (Test-First): Enforced by test-first hooks
- **R** (Review): Evidence required for claims
- **A** (Analyze): Complex errors trigger investigation
- **C** (Consult): Validation specialists for quality issues
- **E** (Execute): Identical CI commands required
- **D** (Document): Quality evidence documented

## Quality Gates
1. **CI Consistency**: Use identical commands as CI/CD
2. **Evidence Required**: No claims without command output
3. **Test-First**: Implementation blocked without tests
4. **Systematic Investigation**: Complex errors require agents

## Validation Commands (Must Match CI)
- ESLint: `npm run lint:check` (not `eslint src`)
- TypeScript: `npm run typecheck`
- Tests: `npm test`
```

### Settings Integration
```json
{
  "hooks": {
    "pre-tool": {
      "command": "~/.claude/hooks/enforce-ci-consistency.sh",
      "args": ["${WORKING_DIR}", "${TOOL_TYPE}"],
      "blocking": false
    },
    "post-tool": {
      "command": "~/.claude/hooks/require-validation-evidence.sh",
      "args": ["${MESSAGE}"],
      "blocking": true
    },
    "pre-write": {
      "command": "~/.claude/hooks/enforce-test-first.sh",
      "args": ["${FILE_PATH}"],
      "blocking": true
    }
  }
}
```

## Updated Enforcement Matrix

### Code Quality Standards

| Rule Category | Source Doc | Primary Enforcement | Secondary Enforcement | Tertiary Enforcement | Notes |
|---------------|------------|---------------------|----------------------|---------------------|-------|
| ESLint Validation | 105-SYSTEM-CODE-QUALITY | ✅ CI consistency hook | Evidence verification | Command documentation | Must match CI exactly |
| TypeScript Checking | 105-SYSTEM-CODE-QUALITY | ✅ CI consistency hook | Evidence verification | Error documentation | Zero tolerance policy |
| Test-First (TDD) | 105-SYSTEM-CODE-QUALITY | ✅ Test existence hook | Review evidence | TDD guidance | RED state mandatory |
| Coverage Configuration | 109-DOC-COVERAGE-STANDARDS | ✅ Workspace-architect | Project initialization | Template validation | 80% minimum thresholds |
| Error Resolution | 105-SYSTEM-CODE-QUALITY | ✅ Investigation triggers | Agent consultation | RCCAFP framework | Systematic analysis |

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-22T16:08:45-04:00 -->
| Validation Claims | 105-SYSTEM-CODE-QUALITY | ✅ Evidence requirement | Quality review | Anti-theater examples | No empty checkmarks |

## Anti-Validation Theater Measures

### Prohibited Behaviors
- ❌ Using different commands than CI/CD
- ❌ Claiming success without evidence
- ❌ Writing implementation before tests
- ❌ Superficial error fixes without investigation
- ❌ "Fixed everything" without verification

### Required Behaviors
- ✅ Use exact CI commands for validation
- ✅ Provide command output as evidence
- ✅ Write failing tests before implementation
- ✅ Use error-resolver for complex issues
- ✅ Document validation steps taken

## Success Metrics

### Immediate
- Zero discrepancy between local and CI validation
- All quality claims backed by evidence
- 100% test-first compliance for new code

### Week 1
- No false positive quality claims
- Systematic error investigation adoption
- CI command consistency enforcement

### Month 1
- Reduced validation failures in CI/CD
- Improved test-driven development practices
- Elimination of validation theater

---

**Authority:** Code Quality Enforcement  
**Implementation:** Hooks + Pre-commit + Agent Integration  
**Validation:** Evidence-based quality gates