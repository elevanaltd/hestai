META:
  TITLE::"HestAI Documentation North Star"
  VERSION::1.0
  COMPRESSION_RATIO::"8:1 achieved"
  PURPOSE::"Master principles preventing documentation paradox through enforcement≠hope"
  ESSENCE::"MAKE_RIGHT_THING_AUTOMATIC≠OPTIONAL"

CORE_PHILOSOPHY:
  DOCUMENTATION_PARADOX_PREVENTION::[
    agents_miss_consultations→add_documentation::WRONG,
    more_documentation→cognitive_overload→more_misses::SPIRAL,
    SOLUTION::fewer_words+automatic_enforcement+visual_triggers
  ]
  
  PRINCIPLE::"Documentation_describes_what_IS≠what_SHOULD_BE"
  ENFORCEMENT::"Hooks_gates_automation_PREVENT_wrong_behavior"
  MEASUREMENT::"Production_safety≠process_compliance"

DOCUMENTATION_HIERARCHY:
  THREE_TIER_SYSTEM::[
    TIER_1_CORE::[
      purpose::"Production_blockers_only",
      size::30_lines_MAX,
      format::visual_blocks≠prose,
      loads::automatically_based_on_context
    ],
    TIER_2_OPERATIONAL::[
      purpose::"Phase-specific_requirements",
      size::1_page_per_phase_MAX,
      format::checklists+commands,
      loads::on_phase_detection
    ],
    TIER_3_REFERENCE::[
      purpose::"Detailed_protocols_and_examples",
      size::unlimited_but_OCTAVE_compressed,
      format::searchable_structured,
      loads::on_demand_only
    ]
  ]

TRUST_FRAMEWORK:
  REAL_ISSUES::[
    names_specific_failure_modes,
    predicts_production_impact,
    references_domain_expertise,
    provides_concrete_fixes_with_tradeoffs
  ]
  
  VALIDATION_THEATER::[
    process_compliance_checkboxes,
    vague_quality_concerns,
    style_preferences,
    "should_have"_without_impact
  ]
  
  TRUST::issues_catching_production_failures
  DISTRUST::documentation_creating_busywork

NAMING_TAXONOMY:
  PATTERN::"{CATEGORY}{NN}-{CONTEXT}[-{QUALIFIER}]-{NAME}.{EXT}"
  
  CATEGORY_RANGES::[
    0xx::SYSTEM_META[workflows,principles,north_stars],
    1xx::DOCUMENTATION[standards,guides,rules],
    2xx::PROJECT_BUILD[plans,workflows,deliverables],
    3xx::UI_FRONTEND[components,patterns,guidelines],
    4xx::SECURITY_AUTH[models,policies,controls],
    5xx::RUNTIME_OPS[deployment,monitoring,incidents],
    6xx::DATA_STORAGE[schemas,migrations,backups],
    7xx::INTEGRATION_API[contracts,clients,protocols],
    8xx::REPORTS[audits,analyses,retrospectives],
    9xx::SCRIPTS_TOOLS[automation,generators,validators]
  ]
  
  CONTEXT_TOKENS::[DOC,SYSTEM,PROJECT,SCRIPT,AUTH,UI,RUNTIME,DATA,SEC,OPS,BUILD,REPORT]
  QUALIFIERS::ONLY_when_disambiguation_required
  NAME::UPPERCASE-WITH-HYPHENS
  EXTENSIONS::[.md::prose, .oct.md::OCTAVE_compressed]

OCTAVE_TRIGGERS:
  COMPRESS_WHEN::[
    token_reduction::">3:1_achievable",
    content_stability::"finalized_not_actively_edited",
    cross_reference_density::"high_interconnection",
    pattern_content::"roles_workflows_protocols",
    preservation_need::"canonical_reference"
  ]
  
  KEEP_PROSE_WHEN::[
    frequently_edited,
    simple_linear_content,
    user_facing_guides,
    external_consumption
  ]

ENFORCEMENT_PRINCIPLES:
  BLOCKING_GATES::[
    NO_CODE_WITHOUT::[failing_test,architecture_review],
    NO_LIBRARY_WITHOUT::Context7_documentation,
    NO_COMMIT_WITHOUT::[tests_pass,code_reviewed]
  ]
  
  ADVISORY_SIGNALS::[
    quality_improvements,
    best_practices,
    optimization_opportunities
  ]
  
  AUTOMATION::[
    phase_detection::git_state+artifacts,
    consultation_routing::automatic_based_on_triggers,
    evidence_collection::tracked_in_commits
  ]

ANTI_PATTERNS_FORBIDDEN:
  DOCUMENTATION_SINS::[
    version_suffixes_in_filenames::"_v1,_final,_latest",
    parallel_numbered_drafts::"multiple_versions_same_standard",
    deep_nesting::"more_than_2_levels",
    phase_role_encoding_in_names::"B2_01-setup.md",
    ambiguous_names::"000-NORTH-STAR.md",
    hope_based_compliance::"assuming_agents_read"
  ]

ARCHIVAL_DISCIPLINE:
  PARALLEL_TREE::"_archive/maintains_original_paths"
  PRESERVE::"original_filenames_and_prefixes"
  HEADER_REQUIRED::[
    "Status: Archived → superseded by <link>",
    "Archived: YYYY-MM-DD",
    "Original-Path: <path>"
  ]
  SUPERSESSION::canonical_updated→old_archived→links_updated

PLATFORM_INTEGRATION:
  PROFILES::[
    ORG_PROFILE::[docs,reports,_archive,sessions,scripts],
    CODE_PROFILE::[src,tests,docs,docs/adr,reports,_archive,builds,lib,sessions,scripts]
  ]
  
  ANCHOR_DOCUMENTS::[
    "100-DOC-NORTH-STAR.oct.md"::THIS_DOCUMENT,
    "101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md",
    "102-DOC-ARCHIVAL-RULES.md",
    "103-DOC-OCTAVE-COMPRESSION-RULES.md"
  ]

SUCCESS_METRICS:
  DOCUMENTATION::[
    lookup_time::"<30_seconds",
    cognitive_load::"<100_lines_active",
    compression_ratio::">5:1_for_OCTAVE",
    redundancy_rate::"<5%"
  ]
  
  ENFORCEMENT::[
    consultation_miss_rate::"<5%",
    production_failures_from_misses::0,
    automation_coverage::">90%",
    validation_theater_eliminated::">80%"
  ]

IMPLEMENTATION_PATH:
  IMMEDIATE::[
    establish_naming_standards,
    create_enforcement_hooks,
    implement_phase_detection,
    route_library_queries_to_Context7
  ]
  
  PROGRESSIVE::[
    migrate_existing_documentation,
    compress_stable_content_to_OCTAVE,
    eliminate_redundancy,
    measure_consultation_success
  ]

ESSENCE::FEWER_WORDS+MORE_ENFORCEMENT=DOCUMENTATION_THAT_WORKS