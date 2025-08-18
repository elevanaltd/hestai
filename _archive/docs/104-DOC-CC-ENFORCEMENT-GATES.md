# Claude Code Enforcement Gates

**Status:** Archived → to be revisited for workflow enforcement
**Archived:** 2025-08-17
**Original-Path:** docs/104-DOC-CC-ENFORCEMENT-GATES.md
**Note:** This document covers WORKFLOW enforcement (test-first, code review, etc.) not DOCUMENTATION enforcement

**Status:** Final  
**Purpose:** Automatic enforcement of documentation standards in Claude Code environments  
**Scope:** Hooks, settings, and commands for iTerm2 and Crystal.app workflows  
**Authority:** Transforms passive documentation into active prevention

## Core Enforcement Philosophy

**Principle:** Make wrong things impossible, right things automatic  
**Strategy:** Block at decision points, not after mistakes  
**Measurement:** Production failures prevented, not compliance tracked

## Hook Configuration Locations

### Global Settings (All Projects)
```
/Users/shaunbuswell/.claude/settings.json
```

### Project Settings (This Repository)
```
/Volumes/HestAI/.claude/settings.local.json
/Volumes/HestAI-New/.claude/settings.local.json
```

### Command Definitions
```
/Users/shaunbuswell/.claude/commands/*.md
```

## Critical Enforcement Gates

### Gate 1: Test-First Development

**Problem:** Code written without tests (leads to untestable implementations)  
**Solution:** Block code file creation without corresponding test

**Implementation:**
```json
{
  "hooks": {
    "pre-write": {
      "command": "~/.claude/hooks/enforce-test-first.sh",
      "args": ["${FILE_PATH}", "${FILE_EXTENSION}"],
      "blocking": true
    }
  }
}
```

**Script: ~/.claude/hooks/enforce-test-first.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
EXTENSION="$2"

# Skip non-code files
if [[ ! "$EXTENSION" =~ ^(ts|tsx|js|jsx|py|rs|go)$ ]]; then
  exit 0
fi

# Skip test files themselves
if [[ "$FILE_PATH" =~ \.test\.|\.spec\.|_test\.|test_ ]]; then
  exit 0
fi

# Check for corresponding test file
BASE_NAME="${FILE_PATH%.*}"
TEST_PATTERNS=("${BASE_NAME}.test.${EXTENSION}" "${BASE_NAME}.spec.${EXTENSION}" "${BASE_NAME}_test.${EXTENSION}")

for PATTERN in "${TEST_PATTERNS[@]}"; do
  if [[ -f "$PATTERN" ]]; then
    exit 0
  fi
done

echo "🚨 BLOCKING: Test-First Development Required"
echo "Create test file FIRST: ${BASE_NAME}.test.${EXTENSION}"
echo "Test must include at least one failing test case"
exit 1
```

### Gate 2: Library Documentation Requirement

**Problem:** Libraries used without checking documentation (60% miss rate)  
**Solution:** Detect imports, require Context7 consultation evidence

**Implementation:**
```json
{
  "hooks": {
    "post-edit": {
      "command": "~/.claude/hooks/enforce-library-docs.sh",
      "args": ["${FILE_PATH}", "${DIFF}"],
      "blocking": false,
      "warning": true
    }
  }
}
```

**Script: ~/.claude/hooks/enforce-library-docs.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
DIFF="$2"

# Check for new imports in the diff
if echo "$DIFF" | grep -q "^+.*import.*from ['\"]"; then
  LIBRARIES=$(echo "$DIFF" | grep "^+.*import.*from" | sed -n "s/.*from ['\"]\\([^'\"]*\\).*/\\1/p")
  
  for LIB in $LIBRARIES; do
    # Check for Context7 evidence comment
    if ! grep -q "// Context7: $LIB" "$FILE_PATH"; then
      echo "⚠️  WARNING: Library import without documentation check"
      echo "Required: Use Context7 to check '$LIB' documentation"
      echo "Add evidence: // Context7: $LIB - [specific API checked]"
      echo ""
      echo "Command: mcp__Context7__resolve-library-id '$LIB'"
      # Non-blocking but highly visible
    fi
  done
fi
```

### Gate 3: Architecture Decision Consultation

**Problem:** Complex architectural decisions without expert review  
**Solution:** Detect architecture patterns, require consultation

**Implementation:**
```json
{
  "hooks": {
    "pre-write": {
      "command": "~/.claude/hooks/enforce-architecture-review.sh",
      "args": ["${FILE_PATH}", "${CONTENT}"],
      "blocking": false,
      "prompt": true
    }
  }
}
```

**Script: ~/.claude/hooks/enforce-architecture-review.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
CONTENT="$2"

# Architecture decision patterns
PATTERNS="(class.*Service|class.*Provider|class.*Repository|interface.*Protocol|type.*Architecture)"

if echo "$CONTENT" | grep -qE "$PATTERNS"; then
  echo "🏗️  ARCHITECTURE DECISION DETECTED"
  echo "Consider consulting: critical-engineer"
  echo "Command: mcp__zen__critical-engineer"
  echo ""
  echo "Skip if consultation already complete"
  # Interactive prompt for Crystal/iTerm
  read -p "Have you consulted critical-engineer? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi
```

## Phase-Aware Enforcement

### Automatic Phase Detection

**Script: ~/.claude/hooks/detect-phase.sh**
```bash
#!/bin/bash
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

# Check for phase indicators
if [[ -f "$PROJECT_ROOT/docs/"*"NORTH-STAR"* ]] && [[ ! -f "$PROJECT_ROOT/docs/"*"VAD"* ]]; then
  echo "B0_VALIDATION"
elif [[ -f "$PROJECT_ROOT/docs/"*"VAD"* ]] && [[ ! -f "$PROJECT_ROOT/BUILD_PLAN"* ]]; then
  echo "B1_PLANNING"
elif [[ -f "$PROJECT_ROOT/BUILD_PLAN"* ]] && [[ -d "$PROJECT_ROOT/src" ]]; then
  echo "B2_IMPLEMENTATION"
elif [[ -d "$PROJECT_ROOT/tests/integration" ]]; then
  echo "B3_INTEGRATION"
elif [[ -f "$PROJECT_ROOT/HANDOFF"* ]]; then
  echo "B4_DELIVERY"
else
  echo "UNKNOWN"
fi
```

### Phase-Specific Requirements

**B2 Implementation Phase Gates:**
```json
{
  "hooks": {
    "session-start": {
      "command": "~/.claude/hooks/phase-requirements.sh",
      "args": ["${PHASE}"]
    }
  }
}
```

## Crystal.app Specific Configuration

### Working with Git Worktrees

Crystal creates isolated worktrees, requiring adjusted paths:

**Crystal-Aware Hook:**
```bash
#!/bin/bash
# Detect if running in Crystal worktree
if [[ "$PWD" =~ \.worktrees ]]; then
  MAIN_PROJECT=$(echo "$PWD" | sed 's/\.worktrees.*//')
  WORKTREE_NAME=$(basename "$PWD")
  echo "Crystal Worktree: $WORKTREE_NAME"
  # Adjust paths accordingly
fi
```

### Crystal Session Settings

**Project .claude/settings.local.json:**
```json
{
  "crystal": {
    "enforceTestFirst": true,
    "requireLibraryDocs": true,
    "architectureReviewPrompt": true
  },
  "systemPrompt": "Check git status first. Follow T.R.A.C.E.D protocol. Consult Context7 for all library imports.",
  "runScripts": {
    "test": "npm test",
    "lint": "npm run lint",
    "typecheck": "npm run type-check"
  }
}
```

## Command-Based Enforcement

### North Star Command

**File: ~/.claude/commands/north-star.md**
```markdown
# North Star Alignment Check

This command validates current work against North Star documents.

## Usage
Run this before major decisions or phase transitions.

## Checks
1. Documentation naming compliance
2. OCTAVE compression opportunities  
3. Required consultations for current phase
4. Evidence of completed gates

## Output
- ✅ Compliant items
- ⚠️  Warnings (non-blocking)
- 🚨 Violations (must fix)
```

### Build Command Enhancement

**File: ~/.claude/commands/build.md**
```markdown
# Build Phase Workflow

[existing content...]

## Mandatory Gates
- NO CODE WITHOUT: failing test written first
- NO LIBRARY WITHOUT: Context7 documentation checked
- NO ARCHITECTURE WITHOUT: critical-engineer consulted

## Evidence Requirements
Include in commit messages:
- Test-first: Link to test file
- Context7: Library versions checked
- Reviews: Consultation evidence
```

## Enforcement Metrics

### Success Indicators
```bash
# Track enforcement effectiveness
~/.claude/hooks/metrics.sh

METRICS:
- Test-first compliance: >95%
- Library documentation: 100%  
- Architecture consultations: >90%
- Production failures from missed gates: 0
```

### Violation Patterns
```bash
# Log violations for pattern analysis
echo "$(date): $VIOLATION_TYPE: $FILE_PATH" >> ~/.claude/enforcement.log
```

## Implementation Checklist

### Immediate (Day 1)
- [ ] Create ~/.claude/hooks/ directory
- [ ] Install enforce-test-first.sh hook
- [ ] Add to settings.local.json
- [ ] Test with sample code creation

### Progressive (Week 1)
- [ ] Add library documentation gate
- [ ] Implement phase detection
- [ ] Create architecture review prompt
- [ ] Set up metrics tracking

### Validation (Week 2)
- [ ] Measure consultation miss rate
- [ ] Analyze violation patterns
- [ ] Refine detection patterns
- [ ] Document success stories

## Common Scenarios

### Scenario 1: Creating New Component
```
1. Agent tries: Write src/components/NewFeature.tsx
2. Hook blocks: "Create test first"
3. Agent creates: src/components/NewFeature.test.tsx
4. Hook allows: Original file creation proceeds
```

### Scenario 2: Using External Library
```
1. Agent adds: import { something } from 'react-query'
2. Hook warns: "Check Context7 documentation"
3. Agent runs: mcp__Context7__resolve-library-id
4. Agent adds: // Context7: react-query v5 - useQuery API
```

### Scenario 3: Architecture Decision
```
1. Agent creates: class AuthenticationService
2. Hook prompts: "Consult critical-engineer?"
3. Agent runs: mcp__zen__critical-engineer
4. Decision validated or refined
```

## Troubleshooting

### Hook Not Firing
- Check: Hook script is executable (`chmod +x`)
- Verify: Path in settings.json is absolute
- Test: Run hook manually with test arguments

### Too Many False Positives
- Refine: Pattern matching in detection scripts
- Add: Exemption patterns for generated code
- Log: False positives for pattern improvement

### Crystal.app Compatibility
- Use: Worktree-aware path detection
- Adjust: Paths for .worktrees structure
- Test: In both main and worktree contexts

---

**Next Steps:** After implementing these gates, create 105-DOC-WARP-ENFORCEMENT-GATES.md for Warp terminal with MCP-specific enforcement patterns.