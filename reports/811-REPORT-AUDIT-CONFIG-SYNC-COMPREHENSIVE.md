# Config Sync Comprehensive Audit Report
**Date**: 2025-12-04
**Author**: system-steward
**Scope**: Agents, Commands, Skills across global + 5 projects

---

## EXECUTIVE SUMMARY

This audit identifies divergences between global (`~/.claude/`) and project (`.claude/`) configurations, recommends canonical versions, and proposes reorganization for commands and skills.

**Key Findings:**
- 6 agent divergences identified - all resolved (global is canonical for 5, minor update needed for 1)
- 38 commands analyzed - 7 redundant/obsolete, 8 domain-specific requiring placement decision
- 20 skills audited - 1 empty (delete), 4 missing from global (pull from projects)

---

## SECTION 1: AGENT DIVERGENCE RESOLUTION

### 1.1 test-infrastructure-steward (PROJECT NEWER)

**Difference**: POC reference only
```diff
- EXTRACT_FIRST::"Mine proven patterns from working systems (POC copy-editor)..."
+ EXTRACT_FIRST::"Mine proven patterns from working systems (POC scripts-web)..."
```

**Analysis**: Functionally identical. Projects updated POC reference to `scripts-web` (more current).

**RECOMMENDATION**: `PULL` - Update global with project version (scripts-web is current POC).

---

### 1.2 code-review-specialist (GLOBAL NEWER)

**Difference**: +51 lines - CONFIDENCE_CATEGORIZATION section

**New Section Purpose**: Forces explicit categorization (CERTAIN/HIGH/MODERATE/SPECULATIVE) before reporting issues. Anti-validation-theater gate.

**Key Addition**:
```octave
CONFIDENCE_CATEGORIES::[
  CERTAIN::["Can point to exact failure mode with concrete evidence"],
  HIGH::["Strong evidence with minimal doubt"],
  MODERATE::["Likely issue but could be wrong based on context"],
  SPECULATIVE::["Worth noting but might be false positive"]
]
REPORTING_THRESHOLD::CERTAIN+HIGH_only
```

**RECOMMENDATION**: `GLOBAL IS CANONICAL` - Push to all projects.

---

### 1.3 design-architect (GLOBAL NEWER)

**Difference**: +31 lines - DESIGN_DECISION_GATE section

**New Section Purpose**: Explicit pause protocol to resolve architectural ambiguities before blueprinting.

**Key Addition**:
```octave
GATE_POSITION::after_BREAKTHROUGH_CONCEPT_RECEIVED→before_BLUEPRINT_CREATION
GATE_PROTOCOL::[
  1::ANALYZE, 2::IDENTIFY_DECISIONS, 3::PRESENT_OPTIONS,
  4::GET_EXPLICIT_CHOICE, 5::DOCUMENT
]
```

**RECOMMENDATION**: `GLOBAL IS CANONICAL` - Push to all projects.

---

### 1.4 holistic-orchestrator (GLOBAL NEWER)

**Difference**: +3 lines in NEVER section

**New Constraints**:
```octave
"Direct implementation after diagnosis - STOP, hand off to implementation-lead..."
"Edit/Write/NotebookEdit on production code without implementation-lead ownership..."
"Diagnosis→implementation without explicit handoff acceptance..."
```

**RECOMMENDATION**: `GLOBAL IS CANONICAL` - Push to all projects.

---

### 1.5 implementation-lead (GLOBAL NEWER)

**Difference**: +37 lines - IMPLEMENTATION_CLARIFICATION_GATE section

**New Section Purpose**: Explicit pause when build plan has ambiguous tasks.

**Key Addition**:
```octave
GATE_CONDITION::"Apply this gate when ANY of the following are unclear..."
AMBIGUITY_DETECTION::[
  PRIORITY_CONFLICTS, DEPENDENCY_CHOICES, INTEGRATION_UNCLEAR,
  TEST_STRATEGY_GAPS, SCOPE_BOUNDARIES
]
```

**RECOMMENDATION**: `GLOBAL IS CANONICAL` - Push to all projects.

---

### 1.6 system-steward (GLOBAL NEWER)

**Difference**: +24 lines across 3 additions

**New Additions**:
1. `INFRASTRUCTURE_AUTHORITY` section (explicit authority boundaries)
2. Updated `QUALITY_GATES` (APPLICATION_CODE_MODIFICATION vs OPERATIONAL_FILE_MODIFICATION)
3. `ECOSYSTEM_STEWARDSHIP` section (Claude Code infrastructure maintenance)

**RECOMMENDATION**: `GLOBAL IS CANONICAL` - Push to all projects.

---

## SECTION 2: COMMANDS AUDIT

### 2.1 Current State: 38 Commands in Global

### 2.2 Category Analysis

#### CATEGORY A: CORE WORKFLOW (Keep Global, Push to Projects)
| Command | Purpose | Status |
|---------|---------|--------|
| `role.md` | Agent activation with RAPH | ✅ Active |
| `traced.md` | Orchestration TRACED | ✅ Active |
| `traced-self.md` | Implementation TRACED | ✅ Active |
| `error.md` | Error resolution pipeline | ✅ Active |
| `workflow.md` | Workflow North Star | ✅ Active |
| `get-context.md` | Context loading | ✅ Active |
| `qg.md` | Quality gates | ✅ Active |

#### CATEGORY B: BUILD/DEPLOY LIFECYCLE (Keep Global, Push to Projects)
| Command | Purpose | Status |
|---------|---------|--------|
| `BUILD.md` | Build discipline engine | ✅ Active |
| `design.md` | D0-D3 design phases | ✅ Active |
| `deploy.md` | B4 deployment | ✅ Active |
| `prepare.md` | Session preparation | ✅ Active |
| `enhance.md` | Enhancement protocol | ✅ Active |
| `fix.md` | Fix orchestration | ✅ Active |
| `fix-self.md` | Fix implementation | ✅ Active |

#### CATEGORY C: PROJECT SETUP (Keep Global, Push to Projects)
| Command | Purpose | Status |
|---------|---------|--------|
| `project-setup.md` | EAV project setup | ✅ Active |
| `north-star.md` | North Star creation | ✅ Active |
| `config-sync.md` | Config synchronization | ✅ Active |
| `sync-coord.md` | Coordination sync | ✅ Active |
| `audit.md` | Requirements audit | ✅ Active |

#### CATEGORY D: MEMORY/CONTEXT (Keep Global Only)
| Command | Purpose | Status |
|---------|---------|--------|
| `claude-mem.md` | Memory operations | ✅ Active |
| `save.md` | Save to memory | ✅ Active |
| `remember.md` | Recall context | ✅ Active |
| `load.md` | Combined role+context load | ✅ Active |

#### CATEGORY E: REDUNDANT/OBSOLETE (DELETE)
| Command | Reason | Action |
|---------|--------|--------|
| `role-raph-enforced.md` | RAPH is now default in role.md | 🗑️ DELETE |
| `role-refresh.md` | Superseded by role.md enhancements | 🗑️ DELETE |
| `SYNC-COORD (from backup).md` | Backup file with invalid filename | 🗑️ DELETE |
| `README-PLANNING-TEMPLATE.md` | Misplaced (should be docs/) | 🗑️ MOVE/DELETE |
| `raph-context-protocol.md` | Superseded by role.md RAPH | 🗑️ EVALUATE |
| `_archive/TRACED.oct.md` | Already archived | ✅ Keep archived |
| `_archive/p.r.e.p.a.r.e-old.md` | Already archived | ✅ Keep archived |

#### CATEGORY F: DOMAIN-SPECIFIC (Placement Decision Required)
| Command | Domain | Recommendation |
|---------|--------|----------------|
| `batch.md` | EAV SmartSuite operations | 📦 MOVE to EAV projects only |
| `eav-context.md` | EAV multi-app context | 📦 MOVE to EAV projects only |
| `new-raindrop-app.md` | Raindrop-specific | 📦 MOVE to Raindrop projects only |
| `reattach-raindrop-session.md` | Raindrop-specific | 📦 MOVE to Raindrop projects only |
| `dual-il.md` | Experimental pattern | ⏸️ EVALUATE - may be superseded |
| `authorize-north-star-change.md` | North star governance | ✅ Keep global |
| `universal-north-star-check.md` | North star validation | ✅ Keep global |
| `create-planning-template.md` | Template creation | ✅ Keep global |

### 2.3 Command Reorganization Recommendations

**DELETE (5 files):**
```bash
rm ~/.claude/commands/role-raph-enforced.md
rm ~/.claude/commands/role-refresh.md
rm ~/.claude/commands/"SYNC-COORD (from backup).md"
rm ~/.claude/commands/README-PLANNING-TEMPLATE.md
rm ~/.claude/commands/raph-context-protocol.md
```

**MOVE TO EAV PROJECTS ONLY (2 files):**
```bash
# Remove from global, keep in EAV projects
mv ~/.claude/commands/batch.md /tmp/eav-only/
mv ~/.claude/commands/eav-context.md /tmp/eav-only/
```

**MOVE TO RAINDROP PROJECTS ONLY (2 files):**
```bash
# Remove from global if not used system-wide
mv ~/.claude/commands/new-raindrop-app.md /tmp/raindrop-only/
mv ~/.claude/commands/reattach-raindrop-session.md /tmp/raindrop-only/
```

---

## SECTION 3: SKILLS AUDIT

### 3.1 Current State

| Location | Count | Status |
|----------|-------|--------|
| Global | 20 | 1 empty (link-fixing) |
| HestAI | 20 | Missing holistic-orchestrator-mode, sync-coord |
| EAV-monorepo | 22 | Has github-issue-creation (unique) |

### 3.2 Skills Inventory

#### GLOBAL SKILLS (19 valid + 1 empty)
```
agent-creation          build-execution         ci-error-resolution
code-extraction         documentation-placement error-triage
extraction-execution    holistic-orchestrator-mode* link-fixing (EMPTY)
octave-compression      smartsuite-patterns     subagent-rules
supabase-operations     supabase-test-harness   sync-coord*
task-decomposition      test-ci-pipeline        test-infrastructure
workflow-phases         workspace-setup
```
*Not in all projects

#### SKILLS IN PROJECTS BUT NOT GLOBAL
```
api-security            (HestAI, EAV-monorepo)
git-workflow            (HestAI, EAV-monorepo)
python-best-practices   (HestAI, EAV-monorepo)
skill-developer         (HestAI, EAV-monorepo)
github-issue-creation   (EAV-monorepo only)
```

### 3.3 Skills Recommendations

**DELETE (Empty skill):**
```bash
rm -rf ~/.claude/skills/link-fixing/
```

**PULL TO GLOBAL (From projects):**
```bash
cp -r /Volumes/HestAI/.claude/skills/api-security ~/.claude/skills/
cp -r /Volumes/HestAI/.claude/skills/git-workflow ~/.claude/skills/
cp -r /Volumes/HestAI/.claude/skills/python-best-practices ~/.claude/skills/
cp -r /Volumes/HestAI/.claude/skills/skill-developer ~/.claude/skills/
```

**PUSH TO PROJECTS (From global):**
- holistic-orchestrator-mode → all projects
- sync-coord → all projects

---

## SECTION 4: PLACEMENT STRATEGY

### 4.1 Principle: Global vs Project-Specific

```octave
GLOBAL::[
  CRITERIA::[universal_applicability, framework_agnostic, workflow_essential],
  EXAMPLES::[role, traced, error, workflow, BUILD, qg, config-sync]
]

PROJECT_SPECIFIC::[
  CRITERIA::[domain_dependent, project_context_required, platform_specific],
  EXAMPLES::[batch(EAV), eav-context(EAV), new-raindrop-app(Raindrop)]
]

RULE::"When in doubt, start in global. Move to project if context-dependent."
```

### 4.2 Sync Strategy

```bash
# Recommended sync flow:
1. Pull test-infrastructure-steward (project→global)
2. Pull 4 skills from projects (api-security, git-workflow, python-best-practices, skill-developer)
3. Delete obsolete commands (5 files)
4. Delete empty skill (link-fixing)
5. Push all agents to projects (/config-sync push all)
6. Push updated skills to projects
7. Move domain-specific commands out of global
```

---

## SECTION 5: ACTION ITEMS

### 5.1 Immediate Actions (Before Push)

| # | Action | Priority |
|---|--------|----------|
| 1 | PULL test-infrastructure-steward to global | HIGH |
| 2 | PULL 4 skills to global | HIGH |
| 3 | DELETE 5 obsolete commands | HIGH |
| 4 | DELETE empty link-fixing skill | HIGH |
| 5 | Review dual-il.md relevance | MEDIUM |

### 5.2 Sync Execution

```bash
# After completing 5.1:
/config-sync push all
```

### 5.3 Post-Sync Validation

```bash
# Verify all projects have:
# - 61 agents (all current)
# - Updated skills (23-24)
# - Core commands (30-32)
```

---

## APPENDIX A: Command Gap Analysis (Projects Missing 32 Commands)

Projects currently have only 6 commands vs 38 global. After cleanup, global will have ~30 commands.

**Commands to Push to All Projects:**
1. role.md, traced.md, traced-self.md, error.md
2. workflow.md, get-context.md, qg.md
3. BUILD.md, design.md, deploy.md
4. prepare.md, enhance.md, fix.md, fix-self.md
5. project-setup.md, north-star.md, config-sync.md
6. sync-coord.md, audit.md, load.md
7. authorize-north-star-change.md, universal-north-star-check.md
8. create-planning-template.md, gitissue.md

**Commands to Keep Global Only (memory):**
- claude-mem.md, save.md, remember.md

---

## APPENDIX B: /config-sync Command Enhancements

The config-sync command should be updated to:

1. **Exclude domain-specific commands** from push-all:
   - batch.md, eav-context.md (EAV only)
   - new-raindrop-app.md, reattach-raindrop-session.md (Raindrop only)

2. **Include skills in sync** (currently may be agents-only)

3. **Add validation step** to confirm file counts after sync

---

*Report generated by system-steward via RAPH constitutional activation*
