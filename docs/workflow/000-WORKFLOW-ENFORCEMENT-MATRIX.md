# Workflow Enforcement Matrix

**Status:** Final  
**Purpose:** Single source of truth for rule enforcement mechanisms across all organizational standards  
**Scope:** All documentation, workflow, and operational rules established in HestAI system  
**Authority:** Enforcement architecture ensuring rules prevent violations rather than just documenting expectations

## Enforcement Categories

### Primary Enforcement (Blocking)
Mechanisms that **prevent** rule violations from occurring

### Secondary Enforcement (Advisory) 
Mechanisms that **detect** and **warn** about rule violations

### Tertiary Enforcement (Documentation)
Mechanisms that **guide** and **educate** about proper patterns

## Rule Enforcement Matrix

### Documentation Standards

| Rule Category      | Source Doc        | Primary Enforcement      | Secondary Enforcement | Tertiary Enforcement   | Notes                   |
|--------------------|-------------------|--------------------------|-----------------------|------------------------|-------------------------|
| Filename Patterns  | 101-DOC-STRUCTURE | ✅ Claude hook (pre-tool)   | Claude.md guidance    | README examples        | Blocks invalid names + phases |
| Directory Depth    | 101-DOC-STRUCTURE | ✅ Naming hook (integrated) | Path depth warnings   | Documentation limits   | Max 2 levels docs/      |
| Version Suffixes   | 101-DOC-STRUCTURE | ✅ Naming hook (integrated) | Filename linting      | Anti-pattern examples  | Blocks _v1, _final      |
| File Placement     | 101-DOC-STRUCTURE | Directory validators     | CI/CD structure check | Placement rules docs   | docs/, reports/, etc.   |
| Archive Headers    | 102-DOC-ARCHIVAL  | ✅ Archive validator hook | Manual review         | Header templates       | Status, date, path      |
| Archive Structure  | 102-DOC-ARCHIVAL  | Path preservation check  | Archive lint          | Migration guidance     | Parallel _archive/ tree |
| OCTAVE Compression | 103-DOC-OCTAVE    | *None*                   | ✅ Claude hook (post-tool) | Compression guidelines | 3:1+ ratio targets      |
| OCTAVE Syntax      | 103-DOC-OCTAVE    | *None*                   | Manual validation     | Syntax documentation   | Fidelity 96%+           |

### Workflow Standards

| Rule Category       | Source Doc             | Primary Enforcement | Secondary Enforcement | Tertiary Enforcement | Notes                  |
|---------------------|------------------------|---------------------|-----------------------|----------------------|------------------------|
| Link Patterns       | 006-WORKFLOW-LINK      | ✅ Link validator hook | CI/CD link check      | Link examples        | Relative paths only    |
| Cross-repo Links    | 006-WORKFLOW-LINK      | *None*              | Migration validator   | Cross-repo patterns  | Repository-relative    |
| External References | 006-WORKFLOW-LINK      | *None*              | Link classification   | External guidelines  | Full paths required    |
| Directory Structure | 005-WORKFLOW-DIRECTORY | Structure validator | Bridge/truth checker  | Structure examples   | Separation enforcement |
| Bridge Boundaries   | 005-WORKFLOW-DIRECTORY | Content validator   | Duplication detector  | Bridge rules         | Index only, no content |

### Workflow Process

| Rule Category     | Source Doc              | Primary Enforcement | Secondary Enforcement | Tertiary Enforcement | Notes                 |
|-------------------|-------------------------|---------------------|-----------------------|----------------------|-----------------------|
| Phase Transitions | 001-WORKFLOW-NORTH-STAR | ✅ Phase dependency hook | RACI accountability   | Phase documentation  | PROJECT prerequisite enforcement |
| RACI Compliance   | 001-WORKFLOW-NORTH-STAR | *Planning*          | Role validation       | RACI matrix          | Specialist assignment |
| Quality Gates     | 001-WORKFLOW-NORTH-STAR | *Planning*          | Evidence validation   | Gate criteria        | B0, B1, B2, B3, B4    |

### Development Standards

| Rule Category       | Source Doc       | Primary Enforcement    | Secondary Enforcement  | Tertiary Enforcement  | Notes                 |
|---------------------|------------------|------------------------|------------------------|-----------------------|-----------------------|
| Test-First (TDD)    | Git pre-commit   | ✅ Pre-commit test check  | CI/CD validation       | TDD guidance          | RED state enforcement |
| Code Review         | Git commit-msg   | ✅ Review evidence nudge  | Review link validation | Review standards      | Advisory only         |
| Architecture Review | Claude.md TRACED | ✅ Critical-engineer triggers | Architecture validator | Consultation triggers | TRACED A component |
| Context7 Library    | Claude gate hook | ✅ Library import block   | Git pre-commit nudge   | Context7 guidance     | Evidence required     |
| Test Methodology    | Claude.md TRACED | ✅ Testguard triggers     | Test quality review    | Testing guidelines    | TRACED C component    |

### Code Quality Standards

| Rule Category | Source Doc | Primary Enforcement | Secondary Enforcement | Tertiary Enforcement | Notes |
|---------------|------------|---------------------|----------------------|---------------------|-------|
| ESLint Validation | 105-SYSTEM-CODE-QUALITY | ✅ CI consistency hook | Evidence verification | Command documentation | Must match CI exactly |
| TypeScript Checking | 105-SYSTEM-CODE-QUALITY | ✅ CI consistency hook | Evidence verification | Error documentation | Zero tolerance policy |
| Validation Claims | 105-SYSTEM-CODE-QUALITY | ✅ Evidence requirement | Quality review | Anti-theater examples | No empty checkmarks |
| Error Resolution | 105-SYSTEM-CODE-QUALITY | ✅ Investigation triggers | Agent consultation | RCCAFP framework | Systematic analysis |

## Session Progress Summary

**Today's Implementations:**
- ✅ **PROJECT Phase Naming** - Extended `enforce-doc-naming.sh` to validate D1-B4 phases
- ✅ **Phase Dependency Gates** - Created `enforce-phase-dependencies.sh` for linear progression
- ✅ **Context7 Integration** - Verified `context7_enforcement_gate.sh` working with proper session-based enforcement
- ✅ **TRACED Protocol Complete** - Implemented `enforce-traced-analyze.sh` and `enforce-traced-consult.sh`

**TRACED Implementation Status:**
- **T** (Test-First): ✅ Pre-commit hooks enforce test file existence
- **R** (Review): ✅ Code review evidence hooks active  
- **A** (Analyze): ✅ Critical-engineer consultation enforced
- **C** (Consult): ✅ Testguard consultation enforced
- **E** (Execute): ✅ Quality gates (lint/typecheck/tests) enforced
- **D** (Document): ✅ Documentation requirements enforced

**Critical Gaps (Need Implementation)**
- **Bridge Content Boundaries** - Prevent content duplication between bridge/build docs
- **Cross-repo Link Integrity** - Migration-safe link validation

**Code Quality Gaps (Recently Identified)**
- **CI Command Discrepancy** - Agents using different commands than CI/CD
- **Validation Theater** - Claims without evidence, false positive success reports
- **Test-First Violations** - Implementation without tests first

## Next Phase Priorities
- **Code Quality Enforcement Implementation** - Create hooks for CI consistency and evidence requirements
- Bridge content boundary enforcement
- Cross-repo link checking with migration safety
- Structure compliance validation

## Enforcement Configuration

### Hook Locations
```
~/.claude/hooks/
├── enforce-doc-naming.sh          # 101-DOC-STRUCTURE + PROJECT phases ✅ Active
├── context7_enforcement_gate.sh   # Context7 library consultation ✅ Active  
├── enforce-phase-dependencies.sh  # 001-WORKFLOW-NORTH-STAR phase gates ✅ Active
├── enforce-traced-analyze.sh      # TRACED A: Critical-engineer triggers ✅ Active
├── enforce-traced-consult.sh      # TRACED C: Testguard triggers ✅ Active
├── suggest-octave-compression.sh  # 103-DOC-OCTAVE ✅ Active
├── validate-links.sh              # 006-WORKFLOW-LINK ✅ Active
├── enforce-archive-headers.sh     # 102-DOC-ARCHIVAL ✅ Active
├── enforce-ci-consistency.sh      # 105-SYSTEM-CODE-QUALITY 📋 Planned
├── require-validation-evidence.sh # 105-SYSTEM-CODE-QUALITY 📋 Planned
├── enforce-test-first.sh          # 105-SYSTEM-CODE-QUALITY 📋 Planned
├── enforce-error-resolution.sh    # 105-SYSTEM-CODE-QUALITY 📋 Planned
└── enforce-bridge-boundaries.sh   # 005-WORKFLOW-DIRECTORY 📋 Planned

~/.githooks/
├── pre-commit                     # TDD + Context7 enforcement
└── commit-msg                     # Review evidence suggestions
```

### Integration Points
- **Claude.md:** TRACED protocol enforces test-first, review, architecture consultation
- **Git Hooks:** Pre-commit TDD validation, commit-msg review evidence
- **CI/CD:** Link validation, structure compliance, archive integrity

## Enforcement Philosophy
**Automate the Automatable** - Pattern checking, structure validation, link integrity  
**Guide the Human-Dependent** - Architectural decisions, quality judgment, creative compression  
**Block the Preventable** - Known anti-patterns, structural violations, compliance gaps  

**Balance:** Strict on structure, flexible on content. Block violations, advise improvements.

---

**Implementation Authority:** System Steward with Technical Implementation  
**Review Cycle:** Quarterly effectiveness assessment with gap analysis  
**Evolution:** Enforcement mechanisms evolve with organizational standards