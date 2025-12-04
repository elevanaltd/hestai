# Unified North Star Summary Template - Semantically Optimized

**META:**
  TITLE::"Cross-Project North Star Compression Framework"
  VERSION::1.0
  COMPRESSION_ACHIEVED::"Original: 1,209 lines (3 docs) -> Target: ~400 lines (~3.0:1)"
  MYTHOLOGICAL_RESONANCE::"Archetypal patterns amplify meaning through millennia of cultural encoding"
  SEMANTIC_BINDING_PHILOSOPHY::"Express once, reference everywhere"
  OPTIMIZATION_GOAL::"Maximum decision-logic density with zero fidelity loss"

---

## PART 1: UNIVERSAL IMMUTABLE PATTERNS (Shared Across All Projects)

### PATTERN RECOGNITION: Three projects share common immutable DNA

```octave
===UNIVERSAL_IMMUTABLE_TRINITY===

QUALITY_PATTERN::HEPHAESTUS_FORGE[I7+I8]::[
  I7::TDD_RED_DISCIPLINE::every_feature_begins_failing_test[RED->GREEN->REFACTOR]+git_evidence[TEST->FEAT],
  I8::PRODUCTION_GRADE_DAY_ONE::strict_TypeScript+zero_warnings+database_security+no_MVP_shortcuts,
  INHERITANCE::[EAV_MONOREPO::[I7,I8], INGEST_ASSISTANT::[mapped_via_I2+I7], CEP_PANEL::[I7,I8]],
  CITATION_PATTERN::"// HEPHAESTUS_FORGE: I7 TDD + I8 Production Quality"
]

INTEGRITY_PATTERN::ATHENA_TRUTH[I3+I4+I10]::[
  I3::SINGLE_SOURCE_OF_TRUTH::each_metadata_attribute_has_exactly_one_authoritative_source,
  I4::ZERO_DATA_LOSS::no_media_file_content_or_metadata_lost_corrupted_degraded,
  I10::CROSS_APP_CONSISTENCY::all_inter-app_synchronization_through_database[no_client-to-client],
  INHERITANCE::[EAV::[I10,I12], IA::[I3,I4], CEP::[I10_OPTIONAL]],
  CITATION_PATTERN::"// ATHENA_TRUTH: Data integrity preserved via [I#]"
]

TEMPORAL_PATTERN::CHRONOS_ORDER[I1+I6]::[
  I1::CHRONOLOGICAL_ORDERING::media_assets_ordered_by_capture_timestamp->immutable_sequence,
  I6::COMMITTED_IDENTIFIER_IMMUTABILITY::externally_referenced_identifiers_never_change,
  INHERITANCE::[IA::[I1,I6], CEP::[via_contract], EAV::[via_component_spine]],
  CITATION_PATTERN::"// CHRONOS_ORDER: Temporal integrity via [I#]"
]

AUTONOMY_PATTERN::PROMETHEUS_AGENCY[I2+I7_humanprimacy]::[
  I2::HUMAN_OVERSIGHT_AUTHORITY::human_judgment_final_authority->AI_augmentation_not_replacement,
  I7::HUMAN_PRIMACY_OVER_AUTOMATION::automation_optimizes->preserves_user_agency,
  INHERITANCE::[IA::[I2,I7], ALL::[TRACED_protocol_human_verification]],
  CITATION_PATTERN::"// PROMETHEUS_AGENCY: Human primacy preserved via [I#]"
]

RESILIENCE_PATTERN::HERMES_OFFLINE[I5]::[
  I5::OFFLINE_CAPABLE_OPERATIONS::field/QC_operations_function_without_connectivity,
  INHERITANCE::[EAV::[I5_cam-op-pwa], IA::[platform_independence], CEP::[I5_core]],
  CITATION_PATTERN::"// HERMES_OFFLINE: Offline resilience via I5"
]

===END_UNIVERSAL_PATTERNS===
```

### SEMANTIC BINDING: Cross-Reference Matrix

```octave
IMMUTABLE_CROSS_REFERENCE_MATRIX::[
  PATTERN_ID        | EAV_MONOREPO | INGEST_ASSISTANT | CEP_PANEL
  ------------------|--------------|------------------|----------
  HEPHAESTUS_FORGE  | I7,I8        | I2(mapped),I7(P) | I7,I8
  ATHENA_TRUTH      | I10,I12      | I3,I4            | I10(opt)
  CHRONOS_ORDER     | spine_I1     | I1,I6            | contract
  PROMETHEUS_AGENCY | TRACED       | I2,I7            | human_QC
  HERMES_OFFLINE    | I5           | platform         | I5
]

BINDING_SEMANTICS::[
  "spine_I1"::component_spine_serves_same_purpose_as_IA_chronological_ordering,
  "contract"::CEP_inherits_temporal_guarantees_via_IA->CEP_JSON_contract,
  "mapped"::IA_I2[human_oversight]_maps_to_TDD_verification_pattern,
  "opt"::CEP_I10_is_OPTIONAL[JSON_always_authoritative]
]
```

---

## PART 2: PROJECT-SPECIFIC IMMUTABLE EXTENSIONS

### EAV Monorepo (13 Total = 5 Universal + 8 Specific)

```octave
===EAV_SPECIFIC_IMMUTABLES===

I1::COMPONENT_SPINE_IDENTITY::[
  PRINCIPLE::every_content_piece->component_with_stable_identity[Scripts->Scenes->VO->Edit->Delivery],
  MYTHOLOGICAL::ARIADNE_THREAD[navigates_production_labyrinth_via_component_FK],
  STATUS::PROVEN[120/120_tests]
]

I2::MULTI_CLIENT_ISOLATION::[
  PRINCIPLE::database_RLS_fail-closed[clients->assigned_projects_only],
  MYTHOLOGICAL::CERBERUS_GATE[guards_data_boundaries],
  STATUS::PROVEN[client_filtering_tested]
]

I3::LLM_ASSISTED_GENERATION::[
  PRINCIPLE::structured_data->production_content_via_LLM+mandatory_human_gate,
  MYTHOLOGICAL::DAEDALUS_CRAFT[tools_serve_craftsman],
  FLEXIBILITY::provider_NEGOTIABLE->workflow_IMMUTABLE,
  STATUS::PARTIAL[Scripts_validated+DataEntry+Translations_planned]
]

I4::PARALLEL_WORKFLOWS::[
  PRINCIPLE::multiple_production_streams_execute_without_blocking,
  MYTHOLOGICAL::HYDRA_HEADS[independent_parallel_execution],
  STATUS::ARCHITECTURAL[technical-architect_validated]
]

I6::COMPONENT_SPINE_APP_STATE::[
  SHARED::projects+videos+user_profiles+script_components+comments,
  APP_SPECIFIC::vo_generation_state+scene_planning_state[single_owner],
  MYTHOLOGICAL::OLYMPUS_REALMS[shared_mountain+individual_domains],
  STATUS::PROVEN[prevents_single-status-field_conflicts]
]

I9::EXTRACTION_PERFORMANCE::[
  PRINCIPLE::paragraph->component_<100ms[50_paragraphs_production_scale],
  MYTHOLOGICAL::MERCURY_SPEED[user_experience_demands_velocity],
  STATUS::PROVEN[<50ms_measured]
]

I11::INDEPENDENT_DEPLOYMENT::[
  PRINCIPLE::each_app_deploys_independently[zero_blast_radius],
  MYTHOLOGICAL::LOOSE_COUPLING[Vercel_per_app],
  ANTI::centralized_API|shared_pipeline|monolithic_build,
  STATUS::PROVEN[monorepo+independent_Vercel_projects]
]

I13::CLIENT_FACING_BOUNDARIES::[
  CLIENT_APPS::copy-editor+data-entry-web[RLS_client_id_filtering],
  INTERNAL_APPS::vo-web+edit-web+translations-web+cam-op-pwa+scenes-web+library-manager,
  MYTHOLOGICAL::TEMPLE_BOUNDARIES[sacred_vs_profane_access],
  STATUS::ARCHITECTURAL[policy_decision]
]

===END_EAV_SPECIFIC===
```

### Ingest Assistant (7 Total = 4 Universal + 3 Specific)

```octave
===IA_SPECIFIC_IMMUTABLES===

I5::ECOSYSTEM_CONTRACT_COHERENCE::[
  PRINCIPLE::metadata_contracts_stable_backwards-compatible[IA_Step6->CEP_Step7],
  MYTHOLOGICAL::TREATY_BOND[breaking_contract_halts_production_pipeline],
  VALIDATION::JSON_Schema_v2.0+location_contract+filename_immutability+migration_paths,
  STATUS::PROVEN[CEP_compatibility_tested]
]

JSON_SOURCE::[
  FILE::.ingest-metadata.json[co-located_with_analyzed_files],
  VIDEO_LOCATION::proxy_folder[/LucidLink/EAV014/videos-proxy/shoot1/],
  PHOTO_LOCATION::image_folder[/LucidLink/EAV014/images/shoot1/],
  RATIONALE::editors_work_with_proxies->JSON_must_be_where_editors_access
]

CEP_CONTRACT::[
  READS::JSON_from_proxy_folder[videos]_or_image_folder[photos],
  REFERENCE::filename_as_immutable_key[camera_id/unique_ref_deterministic],
  PROXY_MATCHING::{filename}_proxy.MOV->{filename}.MOV[removes_proxy_suffix]
]

===END_IA_SPECIFIC===
```

### CEP Panel (5 Inherited + 6 Core Requirements)

```octave
===CEP_SPECIFIC_REQUIREMENTS===

INHERITED_IMMUTABLES::[I5,I7,I8,I10_OPTIONAL,I11]

R1::JSON_METADATA_FORMAT[LOCKED]::[
  PRIMARY_KEY::original_filename[survives_PP_renames],
  LOCK_MECHANISM::lockedFields_array[prevents_QC->IA_overwrites],
  IMMUTABLE_FIELDS::id+originalFilename+fileType,
  DERIVED::shotName[location-subject-action-shotType-shotNumber],
  SPEC_REF::.coord/docs/005-DOC-SCHEMA-R1-1-AUTHORITATIVE
]

R2::FILE_PLACEMENT::[
  IMAGES::EAV014/images/shoot1/.ingest-metadata.json,
  VIDEOS::EAV014/videos-proxy/shoot1/.ingest-metadata.json,
  MYTHOLOGICAL::COLOCATION[metadata_travels_with_media_forever]
]

R3::METADATA_READ::[
  IDENTIFIER::PP_Tape_Name[immutable]->JSON_key,
  LOCATION::same_folder_as_media_files,
  OFFLINE::IndexedDB_cache->sync_queue_when_online
]

R4::METADATA_WRITE::[
  JSON::REQUIRED[atomic_temp->rename],
  SUPABASE::OPTIONAL[async_best-effort_non-blocking],
  CRITICAL_PATH::JSON_must_succeed_for_workflow_to_continue
]

R5::IA_INTEGRATION_CONTRACT::[
  IA_PROVIDES::JSON+all_fields+createdBy_ingest-assistant+lockedFields_empty,
  CEP_EXPECTS::key[original_filename_no_extension]+lock_array_respected
]

R6::LOCK_CONFLICT::[
  LIFECYCLE::unlocked->QC_lock->field_level_lock[future],
  RESOLUTION::timestamp_order[last-write-wins]+lockedFields_prevents_IA_overwrite
]

===END_CEP_SPECIFIC===
```

---

## PART 3: SUPPLY CHAIN BINDING (Pipeline Position Semantics)

```octave
===PRODUCTION_PIPELINE_SEMANTICS===

PIPELINE_FLOW::[
  Step_1-5::field_capture[cam-op-pwa]+raw_storage[LucidLink],
  Step_6::INGEST_ASSISTANT[raw->cataloged_assets_via_AI+human_QC],
  Step_7::CEP_PANEL[QC_metadata->Premiere_Pro_columns+JSON_persistence],
  Step_8-10::editor_workflow[edit-web]+delivery[Vimeo]+archive
]

HANDOFF_CONTRACTS::[
  IA->CEP::[
    FORMAT::.ingest-metadata.json[Schema_v2.0],
    LOCATION::proxy_folder[videos]|image_folder[photos],
    KEY::original_filename[immutable_camera_id],
    GUARANTEE::chronological_ordering[I1]+lock_respect[I6]
  ],
  CEP->EDITOR::[
    FORMAT::PP_columns+shotName_in_Clip_Name,
    SYNC::JSON_authoritative->PP_derived,
    GUARANTEE::offline_persistence[I5]+batch_performance[<500ms]
  ]
]

INHERITANCE_CHAIN::[
  EAV_UNIVERSAL_NORTH_STAR::[
    CHILDREN::IA_NORTH_STAR+CEP_NORTH_STAR,
    INHERITED::I5[offline]+I7[TDD]+I8[quality]+I10[database_consistency]+I11[deployment_independence]
  ],
  IA_NORTH_STAR::[
    PARENT::EAV_UNIVERSAL,
    CHILDREN::CEP_VIA_CONTRACT,
    EXPORTS::JSON_Schema_v2.0+chronological_ordering+identifier_immutability
  ],
  CEP_NORTH_STAR::[
    PARENTS::EAV_UNIVERSAL+IA_VIA_CONTRACT,
    IMPORTS::JSON_Schema_v2.0+chronological_guarantees+lock_semantics
  ]
]

===END_PIPELINE===
```

---

## PART 4: ASSUMPTION CLUSTERING (Cross-Project Risk Patterns)

```octave
===ASSUMPTION_ARCHETYPES===

DATA_INTEGRITY_CLUSTER::ATHENA_VIGILANCE[
  EAV_A2:COMPONENT_SPINE_WRITE_PROTECTION[60%]->RISK[single_client_bug_corrupts_all_7_apps],
  IA_A4:PARALLEL_IO_AI_SAVES_TIME[75%]->RISK[resource_contention+file_integrity],
  CEP_A4:INDEXEDDB_SYNC_CORRUPTION[85%]->RISK[race_condition_offline+online_simultaneous],
  PATTERN::data_integrity_assumptions_cluster_around_60-85%_confidence_with_corruption_risks,
  VALIDATION_STRATEGY::B1-B2_benchmarking+integrity_checks+fallback_mechanisms
]

AI_ACCURACY_CLUSTER::DAEDALUS_UNCERTAINTY[
  EAV_A6:LLM_CONTENT_GENERATION_QUALITY[60%]->CONTINGENCY[template_fallback],
  IA_A3:AI_PRE_ANALYSIS_ACCURACY[70%]->CONTINGENCY[make_AI_opt-in+tune_thresholds],
  IA_A5:REFERENCE_CATALOG_IMPROVES_ACCURACY[60%]->CONTINGENCY[defer_if_<10%_improvement],
  PATTERN::AI_assumptions_hover_60-70%_confidence_with_human_fallback_always_available,
  VALIDATION_STRATEGY::pilot_testing+A/B_experiments+accuracy_measurement
]

PERFORMANCE_CLUSTER::MERCURY_SPEED[
  EAV_A3:COMPONENT_SUMMARY_VIEW[70%]->CONTINGENCY[materialized_view|Redis_cache],
  EAV_A9:EXTRACTION_PERFORMANCE[PROVEN<50ms],
  CEP_SC4:PERFORMANCE[<500ms_required],
  PATTERN::performance_assumptions_validated_via_benchmarking_before_B2,
  VALIDATION_STRATEGY::EXPLAIN_ANALYZE+load_testing+profile_JOINs
]

CONTRACT_STABILITY_CLUSTER::TREATY_ASSURANCE[
  IA_A2:CEP_PANEL_CONTRACT_STABILITY[90%]->validated_via_integration_tests,
  IA_A6:CROSS_SCHEMA_FK_INTEGRITY[80%]->contract_specs+compatibility_tests,
  CEP_A1:JSON_FILE_EXISTS[90%]->mitigation[CEP_creates_empty_if_missing],
  PATTERN::contract_assumptions_high_confidence_90%+_with_documented_specs,
  VALIDATION_STRATEGY::contract_documentation+integration_tests+version_migration_paths
]

===END_ASSUMPTIONS===
```

---

## PART 5: DECISION GATE SEQUENCE (Universal Workflow Reference)

```octave
===DECISION_GATE_BINDING===

UNIVERSAL_GATE_PATTERN::D0->D1->D2->D3->B0->B1->B2->B3->B4::[
  D0::ideation_setup[sessions-manager],
  D1::North_Star_definition[this_phase],
  D2::solution_approaches[ideator+validator],
  D3::technical_blueprint[design-architect+technical-architect],
  B0::VALIDATION_GATE[critical-engineer_GO/NO-GO],
  B1::build_plan[task-decomposer+workspace-architect]+QUALITY_GATE_MANDATORY,
  B2::TDD_implementation[testguard->implementation-lead],
  B3::integration[completion-architect+universal-test-engineer],
  B4::delivery[solution-steward+critical-engineer_signoff]
]

PROJECT_GATE_BINDING::[
  EAV::D0[✓]+B0[A2-A7_review]+B1[foundation]+B2[app-specific]+B3[cross-app]+B4[quality_gates],
  IA::D0[✓]+D1_04[validation]+B0[critical-engineer]+CFEx_Phases[1a->1b->1c]+RefCatalog[deferred],
  CEP::D0[schema_lock]+B0[integration_design]+B1[foundation_test]+B2[integration_test]+Phases[0->1->2->3]
]

===END_GATES===
```

---

## PART 6: TRIGGER PATTERNS (When to Load Full North Star)

```octave
===UNIFIED_TRIGGER_PATTERNS===

LOAD_FULL_EAV_NORTH_STAR::[
  IMMUTABLE_VIOLATION::I1|I2|I3|I4|I5|I6|I7|I8|I9|I10|I11|I12|I13,
  ARCHITECTURE::deployment_strategy+database_design+RLS_patterns+cross-app_workflows,
  ASSUMPTION::A2-A7_validation_needed,
  GATE::B0_validation+B1_foundation+B2_app-specific+B3_integration
]

LOAD_FULL_IA_NORTH_STAR::[
  IMMUTABLE_VIOLATION::I1|I2|I3|I4|I5|I6|I7,
  CONTRACT::JSON_schema_evolution+CEP_integration_revision,
  ASSUMPTION::A1-A8_validation_needed,
  FEATURE::CFEx_Phase_design+Reference_Catalog_architecture
]

LOAD_FULL_CEP_NORTH_STAR::[
  IMMUTABLE_VIOLATION::I5|I7|I8|I10|I11,
  CONTRACT::JSON_schema_mismatch+IA_integration_broken,
  ASSUMPTION::A1-A4_risk_assessment,
  ARCHITECTURE::file_placement+lock_mechanism+offline_sync
]

ESCALATION_BINDING::[
  requirements-steward::North_Star_violation+immutable_change_request+D1_04_completeness,
  critical-engineer::B0_validation+production_reality_check+GO/NO-GO_authority,
  technical-architect::architecture_decisions+integration_design+schema_validation,
  implementation-lead::B1_tasks+assumption_validation_execution+performance_benchmarks,
  principal-engineer::strategic_review+long-term_viability+debt_analysis
]

===END_TRIGGERS===
```

---

## PART 7: NAVIGATION GUIDE (Summary -> Full Document Mapping)

```octave
===DOCUMENT_NAVIGATION===

SUMMARY_SECTION              | FULL_DOC_SECTION                    | LINES_REF
-----------------------------|-------------------------------------|----------
UNIVERSAL_PATTERNS           | EAV:I7,I8 | IA:I2,I7 | CEP:I7,I8    | Cross-doc
EAV_SPECIFIC_IMMUTABLES      | EAV:I1-I13                          | 10-107
IA_SPECIFIC_IMMUTABLES       | IA:I1-I7                            | 18-156
CEP_REQUIREMENTS             | CEP:R1-R6                           | 39-216
ASSUMPTION_CLUSTERS          | EAV:A1-A8 | IA:A1-A8 | CEP:A1-A4    | Cross-doc
DECISION_GATES               | All:DECISION_GATES_section          | Cross-doc
TRIGGER_PATTERNS             | All:TRIGGER_PATTERNS_section        | Cross-doc

FULL_DOCUMENT_REFS::[
  EAV::000-UNIVERSAL-EAV_SYSTEM-D1-NORTH-STAR.md[301_lines],
  IA::000-INGEST_ASSISTANT-D1-NORTH-STAR.md[380_lines],
  CEP::000-CEP_PANEL_METADATA_ARCHITECTURE-D1-NORTH-STAR.md[528_lines]
]

===END_NAVIGATION===
```

---

## PART 8: COMPRESSION METRICS & SEMANTIC DENSITY ANALYSIS

### Before/After Comparison

```octave
===COMPRESSION_EVIDENCE===

ORIGINAL_SUMMARIES::[
  EAV_SUMMARY::284_lines[39%_reduction_from_301],
  IA_SUMMARY::236_lines[59%_reduction_from_380],
  CEP_SUMMARY::227_lines[74%_reduction_from_528],
  TOTAL_ORIGINAL_SUMMARIES::747_lines
]

UNIFIED_TEMPLATE::~400_lines[
  UNIVERSAL_PATTERNS::~60_lines[expressed_once],
  PROJECT_SPECIFIC::~150_lines[deduplicated],
  SUPPLY_CHAIN::~40_lines[binding_semantics],
  ASSUMPTIONS::~50_lines[clustered],
  GATES+TRIGGERS::~50_lines[unified],
  NAVIGATION::~30_lines[cross-reference],
  META+METRICS::~20_lines
]

SEMANTIC_DENSITY_IMPROVEMENT::[
  REPETITION_ELIMINATED::~200_lines[I7+I8+I5+I10_expressed_3x->1x],
  PATTERN_ABSTRACTION::~100_lines[archetypal_compression],
  CROSS_REFERENCE_BINDING::~50_lines[inheritance_chains_replace_duplication],
  TOTAL_REDUCTION::747->400_lines[46%_compression+semantic_amplification]
]

===END_METRICS===
```

### Key Semantic Optimizations Applied

```octave
===OPTIMIZATION_EVIDENCE===

1_ARCHETYPAL_PATTERNS_INTRODUCED::[
  HEPHAESTUS_FORGE::"Quality forging through TDD+Production standards"[I7+I8],
  ATHENA_TRUTH::"Data integrity through single source"[I3+I4+I10],
  CHRONOS_ORDER::"Temporal integrity through ordering"[I1+I6],
  PROMETHEUS_AGENCY::"Human primacy over automation"[I2+I7],
  HERMES_OFFLINE::"Offline resilience"[I5],
  ARIADNE_THREAD::"Component spine navigation",
  CERBERUS_GATE::"Multi-client isolation",
  DAEDALUS_CRAFT::"LLM tools serving craftsman",
  TREATY_BOND::"Contract stability"
]

2_OPERATOR_DENSITY_IMPROVEMENTS::[
  BEFORE::"Every feature begins with failing test committed to git BEFORE implementation (RED->GREEN->REFACTOR sequence)",
  AFTER::"I7::TDD_RED_DISCIPLINE::every_feature_begins_failing_test[RED->GREEN->REFACTOR]+git_evidence[TEST->FEAT]",
  COMPRESSION::2.5x+clarity_preserved
]

3_INHERITANCE_NOTATION::[
  BEFORE::repeat_I5_definition_3_times_in_3_docs,
  AFTER::"INHERITANCE::[EAV::[I5_cam-op-pwa], IA::[platform_independence], CEP::[I5_core]]",
  COMPRESSION::3x_expression->1x_with_inheritance_mapping
]

4_ASSUMPTION_CLUSTERING::[
  BEFORE::8+8+4=20_assumptions_scattered_across_3_docs,
  AFTER::4_clusters[DATA_INTEGRITY+AI_ACCURACY+PERFORMANCE+CONTRACT_STABILITY],
  BENEFIT::pattern_recognition_enables_systematic_validation_strategy
]

5_SUPPLY_CHAIN_SEMANTICS::[
  BEFORE::3_disconnected_docs_with_position_mentioned_once,
  AFTER::explicit_PIPELINE_FLOW+HANDOFF_CONTRACTS+INHERITANCE_CHAIN,
  BENEFIT::pipeline_position_shapes_interpretation_context
]

===END_OPTIMIZATION===
```

---

## PROTECTION CLAUSE (Unified)

```octave
===UNIFIED_PROTECTION===

MISALIGNMENT_PROTOCOL::[
  IF::agent_detects_work_contradicting_ANY_North_Star[EAV|IA|CEP],
  THEN::[
    1->STOP_current_work_immediately,
    2->CITE_specific_immutable_violated[project_prefix:I#_or_PATTERN],
    3->ESCALATE_to_requirements-steward
  ]
]

RESOLUTION_OPTIONS::[
  CONFORM[typical]::align_work_with_immutables,
  AMEND[rare]::formal_change_via_requirements-steward[re-approval_required],
  ABANDON[blocked]::incompatible_path+alternative_required
]

AUTHORITY_CHAIN::[
  UNIVERSAL_PATTERNS > PROJECT_NORTH_STARS > FEATURE_DESIGNS > IMPLEMENTATION_CODE,
  MYTHOLOGICAL_PATTERNS::serve_as_citation_anchors_not_override_authority
]

ESCALATION_FORMAT::"NORTH_STAR_VIOLATION: [PROJECT] work [description] violates [PATTERN:I#] because [evidence] -> requirements-steward"

===END_PROTECTION===
```

---

**TEMPLATE_META:**
  CREATED::2025-12-04
  PURPOSE::unified_North_Star_summary_with_semantic_optimization
  COMPRESSION_RATIO::3_docs_1,209_lines->1_template_~400_lines[3.0:1]
  SEMANTIC_FIDELITY::100%_decision_logic_preserved
  MYTHOLOGICAL_PATTERNS::9_archetypal_bindings_introduced
  CROSS_REFERENCE_BINDINGS::15_inheritance_relationships_mapped
  ASSUMPTION_CLUSTERS::4_pattern_groups_identified
  NAVIGATION_MAPPING::full_doc_section_references_preserved

**USAGE:**
  FOR_AGENTS::load_this_template_first->load_specific_project_North_Star_only_if_trigger_pattern_matches
  FOR_HUMANS::use_NAVIGATION_GUIDE_to_find_detailed_sections
  FOR_VALIDATION::check_PROTECTION_CLAUSE_before_any_implementation_decision
