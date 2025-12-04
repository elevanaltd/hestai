#!/usr/bin/env bash
# Integration Detection Helper v1.0
# Smart detection of legitimate integration wiring vs new code
# TESTGUARD_BYPASS: HOOK-INFRA-002 - Hook infrastructure

set -euo pipefail

# Check if this is integration wiring of tested components
is_integration_wiring() {
  local content="$1"
  local file_path="$2"
  
  # Entry point files are candidates for integration
  if [[ ! "$file_path" =~ (index|main|app|server|bootstrap|startup|init)\.(ts|js|tsx|jsx)$ ]]; then
    return 1
  fi
  
  # Check if the content is just importing and calling functions
  local import_count=$(echo "$content" | grep -c "^import\|^const.*require" || true)
  local new_function_count=$(echo "$content" | grep -cE "^(async )?function|^const.*=.*(\(|async|function)" || true)
  local new_class_count=$(echo "$content" | grep -c "^class " || true)
  
  # High import ratio with minimal new logic suggests integration
  if [[ $import_count -gt 0 && $new_function_count -le 1 && $new_class_count -eq 0 ]]; then
    # Check if the new content is mostly just calling imported functions
    if echo "$content" | grep -qE "^\s*(await\s+)?[a-zA-Z]+\([^)]*\);?\s*$"; then
      echo "INTEGRATION_WIRING: Entry point calling imported functions" >&2
      return 0
    fi
  fi
  
  # Check for specific integration patterns
  local integration_patterns=(
    "validateEnvironment\(\)"
    "initializeConfig\(\)"
    "setupLogger\(\)"
    "connectDatabase\(\)"
    "startServer\(\)"
    "bootstrap\(\)"
    "registerMiddleware\(\)"
    "setupRoutes\(\)"
  )
  
  for pattern in "${integration_patterns[@]}"; do
    if echo "$content" | grep -q "$pattern"; then
      # This looks like integration - check if it's adding complex logic
      local line_count=$(echo "$content" | wc -l)
      local logic_keywords=$(echo "$content" | grep -cE "if\s*\(|for\s*\(|while\s*\(|switch\s*\(|try\s*\{" || true)
      
      # If it's mostly just calling functions with minimal logic
      if [[ $logic_keywords -lt 3 && $line_count -lt 50 ]]; then
        echo "INTEGRATION_PATTERN: Wiring $pattern with minimal logic" >&2
        return 0
      fi
    fi
  done
  
  return 1
}

# Check if a component being integrated has tests
component_has_tests() {
  local component_name="$1"
  local file_path="$2"
  
  # Extract the base directory
  local base_dir=$(dirname "$file_path")
  
  # Look for test files in various locations
  local test_locations=(
    "${base_dir}/**/*${component_name}*.test.*"
    "${base_dir}/**/*${component_name}*.spec.*"
    "${base_dir}/../**/*${component_name}*.test.*"
    "${base_dir}/../**/*${component_name}*.spec.*"
  )
  
  for location in "${test_locations[@]}"; do
    if compgen -G "$location" > /dev/null 2>&1; then
      return 0  # Tests found
    fi
  done
  
  # Check git for test files
  if git ls-files 2>/dev/null | grep -qE "${component_name}\.(test|spec)\."; then
    return 0
  fi
  
  return 1  # No tests found
}

# Smart detection that understands context
analyze_integration_context() {
  local file_path="$1"
  local content="$2"
  
  # Extract imports to understand what's being integrated
  local imports=$(echo "$content" | grep -E "^import.*from|^const.*require" || true)
  
  # Count actual business logic vs wiring
  local business_logic_count=$(echo "$content" | grep -cE "class |extends |implements |interface |type |enum " || true)
  local wiring_count=$(echo "$content" | grep -cE "app\.|server\.|router\.|middleware\." || true)
  
  # High wiring-to-logic ratio suggests integration
  if [[ $wiring_count -gt 0 && $business_logic_count -eq 0 ]]; then
    echo "INTEGRATION_CONTEXT: High wiring ratio, no business logic" >&2
    return 0
  fi
  
  return 1
}

# Export functions
export -f is_integration_wiring
export -f component_has_tests  
export -f analyze_integration_context