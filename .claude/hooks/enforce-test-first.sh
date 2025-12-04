#!/usr/bin/env bash

# Test-First Discipline Enforcement Hook
# Enforces test file existence before implementation
# From 106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Debug: log to a file for troubleshooting
echo "$(date): TEST-FIRST HOOK CALLED with input: $input" >> /tmp/test-first-debug.log
# NOTE: Don't redirect stderr here as it prevents error messages from showing
# exec 2>>/tmp/test-first-debug.log  # This would hide blocking messages!

# Extract tool information using jq (if available)
tool_name=""
file_path=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
  
  # Only process Write, MultiEdit, and Edit tools
  if [[ "$tool_name" != "Write" && "$tool_name" != "MultiEdit" && "$tool_name" != "Edit" ]]; then
    exit 0
  fi
  
  # Extract file path from tool input
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
else
  # Fallback without jq - basic pattern matching
  if echo "$input" | grep -q '"tool_name".*"Write\|MultiEdit\|Edit"'; then
    file_path=$(echo "$input" | grep -o '"file_path"[^"]*"[^"]*"' | cut -d'"' -f4 2>/dev/null || echo "")
  fi
fi

# Exit if no file path found
if [[ -z "$file_path" ]]; then
  exit 0
fi

FILE_PATH="$file_path"

# Only enforce on HestAI project directories
if [[ ! "$FILE_PATH" =~ ^(/Volumes/HestAI-Projects/|/Volumes/HestAI-Tools/) ]]; then
  echo "✓ LOCATION_EXEMPT: File outside HestAI directories - test-first hook skipped" >&2
  exit 0
fi

echo "$(date): Extracted file_path: '$FILE_PATH'" >> /tmp/test-first-debug.log

# Only check implementation files (handle both relative and absolute paths)
if [[ ! "$FILE_PATH" =~ (^|/)src/.*\.(ts|tsx|js|jsx)$ ]]; then
  echo "$(date): Path '$FILE_PATH' doesn't match src pattern, exiting" >> /tmp/test-first-debug.log
  exit 0
fi

echo "$(date): Path '$FILE_PATH' matches src pattern, continuing..." >> /tmp/test-first-debug.log

# Skip test files themselves (including integration/e2e/unit test variants)
if [[ "$FILE_PATH" =~ \.(test|spec|integration\.test|e2e\.test|unit\.test)\.(ts|tsx|js|jsx)$ ]]; then
  exit 0
fi

# Skip type-only files (TestGuard: CONTRACT-DRIVEN-CORRECTION - TypeScript validates types)
if [[ "$FILE_PATH" =~ types?\.(ts|js)$ ]] || [[ "$FILE_PATH" =~ \.d\.ts$ ]]; then
  echo "$(date): Type definition file detected - skipping TDD requirement" >> /tmp/test-first-debug.log
  echo "✓ TYPE_DEFINITION_EXEMPT: TypeScript compiler validates type contracts" >&2
  exit 0
fi

# Check if file contains only type definitions
if [[ -f "$FILE_PATH" ]]; then
  # Read file and check if it only contains type definitions
  if ! grep -qvE '^\s*(//|/\*|\*|import |export (type|interface)|type |interface |$)' "$FILE_PATH" 2>/dev/null; then
    echo "$(date): File contains only type definitions - skipping TDD requirement" >> /tmp/test-first-debug.log
    echo "✓ TYPE_ONLY_EXEMPT: File contains only TypeScript type definitions" >&2
    exit 0
  fi
fi

#============================================================
# INFRASTRUCTURE EXEMPTION (Added 2025-10-18)
# Constitutional Basis: Test infrastructure creates circular
# dependency paradox. Changes validate via dependent test
# execution, not co-located tests.
#============================================================

EXEMPT_PATTERNS=(
  "*/test/setup.ts"        # Vitest global configuration
  "*/test/setup.js"        # Vitest global configuration (JS)
  "*/test/factories.ts"    # Test data builders
  "*/test/factories.js"    # Test data builders (JS)
  "*/test/mocks.ts"        # Mock definitions
  "*/test/mocks.js"        # Mock definitions (JS)
  "*/test/supabase-test-client.ts"   # Supabase test client utilities
  "*/test/supabase-test-client.js"   # Supabase test client utilities (JS)
  "*/test/auth-helpers.ts"           # Auth test helpers
  "*/test/auth-helpers.js"           # Auth test helpers (JS)
  "*/test/testUtils.ts"              # Test utilities (generic)
  "*/test/testUtils.tsx"             # Test utilities (React)
  "*/test/testUtils.js"              # Test utilities (generic JS)
  "*/test/testUtils.jsx"             # Test utilities (React JS)
  "*/src/test/*.ts"        # All test infrastructure utilities (TypeScript)
  "*/src/test/*.tsx"       # All test infrastructure utilities (React)
  "*/src/test/*.js"        # All test infrastructure utilities (JavaScript)
  "*/src/test/*.jsx"       # All test infrastructure utilities (React JS)
  "vitest.config.ts"       # Vitest configuration
  "vitest.config.js"       # Vitest configuration (JS)
  "vite.config.ts"         # Vite configuration
  "vite.config.js"         # Vite configuration (JS)
  "tsconfig.json"          # TypeScript configuration
  "tsconfig.*.json"        # TypeScript project references
  "*.config.ts"            # All config files (TypeScript)
  "*.config.js"            # All config files (JavaScript)
  ".eslintrc.*"            # ESLint configuration
  ".prettierrc.*"          # Prettier configuration
  "jest.config.*"          # Jest configuration
  "webpack.config.*"       # Webpack configuration
)

# Check if changed file matches any exemption pattern
for pattern in "${EXEMPT_PATTERNS[@]}"; do
  # Convert glob pattern to regex for case statement matching
  if [[ "$FILE_PATH" == $pattern ]]; then
    echo "$(date): TDD Exemption: $FILE_PATH (test infrastructure)" >> /tmp/test-first-debug.log
    echo "✓ TDD Exemption: $FILE_PATH (test infrastructure)" >&2
    echo "  Validation: Changes verify through dependent test execution" >&2
    exit 0
  fi
done

# Derive expected test file path
DIR_PATH=$(dirname "$FILE_PATH")
FILE_NAME=$(basename "$FILE_PATH" .ts)

# Handle both .ts/.tsx and .js/.jsx extensions
EXTENSION=""
if [[ "$FILE_PATH" =~ \.tsx$ ]]; then
  EXTENSION=".tsx"
  FILE_NAME=$(basename "$FILE_PATH" .tsx)
elif [[ "$FILE_PATH" =~ \.ts$ ]]; then
  EXTENSION=".ts"
  FILE_NAME=$(basename "$FILE_PATH" .ts)
elif [[ "$FILE_PATH" =~ \.jsx$ ]]; then
  EXTENSION=".jsx"
  FILE_NAME=$(basename "$FILE_PATH" .jsx)
elif [[ "$FILE_PATH" =~ \.js$ ]]; then
  EXTENSION=".js"
  FILE_NAME=$(basename "$FILE_PATH" .js)
fi

# For absolute paths, use absolute paths for co-located tests
# For relative paths, keep relative
if [[ "$FILE_PATH" =~ ^/ ]]; then
  # Absolute path - get project root by removing everything from /src/ onwards
  PROJECT_ROOT=$(echo "$FILE_PATH" | sed 's|/src/.*||')
  
  # Extract relative path from src/ onwards for hierarchical mapping
  # Critical-Engineer: Hierarchical path mapping fix for quality gate architecture
  if [[ "$FILE_PATH" =~ /src/(.*) ]]; then
    SRC_RELATIVE_PATH="${BASH_REMATCH[1]}"
    # Remove file extension from relative path for test file naming
    SRC_RELATIVE_DIR=$(dirname "$SRC_RELATIVE_PATH")
    
    # Strip common organizational prefixes that shouldn't be mirrored in tests
    # Critical-Engineer: Handle /lib/ prefix stripping for established project patterns
    if [[ "$SRC_RELATIVE_DIR" =~ ^lib/(.*) ]]; then
      SRC_RELATIVE_DIR="${BASH_REMATCH[1]}"
    fi
    
    if [[ "$SRC_RELATIVE_DIR" == "." ]] || [[ "$SRC_RELATIVE_DIR" == "lib" ]]; then
      # File is directly in src/ or src/lib/ folder
      HIERARCHICAL_TEST_PATH="${PROJECT_ROOT}/tests/unit/${FILE_NAME}.test${EXTENSION}"
    else
      # File is in subfolder - preserve directory structure after lib/ stripping
      HIERARCHICAL_TEST_PATH="${PROJECT_ROOT}/tests/unit/${SRC_RELATIVE_DIR}/${FILE_NAME}.test${EXTENSION}"
    fi
  else
    # Fallback for files not in src/ structure
    HIERARCHICAL_TEST_PATH="${PROJECT_ROOT}/tests/unit/${FILE_NAME}.test${EXTENSION}"
  fi

  # Support both .ts and .tsx for test files (tests may use React Testing Library)
  ALT_EXTENSION=""
  if [[ "$EXTENSION" == ".ts" ]]; then
    ALT_EXTENSION=".tsx"
  elif [[ "$EXTENSION" == ".tsx" ]]; then
    ALT_EXTENSION=".ts"
  elif [[ "$EXTENSION" == ".js" ]]; then
    ALT_EXTENSION=".jsx"
  elif [[ "$EXTENSION" == ".jsx" ]]; then
    ALT_EXTENSION=".js"
  fi

  POSSIBLE_TEST_PATHS=(
    "${DIR_PATH}/${FILE_NAME}.test${EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.test${ALT_EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.unit.test${EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.integration.test${EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.e2e.test${EXTENSION}"
    "$HIERARCHICAL_TEST_PATH"
    "${PROJECT_ROOT}/tests/unit/${FILE_NAME}.test${EXTENSION}"
    "${PROJECT_ROOT}/tests/unit/${FILE_NAME}.test${ALT_EXTENSION}"
    "${PROJECT_ROOT}/test/${FILE_NAME}.test${EXTENSION}"
    "${PROJECT_ROOT}/test/${FILE_NAME}.test${ALT_EXTENSION}"
    "${PROJECT_ROOT}/__tests__/${FILE_NAME}.test${EXTENSION}"
    "${PROJECT_ROOT}/__tests__/${FILE_NAME}.test${ALT_EXTENSION}"
  )
else
  # Relative path - also support hierarchical mapping
  if [[ "$FILE_PATH" =~ src/(.*) ]]; then
    SRC_RELATIVE_PATH="${BASH_REMATCH[1]}"
    SRC_RELATIVE_DIR=$(dirname "$SRC_RELATIVE_PATH")
    
    # Strip /lib/ prefix for consistency with absolute path handling
    if [[ "$SRC_RELATIVE_DIR" =~ ^lib/(.*) ]]; then
      SRC_RELATIVE_DIR="${BASH_REMATCH[1]}"
    fi
    
    if [[ "$SRC_RELATIVE_DIR" == "." ]] || [[ "$SRC_RELATIVE_DIR" == "lib" ]]; then
      HIERARCHICAL_TEST_PATH="tests/unit/${FILE_NAME}.test${EXTENSION}"
    else
      HIERARCHICAL_TEST_PATH="tests/unit/${SRC_RELATIVE_DIR}/${FILE_NAME}.test${EXTENSION}"
    fi
  else
    HIERARCHICAL_TEST_PATH="tests/unit/${FILE_NAME}.test${EXTENSION}"
  fi

  # Support both .ts and .tsx for test files (tests may use React Testing Library)
  ALT_EXTENSION=""
  if [[ "$EXTENSION" == ".ts" ]]; then
    ALT_EXTENSION=".tsx"
  elif [[ "$EXTENSION" == ".tsx" ]]; then
    ALT_EXTENSION=".ts"
  elif [[ "$EXTENSION" == ".js" ]]; then
    ALT_EXTENSION=".jsx"
  elif [[ "$EXTENSION" == ".jsx" ]]; then
    ALT_EXTENSION=".js"
  fi

  POSSIBLE_TEST_PATHS=(
    "${DIR_PATH}/${FILE_NAME}.test${EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.test${ALT_EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.unit.test${EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.integration.test${EXTENSION}"
    "${DIR_PATH}/${FILE_NAME}.e2e.test${EXTENSION}"
    "$HIERARCHICAL_TEST_PATH"
    "tests/unit/${FILE_NAME}.test${EXTENSION}"
    "tests/unit/${FILE_NAME}.test${ALT_EXTENSION}"
    "test/${FILE_NAME}.test${EXTENSION}"
    "test/${FILE_NAME}.test${ALT_EXTENSION}"
    "__tests__/${FILE_NAME}.test${EXTENSION}"
    "__tests__/${FILE_NAME}.test${ALT_EXTENSION}"
  )
fi

# Check if test file exists
TEST_EXISTS=false
for TEST_PATH in "${POSSIBLE_TEST_PATHS[@]}"; do
  if [[ -f "$TEST_PATH" ]]; then
    TEST_EXISTS=true
    break
  fi
done

echo "$(date): Checking test paths for '$FILE_PATH':" >> /tmp/test-first-debug.log
for TEST_PATH in "${POSSIBLE_TEST_PATHS[@]}"; do
  echo "$(date):   Checking: $TEST_PATH" >> /tmp/test-first-debug.log
  if [[ -f "$TEST_PATH" ]]; then
    echo "$(date):   Found test file: $TEST_PATH" >> /tmp/test-first-debug.log
  fi
done

# Check for consultation evidence before blocking
if [[ "$TEST_EXISTS" == "false" ]]; then
  # Extract content to check for consultation evidence
  content=""
  if [[ "$tool_name" == "Write" ]]; then
    content=$(echo "$input" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
  elif [[ "$tool_name" == "Edit" ]]; then
    content=$(echo "$input" | jq -r '.tool_input.new_string // .tool_input.content // empty' 2>/dev/null || echo "")
  fi
  
  # Pattern 1: APPROVED format (gold standard)
  if echo "$content" | grep -qiE "(//|#)[[:space:]]*(TESTGUARD_APPROVED):[[:space:]]*.*consultation[[:space:]]+[a-f0-9-]{36}"; then
    echo "$(date): Testguard approval evidence found - allowing" >> /tmp/test-first-debug.log
    echo "✓ Testguard approval evidence verified - proceeding" >&2
    exit 0
  fi
  
  # Pattern 2: Any consultation evidence
  if echo "$content" | grep -qiE "(//|#)[[:space:]]*(testguard|critical-engineer).*(consulted|consultation|approved)"; then
    echo "$(date): Consultation evidence found - allowing" >> /tmp/test-first-debug.log
    echo "✓ Testing consultation evidence found - proceeding" >&2
    exit 0
  fi
  
  echo "$(date): No test found, blocking!" >> /tmp/test-first-debug.log
  # Output blocking message to stderr for Claude Code to display
  cat >&2 <<EOF
🚨 BLOCKING: No test file found for implementation

Implementation: $FILE_PATH

Expected test locations:
$(for TEST_PATH in "${POSSIBLE_TEST_PATHS[@]}"; do echo "  - $TEST_PATH"; done)

TDD Requirement: Write failing test BEFORE implementation
EOF
  exit 2  # Using successful blocking exit code pattern (same as anchor hook)
else
  echo "$(date): Test file exists, allowing creation" >> /tmp/test-first-debug.log
fi