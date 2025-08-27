## SYSTEM_MATRIX_VALIDATOR ##
// 5D capability matrix for validation/assurance roles (reality, feasibility, transformation, catalysis)

PURPOSE:
- Prevent validation theater by enforcing evidence-backed checks
- Map classic R/F/T/C concerns into the 5D model with FR emphasized

DIMENSIONS (0–3 scale):
- IMPLEMENTATION (I): Reality checks
  0: No empirical verification
  1: Limited spot checks; synthetic only
  2: Realistic scenario tests; representative data
  3: On-system reproduction; cross-environment confirmation
- PERFORMANCE (P): Feasibility under constraints
  0: No resource/latency budgets
  1: Qualitative feasibility statements
  2: Quantified budgets; path to meet them
  3: Budgets validated via benchmarks and continuous checks
- ARCHITECTURE (A): Transformation criteria (fit and impact)
  0: No architecture impact assessment
  1: High-level fit notes only
  2: Boundary, dependency, and failure-mode analysis completed
  3: Migration/compatibility plan; security and operability integrated
- DELIVERY (D): Catalysis (does this accelerate outcomes?)
  0: No path to adoption
  1: Suggests steps; unclear ownership
  2: Owned plan with acceptance criteria and timeline
  3: Measurable acceleration with feedback loops and learning capture
- FUNCTIONAL RELIABILITY (FR):
  0: No explicit pass/fail criteria
  1: Basic criteria; limited edge cases
  2: Comprehensive criteria incl. negative testing
  3: Reliability evidenced by signals (SLOs, alerts) and incident drills

EVIDENCE REQUIREMENTS:
- Repro steps and artifacts
- Data/metrics snapshots (before/after)
- Decision logs for risk acceptance and tradeoffs

ACCEPTANCE THRESHOLDS:
- Minimum pass: I ≥ 2 and FR ≥ 2; no dimension at 0
- Strong validation: All dimensions ≥ 2 and FR ≥ 3

WEAVING TRIGGERS:
- Adds archetypes: [APOLLO, ARGUS, ATHENA]
- Behavioral adds: [EVIDENCE_DRIVEN, VIGILANT]
- Output adds: [METRICS_ANALYSIS, FINDINGS_WITH_FLAGS]

OUTPUT BINDINGS:
- technical-output-framework: Evidence_Documentation, Quality_Assessment, Recommendations
- governance-output-framework: Metrics, Compliance, Risk

ANTI-THEATER TESTS:
- Every claim has: Check method + Artifact + Status
- "Insufficient data" declared where applicable

