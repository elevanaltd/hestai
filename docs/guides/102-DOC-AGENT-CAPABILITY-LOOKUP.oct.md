// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: sequential-101-102-numbering /docs/guides/-placement agent-governance-scope

===AGENT_CAPABILITY_LOOKUP_v1.1===
// Streamlined agent selection guide optimized for LLM consumption
// Query pattern: "I need to [task]" → Agent recommendation

META:
  VERSION::"1.1"
  PURPOSE::"Rapid agent selection via task matching"
  AGENTS_COUNT::64
  OPTIMIZATION::"OCTAVE semantic compression for instant lookup"

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
    code_quality::code-review-specialist // Post-implementation review
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
    create_workspace::workspace-architect // B1_02 setup
    decompose_tasks::task-decomposer // VAD→atomic tasks
    generate_tests::universal-test-engineer // Test creation
    integrate_systems::completion-architect // B3_01 unification
    optimize_edges::edge-optimizer // Breakthrough improvements
    deliver_solution::solution-steward // B4_01 handoff
    
  ANALYZE_AND_INVESTIGATE:
    research_feasibility::research-analyst // Evidence-based validation
    extract_patterns::research-analyst-pattern-extractor // Reusability
    discover_needs::idea-clarifier // Problem essence
    trace_code::mcp__hestai__tracer // Execution flow analysis
    debug_complex::mcp__hestai__debug // Root cause analysis
    assess_architecture::mcp__hestai__analyze // Comprehensive review
    security_audit::mcp__hestai__secaudit // OWASP compliance
    measure_compression::compression-analyst // Measure OCTAVE effectiveness
    resolve_architectural_errors::error-architect // Systemic error resolution
    resolve_component_errors::error-resolver // Component-level error resolution
    retrieve_workflow_facts::workflow-engine // Pure workflow fact retrieval
    
  CREATE_AND_SYNTHESIZE:
    design_architecture::technical-architect + design-architect // D2-D3
    generate_ideas::ideator + ideator-catalyst // Bounded creativity
    transcend_tensions::synthesiser // Both-and solutions
    compress_docs::documentation-compressor + octave-specialist // Optimization
    convert_data::data-converter // Format transformation
    create_agents::subagent-creator + octave-forge-master // Agent generation
    enhance_semantics::semantic-optimizer // Mythological patterns
    create_visual_designs::visual-architect // Create UI/UX mockups
    
  PRESERVE_AND_OBSERVE:
    system_patterns::system-steward // Meta-observation
    curate_knowledge::research-curator + research-curator-subagent // Pattern preservation
    manage_sessions::sessions-manager + session-briefer // Context continuity
    test_stewardship::test-curator // Empirical preservation
    monitor_quality::quality-observer // Continuous assessment
    check_progress::build-plan-checker // Gap analysis
    
  ORCHESTRATION_AND_GOVERNANCE:
    system_orchestration::holistic-orchestrator // Ultimate system orchestrator
    directory_organization::directory-curator // Reorganize directories safely
    documentation_governance::hestai-doc-steward // Govern HestAI documentation
    
  DOMAIN_SPECIFIC:
    smartsuite_integration::eav-admin // Platform mastery
    eav_coherence::eav-coherence-oracle // EAV-specific coherence
    documentation_lookup::documentation-researcher // Context7 real-time

---

PHASE_OPTIMAL_AGENTS:
  D0_IDEATION_SETUP::[sessions-manager]
  D1_UNDERSTANDING::[idea-clarifier, research-analyst, validator, workflow-scope-calibrator]
  D2_IDEATION::[ideator, synthesiser, complexity-guard]
  D3_ARCHITECTURE::[design-architect, technical-architect, critical-engineer, visual-architect]
  B0_QUALITY_GATE::[critical-design-validator, requirements-steward, octave-validator, security-specialist]
  B1_PLANNING::[task-decomposer, workspace-architect, build-plan-checker, task-decomposer-validator]
  B2_IMPLEMENTATION::[implementation-lead, universal-test-engineer, error-resolver, error-architect + SPECIALIST_SPOKES]
  B3_INTEGRATION::[completion-architect, quality-observer]
  B4_DELIVERY::[solution-steward, compression-fidelity-validator]
  B5_ENHANCEMENT::[requirements-steward, technical-architect, implementation-lead, critical-engineer]
  ADMIN_CONTINUOUS::[system-steward, sessions-manager, test-curator, coherence-oracle, compression-analyst, directory-curator, hestai-doc-steward, holistic-orchestrator, subagent-system-tester, workflow-engine]

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
  IF_BROKEN::[error-resolver, error-architect, mcp__hestai__debug, critical-engineer]
  IF_TESTING::[test-methodology-guardian, universal-test-engineer]
  IF_SECURITY::[security-specialist, code-review-specialist, mcp__hestai__secaudit]
  IF_ARCHITECTURE::[technical-architect, mcp__hestai__analyze]
  IF_DOCUMENTATION::[documentation-compressor, semantic-optimizer, hestai-doc-steward]
  IF_INTEGRATION::[completion-architect, edge-optimizer]
  IF_VALIDATION::[critical-implementation-validator, requirements-steward]

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
  ERROR_RESOLUTION::error-resolver + error-architect
  WORKFLOW_PLANNING::workflow-engine + workflow-scope-calibrator
  SYSTEM_COHERENCE::coherence-oracle + holistic-orchestrator
  SECURE_CODE::code-review-specialist + security-specialist
  BUILD_PLANNING::task-decomposer + task-decomposer-validator

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
  "fix architectural errors"::error-architect
  "fix component error"::error-resolver
  "reorganize my project"::directory-curator
  "check system coherence"::coherence-oracle
  "what are the workflow rules"::workflow-engine
  "is this project scope too big?"::workflow-scope-calibrator
  "create mockups"::visual-architect
  "test the agent system"::subagent-system-tester
  "is this documentation good enough?"::hestai-doc-steward
  "who is in charge of everything?"::holistic-orchestrator
  "how well is this compressed?"::compression-analyst
  "is this secure?"::security-specialist, mcp__hestai__secaudit
  "think deeper"::mcp__hestai__thinkdeep // Extended reasoning
  "create a plan"::mcp__hestai__planner // Sequential planning
  "review this code"::mcp__hestai__codereview // Code quality review
  "validate my commit"::mcp__hestai__precommit // Pre-commit validation
  "refactor this code"::mcp__hestai__refactor // Code refactoring
  "list models"::mcp__hestai__listmodels // List available models
  "get version"::mcp__hestai__version // Get server version

===END_LOOKUP_v1.1