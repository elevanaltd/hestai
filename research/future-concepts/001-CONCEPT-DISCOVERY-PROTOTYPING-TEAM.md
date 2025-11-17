# Discovery Prototyping Team Concept

**Status**: FUTURE RESEARCH - Not currently needed, preserved for later exploration

**Date Created**: 2025-10-22

**Context**: During discussion of Haiku prototyping strategy for EAV multi-app expansion, identified two distinct prototyping patterns. This document captures the "discovery prototyping" pattern for future reference.

---

## Problem Space

When building multiple applications sharing a common library (e.g., `@elevanaltd/shared-lib`), there's a risk of **premature schema lock-in** and **architectural assumptions** that don't match real application needs.

**Question**: How do we validate shared library adequacy BEFORE committing to database schema and architectural decisions?

## Proposed Solution: Discovery Prototyping Team

### Two-Agent Architecture

**Agent 1: `prototype-scout`** (Haiku-optimized)
- **Mission**: Rapid feasibility validation through throwaway code
- **Model**: Haiku (speed advantage for parallel execution)
- **Deliverable**: Friction logs, integration breakpoints, missing abstractions
- **Quality Trade-off**: Deliberately sacrifices code quality for discovery speed
- **Disposal**: Code archived, never reaches production

**Agent 2: `prototype-synthesizer`** (Sonnet/Opus)
- **Mission**: Cross-prototype pattern recognition and architectural insight extraction
- **Model**: Sonnet (synthesis requires deeper reasoning)
- **Deliverable**: Synthesis reports, shared-lib gap analysis, schema recommendations
- **Quality Standard**: Constitutional rigor - feeds production architects
- **Handoff**: Prepares findings for `technical-architect` and `critical-design-validator`

### Workflow Pattern

```
PHASE 1: PARALLEL SCOUTING (Haiku speed)
├─ prototype-scout → app-1 spike (4 hrs) → friction_log_1.md
├─ prototype-scout → app-2 spike (4 hrs) → friction_log_2.md
└─ prototype-scout → app-3 spike (4 hrs) → friction_log_3.md

PHASE 2: SYNTHESIS (Constitutional rigor)
└─ prototype-synthesizer → cross-prototype analysis
   ↓
   synthesis_report.md (patterns across 3 prototypes)

PHASE 3: CONSTITUTIONAL HANDOFF
├─ technical-architect → shared-lib v2.0 design (informed by empirical data)
├─ critical-design-validator → validate against discovered constraints
└─ implementation-lead → production builds from scratch (TDD)
```

### Key Principles

1. **Empirical Architecture**: Design decisions based on observed friction, not assumptions
2. **Parallel Exploration**: 3 simultaneous spikes in time for 1 sequential build
3. **Throwaway Code**: Prototypes explicitly archived, never refactored to production
4. **Learning Extraction**: Friction documentation mandatory, code quality optional
5. **Constitutional Handoff**: Synthesis feeds rigorous production process

### Constitutional Framework

**prototype-scout constraints:**
```octave
MUST::[
  document_friction_points,
  validate_specific_assumptions,
  archive_cleanly,
  time_box_4_hours
]

MAY_SKIP::[
  TDD,
  code_review,
  quality_gates,
  architectural_rigor
]

NEVER::[
  production_deployment,
  schema_modification,
  shared_lib_changes
]
```

**prototype-synthesizer constraints:**
```octave
MUST::[
  pattern_validation,
  cross_prototype_synthesis,
  evidence_based_claims,
  constitutional_compliance
]
```

## Use Cases

- **Multi-app portfolios** sharing common infrastructure
- **Shared library validation** before schema commitment
- **Architectural assumption testing** across diverse requirements
- **Database pattern discovery** through empirical use

## Why Future Research?

This pattern solves a specific problem: **validating shared infrastructure assumptions through parallel exploration before architectural lock-in**.

**Current EAV context needs different pattern**: User-testable iterative builds (vibe coding), not architectural discovery.

**Preserve for future**: When next building shared infrastructure across multiple apps, this discovery pattern prevents premature architecture.

## Related Concepts

- EMPIRICAL_DEVELOPMENT principle: "Reality shapes rightness"
- Throwaway prototyping vs. evolutionary prototyping
- Discovery-driven planning in uncertain domains

## Next Steps (When Revisited)

1. Create `prototype-scout.oct.md` constitutional document
2. Create `prototype-synthesizer.oct.md` constitutional document
3. Define prototyping protocol in `/Volumes/HestAI/docs/workflow/`
4. Test with single prototype spike
5. Scale to parallel execution if validated

---

**Preserved by**: system-steward
**Reason**: Valid architectural pattern for different context than current need
**Retrieval context**: Shared library validation, multi-app architecture, empirical design
