# Blockage Resolution Protocol

**Version**: 1.0
**Status**: APPROVED
**Date**: 2025-12-06
**Authority**: Validated through empirical testing (GitHub Issue #4)
**Evidence**: Comparative test across Claude/Gemini/Codex + Critical Engineer validation

---

## EXECUTIVE_SUMMARY

Signal-driven resolution protocol for when validators (CRS, CE, TMG) block work. Routes blockages through appropriate resolution paths based on signal classification, with optional Synthesis Crucible for complex architectural conflicts.

---

## 1. PROTOCOL_FOUNDATION

### PURPOSE

```octave
BLOCKAGE_RESOLUTION::[
  PROBLEM::"Validator blocks work with BLOCK status - what happens next?",
  SOLUTION::"Signal-driven routing through appropriate resolution path",
  OUTCOME::"Structured resolution without always requiring human intervention",
  PRINCIPLE::"The Crucible produces structurally superior solutions"
]
```

### VALIDATION_EVIDENCE

```octave
EMPIRICAL_PROOF::[
  TRIAL::PR_288→292[FK_constraint_bug_fix],
  RESULT::Crucible_solution_addressed_all_concerns+survived_additional_scrutiny,
  FINDING::Edge_cases_caught_that_original_approach_missed,

  COMPARATIVE_TEST::2025-12-06[
    CLAUDE::breakthrough_insight["FK_is_validation_theater"]+invalid_SQL,
    GEMINI::valid_bifurcated_lineage_approach+migration_complexity,
    CODEX::safe_obvious_path+passed_CE_validation,
    LESSON::"Individual agent can fail; system catches it"
  ]
]
```

---

## 2. SIGNAL_CLASSIFICATION

### TRIGGER

When any blocking validator issues a BLOCK decision:
- critical-engineer
- code-review-specialist
- test-methodology-guardian
- security-specialist

### SIGNAL_TYPES

```octave
SIGNAL_CLASSIFICATION::[
  COMPLIANCE::[
    DEFINITION::"Hard constraint violation (syntax, security, API contract)",
    EXAMPLES::[type_error, SQL_injection, missing_auth, invalid_FK],
    ROUTE::FAST_TRACK
  ],

  COHERENCE::[
    DEFINITION::"Pattern mismatch (lifecycle, data integrity, architecture)",
    EXAMPLES::[semantic_drift, source_of_truth_conflict, hidden_coupling],
    ROUTE::DEEP_TRACK[Synthesis_Crucible]
  ]
]

CLASSIFICATION_RULE::"IF any signal is COHERENCE → route to DEEP_TRACK"
```

---

## 3. RESOLUTION_ROUTING

### FAST_TRACK (Compliance Issues)

```octave
FAST_TRACK::[
  WHEN::all_signals==COMPLIANCE,

  FLOW::[
    1::Validator_issues_BLOCK[with_specific_constraint_violated],
    2::Implementation_Lead_fixes[cite_constraint_in_commit],
    3::Revalidate[same_validator],
    4::IF[still_blocked]→escalate_to_DEEP_TRACK
  ],

  CEREMONY::minimal[commit_message_cites_resolution],
  DURATION::typically_<1_hour
]
```

### DEEP_TRACK (Coherence Issues - Synthesis Crucible)

```octave
DEEP_TRACK::[
  WHEN::any_signal==COHERENCE,

  FLOW::[
    1::Validator_issues_BLOCK[with_constraint_artifacts],
    2::Synthesis_Crucible[see_section_4],
    3::Implementation_Lead_implements[surviving_approach],
    4::Revalidate[same_validators],
    5::IF[still_blocked_after_2_cycles]→ESCALATE
  ],

  CEREMONY::full[artifact_trail],
  DURATION::typically_2-4_hours
]
```

---

## 4. SYNTHESIS_CRUCIBLE

### CRUCIBLE_ARCHITECTURE

```octave
SYNTHESIS_CRUCIBLE::[
  PURPOSE::"Multi-perspective exploration + validation before implementation",
  PRINCIPLE::"Edge-optimizer discovers; Critical-engineer validates; IL implements",

  PHASES::[
    IDEATION::edge_optimizer[conceptual_breakthroughs],
    VALIDATION::critical_engineer[kill_impossible],
    EXECUTION::implementation_lead[production_code]
  ]
]
```

### STANDARD_MODE (Default)

```octave
STANDARD_CRUCIBLE::[

  PHASE_1::IDEATION[
    AGENT::edge-optimizer,
    CLI::gemini|claude[conceptual_strength],
    PROMPT::"Generate 3 optimization paths (Obvious, Adjacent, Heretical). Focus on concepts and trade-offs. Flag experimental proposals with ⚠️ EXPERIMENTAL/REQUIRES-VALIDATION.",
    OUTPUT::concepts+trade_offs+reframings[NOT_production_code]
  ],

  PHASE_2::VALIDATION[
    AGENT::critical-engineer,
    CLI::gemini[fast+accurate],
    PROMPT::"Review these 3 concepts. Identify fatal flaws. Kill technically impossible or dangerous approaches. Provide GO/CONDITIONAL/BLOCK per proposal.",
    OUTPUT::surviving_concepts+conditions+risks
  ],

  PHASE_3::EXECUTION[
    AGENT::implementation-lead,
    CLI::codex[production_code_strength],
    PROMPT::"Take the surviving concept from Critical Engineer. Write production-ready implementation with tests.",
    OUTPUT::production_code+tests+migration_if_needed
  ]
]
```

### COMMITTEE_MODE (High Stakes)

```octave
COMMITTEE_CRUCIBLE::[
  TRIGGER::[
    architectural_change_>3_components,
    security_critical_path,
    >3_day_implementation_impact,
    human_requests_committee
  ],

  PHASE_1::PARALLEL_IDEATION[
    INVOKE_ALL::[
      clink(claude:edge-optimizer),
      clink(gemini:edge-optimizer),
      clink(codex:edge-optimizer)
    ],
    OUTPUT::9_paths_total[3_per_model]
  ],

  PHASE_2::CROSS_CRITIQUE[
    EACH_CE_REVIEWS::all_proposals,
    OUTPUT::consolidated_viability_matrix
  ],

  PHASE_3::SYNTHESIS[
    AGENT::synthesizer,
    MERGE::surviving_elements→unified_approach
  ],

  PHASE_4::EXECUTION[
    AGENT::implementation-lead,
    CLI::codex
  ]
]
```

---

## 5. CLI_ROUTING_MATRIX

### VALIDATED_ASSIGNMENTS

```octave
CLI_ROUTING::[

  IDEATION_ROLES::[
    edge-optimizer::gemini|claude[conceptual_breakthrough],
    ideator-catalyst::gemini[creative_exploration],
    synthesizer::codex[structured_synthesis]
  ],

  VALIDATION_ROLES::[
    critical-engineer::gemini[fast+accurate_validation],
    code-review-specialist::codex[high_reasoning_effort],
    test-methodology-guardian::codex[medium_reasoning_effort]
  ],

  EXECUTION_ROLES::[
    implementation-lead::codex[production_code],
    universal-test-engineer::codex[test_implementation]
  ]
]
```

### RATIONALE

```octave
ROUTING_RATIONALE::[
  GEMINI_FOR_IDEATION::[
    cost_effective[$0.03_vs_$0.46],
    fast[75s_vs_108s],
    novel_framing["Context_Collapse", "Retroactive_Audit_Tampering"]
  ],

  CODEX_FOR_EXECUTION::[
    fastest[23s],
    protocol_compliant[3_paths_per_PATHOS],
    passed_CE_validation[obvious_path_was_viable]
  ],

  LESSON::"Claude/Gemini are best brains; Codex is best hands"
]
```

---

## 6. CONSTRAINT_ARTIFACT_REQUIREMENTS

### BLOCKER_RESPONSIBILITIES

```octave
WHEN_BLOCKING::[
  MUST_INCLUDE::[
    specific_constraint_violated[NOT_just_"FK_violation"],
    schema_context_if_DB_related[actual_FK_target],
    reproduction_evidence[how_to_verify],
    severity_classification[COMPLIANCE|COHERENCE]
  ],

  NOT_ACCEPTABLE::symptom_description_only,

  EXAMPLE_GOOD::[
    "BLOCK: source_component_id FK → paragraph_library.id, but field name implies script_components relationship. COHERENCE signal - semantic drift."
  ],

  EXAMPLE_BAD::[
    "BLOCK: FK violation"
  ]
]
```

---

## 7. ESCALATION_PROTOCOL

### ESCALATION_TRIGGERS

```octave
ESCALATE_WHEN::[
  validator_disagreement_persists_after_2_cycles,
  architectural_scope_exceeds_original_task,
  human_judgment_required_on_trade_offs,
  all_Crucible_proposals_rejected,
  risk_probability_>70_percent
]
```

### ESCALATION_PATH

```octave
ESCALATION_CHAIN::[
  FIRST::principal-engineer[strategic_assessment],
  SECOND::requirements-steward[scope_validation],
  FINAL::human[decision_authority]
]

ORCHESTRATOR_AUTHORITY::"Has direct authority to escalate (not just recommend)"
```

---

## 8. INTEGRATION_POINTS

### AGENT_REFERENCES

```octave
AGENTS_UPDATED_WITH_PROTOCOL::[
  critical-engineer::BLOCKAGE_RESOLUTION_reference,
  code-review-specialist::BLOCKAGE_RESOLUTION_reference,
  implementation-lead::CRUCIBLE_participation,
  edge-optimizer::EXPERIMENTAL_FLAG_REQUIREMENT+ROLE_CLARITY
]
```

### SKILL_INTEGRATION

```octave
RELATED_SKILLS::[
  error-triage::escalation_path_to_blockage_resolution,
  build-execution::quality_gate_blockages,
  ci-error-resolution::CI_failure_blockages
]
```

---

## 9. OPERATIONAL_PARAMETERS

### PERFORMANCE_TARGETS

```octave
PERFORMANCE::[
  FAST_TRACK::resolve_within_1_hour,
  STANDARD_CRUCIBLE::resolve_within_4_hours,
  COMMITTEE_CRUCIBLE::resolve_within_8_hours,
  TOKEN_OVERHEAD::~1500_tokens_per_cycle[acceptable]
]
```

### SUCCESS_METRICS

```octave
SUCCESS_WHEN::[
  critical_gaps_found::>baseline_without_protocol,
  false_positives_caught::invalid_proposals_killed_before_implementation,
  resolution_achieved::selected_path+mandatory_conditions_clear,
  audit_trail::complete_artifact_chain
]
```

---

## 10. OPEN_QUESTIONS_RESOLVED

| Question | Decision | Rationale |
|----------|----------|-----------|
| Domain Understanding | Blocker provides constraint artifacts | Full context in BLOCK signal |
| Escalation Authority | Orchestrator has direct authority | Reduces latency |
| Synthesizer Role | Include when >1 alternative survives | Committee mode only |
| Repeated Blockages | Log in hestai-mcp-server | Pattern detection |
| Partial Blockages | Full protocol (all must pass) | Consistency |
| Token Overhead | 1,500 tokens acceptable | Quality > cost |

---

## APPENDIX_A: QUICK_REFERENCE

```octave
BLOCKAGE_DETECTED::[
  1::CLASSIFY[COMPLIANCE|COHERENCE],
  2::ROUTE[FAST_TRACK|DEEP_TRACK],
  3::IF[DEEP_TRACK]→CRUCIBLE[Ideation→Validation→Execution],
  4::REVALIDATE,
  5::IF[still_blocked_after_2]→ESCALATE
]

CLI_QUICK_REF::[
  edge-optimizer::gemini,
  critical-engineer::gemini,
  implementation-lead::codex,
  code-review-specialist::codex
]
```

---

**STATUS**: Ready for production use
**GITHUB_ISSUE**: elevanaltd/hestai#4
**VALIDATION**: Empirically tested 2025-12-06
