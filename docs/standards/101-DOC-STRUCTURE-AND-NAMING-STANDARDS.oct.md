META:
  TITLE::"HestAI Documentation Structure & Naming Standards"
  VERSION::2.0
  COMPRESSION_RATIO::"4:1 achieved"
  PURPOSE::"Naming+placement+archival patterns preventing documentation chaos"
  ESSENCE::"FLAT_TREES+RICH_NAMES+SEMANTIC_TOKENS"

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

  CONTEXT_TOKENS::[DOC,SYSTEM,PROJECT,WORKFLOW,SCRIPT,AUTH,UI,RUNTIME,DATA,SEC,OPS,BUILD,REPORT]
  QUALIFIER::ONLY_when_disambiguation_required
  NAME::UPPERCASE-WITH-HYPHENS
  EXTENSIONS::[.md::prose, .oct.md::OCTAVE_compressed]

PROJECT_PHASE_REQUIREMENT:
  PATTERN::"{NN}-PROJECT[-{NAME}]-{PHASE}-{NAME}.md"
  PHASES::[D1,D2,D3,B0,B1,B2,B3,B4]
  EXAMPLES::[
    "201-PROJECT-WEBAPP-D1-NORTH-STAR.md",
    "202-PROJECT-WEBAPP-D3-BLUEPRINT.md",
    "203-PROJECT-WEBAPP-B2-IMPLEMENTATION-LOG.md"
  ]

FORBIDDEN_PATTERNS:
  ANTI_PATTERNS::[
    version_suffixes::"_v01,_final,_latest,_draft",
    phase_encoding::"B2_01-setup.md",
    ambiguous_names::"000-NORTH-STAR.md",
    parallel_drafts::"multiple_numbered_same_standard",
    deep_nesting::">2_levels_under_docs"
  ]

EXEMPTED_FILES:
  STANDARD_REPOSITORY_FILES::[
    README.md,LICENSE,CONTRIBUTING.md,CHANGELOG.md,SECURITY.md,
    CODE_OF_CONDUCT.md,CLAUDE.md,CODEOWNERS,package.json,
    pyproject.toml,Cargo.toml,.gitignore,.editorconfig
  ]
  SCOPE::"HestAI_naming_applies_only_to_docs/+reports/+_archive/"

DIRECTORY_ARCHITECTURE:
  DUAL_PROFILES::[
    ORG_PROFILE::[docs/,reports/,_archive/,sessions/,scripts/],
    CODE_PROFILE::[src/,tests/,docs/,docs/adr/,reports/,_archive/,builds/,lib/,sessions/,scripts/]
  ]

  CORE_DIRECTORIES::[
    docs/::"standards+guides+ADR_index+playbooks",
    reports/::"time_bound_analyses+audits+retros",
    _archive/::"retired_docs_with_original_paths",
    sessions/::"raw_logs+explorations+scratch",
    scripts/::"hooks+generators+validators"
  ]

  NESTING_LIMITS::[
    docs/::MAX_DEPTH_2,
    reports/::FLAT_PREFERRED,
    _archive/::MIRROR_ORIGINAL_STRUCTURE
  ]

PLACEMENT_RULES:
  docs/::"standards+conventions+ADR_index+playbooks→filename_pattern_required"
  reports/::"time_bound_outputs→optional_ISO_date_prefix_when_chronology_matters"
  sessions/::"raw_notes+WIP→no_standards_enforced"
  _archive/::"retired_docs→original_filename_preserved+supersession_header"

ARCHIVAL_DISCIPLINE:
  PARALLEL_TREE::"_archive/maintains_original_paths"
  PRESERVE::"original_filenames_and_prefixes"
  SUPERSESSION_HEADER::[
    "Status: Archived → superseded by <link>",
    "Archived: YYYY-MM-DD",
    "Original-Path: <path>"
  ]

ENFORCEMENT_REGEX:
  FILENAME_PATTERN::"^[0-9]{3}-(DOC|SYSTEM|PROJECT|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)(-[A-Z0-9]+)?-[A-Z0-9]+(-[A-Z0-9]+)*\\.(md|oct\\.md)$"

  VALIDATION_RULES::[
    ADRs::must_be_under_docs/adr/,
    docs::must_match_filename_regex,
    reports::must_match_filename_regex,
    _archive::original_names_preserved,
    depth::docs_max_2_levels,
    anti_proliferation::reject_multiple_numbered_same_standard
  ]

LLM_OPTIMIZATION:
  BENEFITS::[
    flat_predictable_paths→better_retrieval,
    rich_filenames→improved_chunking,
    curated_CONTEXT_tokens→standardized_intent,
    archival_hygiene→prevents_stale_embeddings,
    anchor_docs→deterministic_entry_points
  ]

ESSENCE::SHALLOW_TREES+RICH_NAMES+SEMANTIC_TOKENS=DISCOVERABLE_DOCUMENTATION

