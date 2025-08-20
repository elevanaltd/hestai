// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: sequential-101-102-numbering /docs/guides/-placement agent-governance-scope

===AGENT_CAPABILITY_LOOKUP_v1.0===
// Streamlined agent selection guide optimized for LLM consumption
// Query pattern: "I need to [task]" → Agent recommendation

META:
  VERSION::"1.0"
  PURPOSE::"Rapid agent selection via task matching"
  AGENTS_COUNT::57
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
    octave_compliance::agent-validator + octave-validator // Spec enforcement
    
  BUILD_AND_EXECUTE:
    coordinate_build::implementation-lead // B2_01 hub role
    create_workspace::workspace-architect // B1_02 setup
    decompose_tasks::task-decomposer // VAD→atomic tasks
    generate_tests::test-automator + universal-test-engineer // Test creation
    integrate_systems::completion-architect // B3_01 unification
    optimize_edges::edge-optimizer // Breakthrough improvements
    deliver_solution::solution-steward // B4_01 handoff
    
  ANALYZE_AND_INVESTIGATE:
    research_feasibility::research-analyst // Evidence-based validation
    extract_patterns::research-analyst-pattern-extractor // Reusability
    discover_needs::idea-clarifier // Problem essence
    trace_code::mcp__zen__tracer // Execution flow analysis
    debug_complex::mcp__zen__debug // Root cause analysis
    assess_architecture::mcp__zen__analyze // Comprehensive review
    security_audit::mcp__zen__secaudit // OWASP compliance
    
  CREATE_AND_SYNTHESIZE:
    design_architecture::technical-architect + design-architect // D2-D3
    generate_ideas::ideator + ideator-catalyst // Bounded creativity
    transcend_tensions::synthesiser // Both-and solutions
    compress_docs::documentation-compressor + octave-specialist // Optimization
    convert_data::data-converter // Format transformation
    create_agents::subagent-creator + octave-forge-master // Agent generation
    enhance_semantics::semantic-optimizer // Mythological patterns
    
  PRESERVE_AND_OBSERVE:
    system_patterns::system-steward // Meta-observation
    curate_knowledge::research-curator + research-curator-subagent // Pattern preservation
    manage_sessions::sessions-manager + session-briefer // Context continuity
    test_stewardship::test-curator // Empirical preservation
    monitor_quality::quality-observer // Continuous assessment
    check_progress::build-plan-checker // Gap analysis
    
  DOMAIN_SPECIFIC:
    smartsuite_integration::smartsuite-expert + eav-admin // Platform mastery
    documentation_lookup::documentation-researcher // Context7 real-time
    claude_code_setup::statusline-setup + output-mode-setup // Developer UX

---

PHASE_OPTIMAL_AGENTS:
  D1_UNDERSTANDING::[idea-clarifier, research-analyst, validator]
  D2_IDEATION::[ideator, synthesiser, complexity-guard]
  D3_ARCHITECTURE::[design-architect, technical-architect, critical-engineer]
  B0_QUALITY_GATE::[critical-design-validator, requirements-steward, agent-validator]
  B1_PLANNING::[task-decomposer, workspace-architect, build-plan-checker]
  B2_IMPLEMENTATION::[implementation-lead + SPECIALIST_SPOKES]
  B3_INTEGRATION::[completion-architect, quality-observer]
  B4_DELIVERY::[solution-steward, compression-fidelity-validator]
  ADMIN_CONTINUOUS::[system-steward, sessions-manager, test-curator]

---

ZEN_MCP_TOOLS:
  // External reasoning specialists (Gemini/GPT-5/DeepSeek)
  LIGHTWEIGHT_CONSULT::mcp__zen__chat // Quick specialist advice
  CRITICAL_VALIDATION::mcp__zen__critical_engineer // Design reality check
  TEST_INTEGRITY::mcp__zen__testguard // Anti-manipulation
  COMPREHENSIVE_ANALYSIS::mcp__zen__analyze // Multi-dimensional
  SYSTEMATIC_DEBUG::mcp__zen__debug // Root cause with DeepSeek R1
  CONSENSUS_DECISION::mcp__zen__consensus // Multi-model evaluation
  CODE_COMPREHENSION::mcp__zen__tracer // Precision or dependencies
  SECURITY_ASSESSMENT::mcp__zen__secaudit // OWASP validation
  CHALLENGE_RESPONSE::mcp__zen__challenge // Anti-reflexive agreement

---

SELECTION_HEURISTICS:
  // Quick decision rules
  
  IF_STUCK::[ideator-catalyst, mcp__zen__chat]
  IF_COMPLEX::[implementation-lead, mcp__zen__consensus]
  IF_BROKEN::[mcp__zen__debug, critical-engineer]
  IF_TESTING::[test-methodology-guardian, universal-test-engineer]
  IF_SECURITY::[code-review-specialist, mcp__zen__secaudit]
  IF_ARCHITECTURE::[technical-architect, mcp__zen__analyze]
  IF_DOCUMENTATION::[documentation-compressor, semantic-optimizer]
  IF_INTEGRATION::[completion-architect, edge-optimizer]
  IF_VALIDATION::[critical-senior-engineer, requirements-steward]

---

AGENT_COMBINATIONS:
  // Proven complementary pairs
  
  CREATIVE_VALIDATION::ideator + validator
  ARCHITECTURE_HARDENING::technical-architect + critical-engineer
  TEST_INTEGRITY::test-automator + test-methodology-guardian
  SCOPE_CONTROL::requirements-steward + complexity-guard
  COMPRESSION_SAFETY::octave-specialist + compression-fidelity-validator
  BUILD_COORDINATION::implementation-lead + quality-observer
  PATTERN_PRESERVATION::research-curator + system-steward

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
  "will this scale?"::critical-engineer + mcp__zen__critical_engineer
  "break down tasks"::task-decomposer → task-decomposer-validator
  "optimize performance"::edge-optimizer // After working code exists
  "integrate components"::completion-architect // B3 phase
  "find root cause"::mcp__zen__debug // Systematic investigation
  "validate architecture"::mcp__zen__analyze + critical-implementation-validator
  "prevent scope creep"::requirements-steward + complexity-guard
  "compress documentation"::documentation-compressor + semantic-optimizer

===END_LOOKUP_v1.0===