# Workflow Link Standards

**Status:** Final  
**Purpose:** Establish linking conventions preventing link rot and enabling clean migrations  
**Scope:** All documentation linking within and between repositories  
**Authority:** Ensures sustainable cross-reference maintenance

## Link Architecture Principles

### Principle 1: Locality Over Absoluteness
- Internal links use relative paths from current document location
- External links use full paths only when crossing system boundaries
- Repository-relative paths for cross-repo references within HestAI ecosystem

### Principle 2: Migration Resilience
- Links must survive directory reorganization
- Repository moves should not break internal references
- External system references clearly identified and isolated

### Principle 3: Validation Enforcement
- All links must be testable through automation
- Broken links block commits in critical documentation
- Link patterns consistent across all documentation types

## Internal Documentation Links

### Within Same Directory
```markdown
# Correct - relative path
[Naming Standards](./101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md)
[OCTAVE Rules](./103-DOC-OCTAVE-COMPRESSION-RULES.md)

# Incorrect - absolute path
[Bad Example](/Volumes/HestAI-New/docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md)
```

### Cross-Directory Within Repository
```markdown
# From docs/ to templates/
[Project Context Template](../templates/PROJECT_CONTEXT.md)

# From docs/ to reports/
[Security Audit](../reports/801-REPORT-SECURITY-AUDIT.oct.md)

# From docs/adr/ to docs/
[Parent Documentation](../101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md)
```

### Repository Root References
```markdown
# From any docs/ location to root files
[Repository README](../../README.md)
[Claude Instructions](../../CLAUDE.md)
```

## Cross-Repository Links

### HestAI to HestAI-Projects
```markdown
# From organizational docs to project bridge
[EAV Project Status](../../HestAI-Projects/eav-orchestrator/docs/PROJECT_CONTEXT.md)

# From organizational docs to project build
[EAV Implementation](../../HestAI-Projects/eav-orchestrator/build/docs/201-PROJECT-IMPLEMENTATION-LOG.md)
```

### HestAI-Projects to HestAI
```markdown
# From project docs to organizational standards
[Workflow Standards](../../../HestAI/docs/001-WORKFLOW-NORTH-STAR.md)
[Naming Rules](../../../HestAI/docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md)
```

### Project Bridge to Build
```markdown
# From project/docs/ to project/build/docs/
[Build Plan](../build/docs/201-PROJECT-B1-BUILD-PLAN.md)
[Implementation Log](../build/docs/201-PROJECT-IMPLEMENTATION-LOG.md)
[ADR Index](../build/docs/adr/README.md)
```

## External System References

### Claude Code Configuration
```markdown
# Full paths for user-specific configurations
[Claude Settings](/Users/shaunbuswell/.claude/settings.json)
[Build Commands](/Users/shaunbuswell/.claude/commands/build.md)
[Role Protocols](/Users/shaunbuswell/.claude/commands/role.md)
```

### Git Hooks and Scripts
```markdown
# Full paths for system-level tooling
[Pre-commit Configuration](~/.pre-commit-config.yaml)
[Documentation Validator](~/.claude/hooks/enforce-doc-naming.sh)
```

### Web Resources
```markdown
# Full URLs for external documentation
[Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
[OCTAVE Specification](https://github.com/hestai/octave-spec)
```

## Anchor Links and References

### Document Sections
```markdown
# Within same document
[Implementation Details](#implementation-details)
[Success Metrics](#success-metrics)

# Cross-document sections
[Naming Pattern](./101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md#naming-pattern)
[Compression Rules](./103-DOC-OCTAVE-COMPRESSION-RULES.md#compression-decision-framework)
```

### Specific Content References
```markdown
# Reference specific content with context
See [TRACED Protocol requirements](./001-WORKFLOW-NORTH-STAR.md#quality-gates) for B2 implementation standards.

According to [naming standards](./101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md#forbidden), version suffixes are prohibited.
```

## Link Validation Rules

### Automated Checking
- All relative links validated during pre-commit
- Cross-repository links checked in CI/CD
- External links validated weekly (non-blocking)
- Link rot reports generated monthly

### Manual Validation Triggers
- Before major repository moves
- During documentation restructuring
- After external system changes
- Quarterly link health audits

### Error Handling
```markdown
# For temporarily broken links, use explicit notation
[Under Construction: Build Automation](./007-WORKFLOW-BUILD-AUTOMATION.md) *(planned)*

# For deprecated links, provide replacement
[Legacy Process](../archive/old-workflow.md) → Use [Current Workflow](./001-WORKFLOW-NORTH-STAR.md) instead
```

## Repository Migration Patterns

### During Migration
```markdown
# Document expected link updates
<!-- MIGRATION NOTE: Update all references to /Volumes/HestAI-New after cutover -->

# Use migration-safe patterns
[Organizational Standards](../HestAI/docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md)
```

### Post-Migration Validation
- Automated link checking across all repositories
- Update external references (Claude.md, system configs)
- Archive old repository with redirect documentation

## Link Pattern Examples

### Good Patterns
```markdown
# Clear, relative, maintainable
[Quality Gates](./001-WORKFLOW-NORTH-STAR.md#quality-gates)
[Project Template](../templates/PROJECT_CONTEXT.md)
[EAV Status](../../HestAI-Projects/eav-orchestrator/docs/PROJECT_CONTEXT.md)

# Descriptive link text
[B2 Implementation Standards](./001-WORKFLOW-NORTH-STAR.md#b2-implementation) in the Workflow North Star
```

### Anti-Patterns
```markdown
# Absolute paths that break during moves
[Bad](/Volumes/HestAI-New/docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md)

# Vague link text
[Click here](./001-WORKFLOW-NORTH-STAR.md)
[This document](./103-DOC-OCTAVE-COMPRESSION-RULES.md)

# Unvalidated external references
[Broken External Link](http://old-system.example.com/gone)
```

## Enforcement Implementation

### Pre-commit Hook
```bash
#!/bin/bash
# ~/.claude/hooks/validate-links.sh

# Check relative links exist
grep -r "\[.*\](\./.*\.md)" docs/ | while IFS=: read -r file link; do
  # Extract and validate path
  # Block commit if broken
done

# Validate cross-repo references
# Check external links (warn only)
```

### CI/CD Integration
```yaml
# .github/workflows/link-validation.yml
name: Link Validation
on: [push, pull_request]
jobs:
  validate-links:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Check internal links
        run: scripts/validate-links.py --internal
      - name: Check cross-repo links  
        run: scripts/validate-links.py --cross-repo
```

### Documentation Linting
```python
# scripts/validate-links.py
def check_relative_links(file_path):
    """Validate all relative links in markdown file"""
    # Parse markdown links
    # Resolve relative paths
    # Check file existence
    # Report broken links
```

## Success Metrics

### Link Health Indicators
- Internal link success rate: >99%
- Cross-repository link success rate: >95%
- External link validation: >90% (weekly check)
- Migration link breakage: <1%

### Maintenance Efficiency
- Link validation time: <30 seconds per repository
- False positive rate: <5%
- Link rot detection time: <1 week
- Migration link updates: Automated 90%+

### Developer Experience
- Link click success rate: >98%
- Navigation time to related docs: <10 seconds
- Cross-reference discovery: Enhanced through consistent patterns

## Migration Checklist

### Pre-Migration
- [ ] All internal links use relative paths
- [ ] Cross-repo links use migration-safe patterns
- [ ] External links clearly identified
- [ ] Link validation passing 100%

### During Migration
- [ ] Update repository references
- [ ] Test all cross-repository links
- [ ] Validate external system references
- [ ] Update Claude.md and system configs

### Post-Migration
- [ ] Full link validation across ecosystem
- [ ] Archive old repository with redirects
- [ ] Update external documentation
- [ ] Establish ongoing link monitoring

---

**Implementation Authority:** System Steward with Documentation Standards  
**Validation:** Automated link checking with manual audit quarterly  
**Migration Support:** Link patterns designed for clean repository transitions