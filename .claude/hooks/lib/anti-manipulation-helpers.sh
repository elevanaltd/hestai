#!/usr/bin/env bash
# Anti-Manipulation Helper Library v1.0
# Core functions for preventing AI test manipulation
# Focus: Prevent Claude from weakening tests instead of fixing code

set -euo pipefail

# Check if NodeJS and TypeScript are available for semantic analysis
HAS_NODE=false
HAS_SEMANTIC_DETECTOR=false

if command -v node >/dev/null 2>&1; then
  HAS_NODE=true
  if [[ -f "$HOME/.claude/hooks/lib/detect-test-manipulation.js" ]]; then
    HAS_SEMANTIC_DETECTOR=true
  fi
fi

# Detect if content contains test manipulation patterns
detect_test_manipulation() {
  local old_content="$1"
  local new_content="$2"
  local file_path="${3:-unknown}"
  
  # Quick check: Is this a test file?
  if [[ ! "$file_path" =~ \.(test|spec)\. ]]; then
    return 0  # Not a test file, no manipulation possible
  fi
  

  # EXEMPTION 1: TypeScript import extension fixes
  if echo "$new_content" | grep -q ".js.;$" && echo "$old_content" | grep -qv ".js.;$"; then
    echo "INFO: TypeScript import extension fix detected - not manipulation" >&2
    return 0
  fi
  # EXEMPTION 2: Type assertions for compilation fixes
  if echo "$new_content" | grep -q "(.*as any)" && ! echo "$old_content" | grep -q "expect.*as any"; then
    echo "INFO: Type assertion for compilation detected - not manipulation" >&2
    return 0
  fi
  # EXEMPTION 3: Contract-driven test corrections (interface/API changes)
  if detect_contract_correction "$old_content" "$new_content" "$file_path"; then
    echo "INFO: Contract-driven test correction detected - legitimate interface alignment" >&2
    return 0
  fi
  
  # Check if this is primarily new test content being added
  # Count test functions in old vs new to detect additions vs modifications
  local old_test_count=$(echo "$old_content" | grep -c "^\s*it\s*(" 2>/dev/null || echo "0")
  local new_test_count=$(echo "$new_content" | grep -c "^\s*it\s*(" 2>/dev/null || echo "0")
  
  # Ensure we have valid numbers (fallback to 0 if empty)
  [[ -z "$old_test_count" || ! "$old_test_count" =~ ^[0-9]+$ ]] && old_test_count=0
  [[ -z "$new_test_count" || ! "$new_test_count" =~ ^[0-9]+$ ]] && new_test_count=0
  
  # If we're adding more tests than modifying, it's likely not manipulation
  if [[ $new_test_count -gt $old_test_count ]]; then
    echo "INFO: Adding new tests (from $old_test_count to $new_test_count) - not manipulation" >&2
    return 0
  fi
  
  # Use semantic analysis if available
  if [[ "$HAS_SEMANTIC_DETECTOR" == "true" ]]; then
    if node "$HOME/.claude/hooks/lib/detect-test-manipulation.js" "$old_content" "$new_content" "$file_path" 2>/dev/null; then
      return 0  # No manipulation detected
    else
      return 1  # Manipulation detected
    fi
  fi
  
  # Fallback to pattern-based detection
  detect_manipulation_patterns "$old_content" "$new_content"
}

# Pattern-based manipulation detection (fallback)
detect_manipulation_patterns() {
  local old_content="$1"
  local new_content="$2"
  
  local violations=""
  
  # Check for test avoidance
  if echo "$new_content" | grep -qE "\.(skip|only)\(" && ! echo "$old_content" | grep -qE "\.(skip|only)\("; then
    violations+="TEST_AVOIDANCE: Test disabled with .skip() or .only()"$'\n'
  fi
  
  # Check for weakened assertions
  if check_weakened_assertions "$old_content" "$new_content"; then
    violations+="WEAKENED_ASSERTIONS: Test assertions made less strict"$'\n'
  fi
  
  # Check for removed assertions
  if check_removed_assertions "$old_content" "$new_content"; then
    violations+="REMOVED_ASSERTIONS: Test validations removed"$'\n'
  fi
  
  # Check for expectation adjustments
  if check_expectation_adjustments "$old_content" "$new_content"; then
    violations+="EXPECTATION_ADJUSTMENT: Expected values changed to match broken output"$'\n'
  fi
  
  # Check for trivial test creation (workaround pattern)
  if check_trivial_test_creation "$old_content" "$new_content"; then
    violations+="TRIVIAL_TEST_CREATION: Meaningless test created to bypass requirements"$'\n'
  fi
  
  # Check for timeout increases (hiding performance issues)
  if check_timeout_increases "$old_content" "$new_content"; then
    violations+="TIMEOUT_MANIPULATION: Test timeouts increased to hide performance issues"$'\n'
  fi
  
  if [[ -n "$violations" ]]; then
    echo "$violations" >&2
    return 1
  fi
  
  return 0
}

# Check for weakened assertions
check_weakened_assertions() {
  local old_content="$1"
  local new_content="$2"
  
  # Patterns indicating weakening
  local weakening_patterns=(
    "toBe.*toBeTruthy"
    "toEqual.*toBeDefined"
    "toStrictEqual.*toEqual"
    "toThrow\([^)]+\).*toThrow\(\)"
    "toHaveBeenCalledWith.*toHaveBeenCalled"
    "toMatch\([^)]+\).*toBeDefined"
    # Additional Python/pytest patterns
    "assertEqual.*assertTrue"
    "assertIs.*assertIsNotNone"
    "assertRaises\([^)]+\).*assertTrue"
    "assertIn.*assertTrue"
    "assertGreater.*assertTrue"
    "assertLess.*assertTrue"
    # Generic catch-all patterns
    "assert.*True"
    "assertTrue.*True"
    "expect.*anything"
    "toBeCloseTo.*toBeDefined"
    "toContain.*toBeTruthy"
    "toHaveLength.*toBeDefined"
    # Mock/spy weakening
    "toHaveBeenCalledTimes\([0-9]+\).*toHaveBeenCalled"
    "toHaveBeenLastCalledWith.*toHaveBeenCalled"
    # Error handling weakening
    "toThrowError\([^)]+\).*not\.toThrow"
    "assertRaises\([^)]+\).*pass"
  )
  
  for pattern in "${weakening_patterns[@]}"; do
    local old_pattern="${pattern%.*}"
    local new_pattern="${pattern#*.}"
    
    if echo "$old_content" | grep -q "$old_pattern" && echo "$new_content" | grep -q "$new_pattern"; then
      return 0  # Weakening detected
    fi
  done
  
  return 1
}

# Check for removed assertions
check_removed_assertions() {
  local old_content="$1"
  local new_content="$2"
  
  # Count expect() statements
  local old_count=$(echo "$old_content" | grep -c "expect(" || true)
  local new_count=$(echo "$new_content" | grep -c "expect(" || true)
  
  if [[ $new_count -lt $old_count ]]; then
    return 0  # Assertions removed
  fi
  
  return 1
}

# Check for expectation adjustments
check_expectation_adjustments() {
  local old_content="$1"
  local new_content="$2"
  
  # Look for changed values in assertions that might indicate "fixing the test"
  # This is a heuristic - looks for common patterns of adjusting to match output
  
  # Check for changes to undefined/null/empty values (common when adjusting to broken output)
  if echo "$new_content" | grep -qE "toBe\((undefined|null|''|\"\"|\[\]|\{\})\)" && \
     ! echo "$old_content" | grep -qE "toBe\((undefined|null|''|\"\"|\[\]|\{\})\)"; then
    return 0  # Likely adjusted to match broken output
  fi
  
  return 1
}

# Check for trivial test creation (workaround pattern)
check_trivial_test_creation() {
  local old_content="$1"
  local new_content="$2"
  
  # Detect patterns indicating trivial/meaningless tests
  local trivial_patterns=(
    "assertTrue\(true\)"
    "assertTrue\(True\)"  # Python
    "expect\(true\)\.toBe\(true\)"
    "expect\(1\)\.toBe\(1\)"
    "assertEqual\(1, 1\)"
    "assert 1 == 1"
    "self\.assertTrue\(True\)"
    "test.*pass$"  # Empty test with just 'pass'
    "def test.*:\s*pass"  # Python empty test
    "it\(['\"].*['\"], \(\) => \{\}\)"  # Empty JS test
  )
  
  for pattern in "${trivial_patterns[@]}"; do
    if echo "$new_content" | grep -qE "$pattern" && ! echo "$old_content" | grep -qE "$pattern"; then
      return 0  # Trivial test detected
    fi
  done
  
  # Check for tests with no meaningful assertions
  local new_test_count=$(echo "$new_content" | grep -cE "(def test|it\(|test\()" || true)
  local new_assertion_count=$(echo "$new_content" | grep -cE "(expect\(|assert|assertTrue|assertEqual)" || true)
  
  if [[ $new_test_count -gt 0 ]] && [[ $new_assertion_count -eq 0 ]]; then
    return 0  # Test without assertions
  fi
  
  return 1
}

# Check for timeout increases (hiding performance issues)
check_timeout_increases() {
  local old_content="$1"
  local new_content="$2"
  
  # Extract timeout values from old and new content
  local old_timeouts=$(echo "$old_content" | grep -oE "timeout[:=]\s*[0-9]+" | grep -oE "[0-9]+" || true)
  local new_timeouts=$(echo "$new_content" | grep -oE "timeout[:=]\s*[0-9]+" | grep -oE "[0-9]+" || true)
  
  # Check if any timeout was significantly increased (>2x)
  if [[ -n "$old_timeouts" && -n "$new_timeouts" ]]; then
    while IFS= read -r old_timeout; do
      while IFS= read -r new_timeout; do
        if [[ $new_timeout -gt $((old_timeout * 2)) ]]; then
          return 0  # Timeout manipulation detected
        fi
      done <<< "$new_timeouts"
    done <<< "$old_timeouts"
  fi
  
  # Check for new timeout additions (might be hiding slow code)
  if echo "$new_content" | grep -qE "timeout[:=]\s*[0-9]+" && ! echo "$old_content" | grep -qE "timeout[:=]\s*[0-9]+"; then
    local new_timeout=$(echo "$new_content" | grep -oE "timeout[:=]\s*[0-9]+" | grep -oE "[0-9]+" | head -1)
    if [[ $new_timeout -gt 5000 ]]; then  # >5 seconds might be suspicious
      return 0
    fi
  fi
  
  return 1
}

# Check if this is integration wiring (legitimate low-risk change)
is_integration_wiring() {
  local content="$1"
  local file_path="$2"
  
  # Check if this is an entry point file
  if [[ ! "$file_path" =~ (index|main|app|server)\.(ts|js)$ ]]; then
    return 1
  fi
  
  # Check if just calling already tested functions
  if echo "$content" | grep -qE "^\+\s*(validateEnvironment|initializeConfig|setupLogger|connectDatabase)\(\)"; then
    # Check if these functions have tests
    local func_name=$(echo "$content" | grep -oE "(validateEnvironment|initializeConfig|setupLogger|connectDatabase)" | head -1)
    if has_tests_for_function "$func_name"; then
      return 0  # This is legitimate integration wiring
    fi
  fi
  
  return 1
}

# Check if a function has tests
has_tests_for_function() {
  local func_name="$1"
  
  # Look for test files for this function
  if git ls-files -- "*${func_name}*.spec.*" "*${func_name}*.test.*" 2>/dev/null | grep -q .; then
    return 0
  fi
  
  # Also check if tests exist in the working directory (not yet committed)
  if ls *"${func_name}"*.spec.* *"${func_name}"*.test.* 2>/dev/null | grep -q .; then
    return 0
  fi
  
  return 1
}

# Detect legitimate contract-driven test corrections
detect_contract_correction() {
  local old_content="$1"
  local new_content="$2"
  local file_path="$3"
  
  # Pattern 1: Response structure changes (pagination, data wrapping)
  if echo "$old_content" | grep -q "pagination" && echo "$new_content" | grep -qv "pagination" && \
     echo "$new_content" | grep -qE "(limit|offset)"; then
    return 0  # Flattened response structure
  fi
  
  # Pattern 2: Property renaming in expectations
  if echo "$old_content" | grep -qE "expect.*\.(toHaveProperty|toBe)" && \
     echo "$new_content" | grep -qE "expect.*\.(toHaveProperty|toBe)" && \
     [[ $(echo "$old_content" | grep -c "expect") -eq $(echo "$new_content" | grep -c "expect") ]]; then
    return 0  # Same number of expectations, likely property name changes
  fi
  
  # Pattern 3: Interface changes with same test coverage
  local old_assertions=$(echo "$old_content" | grep -cE "(expect|assert)" 2>/dev/null || echo "0")
  local new_assertions=$(echo "$new_content" | grep -cE "(expect|assert)" 2>/dev/null || echo "0")

  # Ensure variables are not empty
  old_assertions=${old_assertions:-0}
  new_assertions=${new_assertions:-0}

  if [[ $old_assertions -eq $new_assertions ]] && [[ $old_assertions -gt 0 ]] && \
     echo "$new_content" | grep -qE "(toHaveProperty|toBe|toEqual)" && \
     ! check_weakened_assertions "$old_content" "$new_content"; then
    return 0  # Same assertion count, specific expectations, not weakened
  fi
  
  # Pattern 4: Error message/format updates (still validating errors, just different messages)
  if echo "$old_content" | grep -qE "toThrow.*Error" && \
     echo "$new_content" | grep -qE "toThrow.*Error"; then
    return 0  # Still testing error throwing, just different error details
  fi
  
  return 1
}

# Format manipulation violation message
format_manipulation_message() {
  local violation_type="$1"
  local details="$2"
  local file_path="${3:-unknown}"
  
  cat <<EOF
🚨 TEST MANIPULATION DETECTED - $violation_type

File: $file_path

VIOLATION: $details

PRINCIPLE VIOLATED: Tests reveal reality, not confirm wishes

REQUIRED ACTIONS:
1. REVERT the test changes
2. FIX the code to make the original test pass
3. If the test is genuinely wrong, write a NEW correct test
4. NEVER weaken assertions to hide failures

Remember: The test is the specification. If it fails, the code is wrong.

PATTERNS DETECTED:
- Weakening assertions (toBe → toBeTruthy)
- Removing validations
- Adjusting expectations to match broken output
- Skipping failing tests

This hook prevents you from taking the easy path of "fixing" the test.
The harder path of fixing the code is the correct path.

To proceed:
1. Undo test modifications
2. Fix the actual code
3. Ensure tests pass with their original strictness

EOF
}

# Check if changes include corresponding code fixes
has_corresponding_code_fix() {
  local test_file="$1"
  
  # Derive the source file from test file
  local source_file="${test_file/.test/}"
  source_file="${source_file/.spec/}"
  
  # Check if source file is also being modified
  if git diff --cached --name-only | grep -q "$source_file"; then
    return 0  # Code is being fixed alongside test
  fi
  
  return 1
}

# Validate test-first development
check_test_first() {
  local file_path="$1"
  local content="$2"
  
  # Skip if not a source file
  if [[ "$file_path" =~ \.(test|spec)\. ]]; then
    return 0  # This IS a test file
  fi
  
  # Check if tests exist for this file
  local test_file="${file_path%.*}.test.${file_path##*.}"
  local spec_file="${file_path%.*}.spec.${file_path##*.}"
  
  if [[ ! -f "$test_file" && ! -f "$spec_file" ]]; then
    # Check if test is being created in this commit
    if ! git diff --cached --name-only | grep -qE "(${file_path%.*}\.(test|spec)\.${file_path##*.})"; then
      echo "NO_TEST: Code without test detected" >&2
      return 1
    fi
  fi
  
  return 0
}

# Export functions for use in hooks
export -f detect_test_manipulation
export -f detect_manipulation_patterns
export -f detect_contract_correction
export -f check_weakened_assertions
export -f check_removed_assertions
export -f check_expectation_adjustments
export -f check_trivial_test_creation
export -f check_timeout_increases
export -f is_integration_wiring
export -f has_tests_for_function
export -f format_manipulation_message
export -f has_corresponding_code_fix
export -f check_test_first