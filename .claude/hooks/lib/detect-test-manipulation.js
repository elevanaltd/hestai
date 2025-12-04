#!/usr/bin/env node
/**
 * Test Manipulation Detector v1.0
 * Prevents AI from weakening tests instead of fixing code
 * Uses AST analysis for semantic understanding beyond regex
 */

// Context7: consulted for typescript - AST parsing for semantic code analysis
// Context7: consulted for fs - file system operations
// Context7: consulted for path - path manipulation utilities
// Critical-Engineer: consulted for test-manipulation-detection architecture
// CRITICAL_ENGINEER_APPROVED: Anti-manipulation pattern detection implementation

const ts = require('typescript');
const fs = require('fs');
const path = require('path');

// Manipulation patterns that indicate test gaming
const MANIPULATION_PATTERNS = {
  WEAKENED_ASSERTIONS: {
    severity: 'CRITICAL',
    patterns: [
      { from: /\.toBe\([^)]+\)/, to: /\.toBeTruthy\(\)/, desc: 'Specific assertion replaced with generic' },
      { from: /\.toEqual\([^)]+\)/, to: /\.toBeDefined\(\)/, desc: 'Equality check weakened to existence' },
      { from: /\.toThrow\([^)]+\)/, to: /\.toThrow\(\)/, desc: 'Specific error check made generic' },
      { from: /\.toHaveBeenCalledWith\([^)]+\)/, to: /\.toHaveBeenCalled\(\)/, desc: 'Call args verification removed' }
    ]
  },
  
  REMOVED_VALIDATIONS: {
    severity: 'CRITICAL',
    patterns: [
      { removed: /expect\([^)]+\)\.[^;]+;/, desc: 'Assertion removed entirely' },
      { removed: /\.toHaveLength\([^)]+\)/, desc: 'Array/string length validation removed' },
      { removed: /\.toContain\([^)]+\)/, desc: 'Content validation removed' }
    ]
  },
  
  TEST_AVOIDANCE: {
    severity: 'CRITICAL', 
    patterns: [
      { added: /\.(skip|only)\(/, desc: 'Test disabled or isolated' },
      { added: /pending\(\)/, desc: 'Test marked pending' },
      { added: /@(Ignore|Disabled)/, desc: 'Test annotation to skip' },
      { added: /return\s+Promise\.resolve\(\)/, desc: 'Test short-circuited' }
    ]
  },
  
  EXCESSIVE_MOCKING: {
    severity: 'HIGH',
    patterns: [
      { added: /mockReturnValue\(.*\)/, threshold: 3, desc: 'Excessive mock returns hiding reality' },
      { added: /jest\.mock\(/, threshold: 5, desc: 'Too many modules mocked' },
      { replaced: /actual implementation/, with: /mock/, desc: 'Real logic replaced with mocks' }
    ]
  },
  
  EXPECTATION_ADJUSTMENT: {
    severity: 'CRITICAL',
    patterns: [
      { 
        detect: 'Value in expect().toBe() changed to match actual output',
        check: (oldAST, newAST) => detectExpectationAdjustment(oldAST, newAST)
      }
    ]
  }
};

/**
 * Main detection function
 */
function detectTestManipulation(oldContent, newContent, fileName = 'test.ts') {
  const violations = [];
  
  try {
    // Parse AST for both versions
    const oldAST = ts.createSourceFile(`old_${fileName}`, oldContent, ts.ScriptTarget.Latest, true);
    const newAST = ts.createSourceFile(`new_${fileName}`, newContent, ts.ScriptTarget.Latest, true);
    
    // Check for weakened assertions
    const weakenedAssertions = findWeakenedAssertions(oldAST, newAST);
    if (weakenedAssertions.length > 0) {
      violations.push({
        type: 'WEAKENED_ASSERTIONS',
        severity: 'CRITICAL',
        details: weakenedAssertions,
        message: 'Tests made less strict - fix the code, not the test!'
      });
    }
    
    // Check for removed test logic
    const removedLogic = findRemovedTestLogic(oldAST, newAST);
    if (removedLogic.length > 0) {
      violations.push({
        type: 'REMOVED_TEST_LOGIC',
        severity: 'CRITICAL',
        details: removedLogic,
        message: 'Test validations removed - tests must reveal reality!'
      });
    }
    
    // Check for test avoidance patterns
    const avoidancePatterns = findTestAvoidance(oldContent, newContent);
    if (avoidancePatterns.length > 0) {
      violations.push({
        type: 'TEST_AVOIDANCE',
        severity: 'CRITICAL',
        details: avoidancePatterns,
        message: 'Tests disabled or skipped - face the failing test!'
      });
    }
    
    // Check for expectation adjustments
    const adjustments = detectExpectationAdjustment(oldAST, newAST);
    if (adjustments.length > 0) {
      violations.push({
        type: 'EXPECTATION_ADJUSTMENT',
        severity: 'CRITICAL',
        details: adjustments,
        message: 'Expectations adjusted to match broken code - this hides bugs!'
      });
    }
    
  } catch (error) {
    // Fallback to pattern matching if AST parsing fails
    violations.push(...detectViaPatterns(oldContent, newContent));
  }
  
  return violations;
}

/**
 * Find weakened assertions by comparing AST nodes
 */
function findWeakenedAssertions(oldAST, newAST) {
  const weakened = [];
  const oldAssertions = extractAssertions(oldAST);
  const newAssertions = extractAssertions(newAST);
  
  oldAssertions.forEach(oldAssertion => {
    const corresponding = findCorrespondingAssertion(oldAssertion, newAssertions);
    if (corresponding && isWeakened(oldAssertion, corresponding)) {
      weakened.push({
        line: corresponding.line,
        old: oldAssertion.text,
        new: corresponding.text,
        reason: determineWeakeningReason(oldAssertion, corresponding)
      });
    }
  });
  
  return weakened;
}

/**
 * Extract all assertion statements from AST
 */
function extractAssertions(sourceFile) {
  const assertions = [];
  
  function visit(node) {
    if (ts.isCallExpression(node)) {
      const text = node.getText(sourceFile);
      if (text.includes('expect(') || text.includes('assert')) {
        assertions.push({
          text: text,
          line: sourceFile.getLineAndCharacterOfPosition(node.getStart(sourceFile)).line + 1,
          node: node
        });
      }
    }
    ts.forEachChild(node, visit);
  }
  
  visit(sourceFile);
  return assertions;
}

/**
 * Check if an assertion has been weakened
 */
function isWeakened(oldAssertion, newAssertion) {
  const strongMatchers = ['toBe', 'toEqual', 'toStrictEqual', 'toHaveBeenCalledWith', 'toThrowError'];
  const weakMatchers = ['toBeTruthy', 'toBeFalsy', 'toBeDefined', 'toBeUndefined', 'toHaveBeenCalled'];
  
  const oldMatcher = extractMatcher(oldAssertion.text);
  const newMatcher = extractMatcher(newAssertion.text);
  
  // Check if moved from strong to weak matcher
  if (strongMatchers.includes(oldMatcher) && weakMatchers.includes(newMatcher)) {
    return true;
  }
  
  // Check if assertion lost specificity (had args, now doesn't)
  if (oldAssertion.text.includes('(') && !newAssertion.text.includes('(')) {
    return true;
  }
  
  return false;
}

/**
 * Extract matcher name from assertion text
 */
function extractMatcher(assertionText) {
  const match = assertionText.match(/\.(to\w+|not\.to\w+)\(/);
  return match ? match[1].replace('not.', '') : '';
}

/**
 * Find removed test logic
 */
function findRemovedTestLogic(oldAST, newAST) {
  const removed = [];
  const oldAssertions = extractAssertions(oldAST);
  const newAssertions = extractAssertions(newAST);
  
  // Find assertions that existed in old but not in new
  oldAssertions.forEach(oldAssertion => {
    const stillExists = newAssertions.some(newAssertion => 
      similarAssertions(oldAssertion.text, newAssertion.text)
    );
    
    if (!stillExists) {
      removed.push({
        line: oldAssertion.line,
        removed: oldAssertion.text,
        impact: 'Validation logic removed - coverage decreased'
      });
    }
  });
  
  return removed;
}

/**
 * Check if two assertions are similar (not exact match due to reformatting)
 */
function similarAssertions(assertion1, assertion2) {
  // Normalize whitespace and compare
  const normalize = (str) => str.replace(/\s+/g, ' ').trim();
  return normalize(assertion1) === normalize(assertion2);
}

/**
 * Detect test avoidance patterns
 */
function findTestAvoidance(oldContent, newContent) {
  const avoidance = [];
  
  // Check for newly added skip/only/pending
  const skipPatterns = [
    /\.skip\(/g,
    /\.only\(/g,
    /\bxit\(/g,
    /\bxdescribe\(/g,
    /\.pending\(/g,
    /@Ignore/g,
    /@Disabled/g
  ];
  
  skipPatterns.forEach(pattern => {
    const oldMatches = (oldContent.match(pattern) || []).length;
    const newMatches = (newContent.match(pattern) || []).length;
    
    if (newMatches > oldMatches) {
      avoidance.push({
        pattern: pattern.source,
        added: newMatches - oldMatches,
        impact: 'Tests being avoided instead of fixed'
      });
    }
  });
  
  return avoidance;
}

/**
 * Detect expectation adjustments to match actual output
 */
function detectExpectationAdjustment(oldAST, newAST) {
  const adjustments = [];
  const oldAssertions = extractAssertions(oldAST);
  const newAssertions = extractAssertions(newAST);
  
  oldAssertions.forEach(oldAssertion => {
    const corresponding = findCorrespondingAssertion(oldAssertion, newAssertions);
    if (corresponding) {
      // Extract expected values
      const oldExpected = extractExpectedValue(oldAssertion.text);
      const newExpected = extractExpectedValue(corresponding.text);
      
      if (oldExpected && newExpected && oldExpected !== newExpected) {
        // Check if this looks like adjusting to match actual
        if (looksLikeActualOutput(newExpected)) {
          adjustments.push({
            line: corresponding.line,
            old: oldExpected,
            new: newExpected,
            suspicious: true,
            reason: 'Expected value changed - possibly to match broken output'
          });
        }
      }
    }
  });
  
  return adjustments;
}

/**
 * Extract expected value from assertion
 */
function extractExpectedValue(assertionText) {
  // Match patterns like .toBe(value), .toEqual(value)
  const match = assertionText.match(/\.to(?:Be|Equal|StrictEqual)\(([^)]+)\)/);
  return match ? match[1].trim() : null;
}

/**
 * Check if a value looks like actual output (heuristic)
 */
function looksLikeActualOutput(value) {
  // Heuristics for detecting "adjusted to match actual" patterns
  return (
    value.includes('undefined') ||
    value.includes('null') ||
    value.includes('NaN') ||
    value === "''" ||
    value === '""' ||
    value === '[]' ||
    value === '{}'
  );
}

/**
 * Find corresponding assertion in new AST
 */
function findCorrespondingAssertion(oldAssertion, newAssertions) {
  // Try to find by similar line number first
  let closest = newAssertions.find(a => Math.abs(a.line - oldAssertion.line) <= 2);
  
  if (!closest) {
    // Try to find by similar content
    closest = newAssertions.find(a => {
      const oldCore = oldAssertion.text.split('.')[0];
      const newCore = a.text.split('.')[0];
      return oldCore === newCore;
    });
  }
  
  return closest;
}

/**
 * Determine reason for weakening
 */
function determineWeakeningReason(oldAssertion, newAssertion) {
  if (oldAssertion.text.includes('.toBe') && newAssertion.text.includes('.toBeTruthy')) {
    return 'Specific value check replaced with truthy check';
  }
  if (oldAssertion.text.includes('toHaveBeenCalledWith') && newAssertion.text.includes('toHaveBeenCalled')) {
    return 'Function call arguments no longer validated';
  }
  if (oldAssertion.text.includes('toThrow') && !newAssertion.text.includes('toThrow')) {
    return 'Error validation removed';
  }
  return 'Assertion specificity reduced';
}

/**
 * Fallback pattern-based detection
 */
function detectViaPatterns(oldContent, newContent) {
  const violations = [];
  
  // Simple pattern checks when AST parsing fails
  if (newContent.includes('.skip(') && !oldContent.includes('.skip(')) {
    violations.push({
      type: 'TEST_AVOIDANCE',
      severity: 'CRITICAL',
      message: 'Test skipped - tests must run to reveal truth'
    });
  }
  
  if (oldContent.includes('.toBe(') && newContent.includes('.toBeTruthy()')) {
    violations.push({
      type: 'WEAKENED_ASSERTIONS',
      severity: 'CRITICAL',
      message: 'Assertion weakened - maintain test strictness'
    });
  }
  
  return violations;
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length < 2) {
    console.error('Usage: detect-test-manipulation.js <old-content> <new-content> [filename]');
    process.exit(1);
  }
  
  const [oldContent, newContent, fileName] = args;
  const violations = detectTestManipulation(oldContent, newContent, fileName);
  
  if (violations.length > 0) {
    console.log(JSON.stringify(violations, null, 2));
    process.exit(1);  // Exit with error code if manipulations detected
  }
  
  process.exit(0);
}

module.exports = { detectTestManipulation, MANIPULATION_PATTERNS };