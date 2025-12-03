---
name: documentation-placement
description: Document placement rules for EAV monorepo including .coord/ structure, reports 8xx naming, and phase artifact placement. Enforces timeline test (planning vs implementation docs), documentation-first PR protocol, and naming standards compliance.
allowed-tools: Read, Write, Bash
---

# Documentation Placement (EAV Monorepo)

STANDARD_REFERENCE::"/Volumes/HestAI/docs/standards/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md"

---

## CORE DECISION RULES

```octave
TIMELINE_TEST::[
  BEFORE_CODE_EXISTS→.coord/workflow-docs/,
  DESCRIBES_IMPLEMENTATION→app_specific_docs,
  GUIDES_IMPLEMENTATION→dev/docs/architecture/
]

EAV_STRUCTURE::[
  .coord/::project_coordination[workflow-docs,reports,apps/{app}/,sessions/],
  apps/{app}/::app_implementation_docs,
  packages/shared/::shared_module_docs
]
```

---

## REPORTS GOVERNANCE (8xx NAMING)

```octave
PATTERN::"{SEQ}-REPORT-{CATEGORY}-{NAME}[-{DATE}].md"

SEQUENCE_RANGE::800-899
NEXT_AVAILABLE::see_.coord/reports/README.md

CATEGORIES::[
  AUDIT::[security,RLS,TDD_compliance],
  CI::[pipeline,workflow,best_practices],
  REVIEW::[agent_constitutional_reviews],
  PLAN::[action_plans,roadmaps,issue_drafts],
  ANALYSIS::[app_specific,system_analysis],
  INVESTIGATION::[bug_root_cause,issue_analysis],
  PHASE::[assessments,drift_detection],
  ARCH::[architectural_assessments],
  STRATEGIC::[6_month_trajectory,long_term]
]

EXAMPLES::[
  "855-REPORT-AUDIT-SECURITY-2025-11-26.md",
  "856-REPORT-CI-WORKFLOW-FINAL-PLAN.md",
  "857-REPORT-REVIEW-CRITICAL-ENGINEER-GO-NO-GO.md"
]

FORBIDDEN::[
  version_suffixes[_v2,_final,_draft],
  missing_8xx_prefix,
  missing_REPORT_context,
  lowercase_names
]

ENFORCEMENT::[
  PRE_WRITE::enforce-doc-naming.sh[blocks_non_compliant],
  PRE_COMMIT::.git/hooks/pre-commit[validates_before_commit],
  POST_WRITE::update-doc-registry.sh[updates_sequence_tracker]
]
```

---

## EAV DIRECTORY STRUCTURE

```octave
.coord/::[
  workflow-docs/::phase_artifacts[D1-NORTH-STAR,D2-DESIGN,B0-VALIDATION],
  reports/::analysis_reports[8xx_naming→see_README.md],
  apps/{app}/::app_specific[APP-CONTEXT.md,APP-CHECKLIST.md],
  sessions/::session_notes_and_handoffs,
  DECISIONS.md::architectural_rationale,
  PROJECT-CONTEXT.md::system_dashboard,
  PROJECT-CHECKLIST.md::high_level_tasks
]

apps/{app}/::[
  src/::implementation,
  docs/::app_technical_docs[if_needed]
]

packages/shared/::[
  src/::shared_code,
  docs/::module_documentation
]
```

---

## PHASE ARTIFACT PLACEMENT

```octave
PHASE_DESTINATIONS::[
  D1_NORTH_STAR→.coord/workflow-docs/000-*-D1-NORTH-STAR.md,
  D2_DESIGN→.coord/workflow-docs/,
  D3_BLUEPRINT→.coord/apps/{app}/[then_migrate_at_B1],
  B0_VALIDATION→.coord/workflow-docs/,
  B1_B4_REPORTS→.coord/reports/
]

B1_MIGRATION_GATE::[
  CHECKPOINT::human_approval_required,
  ACTION::move_D3_BLUEPRINT→app_docs/,
  VERIFY::all_planning_artifacts_complete
]
```

---

## DOCUMENTATION-FIRST PR PROTOCOL

```octave
PRINCIPLE::"Documentation = prerequisite for code, not side effect"

SEQUENCE::[
  1::create_docs_PR[docs/feature-X],
  2::merge_docs_first,
  3::create_impl_PR[feat/feature-X]→references_merged_docs,
  4::impl_PR_commit_references_doc_PR_number
]

MERGE_STRATEGY::[
  D3_BLUEPRINT→immediate_before_B0,
  ADRs→immediate_before_implementation,
  API_DOCS→with_or_before_implementation,
  ARCHITECTURE_AS_BUILT→with_implementation
]
```

---

## AGENT BOUNDARIES

```octave
RESPONSIBILITIES::[
  directory-curator::reports_violations_only[never_fixes],
  workspace-architect::fixes_placement+owns_migrations,
  system-steward::documents_patterns+updates_standards,
  holistic-orchestrator::enforces_at_phase_gates,
  hestai-doc-steward::governs_/Volumes/HestAI/docs/
]
```

---

## QUICK REFERENCE

```octave
WHERE_DOES_THIS_GO::[
  planning_doc→.coord/workflow-docs/,
  app_analysis→.coord/reports/[8xx-REPORT-ANALYSIS-*],
  security_audit→.coord/reports/[8xx-REPORT-AUDIT-*],
  agent_review→.coord/reports/agent-reviews/[8xx-REPORT-REVIEW-*],
  CI_report→.coord/reports/ci/[8xx-REPORT-CI-*],
  investigation→.coord/reports/investigations/[8xx-REPORT-INVESTIGATION-*],
  app_context→.coord/apps/{app}/APP-CONTEXT.md,
  session_notes→.coord/sessions/,
  architectural_decision→.coord/DECISIONS.md
]

COMMON_MISTAKES::[
  ❌::dump_files_in_root→use_appropriate_subdir,
  ❌::skip_8xx_prefix→hook_will_block,
  ❌::use_coordination/→EAV_uses_.coord/,
  ❌::version_suffixes→git_handles_versioning,
  ❌::create_without_checking_README→check_next_sequence
]
```

---

## VALIDATION COMMANDS

```bash
# Check next available report sequence
grep "Next available" .coord/reports/README.md

# Validate report naming compliance
find .coord/reports -name "*.md" | xargs -I {} basename {} | grep -v '^[0-9]\{3\}-REPORT-'

# Check for sequence conflicts
find .coord/reports -name "[0-9][0-9][0-9]-*.md" | sed 's|.*/||' | cut -c1-3 | sort | uniq -d
```
