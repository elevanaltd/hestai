# SessionStart Hook - North Star Summary Auto-Loading

**Status:** Production Ready
**Issue:** [#7](https://github.com/elevanaltd/hestai/issues/7)
**Purpose:** Optimize token usage by loading compressed North Star Summaries at startup instead of full documents

---

## Overview

The SessionStart hook automatically detects and loads North Star Summary documents when starting a Claude Code session in a project with coordination structure. This addresses Issue #7's requirement to reduce startup token usage from ~3k to ~500 tokens while maintaining 100% decision-logic fidelity.

### Benefits

- **Token Savings:** ~2-2.5k tokens saved at startup (67-83% reduction)
- **Zero Overhead:** Only loads when coordination exists
- **Lazy Loading Triggers:** Full document loaded only when needed
- **Silent Fallback:** No errors if summary doesn't exist

---

## How It Works

### Discovery Process

```
Session Start
    ↓
Check for .coord symlink
    ↓ (exists)
Look for .coord/workflow-docs/*NORTH-STAR-SUMMARY*.md
    ↓ (found)
Load and display summary
    ↓
Session begins with North Star context
```

### Files

- **SessionStart.ts** - TypeScript implementation with discovery logic
- **SessionStart.sh** - Shell wrapper for execution
- **SessionStart-README.md** - This documentation

---

## Setup

### Prerequisites

The hook requires:

1. **TypeScript environment** (already configured in `.claude/hooks/`)
2. **Project coordination structure** (`.coord` symlink)
3. **North Star Summary document** (created via `/ns-summary-create`)

### Installation

The hook is already installed and executable. No additional setup needed.

To verify:

```bash
ls -la ~/.claude/hooks/SessionStart.*
```

Expected output:
```
-rwxr-xr-x  SessionStart.sh
-rw-r--r--  SessionStart.ts
```

---

## Creating North Star Summaries

### Method 1: Use the Command (Recommended)

```bash
/ns-summary-create {project_name}
```

This command (defined in `.claude/commands/ns-summary-create.md`) follows the compression methodology:

1. **Read full North Star** from `.coord/workflow-docs/`
2. **Extract immutables, assumptions, gates** with line citations
3. **Apply compression rules** (3:1 to 6:1 ratio)
4. **Validate fidelity** (100% decision logic preserved)
5. **Output summary** to `.coord/workflow-docs/000-{PROJECT}-NORTH-STAR-SUMMARY.oct.md`

### Method 2: Manual Creation

If you need to create a summary manually:

1. Read the full North Star document
2. Follow the compression rules in `/ns-summary-create` command
3. Save to: `.coord/workflow-docs/000-{PROJECT}-NORTH-STAR-SUMMARY.oct.md`

### Compression Targets

Based on the methodology:

- **EAV Monorepo:** 301 lines → ~105 lines (2.9:1)
- **Ingest Assistant:** 380 lines → ~95 lines (4:1)
- **CEP Panel:** 528 lines → ~79 lines (6.7:1)

---

## Summary Format

A North Star Summary must contain:

### Required Sections

```octave
# {PROJECT_NAME} - North Star Summary

**AUTHORITY**: D1 Phase Deliverable
**APPROVAL**: ✅ or ⚠️
**FULL_DOCUMENT**: [link]
**VERSION**: 1.0-OCTAVE-SUMMARY

---

## IMMUTABLES ({N} Total)

[Each immutable with PRINCIPLE + WHY + STATUS]

I1::TITLE::[
  PRINCIPLE::core_rule_one_sentence,
  WHY::business_or_technical_reason,
  STATUS::status_with_proof
]

---

## CRITICAL ASSUMPTIONS ({M} Total)

[Status + owner + phase only]

A1::TITLE[confidence%]→STATUS[owner@phase]

---

## CONSTRAINED VARIABLES (Top 3-4)

[IMMUTABLE/FLEXIBLE/NEGOTIABLE structure]

---

## SCOPE BOUNDARIES

[Top 3-4 IS + top 3-4 IS_NOT items]

---

## DECISION GATES

[D0→B0→B1→B2→B3→B4 with status]

---

## AGENT ESCALATION

[Routing for key decision types]

---

## TRIGGER PATTERNS (Load Full North Star When...)

LOAD_FULL_NORTH_STAR_IF::[
  "violates I#" :: immutable_conflict,
  "architecture|design" :: design_decisions,
  "assumption A#" :: validation_needed,
  "B0|B1|B2" :: decision_gate_approaching
]

---

## PROTECTION CLAUSE

IF::agent_detects_work_contradicting_North_Star,
THEN::[STOP→CITE→ESCALATE]

---

**STATUS**: Ready
**COMPRESSION**: {original}→{summary} ({ratio}:1)
**FIDELITY**: 100% decision logic preserved
```

---

## Hook Behavior

### When Summary Exists

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 NORTH STAR SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Full summary content displayed]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ North Star Summary loaded from coordination
  Location: .coord/workflow-docs/000-PROJECT-NORTH-STAR-SUMMARY.oct.md
```

### When Summary Doesn't Exist

The hook exits silently with:

```
✓ SessionStart complete
```

No error is shown. This allows projects without summaries to work normally.

### When .coord Doesn't Exist

Same as above - silent success. The hook is project-structure aware.

---

## Trigger Patterns for Full Document Loading

When working on implementation, load the full North Star document if any of these patterns match:

### Tier 1: Critical (Auto-Load Immediately)

```octave
TIER_1_CRITICAL::[
  "violates I#" :: immutable_conflict_detected,
  "schema_mismatch|contract_violation" :: ecosystem_breaks,
  "RLS_policy+security" :: data_isolation_risk,
  "component_ID+FK_broken" :: cross-app_spine_failure
]
```

### Tier 2: High Priority (Load on Detection)

```octave
TIER_2_HIGH_PRIORITY::[
  "data_loss|corrupted_metadata" :: integrity_violation,
  "offline+Supabase_unavailable" :: resilience_question,
  "shot_number+reordered" :: temporal_ordering_violation,
  "AI+no_override" :: human_oversight_bypassed
]
```

### Tier 3: Contextual (Load When Approaching)

```octave
TIER_3_CONTEXTUAL::[
  "B0|B1|B2_gate" :: decision_gate_approaching,
  "assumption_A#" :: validation_planning,
  "deployment_strategy|architecture" :: design_decisions,
  "constrained_variable_negotiation" :: flexibility_questions
]
```

### How to Load Full Document

When a trigger pattern matches:

```bash
Read(".coord/workflow-docs/000-{PROJECT}-NORTH-STAR.md")
```

---

## Testing the Hook

### Test 1: Verify Hook Execution

```bash
cd /Volumes/HestAI-Projects/your-project

# Create test input
echo '{"cwd":"'$(pwd)'","session_id":"test"}' | \
  npx tsx ~/.claude/hooks/SessionStart.ts
```

Expected: Summary content displayed (if exists) or silent success

### Test 2: Verify Discovery Logic

```bash
# Test with coordination
cd /Volumes/HestAI-Projects/eav-ops
echo '{"cwd":"'$(pwd)'","session_id":"test"}' | \
  ~/.claude/hooks/SessionStart.sh

# Test without coordination
cd /tmp
echo '{"cwd":"'$(pwd)'","session_id":"test"}' | \
  ~/.claude/hooks/SessionStart.sh
```

Expected: Summary in first case, silent success in second

### Test 3: Integration Test

Start a new Claude Code session in a project with coordination:

```bash
cd /Volumes/HestAI-Projects/eav-ops
code .
```

Expected: North Star Summary automatically displayed at startup

---

## Performance

### Token Usage

- **Without Summary:** ~3k tokens (300-line full document)
- **With Summary:** ~500 tokens (100-130-line compressed)
- **Savings:** ~2.5k tokens per session (83% reduction)

### Execution Time

- **Discovery:** <5ms (file system checks)
- **Loading:** <10ms (read 100-130 lines)
- **Total Overhead:** <15ms

### Cost Impact

At 100 sessions/month:
- **Before:** 300k tokens → ~$1.50/month
- **After:** 50k tokens → ~$0.25/month
- **Savings:** ~$1.25/month per active project

---

## Troubleshooting

### Hook Not Running

1. **Check executable permissions:**
   ```bash
   chmod +x ~/.claude/hooks/SessionStart.sh
   ```

2. **Verify TypeScript can execute:**
   ```bash
   npx tsx --version
   ```

3. **Check hook dependencies:**
   ```bash
   cd ~/.claude/hooks && npm install
   ```

### Summary Not Loading

1. **Verify .coord exists:**
   ```bash
   ls -la .coord
   ```

2. **Check summary file exists:**
   ```bash
   ls -la .coord/workflow-docs/*NORTH-STAR-SUMMARY*.md
   ```

3. **Test discovery manually:**
   ```bash
   echo '{"cwd":"'$(pwd)'","session_id":"test"}' | \
     npx tsx ~/.claude/hooks/SessionStart.ts
   ```

### Hook Errors

Check for error output in terminal. The hook fails silently by design but may show warnings:

```
⚠️  SessionStart hook error: [error message]
```

Common errors:
- **Cannot read .coord:** Permissions issue or broken symlink
- **File read failed:** Summary file corrupted or inaccessible

---

## Integration with Workflow

### When Summary is Sufficient (80% of cases)

You can work directly without loading the full document for:

- **Implementation tasks** following established patterns
- **Code reviews** checking for obvious violations
- **Feature work** within defined scope boundaries
- **Bug fixes** not touching architectural decisions

### When Full Document is Needed (20% of cases)

Load full document when:

- **Immutable violation detected** (cite specific I# code)
- **Architectural decisions required** (deployment, database, integration)
- **Assumption validation needed** (executing validation plans)
- **Decision gates approaching** (B0, B1, B2 validation)

### Agent Escalation

The summary includes routing for specialists:

```octave
ESCALATION_ROUTING::[
  requirements-steward::["violates I#", "scope_boundary", "amendment"],
  technical-architect::["deployment", "database", "integration"],
  implementation-lead::["assumption_validation", "B1_tasks"],
  critical-engineer::["B0_validation", "GO/NO-GO"]
]
```

---

## Future Enhancements

Potential improvements (not yet implemented):

1. **Multi-Project Detection:** Load multiple summaries when working in monorepo
2. **Smart Triggers:** Analyze user prompt for trigger pattern matches
3. **Diff Display:** Show what changed since last session
4. **Version Tracking:** Track which summary version was loaded
5. **Cache Management:** Cache summary content for faster subsequent loads

---

## References

- **Issue:** https://github.com/elevanaltd/hestai/issues/7
- **Compression Methodology:** `.claude/commands/ns-summary-create.md`
- **Template:** `/Volumes/HestAI/docs/guides/100-UNIFIED-NORTH-STAR-SUMMARY-TEMPLATE.oct.md`
- **Hook System:** `.claude/hooks/README.md`

---

**Created:** 2024-12-04
**Status:** Production Ready
**Maintainer:** system-steward
