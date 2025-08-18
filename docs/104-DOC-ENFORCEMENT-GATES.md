# Documentation Enforcement Gates

**Status:** Final  
**Purpose:** Enforce documentation standards from 101-103 through hooks and automation  
**Scope:** Naming conventions, OCTAVE compression, archival rules, file placement  
**Authority:** Prevents documentation chaos through automatic validation

## What We're Enforcing (from 101-103)

### From 101-DOC-STRUCTURE-AND-NAMING-STANDARDS
- **Naming Pattern:** `{CATEGORY}{NN}-{CONTEXT}[-{QUALIFIER}]-{NAME}.{EXT}`
- **No Version Suffixes:** Block `_v1`, `_final`, `_latest`
- **Max Depth:** docs/ can only go 2 levels deep
- **No Draft Proliferation:** One canonical doc per standard

### From 102-DOC-ARCHIVAL-RULES  
- **Archive Structure:** Parallel _archive/ tree preserving paths
- **Required Headers:** Status, Archived date, Original-Path
- **Filename Preservation:** Original names must stay intact

### From 103-DOC-OCTAVE-COMPRESSION-RULES
- **Compression Triggers:** >3:1 achievable, stable content
- **Extension Usage:** .oct.md for compressed, .md for prose
- **Fidelity Requirement:** 96%+ information preservation

## Hook Implementation for Documentation

### Gate 1: Filename Pattern Enforcement

**Problem:** Files created with wrong naming patterns  
**Solution:** Block creation of incorrectly named docs

**Hook Location:** `/Volumes/HestAI/.claude/settings.local.json`
```json
{
  "hooks": {
    "pre-write": {
      "command": "~/.claude/hooks/enforce-doc-naming.sh",
      "args": ["${FILE_PATH}"],
      "blocking": true
    }
  }
}
```

**Script: ~/.claude/hooks/enforce-doc-naming.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")
DIR_PATH=$(dirname "$FILE_PATH")

# Only check files in docs/, reports/, or _archive/
if [[ ! "$DIR_PATH" =~ (^|/)(docs|reports|_archive)(/|$) ]]; then
  exit 0
fi

# Skip README files
if [[ "$FILE_NAME" == "README.md" ]]; then
  exit 0
fi

# Pattern: {CATEGORY}{NN}-{CONTEXT}[-{QUALIFIER}]-{NAME}.{EXT}
PATTERN='^[0-9]{3}-(DOC|SYSTEM|PROJECT|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)(-[A-Z0-9]+)?-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'

if [[ ! "$FILE_NAME" =~ $PATTERN ]]; then
  echo "🚨 BLOCKING: Invalid documentation filename"
  echo "File: $FILE_NAME"
  echo ""
  echo "Required pattern: {CATEGORY}{NN}-{CONTEXT}[-{QUALIFIER}]-{NAME}.{EXT}"
  echo "Example: 103-DOC-OCTAVE-COMPRESSION-RULES.md"
  echo ""
  echo "CONTEXT must be one of:"
  echo "  DOC, SYSTEM, PROJECT, WORKFLOW, SCRIPT, AUTH, UI, RUNTIME, DATA, SEC, OPS, BUILD, REPORT"
  echo ""
  echo "Rules:"
  echo "  - 3-digit category (e.g., 103)"
  echo "  - UPPERCASE-WITH-HYPHENS for names"
  echo "  - .md or .oct.md extension only"
  echo "  - No version suffixes (_v1, _final, etc.)"
  exit 1
fi

# Check for forbidden version suffixes
if [[ "$FILE_NAME" =~ (_v[0-9]+|_final|_latest|_draft|_old|_new) ]]; then
  echo "🚨 BLOCKING: Version suffixes forbidden"
  echo "File: $FILE_NAME"
  echo "Use git branches/history for versions, not filename suffixes"
  exit 1
fi
```

### Gate 2: Directory Depth Enforcement

**Problem:** Deep nesting makes documents hard to find  
**Solution:** Block creation beyond 2 levels in docs/

**Script: ~/.claude/hooks/enforce-doc-depth.sh**
```bash
#!/bin/bash
FILE_PATH="$1"

# Check if file is under docs/
if [[ "$FILE_PATH" =~ ^(.*/)?docs/ ]]; then
  # Count depth under docs/
  DOCS_PORTION=${FILE_PATH#*docs/}
  DEPTH=$(echo "$DOCS_PORTION" | tr '/' '\n' | wc -l)
  
  if [[ $DEPTH -gt 2 ]]; then
    echo "🚨 BLOCKING: Maximum depth exceeded in docs/"
    echo "Path: $FILE_PATH"
    echo "Maximum allowed: docs/subfolder/file.md (2 levels)"
    echo "Your depth: $DEPTH levels"
    exit 1
  fi
fi
```

### Gate 3: Archive Header Validation

**Problem:** Archived files missing required headers  
**Solution:** Check archived files for proper headers

**Script: ~/.claude/hooks/enforce-archive-headers.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
CONTENT="$2"

# Only check files in _archive/
if [[ ! "$FILE_PATH" =~ ^(.*/)?_archive/ ]]; then
  exit 0
fi

# Check for required headers
REQUIRED_HEADERS=(
  "Status: Archived"
  "Archived: [0-9]{4}-[0-9]{2}-[0-9]{2}"
  "Original-Path:"
)

for HEADER in "${REQUIRED_HEADERS[@]}"; do
  if ! echo "$CONTENT" | head -10 | grep -qE "$HEADER"; then
    echo "🚨 BLOCKING: Archive header missing"
    echo "File: $FILE_PATH"
    echo "Required headers (in first 10 lines):"
    echo "  Status: Archived → superseded by <link>"
    echo "  Archived: YYYY-MM-DD"
    echo "  Original-Path: <original path>"
    exit 1
  fi
done
```

### Gate 4: OCTAVE Compression Detection

**Problem:** Large, stable documents not compressed  
**Solution:** Suggest compression for eligible content

**Script: ~/.claude/hooks/suggest-octave-compression.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
CONTENT="$2"

# Only check .md files (not already .oct.md)
if [[ ! "$FILE_PATH" =~ \.md$ ]] || [[ "$FILE_PATH" =~ \.oct\.md$ ]]; then
  exit 0
fi

# Count lines and estimate compression potential
LINE_COUNT=$(echo "$CONTENT" | wc -l)
WORD_COUNT=$(echo "$CONTENT" | wc -w)

# Check for compression indicators
if [[ $LINE_COUNT -gt 100 ]]; then
  # Check for patterns indicating high compression potential
  PATTERN_COUNT=$(echo "$CONTENT" | grep -c -E "(MUST|SHOULD|ALWAYS|NEVER|\:\:|→|←|↔)")
  REDUNDANCY=$(echo "$CONTENT" | grep -o -E '\b\w+\b' | sort | uniq -c | sort -rn | head -20 | awk '$1>5' | wc -l)
  
  if [[ $PATTERN_COUNT -gt 20 ]] || [[ $REDUNDANCY -gt 10 ]]; then
    echo "💡 SUGGESTION: Consider OCTAVE compression"
    echo "File: $FILE_NAME has compression potential"
    echo "  Lines: $LINE_COUNT"
    echo "  Pattern density: $PATTERN_COUNT structured patterns"
    echo "  Potential ratio: 3:1 or better"
    echo ""
    echo "To compress: Apply patterns from 103-DOC-OCTAVE-COMPRESSION-RULES.md"
    echo "Rename to: ${FILE_PATH%.md}.oct.md after compression"
    # Non-blocking suggestion
  fi
fi
```

### Gate 5: Duplicate Document Prevention

**Problem:** Multiple numbered versions of same standard  
**Solution:** Detect and block parallel drafts

**Script: ~/.claude/hooks/prevent-doc-duplication.sh**
```bash
#!/bin/bash
FILE_PATH="$1"
FILE_NAME=$(basename "$FILE_PATH")
DIR_PATH=$(dirname "$FILE_PATH")

# Extract CONTEXT and NAME portions
if [[ "$FILE_NAME" =~ ^[0-9]{3}-([A-Z]+)(-[A-Z0-9]+)?-(.+)\.(md|oct\.md)$ ]]; then
  CONTEXT="${BASH_REMATCH[1]}"
  NAME_PART="${BASH_REMATCH[3]}"
  
  # Check for similar documents
  SIMILAR=$(find "$DIR_PATH" -maxdepth 1 -name "*-${CONTEXT}*${NAME_PART}*" 2>/dev/null | grep -v "$FILE_NAME")
  
  if [[ -n "$SIMILAR" ]]; then
    echo "⚠️  WARNING: Potential duplicate document"
    echo "New file: $FILE_NAME"
    echo "Similar existing:"
    echo "$SIMILAR"
    echo ""
    echo "Rules:"
    echo "  - One canonical document per standard"
    echo "  - Use git branches for drafts, not numbered files"
    echo "  - Archive old versions, don't create new numbers"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    fi
  fi
fi
```

## Pre-commit Hook Configuration

**File: /Volumes/HestAI-New/.pre-commit-config.yaml**
```yaml
repos:
  - repo: local
    hooks:
      - id: doc-naming-lint
        name: Enforce documentation naming standards
        entry: scripts/validate_docs.py --check-names
        language: python
        files: '^(docs|reports|_archive)/'
        
      - id: doc-structure-lint
        name: Check directory depth and structure
        entry: scripts/validate_docs.py --check-structure
        language: python
        files: '^(docs|reports|_archive)/'
        
      - id: octave-suggestion
        name: Suggest OCTAVE compression
        entry: scripts/validate_docs.py --suggest-compression
        language: python
        files: '\.md$'
        exclude: '\.oct\.md$'
```

## Validation Script

**File: /Volumes/HestAI-New/scripts/validate_docs.py**
```python
#!/usr/bin/env python3
import re
import sys
import os
from pathlib import Path

# Naming pattern from 101
NAMING_PATTERN = re.compile(
    r'^[0-9]{3}-(DOC|SYSTEM|PROJECT|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)'
    r'(-[A-Z0-9]+)?-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'
)

FORBIDDEN_SUFFIXES = ['_v1', '_v2', '_final', '_latest', '_draft', '_old', '_new']
VALID_CONTEXTS = ['DOC', 'SYSTEM', 'PROJECT', 'WORKFLOW', 'SCRIPT', 'AUTH', 'UI', 
                  'RUNTIME', 'DATA', 'SEC', 'OPS', 'BUILD', 'REPORT']

def check_naming(filepath):
    """Validate filename against standards"""
    filename = os.path.basename(filepath)
    
    # Skip README files
    if filename == 'README.md':
        return True
        
    # Check pattern
    if not NAMING_PATTERN.match(filename):
        print(f"❌ Invalid name: {filename}")
        print(f"   Required: NNN-CONTEXT[-QUALIFIER]-NAME.ext")
        return False
        
    # Check forbidden suffixes
    for suffix in FORBIDDEN_SUFFIXES:
        if suffix in filename:
            print(f"❌ Forbidden suffix '{suffix}' in: {filename}")
            return False
            
    return True

def check_structure(filepath):
    """Check directory depth constraints"""
    path_parts = Path(filepath).parts
    
    if 'docs' in path_parts:
        docs_index = path_parts.index('docs')
        depth = len(path_parts) - docs_index - 1
        if depth > 2:
            print(f"❌ Too deep: {filepath}")
            print(f"   Max depth under docs/: 2, found: {depth}")
            return False
            
    return True

def suggest_compression(filepath):
    """Suggest OCTAVE compression for eligible files"""
    if filepath.endswith('.oct.md'):
        return True
        
    with open(filepath, 'r') as f:
        content = f.read()
        lines = content.count('\n')
        
    if lines > 100:
        # Count compression indicators
        patterns = len(re.findall(r'(MUST|SHOULD|ALWAYS|NEVER|::|→|←|↔)', content))
        if patterns > 20:
            print(f"💡 Consider OCTAVE compression for: {filepath}")
            print(f"   {lines} lines, {patterns} patterns detected")
            print(f"   Potential compression: 3:1 or better")
            
    return True

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--check-names', action='store_true')
    parser.add_argument('--check-structure', action='store_true')
    parser.add_argument('--suggest-compression', action='store_true')
    parser.add_argument('files', nargs='*')
    
    args = parser.parse_args()
    success = True
    
    for filepath in args.files:
        if args.check_names:
            success &= check_naming(filepath)
        if args.check_structure:
            success &= check_structure(filepath)
        if args.suggest_compression:
            suggest_compression(filepath)
            
    sys.exit(0 if success else 1)
```

## Claude.md Integration

**File: /Volumes/HestAI-New/CLAUDE.md**
```markdown
# Documentation Standards Enforcement

## Automatic Validation
This repository enforces documentation standards from:
- 101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md
- 102-DOC-ARCHIVAL-RULES.md
- 103-DOC-OCTAVE-COMPRESSION-RULES.md

## What Gets Checked
- ✅ Filename pattern: NNN-CONTEXT-NAME.ext
- ✅ No version suffixes (_v1, _final, etc.)
- ✅ Maximum 2 levels deep in docs/
- ✅ Archive headers in _archive/ files
- ✅ OCTAVE compression suggestions

## When Creating Documentation
1. Use correct naming: 105-DOC-EXAMPLE-GUIDE.md
2. Place in correct directory (docs/, reports/, etc.)
3. Consider OCTAVE compression for >100 lines
4. One canonical doc per topic (use git for versions)
```

## Testing the Enforcement

### Test Cases

```bash
# Should PASS
echo "# Test" > /tmp/103-DOC-TEST-GUIDE.md

# Should FAIL - bad pattern
echo "# Test" > /tmp/test-guide.md

# Should FAIL - version suffix
echo "# Test" > /tmp/103-DOC-TEST_v1.md

# Should FAIL - too deep
mkdir -p /tmp/docs/sub1/sub2/sub3
echo "# Test" > /tmp/docs/sub1/sub2/sub3/103-DOC-TEST.md

# Should WARN - needs compression
seq 1 200 > /tmp/105-DOC-LARGE-FILE.md
```

## Success Metrics

### Immediate
- Zero incorrectly named files in docs/
- No version suffixes in filenames
- All archived files have proper headers

### Week 1
- 100% naming compliance
- Compression suggestions acted upon
- No duplicate standards

### Month 1  
- Average document size reduced 50%
- OCTAVE adoption for stable content
- Clean, navigable documentation tree

---

**Authority:** Documentation Standards Enforcement  
**Implementation:** Hooks + Pre-commit + Scripts  
**Validation:** Automated testing of all patterns