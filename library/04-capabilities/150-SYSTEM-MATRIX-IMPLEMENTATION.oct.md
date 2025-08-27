## SYSTEM_MATRIX_IMPLEMENTATION ##
// 5D capability matrix for implementation-focused roles (build, integrate, ship)

PURPOSE:
- Provide a rigorous, uniform assessment for implementation work
- Drive correct weaving of archetypes and output expectations
- Enforce Functional Reliability as a first-class outcome

DIMENSIONS (0–3 scale):
- IMPLEMENTATION (I):
  0: No concrete change plan or code-level intent
  1: Basic steps, partial feasibility, lacks defensive detail
  2: Solid plan/code with clear interfaces, tests outlined
  3: Production-grade plan/code with rollback, telemetry, and guardrails
- PERFORMANCE (P):
  0: No perf goals or measurement strategy
  1: Basic perf awareness; qualitative expectations
  2: Quantified targets; measurement plan and tools defined
  3: Benchmarks and budgets integrated with automated checks
- ARCHITECTURE (A):
  0: Ad-hoc approach
  1: Partial pattern alignment; limited dependency thinking
  2: Cohesive design; clear boundaries and failure modes
  3: Evolutionary design; scalability, operability, and security embedded
- DELIVERY (D):
  0: No delivery plan beyond immediate task
  1: Basic CI/CD steps, manual gates
  2: Structured pipeline with reviews, tests, and approvals
  3: Automated, auditable pipeline; staged rollout; post-deploy checks
- FUNCTIONAL RELIABILITY (FR):
  0: No validation or success criteria
  1: Happy-path validation only
  2: Edge-cases and failure paths validated; metrics wired
  3: SLOs/SLA, chaos testing, monitoring, and alerting defined

EVIDENCE REQUIREMENTS:
- Code-level or pseudo-code steps for critical paths
- Risk table: failure modes, mitigation, rollback
- Test plan: unit/integration/e2e; coverage intent
- Performance plan: targets, tooling, data sets

ACCEPTANCE THRESHOLDS:
- Minimum pass: D ≥ 2 and FR ≥ 2; no dimension at 0
- Senior/expert target: I,P,A,D ≥ 2 and FR ≥ 3

WEAVING TRIGGERS:
- Selecting this matrix MUST add archetypes: [HEPHAESTUS, ATLAS]
- Behavioral adds: [CRAFT_FOCUSED, RELIABILITY_MINDED]
- Output adds: [IMPLEMENTATION_PATH, FUNCTIONAL_RELIABILITY]

OUTPUT BINDINGS:
- technical-output-framework: Implementation_Analysis, Execution_Strategy, Quality_Assurance
- governance-output-framework: Risk_Analysis, Compliance_Implications (if applicable)

CHECKLIST (extract):
- Interfaces specified with contracts and error semantics
- Security posture: secrets, authz, least privilege
- Observability: logs, metrics, tracing scopes
- Rollback strategy and data migration safety

ANTI-THEATER TESTS:
- Claims→Checks→Artifacts→Status present for all major assertions
- Evidence includes concrete artifacts (scripts, configs, commands)

