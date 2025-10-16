META:
  TITLE::"Code Quality Enforcement Gates"
  VERSION::2.0
  COMPRESSION_RATIO::"6:1 achieved"
  PURPOSE::"Prevent validation theater through enforcement≠hope"
  ESSENCE::"IDENTICAL_COMMANDS+EVIDENCE_REQUIRED+TDD_DISCIPLINE"

PROBLEM_STATEMENT:
  VALIDATION_FAILURES::[
    local≠CI_commands,
    claims_without_evidence,
    implementation_before_tests,
    false_positive_quality_claims
  ]

ENFORCEMENT_GATES:

GATE_1_CI_CONSISTENCY:
  PROBLEM::"agents≠CI_commands"
  SOLUTION::"force_identical_validation"
  HOOK::"`~/.claude/hooks/enforce-ci-consistency.sh`"
  SCRIPT_FUNCTION::[
    extract_package_json_scripts,
    enforce_npm_run_lint:check,
    enforce_npm_run_typecheck,
    enforce_npm_test
  ]

GATE_2_EVIDENCE_REQUIRED:
  PROBLEM::"claims_without_evidence"
  SOLUTION::"block_empty_quality_claims"
  HOOK::"`~/.claude/hooks/require-validation-evidence.sh`"
  CLAIM_PATTERNS::[all.*eslint.*fixed,no.*errors.*warnings,lint.*clean,typecheck.*passes]
  REQUIRED_EVIDENCE::[command_output,test_results,typecheck_status]

GATE_3_TDD_DISCIPLINE:
  PROBLEM::"code_before_tests"
  SOLUTION::"enforce_test_file_existence"
  HOOK::"`~/.claude/hooks/enforce-test-first.sh`"
  TEST_PATHS::[src/{file}.test.ts,tests/unit/{file}.test.ts,__tests__/{file}.test.ts]
  REQUIREMENT::"failing_test_BEFORE_implementation"

GATE_4_ERROR_INVESTIGATION:
  PROBLEM::"superficial_error_fixes"
  SOLUTION::"require_systematic_analysis"
  HOOK::"`~/.claude/hooks/enforce-error-resolution.sh`"
  COMPLEX_ERRORS::[unhandled.*rejection,typescript.*error,lint.*error,test.*fail]
  AGENT_CONSULTATION::"error-resolver_for_complex_issues"

TRACED_PROTOCOL_INTEGRATION:
  T::test_first→enforced_by_hooks
  R::review→evidence_required_for_claims
  A::analyze→complex_errors_trigger_investigation
  C::consult→validation_specialists_for_quality
  E::execute→identical_CI_commands_required
  D::document→quality_evidence_documented

VALIDATION_COMMANDS:
  ESLINT::"npm run lint:check"≠"eslint src"
  TYPESCRIPT::"npm run typecheck"
  TESTS::"npm test"

VIOLATION_PATTERNS:
  TYPE_ASSERTIONS::"remove_unnecessary_as_Type"
  AWAIT_IN_LOOP::"use_Promise.all()_for_independent_ops"
  ASYNC_WITHOUT_AWAIT::"remove_async_or_add_await"

SUPPRESSION_PROTOCOL:
  VALID_CASES::[order_dependent_operations,rate_limited_APIs,test_determinism,legacy_interop]
  FORMAT::"// eslint-disable-next-line rule-name -- REASON: specific_justification"
  TRACKING::"exception_count_must_trend_downward"

ANTI_THEATER_MEASURES:
  PROHIBITED::[different_commands_than_CI,claims_without_evidence,implementation_before_tests]
  REQUIRED::[exact_CI_commands,command_output_evidence,failing_tests_first]

B1_02_WORKSPACE_SETUP:
  SCRIPTS::[lint::eslint_max_warnings_0,typecheck::tsc_noEmit,test::jest_coverage]
  HOOKS::[pre_commit_lint,pre_commit_typecheck,pre_commit_test]
  CI_PIPELINE::"fail_fast_on_any_violation"

SUCCESS_METRICS:
  IMMEDIATE::[zero_local_CI_discrepancy,all_claims_evidenced,100_percent_TDD]
  ONGOING::[validation_theater_eliminated,suppression_count_decreasing]

INTEGRATION_ERROR_PATTERNS:
  INCOMPLETE_INTEGRATION::"validation_layer≠execution_flow"
  TYPE_SAFETY_THEATER::"validation→type_casting"
  ERROR_FLATTENING::"structured_error→message_only"
  VALIDATION_BYPASS::"validation_results_ignored"

ESSENCE::IDENTICAL_COMMANDS+EVIDENCE_REQUIRED+TDD_DISCIPLINE=QUALITY_WITHOUT_THEATER