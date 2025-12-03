// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: sequential-101-102-numbering /docs/guides/-placement agent-governance-scope

===AGENT_CAPABILITY_LOOKUP_v1.3===
// Streamlined agent selection guide optimized for LLM consumption
// Query pattern: "I need to [task]" → Agent recommendation

META:
  VERSION::"1.3"
  PURPOSE::"Rapid agent selection via task matching"
  AGENTS_COUNT::56
  LAST_AUDIT::"2025-12-03"
  OPTIMIZATION::"OCTAVE semantic compression for instant lookup"
  CHANGELOG_1.3::"Added EXPLORATION_TOOL_SELECTION based on empirical Issue#183 comparison"

0.DEF:
  PHASE::[D1-D3 (DESIGN), B0-B4 (BUILD), ADMIN]
  COGNITION::[ETHOS (validate), LOGOS (synthesize), PATHOS (explore)]
  TRIGGER::"Condition requiring agent activation"
  BLOCKS::"What prevents success"

---

TASK_TO_AGENT_MAPPING:
  // Primary lookup: What do you need to do?
  
  VALIDATE_AND_PREVENT:
    test_integrity::test-methodology-guardian // "fix the test" → NO
    code_quality::code-review-specialist // Post-implementation review [See: 106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md]
    production_readiness::critical-engineer // "Will this break?"
    design_hardening::critical-design-validator // B0 gate
    architecture_assessment::critical-implementation-validator // VAD compliance
    requirement_drift::requirements-steward // North Star enforcement
    complexity_creep::complexity-guard // Over-engineering detection
    compression_validity::compression-fidelity-validator // Zero info loss
    octave_compliance::octave-validator // Spec enforcement
    security_posture::security-specialist // Defensive security analysis
    system_incoherence::coherence-oracle // Prevent system incoherence
    agent_system_functionality::subagent-system-tester // Test agent system
    build_plan_quality::task-decomposer-validator // Validate build plan
    proportional_effort::workflow-scope-calibrator // Enforce effort boundaries
    
  BUILD_AND_EXECUTE:
    coordinate_build::implementation-lead // B2_01 hub role
    create_workspace::workspace-architect // B1_02 setup [Quality gates: 106-SYSTEM-CODE-QUALITY-ENFORCEMENT-GATES.md]
    decompose_tasks::task-decomposer // VAD→atomic tasks
    generate_tests::universal-test-engineer // Test creation
    integrate_systems::completion-architect // B3_01 unification
    optimize_edges::edge-optimizer // Breakthrough improvements
    deliver_solution::solution-steward // B4_01 handoff
    
  ANALYZE_AND_INVESTIGATE:
    research_feasibility::research-analyst // Evidence-based validation
    discover_needs::idea-clarifier // Problem essence
    trace_code::mcp__hestai__tracer // Execution flow analysis
    debug_complex::mcp__hestai__debug // Root cause analysis
    assess_architecture::mcp__hestai__analyze // Comprehensive review
    security_audit::mcp__hestai__secaudit // OWASP compliance
    resolve_all_errors::error-architect // Unified error resolution (simple to complex)
    triage_simple_errors::error-architect-surface // Fast surface-level error triage
    survey_codebase::surveyor // Autonomous file discovery [See: EXPLORATION_TOOL_SELECTION]
    
  CREATE_AND_SYNTHESIZE:
    design_architecture::technical-architect + design-architect // D2-D3
    generate_ideas::ideator + ideator-catalyst // Bounded creativity
    transcend_tensions::synthesizer // Both-and solutions
    compress_docs::documentation-compressor + octave-specialist // Optimization
    create_agents::subagent-creator + octave-forge-master // Agent generation
    enhance_semantics::semantic-optimizer // Mythological patterns
    create_visual_designs::visual-architect // Create UI/UX mockups
    establish_north_star::north-star-architect // Immutable requirements extraction
    validate_octave::octave-validator // OCTAVE specification compliance
    
  PRESERVE_AND_OBSERVE:
    system_patterns::system-steward // Meta-observation
    curate_knowledge::research-curator // Pattern preservation
    manage_sessions::sessions-manager + session-briefer // Context continuity
    test_stewardship::test-curator // Empirical preservation
    monitor_quality::quality-observer // Continuous assessment
    check_progress::build-plan-checker // Gap analysis
    validate_principal_decisions::principal-engineer // Senior validation authority
    
  ORCHESTRATION_AND_GOVERNANCE:
    system_orchestration::holistic-orchestrator // Ultimate system orchestrator
    orchestrator_analysis::ho-liaison // Advisory analysis for holistic-orchestrator
    directory_organization::directory-curator // Reorganize directories safely
    documentation_governance::hestai-doc-steward // Govern HestAI documentation
    validate_decomposition::task-decomposer-validator // Build plan quality validation
    
  DOMAIN_SPECIFIC:
    smartsuite_integration::eav-admin // Platform mastery
    eav_coherence::eav-coherence-oracle // EAV-specific coherence
    documentation_lookup::documentation-researcher // Context7 real-time
    supabase_integration::supabase-expert // Supabase platform expertise
    smartsuite_expertise::smartsuite-expert // SmartSuite platform expertise
    accounting_guidance::accounting-partner // EAV financial and accounting operations

---

PHASE_OPTIMAL_AGENTS:
  D0_IDEATION_SETUP::[sessions-manager, session-briefer]
  D1_UNDERSTANDING::[idea-clarifier, research-analyst, validator, workflow-scope-calibrator, north-star-architect, surveyor]
  D2_IDEATION::[ideator, ideator-catalyst, synthesizer, complexity-guard]
  D3_ARCHITECTURE::[design-architect, technical-architect, critical-engineer, visual-architect, principal-engineer]
  B0_QUALITY_GATE::[critical-design-validator, requirements-steward, octave-validator, security-specialist, critical-implementation-validator]
  B1_PLANNING::[task-decomposer, workspace-architect, build-plan-checker, task-decomposer-validator]
  B2_IMPLEMENTATION::[implementation-lead, universal-test-engineer, error-architect, error-architect-surface + SPECIALIST_SPOKES]
  B3_INTEGRATION::[completion-architect, quality-observer, edge-optimizer]
  B4_DELIVERY::[solution-steward, compression-fidelity-validator]
  B5_ENHANCEMENT::[requirements-steward, technical-architect, implementation-lead, critical-engineer]
  ADMIN_CONTINUOUS::[system-steward, sessions-manager, test-curator, coherence-oracle, directory-curator, hestai-doc-steward, holistic-orchestrator, ho-liaison, subagent-creator]

---

HESTAI_MCP_TOOLS:
  // External reasoning specialists (Gemini/GPT-5/DeepSeek)
  LIGHTWEIGHT_CONSULT::mcp__hestai__chat // Quick specialist advice
  CRITICAL_VALIDATION::mcp__hestai__critical_engineer // Design reality check
  TEST_INTEGRITY::mcp__hestai__testguard // Anti-manipulation
  COMPREHENSIVE_ANALYSIS::mcp__hestai__analyze // Multi-dimensional
  SYSTEMATIC_DEBUG::mcp__hestai__debug // Root cause with DeepSeek R1
  CONSENSUS_DECISION::mcp__hestai__consensus // Multi-model evaluation
  CODE_COMPREHENSION::mcp__hestai__tracer // Precision or dependencies
  SECURITY_ASSESSMENT::mcp__hestai__secaudit // OWASP validation
  CHALLENGE_RESPONSE::mcp__hestai__challenge // Anti-reflexive agreement
  EXTENDED_REASONING::mcp__hestai__thinkdeep // Deep thinking and problem solving
  SEQUENTIAL_PLANNING::mcp__hestai__planner // Step-by-step project planning
  CODE_QUALITY_REVIEW::mcp__hestai__codereview // Systematic code review
  PRE_COMMIT_VALIDATION::mcp__hestai__precommit // Pre-commit change validation
  CODE_REFACTORING::mcp__hestai__refactor // Code refactoring analysis
  LIST_MODELS::mcp__hestai__listmodels // List available AI models
  SERVER_VERSION::mcp__hestai__version // Get server version info

---

SELECTION_HEURISTICS:
  // Quick decision rules
  
  IF_STUCK::[ideator-catalyst, mcp__hestai__chat]
  IF_COMPLEX::[implementation-lead, mcp__hestai__consensus]
  IF_BROKEN::[error-architect, mcp__hestai__debug, critical-engineer]
  IF_TESTING::[test-methodology-guardian, universal-test-engineer]
  IF_SECURITY::[security-specialist, code-review-specialist, mcp__hestai__secaudit]
  IF_ARCHITECTURE::[technical-architect, mcp__hestai__analyze]
  IF_DOCUMENTATION::[documentation-compressor, semantic-optimizer, hestai-doc-steward]
  IF_INTEGRATION::[completion-architect, edge-optimizer]
  IF_VALIDATION::[critical-implementation-validator, requirements-steward]
  IF_EXPLORATION::[Task(Explore), clink(gemini,surveyor), Task(surveyor)]

---

EXPLORATION_TOOL_SELECTION:
  // Empirical findings from Issue #183 comparison (2025-12-03)
  // All tools converged on same core findings - selection is about speed/depth/artifacts trade-off

  TOOL_MATRIX::[
    TASK_EXPLORE::[
      invocation::Task(subagent_type="Explore"),
      model::Haiku[default],
      speed::⭐⭐,
      depth::⭐⭐⭐⭐⭐,
      artifacts::❌,
      cost::Low,
      reliability::⭐⭐⭐⭐⭐,
      USE_WHEN::"exhaustive_audit+production_critical+verification_needed"
    ],

    CLINK_GEMINI_SURVEYOR::[
      invocation::mcp__hestai__clink(cli_name="gemini",role="surveyor"),
      model::Gemini,
      speed::⭐⭐⭐⭐⭐[55_seconds],
      depth::⭐⭐⭐,
      artifacts::❌,
      cost::Low[NOT_free→budget_awareness_required],
      reliability::⭐⭐⭐⭐,
      USE_WHEN::"fast_triage+initial_assessment+80%_of_exploration_cases"
    ],

    TASK_SURVEYOR_HAIKU::[
      invocation::Task(subagent_type="surveyor"),
      model::Haiku,
      speed::⭐⭐⭐⭐,
      depth::⭐⭐⭐⭐,
      artifacts::✅[persistent_reports],
      cost::Low,
      reliability::⭐⭐⭐,
      USE_WHEN::"persistent_documentation_needed+report_artifacts",
      CAVEAT::"⚠️ WORKTREE_CONTEXT_injection_MANDATORY_in_worktrees"
    ]
  ]

  DEFAULT_WORKFLOW::[
    1::START_with_clink(gemini,surveyor)[fast_triage_55s],
    2::ESCALATE_to_Task(Explore)_IF::[exhaustive_listing_needed,production_critical,gemini_needs_verification],
    3::USE_Task(surveyor)_IF::[persistent_artifacts_needed,documentation_generation]
  ]

  WORKTREE_WARNING::"Task() subagents may escape worktree context → inject WORKTREE_CONTEXT in prompt"

  KEY_INSIGHT::"All tools converge on same diagnosis → effort estimates vary 4.5x → use Gemini for optimistic, Explore for conservative"

---

AGENT_COMBINATIONS:
  // Proven complementary pairs

  CREATIVE_VALIDATION::ideator + validator
  ARCHITECTURE_HARDENING::technical-architect + critical-engineer
  TEST_INTEGRITY::universal-test-engineer + test-methodology-guardian
  SCOPE_CONTROL::requirements-steward + complexity-guard
  COMPRESSION_SAFETY::octave-specialist + compression-fidelity-validator
  BUILD_COORDINATION::implementation-lead + quality-observer
  PATTERN_PRESERVATION::research-curator + system-steward
  ERROR_RESOLUTION::error-architect[unified_simple_to_complex] + error-architect-surface[fast_triage]
  SYSTEM_COHERENCE::coherence-oracle + holistic-orchestrator
  SECURE_CODE::code-review-specialist + security-specialist
  BUILD_PLANNING::task-decomposer + task-decomposer-validator
  ORCHESTRATION_INTELLIGENCE::holistic-orchestrator + ho-liaison
  IDEATION_AMPLIFICATION::ideator + ideator-catalyst
  IMMUTABLE_REQUIREMENTS::north-star-architect + requirements-steward
  AGENT_CREATION::subagent-creator + octave-forge-master
  CODEBASE_EXPLORATION::surveyor + critical-engineer // See EXPLORATION_TOOL_SELECTION for tool variants

---

ANTI_PATTERNS:
  // What NOT to do
  
  NEVER::[
    "Use general-purpose for specific needs",
    "Skip validation agents at quality gates",
    "Invoke creation agents for validation tasks",
    "Mix ETHOS+LOGOS cognition in same agent",
    "Use compression without fidelity validation",
    "Deploy without solution-steward handoff"
  ]

---

QUICK_LOOKUP_EXAMPLES:
  "fix failing tests"::test-methodology-guardian // Prevents test manipulation
  "review my code"::code-review-specialist // Immediate post-implementation
  "will this scale?"::critical-engineer + mcp__hestai__critical_engineer
  "break down tasks"::task-decomposer → task-decomposer-validator
  "optimize performance"::edge-optimizer // After working code exists
  "integrate components"::completion-architect // B3 phase
  "find root cause"::mcp__hestai__debug // Systematic investigation
  "validate architecture"::mcp__hestai__analyze + critical-implementation-validator
  "prevent scope creep"::requirements-steward + complexity-guard
  "compress documentation"::documentation-compressor + semantic-optimizer
  "fix any errors"::error-architect
  "quick error triage"::error-architect-surface
  "reorganize my project"::directory-curator
  "check system coherence"::coherence-oracle
  "is this project scope too big?"::workflow-scope-calibrator
  "create mockups"::visual-architect
  "is this documentation good enough?"::hestai-doc-steward
  "who is in charge of everything?"::holistic-orchestrator
  "is this secure?"::security-specialist, mcp__hestai__secaudit
  "think deeper"::mcp__hestai__thinkdeep // Extended reasoning
  "create a plan"::mcp__hestai__planner // Sequential planning
  "review this code"::mcp__hestai__codereview // Code quality review
  "validate my commit"::mcp__hestai__precommit // Pre-commit validation
  "refactor this code"::mcp__hestai__refactor // Code refactoring
  "list models"::mcp__hestai__listmodels // List available models
  "get version"::mcp__hestai__version // Get server version
  "find files in codebase"::surveyor // See EXPLORATION_TOOL_SELECTION for tool choice
  "explore codebase patterns"::clink(gemini,surveyor) // Fast triage, then escalate if needed
  "establish immutable requirements"::north-star-architect // North Star creation
  "create new agent"::subagent-creator // Agent generation
  "analyze for orchestrator"::ho-liaison // HO advisory analysis
  "accounting guidance"::accounting-partner // EAV financial operations
  "smartsuite integration"::smartsuite-expert // SmartSuite expertise
  "supabase integration"::supabase-expert // Supabase expertise
  "session management"::sessions-manager + session-briefer // Context continuity
  "validate senior decisions"::principal-engineer // Senior authority

===END_LOOKUP_v1.3===

<!-- SUBAGENT_AUTHORITY: system-steward 2025-12-03 (v1.3 EXPLORATION_TOOL_SELECTION) -->