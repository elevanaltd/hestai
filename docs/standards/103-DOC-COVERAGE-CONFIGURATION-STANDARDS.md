# 109-DOC-COVERAGE-CONFIGURATION-STANDARDS

## Purpose
Standardize coverage configuration across TypeScript/Node.js projects to prevent systematic oversight of coverage setup and ensure consistent quality gates.

## Mandatory vitest.config.ts Configuration

```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      reportsDirectory: 'coverage',
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80
        }
      },
      exclude: [
        'coverage/**',
        'dist/**',
        'node_modules/**',
        '**/*.d.ts',
        '**/*.config.{js,ts}',
        '**/test/**',
        '**/tests/**',
        '**/__tests__/**'
      ]
    }
  }
})
```

## Required package.json Scripts

```json
{
  "scripts": {
    "test": "vitest",
    "test:watch": "vitest --watch",
    "test:coverage": "vitest --coverage",
    "test:ui": "vitest --ui --coverage",
    "coverage:check": "vitest --coverage --reporter=text",
    "coverage:open": "open coverage/index.html"
  }
}
```

## Project Initialization Checklist

### Phase B1 Setup Requirements
- [ ] Install vitest and @vitest/ui as devDependencies
- [ ] Install @vitest/coverage-v8 for coverage provider
- [ ] Create vitest.config.ts with mandatory thresholds
- [ ] Add coverage scripts to package.json
- [ ] Add coverage/ to .gitignore
- [ ] Verify coverage command executes without errors

### Workspace-Architect Protocol Integration
```bash
# Standard commands for project setup
npm install --save-dev vitest @vitest/ui @vitest/coverage-v8
# Configure vitest.config.ts per standards
# Validate coverage execution: npm run test:coverage
```

## Integration with Quality Gates (Document 106)

### Coverage as Diagnostic Tool
- Coverage percentage guides test gap identification
- 80% threshold provides baseline quality assurance
- Coverage reports inform testing strategy decisions
- NOT a blocking gate - diagnostic feedback only

### Quality Gate Integration
- Coverage reports generated during CI/CD pipeline
- Results inform code review discussions
- Threshold violations trigger investigation, not blocking
- Focus on meaningful behavior coverage over percentage pursuit

## Reference Implementation

### SmartSuite MCP Proven Pattern
The SmartSuite MCP server demonstrates successful coverage configuration:
- Achieved 96% unique pattern coverage across 50 test scenarios
- Used vitest with v8 provider for reliable TypeScript coverage
- Integrated coverage into CI workflow without blocking deployments
- Coverage reports guided test improvement decisions

### Configuration Location
```
project-root/
├── vitest.config.ts     # Mandatory coverage configuration
├── package.json         # Required coverage scripts
├── coverage/           # Generated reports (gitignored)
└── tests/              # Test files with coverage assertions
```

## Enforcement Protocol

### Workspace-Architect Responsibility
- Verify coverage configuration during B1 setup phase
- Ensure vitest.config.ts includes mandatory thresholds
- Validate coverage scripts execute successfully
- Document coverage setup in project coordination files

### Quality Assurance Pattern
- Coverage configuration checked during project initialization
- Coverage execution validated before first implementation phase
- Coverage reports reviewed during code review process
- Coverage gaps addressed through test improvement, not threshold reduction

## Configuration Validation

### Required Dependencies
```json
{
  "devDependencies": {
    "vitest": "^latest",
    "@vitest/ui": "^latest", 
    "@vitest/coverage-v8": "^latest"
  }
}
```

### Execution Verification
```bash
# Verify coverage configuration
npm run test:coverage

# Expected output includes:
# - Coverage summary with percentages
# - Threshold compliance status
# - Generated coverage/index.html report
```

## Anti-Patterns Prevention

### Forbidden Configurations
- ❌ No coverage thresholds defined
- ❌ Thresholds below 80% without documented justification
- ❌ Coverage provider other than 'v8' for TypeScript projects
- ❌ Missing coverage scripts in package.json
- ❌ Coverage reports committed to repository

### Quality Discipline
- Coverage supports testing strategy, not replaces it
- Meaningful behavior assertions prioritized over coverage percentage
- Coverage gaps inform test improvement, not threshold reduction
- Focus on testing critical paths and edge cases comprehensively

<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-22T13:45:23-04:00 -->