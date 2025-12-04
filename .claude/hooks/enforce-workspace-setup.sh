#!/bin/bash

# enforce-workspace-setup.sh
# CRITICAL: Prevents implementation without proper quality infrastructure
# Authority: System Steward (B1 workspace integrity enforcement)
# Created: 2025-01-06

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔍 B1 WORKSPACE SETUP VERIFICATION HOOK${NC}"
echo "Checking quality gate infrastructure..."

# Function to check if we're in a project directory
is_project_dir() {
  # Check if we're in a build directory or have package.json
  if [ -f "package.json" ] || [ -f "../build/package.json" ] || [[ "$PWD" == *"/build"* ]]; then
    return 0
  fi
  return 1
}

# Function to check for src/ file creation
is_creating_src_file() {
  # Check git status for new src/ files
  if git status --porcelain 2>/dev/null | grep -q "^A.*src/"; then
    return 0
  fi
  # Check if src/ directory exists with files
  if [ -d "src" ] && [ "$(ls -A src 2>/dev/null)" ]; then
    return 0
  fi
  return 1
}

# Only run checks if in a project directory
if ! is_project_dir; then
  exit 0
fi

# Check for bypass flag
if [ -f ".workspace-setup-bypass" ]; then
  echo -e "${YELLOW}⚠️  Workspace setup bypass detected. Technical debt will accumulate!${NC}"
  exit 0
fi

# Define required files
REQUIRED_FILES=(
  "package.json"
  "tsconfig.json"
  ".eslintrc.cjs"
  ".prettierrc"
  ".gitignore"
  ".env.example"
)

# Define required CI file
CI_FILE=".github/workflows/ci.yml"

# Define test config files (at least one required)
TEST_CONFIGS=("vitest.config.ts" "jest.config.js" "jest.config.ts")

# Track missing items
MISSING_ITEMS=()

# Check each required file
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    MISSING_ITEMS+=("❌ $file - MISSING")
  else
    echo -e "${GREEN}✅ $file found${NC}"
  fi
done

# Check for test configuration (at least one)
TEST_CONFIG_FOUND=false
for config in "${TEST_CONFIGS[@]}"; do
  if [ -f "$config" ]; then
    TEST_CONFIG_FOUND=true
    echo -e "${GREEN}✅ $config found${NC}"
    break
  fi
done

if [ "$TEST_CONFIG_FOUND" = false ]; then
  MISSING_ITEMS+=("❌ Test configuration (vitest.config.ts or jest.config.js) - MISSING")
fi

# Check for CI configuration
if [ ! -f "$CI_FILE" ]; then
  MISSING_ITEMS+=("❌ $CI_FILE - MISSING")
else
  echo -e "${GREEN}✅ $CI_FILE found${NC}"
  
  # Verify CI has quality gates
  if ! grep -q "npm run lint" "$CI_FILE" 2>/dev/null; then
    MISSING_ITEMS+=("❌ CI missing 'npm run lint' step")
  fi
  if ! grep -q "npm run typecheck" "$CI_FILE" 2>/dev/null; then
    MISSING_ITEMS+=("❌ CI missing 'npm run typecheck' step")
  fi
  if ! grep -q "npm test" "$CI_FILE" 2>/dev/null; then
    MISSING_ITEMS+=("❌ CI missing 'npm test' step")
  fi
fi

# If package.json exists, verify scripts
if [ -f "package.json" ]; then
  # Check for required scripts
  REQUIRED_SCRIPTS=("lint" "typecheck" "test")
  for script in "${REQUIRED_SCRIPTS[@]}"; do
    if ! grep -q "\"$script\":" package.json; then
      MISSING_ITEMS+=("❌ package.json missing script: $script")
    fi
  done
  
  # If all config files exist, try to run quality gates
  if [ ${#MISSING_ITEMS[@]} -eq 0 ] && [ -d "node_modules" ]; then
    echo ""
    echo "Running quality gate verification..."
    
    # Try to run the quality gates
    if npm run lint >/dev/null 2>&1 && npm run typecheck >/dev/null 2>&1 && npm run test >/dev/null 2>&1; then
      echo -e "${GREEN}✅ Quality gates pass!${NC}"
    else
      echo -e "${YELLOW}⚠️  Quality gates not fully operational yet${NC}"
      # Don't block if gates aren't passing yet, just warn
    fi
  fi
fi

# Block if trying to create src/ files without infrastructure
if is_creating_src_file && [ ${#MISSING_ITEMS[@]} -gt 0 ]; then
  echo ""
  echo -e "${RED}🚫 B1 WORKSPACE SETUP VIOLATION DETECTED!${NC}"
  echo -e "${RED}Cannot create src/ files without proper infrastructure.${NC}"
  echo ""
  echo "Missing required items:"
  for item in "${MISSING_ITEMS[@]}"; do
    echo "  $item"
  done
  echo ""
  echo -e "${YELLOW}REQUIRED ACTION:${NC}"
  echo "1. Complete B1 workspace setup checklist FIRST"
  echo "2. Ensure 'npm run lint && npm run typecheck && npm run test' passes"
  echo "3. See: /Users/shaunbuswell/.claude/protocols/WORKSPACE-SETUP.md"
  echo ""
  echo -e "${YELLOW}To bypass (ONLY with explicit approval):${NC}"
  echo "  echo 'WORKSPACE_SETUP_BYPASS: [justification]' > .workspace-setup-bypass"
  echo ""
  exit 1
fi

# If missing items but not creating src files yet, just warn
if [ ${#MISSING_ITEMS[@]} -gt 0 ]; then
  echo ""
  echo -e "${YELLOW}⚠️  Workspace setup incomplete. Complete before implementation:${NC}"
  for item in "${MISSING_ITEMS[@]}"; do
    echo "  $item"
  done
  echo ""
fi

exit 0