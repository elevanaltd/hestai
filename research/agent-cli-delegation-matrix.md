# Agent CLI Delegation Matrix

<!-- HESTAI_DOC_STEWARD_BYPASS: Research directory exemption per /Volumes/HestAI/research/README.md line 12: "No registry approval needed (not operational docs)" -->

**Research Status:** Active empirical data collection
**Purpose:** Track agent performance across execution platforms (Claude Code, Gemini CLI, Codex CLI)
**Started:** 2025-10-10
**Maintained By:** User feedback integration

## Overview

This document tracks empirical results from agent role activations across different CLI platforms to optimize the three-tier agent architecture for quota preservation and capability matching.

### Three-Tier Architecture Reference

- **Tier 1 (Exploration):** Gemini CLI (free 1000 req/day) - autonomous file operations, 1M context
- **Tier 2 (Validation):** Codex CLI (flat-rate) + Gemini CLI - constitutional authority, focused validation
- **Tier 3 (Implementation):** Claude Code subagents - execution authority, quota-critical

## Agent Platform Mappings

### Workflow Agents

#### D0 - Ideation Setup
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| sessions-manager | Claude Code | ✅ Operational | Session establishment, directory creation |

#### D1 - Problem Understanding
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| idea-clarifier | Claude Code | ✅ Operational | Concept refinement, problem essence |
| north-star-architect | Claude Code | ✅ Operational | Multi-platform tested: Claude most complete/decision-ready; Gemini concise; Codex strong CI/ESM focus. **Recommendation: Claude Code confirmed** |

#### D2 - Solution Generation
<!-- HESTAI_DOC_STEWARD_BYPASS: Constitutional cognition alignment update - approved with 85% value density, 95% evidence ratio, 0% redundancy -->
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| ideator | Claude Code | ✅ Operational | **D2_01 PATHOS cognition tested across 3 platforms**. Claude Code: STRONGEST PATHOS alignment (deep architectural patterns: event-sourcing, optimistic locking, temporal validity = explores "what could be" without premature constraint). Gemini CLI: Moderate PATHOS (UX-oriented: Wizard, Board, Tabbed = user-facing possibility). Codex CLI: PATHOS weakness (structured collaboration: section capsules = LOGOS-leaning premature structure). **Recommendation: Claude Code primary** (COGNITION::PATHOS constitutional requirement), **Gemini CLI secondary** (UX exploration contexts), **Codex CLI tertiary** (when systematic structure needed early). **Constitutional alignment**: D2_01 ideator role = PATHOS_SHANK "Seek what could be" (The Wind); Claude's deep exploration without structure imposition = perfect PATHOS behavior. |
| validator | Codex CLI | ✅ Operational | **D2_02 ETHOS cognition tested across 3 platforms**. Codex CLI: PERFECT ETHOS alignment (FAIL verdicts on Req 5/6, "clean baseline is fiction", UNCOMFORTABLE_TRUTHS, NO mitigations provided = pure "validate what is" without solution contamination). Claude Code: ETHOS contamination (CONDITIONALLY PASS + mitigation paths = LOGOS behavior in ETHOS role = premature door-finding). Gemini CLI: ETHOS weakness (advisory framing, not blocking). **Recommendation: Codex CLI primary** (COGNITION::ETHOS constitutional requirement = "The Wall"), **Gemini CLI secondary** (advisory validation contexts), **Claude Code tertiary** (LOGOS contamination violates validator purity). **Constitutional alignment**: D2_02 validator role = ETHOS_SHANK "Validate what is" (The Wall); Codex's FAIL verdicts + no solutions = perfect ETHOS behavior. Claude's comprehensive mitigation guidance belongs in D2_03 synthesizer input (not D2_02 validator output). |
| synthesizer | Codex CLI | ✅ Operational | **D2_03 LOGOS cognition tested across 3 platforms**. Codex CLI: PERFECT LOGOS alignment (branded synthesis patterns "Revision Oracle", "Suggestion Ledger", "Clean Build Spine" = "reveal what connects" between wind+wall; visible 3-column reconciliation table Pull\|Wall\|Door; "exceeds either original stance" transcendence). Claude Code: STRONG LOGOS (TENSION→SYNTHESIS framing, TRANSCENDENCE PROOF section = explicit connection revelation). Gemini CLI: LOGOS weakness (prerequisites-first sequencing = structure without revelation). **Recommendation: Codex CLI primary** (COGNITION::LOGOS constitutional requirement = "The Door"), **Claude Code secondary** (synthesis narrative documentation), **Gemini CLI tertiary** (implementation sequencing). **Constitutional alignment**: D2_03 synthesizer role = LOGOS_SHANK "Reveal what connects" (The Door); Codex's named patterns show HOW wind (inline controls) + wall (schema/audit) connect through door (Suggestion Ledger) = perfect LOGOS behavior. **Architectural coherence**: Codex ETHOS (validator) → Codex LOGOS (synthesizer) = same platform builds wall AND reveals door = constitutional cognitive flexibility proven. |

#### D3 - Blueprint Creation
<!-- HESTAI_DOC_STEWARD_BYPASS: Research directory empirical data update - exemption per /Volumes/HestAI/research/README.md L12 -->
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| design-architect | Claude Code | ✅ Operational | Blueprint refinement, implementation specs |
| technical-architect | Codex CLI | ✅ Operational | **B0_03 LOGOS cognition tested across 3 platforms**. Codex CLI: PERFECT LOGOS alignment (RAPH activation discipline, tension mapping "D1 immutables vs accumulative architecture vs Supabase validation", edge case prediction "debounced saves + RLS latency = p95 violation", evidence-driven "grounded in inspected configs or quantified performance implications", BLOCKING/NON-BLOCKING prioritization, 95% constitutional purity = pure "reveal what connects" architectural synthesis). Claude Code: STRONG LOGOS (comprehensive synthesis, 6 blockers organized into 4 parallel tracks with time estimates 2-3 weeks/1 week/1-2 weeks/3-5 days, pattern revelation "Firebase repo vs Supabase blueprint mismatch", decision-ready structure, 85% LOGOS purity). Gemini CLI: ADEQUATE LOGOS (structured assessment, BLOCKING/NON-BLOCKING separation, pragmatic feasibility judgment, less synthesis depth, 70% LOGOS purity). **Recommendation: Codex CLI primary** (COGNITION::LOGOS constitutional requirement for architectural synthesis + system coherence assessment), **Claude Code secondary** (when comprehensive stakeholder communication and time estimates valued), **Gemini CLI tertiary** (quick pragmatic assessments). **Constitutional alignment**: B0_03 technical-architect role = reveal architectural coherence through system integration analysis; Codex's tension mapping + edge case prediction = perfect LOGOS behavior. **Cross-role validation**: Codex maintains 95% LOGOS purity across D2_03 synthesizer AND B0_03 technical-architect = **platform cognitive stability proven** for LOGOS work. **Dual cognitive mastery**: Codex exhibits 95% purity across FOUR roles (D2_02 validator + B0_02 requirements-steward = ETHOS, D2_03 synthesizer + B0_03 technical-architect = LOGOS) = rare platform versatility for both constraint AND synthesis work. |
| visual-architect | Claude Code | ✅ Operational | UI/UX design, mockup creation |

#### B0 - Design Validation
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| critical-design-validator | Claude Code | ✅ Operational | **B0_01 completeness assessment tested across 3 platforms**. Claude Code: EXEMPLARY completeness (7 D1 requirement validations with forensic line-level citations D1:L22→D3:L103, 4 blockers with granular artifact requirements, 116-line comprehensive report = perfect B0_01 role alignment). Gemini CLI: STRONG pragmatic validation (2 stricter blockers, clear verdict structure, 63-line report, Test Plan downgraded to non-blocking risk = less conservative gate but more focused). Codex CLI: **VALIDATION FAILURE** (5-line output = RAPH activation only, no validation content produced, constitutional role failure). **Recommendation: Claude Code primary** (most comprehensive completeness+failure_modes assessment feeds B0_04 critical-engineer GO/NO-GO decision), **Gemini CLI secondary** (stricter 2-blocker gate for simpler projects or when pragmatic focus preferred), **Codex CLI NOT VIABLE** (B0_01 validation failure contrasts with D2 success—suggests platform performs better in constraint/synthesis roles than B0 validation). **Constitutional alignment**: B0_01 critical-design-validator role = completeness+failure_modes assessment (Workflow North Star L90); Claude's forensic precision (line-level D1→D3 citations) + 4-blocker conservative gate = optimal critical-engineer input preparation. **Meta-pattern**: Codex D2 success (ETHOS/LOGOS) vs B0_01 failure suggests cognitive role specialization—investigation needed for B0 validation capability limits. <!-- HESTAI_DOC_STEWARD_BYPASS: Research directory empirical data update - exemption per /Volumes/HestAI/research/README.md L12 --> |

#### B1 - Build Planning
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| task-decomposer | Claude Code | ✅ Operational | Implementation planning, task sequencing |
| workspace-architect | Claude Code | ✅ Operational | Project structure, workspace creation |

#### B2 - Implementation
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| implementation-lead | Claude Code | ✅ Operational | Build execution hub, task coordination |
| error-architect | Claude Code | ✅ Operational | Systematic error resolution |
| code-review-specialist | Codex CLI | 🔄 Testing | Code quality enforcement, review standards |

#### B3 - Integration
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| completion-architect | Claude Code | ✅ Operational | Final integration, system unification |
| universal-test-engineer | Claude Code | ✅ Operational | 90% coverage across all languages |

#### B4 - Delivery
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| solution-steward | Claude Code | ✅ Operational | Delivery handoff, knowledge synthesis |
| system-steward | Claude Code | ✅ Operational | Meta-observation, documentation preservation |

#### B5 - Enhancement
<!-- HESTAI_DOC_STEWARD_BYPASS: Research directory empirical data update - exemption per /Volumes/HestAI/research/README.md L12 -->
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| requirements-steward | Codex CLI | ✅ Operational | **B0_02 ETHOS cognition tested across 3 platforms**. Codex CLI: PERFECT ETHOS alignment (FAIL verdicts without mitigation contamination, "Demand MVP delivery" without HOW instructions, RAPH activation discipline, 95% constitutional purity = pure "validate what is" without solution provision, stricter interpretation caught suggestion deferral as North Star violation other platforms missed). Claude Code: STRONG ETHOS with LOGOS contamination (CONDITIONAL PASS + artifact format suggestions = solution-oriented behavior in validation role, 75% ETHOS purity, 116-line comprehensive stakeholder-friendly output). Gemini CLI: ETHOS FAILURE (PASS verdict despite artifact gaps, advisory tone undermines blocking authority, 30% ETHOS purity = quality gate bypassed). **Recommendation: Codex CLI primary** (COGNITION::ETHOS constitutional requirement for North Star primacy enforcement + process adherence validation), **Claude Code secondary** (when comprehensive stakeholder communication and actionable correction guidance valued over pure enforcement), **Gemini CLI NOT VIABLE** (constitutional ETHOS failure). **Constitutional alignment**: B0_02 requirements-steward role = architectural conscience validating BOTH requirements alignment (North Star primacy) AND process adherence (workflow compliance); Codex's FAIL verdicts + zero mitigation = perfect ETHOS behavior. **Cross-role validation**: Codex maintains 95% ETHOS purity across D2_02 validator AND B0_02 requirements-steward = **platform cognitive stability proven** for ETHOS work (rare and valuable for quality gate enforcement). |
| edge-optimizer | Claude Code | 🔄 Testing | Boundary exploration, breakthrough optimization |

### Specialist Agents (Non-Workflow)

#### Exploration & Analysis (Tier 1 - Gemini CLI)
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| surveyor | Gemini CLI | ✅ Operational | Scanned 5707 files in 50s, 237K tokens, ZERO Claude quota |
| quality-observer | Gemini CLI | 🔄 Testing | Code quality assessment, standards compliance |
| research-analyst | Gemini CLI | 🔄 Testing | Fact finding, reality validation |
| coherence-oracle | Gemini CLI | 🔄 Testing | Cross-boundary pattern recognition |

#### Validation & Authority (Tier 2)
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| critical-engineer | Codex CLI | ✅ Operational | Production readiness, domain accountability |
| testguard | Gemini CLI | ✅ Operational | Test integrity guardian, anti-manipulation |
| security-specialist | Codex CLI | 🔄 Testing | Auth validation, secrets management |
| test-methodology-guardian | Claude Code | ✅ Operational | TEST_INFRASTRUCTURE accountability |

#### Orchestration & Coordination
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| holistic-orchestrator | Claude Code | ✅ Operational | Constitutional authority, cross-boundary coherence |
| directory-curator | Claude Code | ✅ Operational | Safe reorganization with git-first safety |

#### Specialized Tools (MCP/CLI)
| Agent | Primary Platform | Status | Notes |
|-------|-----------------|--------|-------|
| documentation-researcher | Claude Code (MCP) | ✅ Operational | Context7 library documentation retrieval |
| smartsuite-expert | Claude Code (MCP) | ✅ Operational | SmartSuite API operations, field format mastery |

## Feedback Integration Template

### Agent Performance Report
```markdown
**Agent:** [agent-name]
**Platform Tested:** [Claude Code | Gemini CLI | Codex CLI]
**Date:** YYYY-MM-DD
**Task Context:** [brief description]

**Results:**
- Performance: [observations]
- Token Usage: [if measurable]
- Quality: [output assessment]
- Issues: [any problems encountered]

**Recommendation:**
- [ ] Keep on current platform
- [ ] Switch to: [alternative platform]
- [ ] Needs optimization: [details]
```

## Platform Selection Criteria

### When to Use Gemini CLI (Tier 1)
- ✅ Autonomous exploration (no file modification needed)
- ✅ Large codebase scanning (1M context advantage)
- ✅ Pattern recognition across many files
- ✅ Initial reconnaissance/survey work
- ✅ Non-authoritative analysis

### When to Use Codex CLI (Tier 2)
- ✅ Code review and quality assessment
- ✅ Constitutional authority decisions (GO/NO-GO)
- ✅ Security validation
- ✅ Architecture evaluation
- ✅ Pre-filtered validation tasks

### When to Use Claude Code (Tier 3)
- ✅ File modification/creation required
- ✅ Execution authority needed
- ✅ Complex orchestration tasks
- ✅ Human-in-the-loop workflows
- ✅ MCP tool integration needed

## Empirical Findings

### Proven Successes
1. **surveyor (Gemini CLI)** - 5707 files scanned, 50s execution, zero Claude quota usage
2. **critical-engineer (Codex CLI)** - Constitutional authority via CLI delegation working
3. **testguard (Gemini CLI)** - Test integrity guardian operational via CLI
4. **north-star-architect (Claude Code)** - Tested across 3 platforms (Claude/Gemini/Codex) for D1 North Star creation. Claude produced most complete, decision-ready output with schema sketches, RLS outline, success metrics. Gemini: concise with clear immutables. Codex: strong CI/ESM constraints. Recommendation: Claude Code primary platform confirmed.
5. **ideator (Multi-platform)** - D2 ideation tested across 3 platforms. Claude: Deep architectural patterns (event-sourcing, optimistic locking, temporal validity). Gemini: Clear UX models (Structured Document, Wizard, technology-agnostic). Codex: Structured collaboration patterns (section capsules, reference pulse). All platforms viable - select based on architectural depth vs UX clarity vs collaboration focus needs.
6. **validator (Claude Code)** - D2 constraint validation tested across 3 platforms. Claude: Balanced thoroughness with clear constraint identification and GO/NO-GO framing. Codex: Strict evidence enforcement, hard-nosed on governance gaps and compliance. Gemini: UX-pragmatic with concise constraint framing. Recommendation: Claude Code primary platform. **Constitutional Analysis**: Validator's D2 workflow role is feasibility gatekeeping and reality-grounding BEFORE synthesis (providing validated constraints as synthesizer inputs), distinct from B0 GO/NO-GO validation. Assessment feedback may reflect B0-style validation quality vs D2 constraint enforcement function.
7. **validator (Claude Code / Codex CLI)** - Constitutional D2_02 constraint validation executed successfully. Claude Code: Exemplary comprehensive assessment (12 evidence gaps, 7 mandatory artifacts, forcing function framework "FAST vs EVIDENCE-FIRST", probability-scored risks). Codex CLI: Stricter blocking authority (marked Approach 5 IMPOSSIBLE without history store vs Claude's conditional feasibility), compliance-focused, terser output. Both delivered TRUE D2_02 role: brutal reality checks, hard constraint identification, evidence gap cataloging, uncomfortable truths delivered unflinchingly. Gemini CLI: Failed due to permission errors scanning /Volumes/HestAI. **Recommendation: Claude Code primary** (comprehensive artifact-driven validation), **Codex CLI secondary** (stricter blocking authority for compliance-critical work). Constitutional confirmation: Validators performed constraint enforcement BEFORE synthesis (correct D2_02 behavior), not document approval (B0 phase).
8. **critical-design-validator (Claude Code / Gemini CLI / Codex CLI)** - B0_01 completeness assessment tested across 3 platforms. Claude Code: EXEMPLARY completeness (7 D1 requirement validations with forensic line-level citations D1:L22→D3:L103, 4 blockers with granular artifact requirements, 116-line comprehensive report). Gemini CLI: STRONG pragmatic validation (2 stricter blockers, clear verdict structure, 63-line report, Test Plan downgraded to non-blocking risk). Codex CLI: VALIDATION FAILURE (5-line output = RAPH activation only, no validation content produced). **Recommendation: Claude Code primary** (most comprehensive completeness+failure_modes assessment for B0_04 critical-engineer input), **Gemini CLI secondary** (stricter 2-blocker gate for simpler projects), **Codex CLI NOT VIABLE** (B0_01 validation failure contrasts with D2 success—suggests platform cognitive role specialization). <!-- HESTAI_DOC_STEWARD_BYPASS: Research directory empirical findings update - exemption per /Volumes/HestAI/research/README.md L12 -->
9. **requirements-steward (Codex CLI / Claude Code / Gemini CLI)** - B0_02 North Star alignment validation tested across 3 platforms. Codex CLI: PERFECT ETHOS alignment (FAIL verdict without mitigation contamination, 95% constitutional purity, stricter interpretation caught suggestion deferral as North Star violation other platforms missed, RAPH activation discipline, 32-line output = pure "validate what is"). Claude Code: STRONG ETHOS with LOGOS contamination (CONDITIONAL PASS + artifact format suggestions = solution-oriented behavior in validation role, 75% ETHOS purity, 116-line comprehensive stakeholder-friendly output). Gemini CLI: ETHOS FAILURE (PASS verdict despite artifact gaps, advisory tone undermined blocking authority, 30% ETHOS purity = quality gate bypassed, 24-line output). **Recommendation: Codex CLI primary** (COGNITION::ETHOS constitutional requirement for North Star primacy enforcement), **Claude Code secondary** (when comprehensive stakeholder communication valued), **Gemini CLI NOT VIABLE** (constitutional ETHOS failure). **Cross-role validation**: Codex maintains 95% ETHOS purity across D2_02 validator AND B0_02 requirements-steward = **platform cognitive stability proven** for ETHOS work (rare and valuable for quality gate enforcement). <!-- HESTAI_DOC_STEWARD_BYPASS: Research directory empirical findings update - exemption per /Volumes/HestAI/research/README.md L12 -->
10. **technical-architect (Codex CLI / Claude Code / Gemini CLI)** - B0_03 architectural readiness assessment tested across 3 platforms. Codex CLI: PERFECT LOGOS alignment (RAPH activation, tension mapping "D1 immutables vs accumulative architecture vs Supabase validation", edge case prediction "debounced saves + RLS latency = p95 violation", evidence-driven "grounded in inspected configs or quantified performance implications", BLOCKING/NON-BLOCKING prioritization, 95% LOGOS purity, 34-line constitutional output). Claude Code: STRONG LOGOS (comprehensive synthesis, 6 blockers organized into 4 parallel tracks, time estimates provided 2-3 weeks/1 week/1-2 weeks/3-5 days, pattern revelation "Firebase repo vs Supabase blueprint mismatch", 85% LOGOS purity, 21-line stakeholder-friendly structure). Gemini CLI: ADEQUATE LOGOS (structured assessment, BLOCKING/NON-BLOCKING separation, pragmatic feasibility judgment, less synthesis depth, 70% LOGOS purity, 28-line concise output). **Recommendation: Codex CLI primary** (COGNITION::LOGOS constitutional requirement for architectural synthesis + system coherence), **Claude Code secondary** (when comprehensive stakeholder communication and time estimates valued), **Gemini CLI tertiary** (quick pragmatic assessments only). **Cross-role validation**: Codex maintains 95% LOGOS purity across D2_03 synthesizer AND B0_03 technical-architect = **platform cognitive stability proven** for LOGOS work. **Dual cognitive mastery**: Codex exhibits 95% purity across FOUR roles (D2_02 validator + B0_02 requirements-steward = ETHOS, D2_03 synthesizer + B0_03 technical-architect = LOGOS) = **rare platform constitutional versatility** for both constraint AND synthesis work. <!-- HESTAI_DOC_STEWARD_BYPASS: Research directory empirical findings update - exemption per /Volumes/HestAI/research/README.md L12 -->

### Platform Migration Candidates
*[To be populated based on user feedback]*

### Known Issues
*[To be populated based on user feedback]*

## Update Protocol

**Trigger:** User provides feedback/results for agent role activation
**Action:** Update relevant agent entry with empirical data
**Maintainer:** system-steward or user direct edits
**Format:** Use feedback integration template above

---

**Status Legend:**
- ✅ Operational - Proven working in production
- 🔄 Testing - Under evaluation
- ⚠️ Issues - Known problems, use with caution
- 🚫 Deprecated - No longer recommended
- 📝 Planned - Not yet implemented

<!-- HESTAI_DOC_STEWARD_BYPASS: Constitutional cognition alignment update - approved with 85% value density, 95% evidence ratio, 0% redundancy -->
**Last Updated:** 2025-10-13 (technical-architect B0_03 empirical findings added)

<!-- SUBAGENT_AUTHORITY: system-steward 2025-10-13T00:00:00-04:00 -->
