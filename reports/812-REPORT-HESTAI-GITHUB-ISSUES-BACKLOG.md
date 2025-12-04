# HestAI GitHub Issues Backlog Report

**Report ID:** 812-REPORT-HESTAI-GITHUB-ISSUES-BACKLOG
**Generated:** 2025-12-04
**Repository:** elevanaltd/hestai
**Purpose:** Comprehensive reference for agents without GitHub access
**Authority:** holistic-orchestrator

---

## Executive Summary

10 open enhancement issues focused on **context optimization** and **operational improvements** for the HestAI agent system.

### Priority Distribution
| Priority | Count | Focus Area |
|----------|-------|------------|
| P1 | 5 | Context reduction, role compliance |
| P2 | 2 | Session context, RAPH optimization |
| P3 | 1 | Blockage resolution protocol |
| P4 | 1 | MUST_NEVER monitoring research |

### Token Impact Analysis
| Category | Issues | Potential Savings |
|----------|--------|-------------------|
| SUBTRACT (reduce load) | #6, #7, #8, #9 | ~36k tokens |
| STREAMLINE (optimize) | #10 | ~5k tokens |
| NEUTRAL | #2 | 0 tokens |
| ADD (new features) | #1, #3, #4, #5 | +context |

---

## Issue #1: Episodic Memory
**Priority:** P1 | **Labels:** enhancement | **State:** OPEN

### Summary
Implement episodic memory capability to prevent "amnesia" between sessions. System Steward will maintain persistent memory of audit findings, patterns, and decisions.

### Rationale
- Zero infrastructure risk (file system only, no hook changes)
- Aligns with existing System Steward role (ADMIN_CONTINUOUS, "Witness/Preserver")
- Prevents repeated investigations of same issues
- Enables recurring pattern detection and escalation

### Implementation
```
.coord/system-memory/
├── episodes/
│   └── {YYYY-MM-DD}.md  # Daily episode files
└── patterns.md          # OCTAVE-compressed recurring patterns
```

### Episode File Template
```markdown
# Episode: {DATE}

## Signal
{What was observed/investigated}

## Decision
{What was decided and why}

## Outcome
{Result and any lessons learned}
```

### Acceptance Criteria
- [ ] `.coord/system-memory/` structure exists
- [ ] System Steward constitution updated with memory duties
- [ ] At least one episode logged per session
- [ ] Patterns use OCTAVE compression
- [ ] `/load` references memory location (not content)

### Token Impact
ADDS context (memory should be pull-based, not push-based to prevent bloat)

---

## Issue #2: Role Compliance (Advisory Mode)
**Priority:** P1 | **Labels:** enhancement | **State:** OPEN

### Summary
Re-enable the existing `enforce-role-boundaries.sh` hook in advisory (non-blocking) mode to provide visibility on role violations without halting work.

### Current State
- Location: `~/.claude/hooks/enforce-role-boundaries.sh`
- Status: Disabled (early `exit 0`)
- Reason: False positives blocked valid work

### Implementation Change
```bash
# Before (blocking)
exit 2  # HOOK_BLOCKED

# After (advisory)
echo "⚠️ [ADVISORY] HO touching implementation code. Delegate to implementation-lead recommended." >&2
exit 0  # Allow but warn
```

### Acceptance Criteria
- [ ] Hook re-enabled (remove early `exit 0`)
- [ ] Exit code changed from 2 (block) to 0 (pass)
- [ ] Warning message output to stderr
- [ ] Message clearly indicates advisory nature
- [ ] No false positive blocking of legitimate work

### Token Impact
NEUTRAL (script execution overhead is low)

---

## Issue #3: WHY Synthesis for /load
**Priority:** P2 | **Labels:** enhancement | **State:** OPEN

### Summary
Enhance the `/load` command to include a "WHY" synthesis section that explains why things are in their current state, based on recent git history analysis.

### Rationale
- Current `/load` provides WHAT (constitution, context, git state) but not WHY
- Addresses context-filling problem by starting with compressed understanding
- Reduces repeated "git archaeology" at session start

### Missing Components
- Summary of last session's work
- Key decisions and their rationale
- Open questions/continuation points

### Proposed Dashboard Section
```
📝 SESSION CONTEXT (WHY)
   Last work: {summary_from_git}
   Key decisions: {extracted_from_commits}
   Continue from: {open_items_if_known}
```

### Acceptance Criteria
- [ ] `/load` output includes WHY section
- [ ] WHY derived from actual git history
- [ ] Paragraph references at least one recent commit
- [ ] Integration with episodic memory (if exists)
- [ ] Adds ≤3 seconds to /load time

### Dependencies
Benefits from Issue #1 (Episodic Memory) but not blocked by it

### Token Impact
ADDS context (~500-1k tokens)

---

## Issue #4: Blockage Resolution Protocol
**Priority:** P3 | **Labels:** documentation, enhancement | **State:** OPEN

### Summary
Document a formal "Blockage Resolution Protocol" for when critical-engineer or other validators block work, enabling structured resolution without always requiring human intervention.

### Rationale
- Currently blockages are binary: BLOCK → human intervention
- Research shows multi-agent debate improves accuracy on complex logic
- Structured resolution reduces human intervention while maintaining quality
- Process/discipline change, no code required

### Proposed Protocol
```octave
BLOCKAGE_RESOLUTION_PROTOCOL::[
  1::implementation-lead_proposes_3_alternatives[
    Alt_A::{approach+tradeoffs},
    Alt_B::{approach+tradeoffs},
    Alt_C::{approach+tradeoffs}
  ],
  2::critical-engineer_critiques_each[
    security_implications,
    architectural_concerns,
    recommendation
  ],
  3::synthesizer_finds_third_way[
    OPTIONAL::if_all_alternatives_flawed,
    OUTPUT::hybrid_or_novel_approach
  ],
  4::human_approves_or_escalates[
    APPROVE::proceed_with_selected_approach,
    ESCALATE::to_principal-engineer_or_requirements-steward
  ]
]
```

### Acceptance Criteria
- [ ] Protocol documented in appropriate location
- [ ] Clear trigger conditions defined
- [ ] Step sequence formalized
- [ ] Escalation path documented
- [ ] Referenced from relevant agent constitutions

### Token Impact
ADDS context (loading extra documentation when needed)

---

## Issue #5: MUST_NEVER Monitoring Research
**Priority:** P4 | **Labels:** enhancement | **State:** OPEN

### Summary
Research feasibility and alternatives for implementing automated MUST_NEVER violation detection, given the lack of PostResponse hook infrastructure.

### Blocker
Claude Code CLI lacks `PostResponse` or `AgentOutput` hook. Current hooks:
- `UserPromptSubmit` - intercepts user input
- `PreToolUse` - before tool execution
- `PostToolUse` - after tool execution
- ❌ NO `PostResponse` - cannot inspect assistant output

### Research Questions
1. **Reactive Check Approach** - Check *previous* response in next `UserPromptSubmit`?
2. **Post-Tool Proxy** - Can post-tool hooks approximate response checking?
3. **Alternative Enforcement Points** - Pre-commit hook? Periodic audit?
4. **Infrastructure Evolution** - Is Claude Code CLI adding PostResponse hooks?

### Liaison Analysis Summary
- **Codex**: Feasible via post-tool hooks, ~370 token overhead, misses subagents
- **Gemini**: Defer - Low ROI due to infrastructure complexity, high noise risk

### Acceptance Criteria
- [ ] Document feasibility assessment
- [ ] Identify viable implementation path (if any)
- [ ] Estimate effort and ROI
- [ ] Recommend proceed/defer/alternative

### Token Impact
ADDS context (active monitoring scripts/rules)

---

## Issue #6: MCP Tool Audit
**Priority:** P1 | **Labels:** enhancement | **State:** OPEN

### Summary
Audit all MCP tools to identify which are actively used vs consuming context budget unnecessarily. MCP tools currently consume **30.2k tokens (15.1%)** of context.

### Current MCP Tool Inventory
| Server | Tools | Est. Tokens |
|--------|-------|-------------|
| repomix | 6 | ~5k |
| Context7 | 2 | ~1.7k |
| hestai | 5 | ~12k |
| supabase | 12 | ~11k |
| **TOTAL** | 25 | **~30k** |

### Audit Questions
1. **Server-Level**: Which MCP servers are used in typical HO sessions?
2. **Tool-Level**: Within each server, which tools are actually invoked?
3. **Configuration**: Can we create "profiles" (minimal, standard, full)?

### Acceptance Criteria
- [ ] Document usage frequency of each MCP tool (last 30 days)
- [ ] Identify tools with zero/low usage
- [ ] Create recommendation for minimal MCP configuration
- [ ] Estimate token savings from recommended changes
- [ ] Document how to enable/disable MCP tools

### Token Impact
POTENTIAL SAVINGS: ~15k tokens (50% reduction target)

---

## Issue #7: North Star Audit
**Priority:** P1 | **Labels:** enhancement | **State:** OPEN

### Summary
Investigate how North Star documents should be used effectively. Currently loaded eagerly but may not need full content at startup.

### Current State
- **Location**: `.coord/workflow-docs/000-UNIVERSAL-EAV_SYSTEM-D1-NORTH-STAR.md`
- **Size**: ~300 lines, ~3k tokens
- **Loading**: EAGER (always loaded at startup)
- **Content**: 13 immutables, assumptions, decision gates, constrained variables

### Loading Strategy Options
| Strategy | Description | Token Cost |
|----------|-------------|------------|
| EAGER FULL | Current (always load all 300 lines) | ~3k |
| EAGER SUMMARY | Load only I1-I13 codes | ~0.5k |
| LAZY FULL | Load on first alignment question | 0 at startup |
| HYBRID | Summary eager, full on-demand | ~0.5k |

### Proposed North Star Summary
```octave
IMMUTABLES::[
  I1::component_spine,
  I2::multi_client_RLS,
  I3::LLM_assisted_generation,
  ...
  I13::client_facing_boundaries
]
TRIGGER::requirements-steward[full_North_Star_lookup]
```

### Acceptance Criteria
- [ ] Document actual North Star usage patterns in sessions
- [ ] Create compressed "North Star Summary" version
- [ ] Define clear trigger for full North Star loading
- [ ] Test HO effectiveness with summary vs full
- [ ] Recommend loading strategy based on evidence

### Token Impact
POTENTIAL SAVINGS: ~2-2.5k tokens

---

## Issue #8: Repomix Audit
**Priority:** P1 | **Labels:** enhancement | **State:** OPEN

### Summary
Audit repomix usage patterns to determine if it should be a trigger-based skill rather than eager-loaded at startup.

### Current State
- **Tool**: `mcp__repomix__pack_codebase`
- **Usage in /load**: Step 6 (EAGER - always runs)
- **Output**: 638 files, 427K tokens (compressed)
- **Token impact**: ~15k tokens in message history

### Investigation Questions
1. How often is the repomix output actually used after packing?
2. What prompts/questions trigger codebase queries?
3. Can repomix be a skill that activates on UserPromptSubmit?

### Proposed Skill Design
```yaml
---
name: codebase-awareness
description: Packs codebase via repomix when architecture/codebase questions detected
triggers: ["codebase", "architecture", "find all", "where is", "how does"]
---

ON_TRIGGER::[
  IF::outputId_not_cached→pack_codebase,
  ELSE::use_existing_outputId
]
```

### Acceptance Criteria
- [ ] Analyze repomix usage in last 30 days of sessions
- [ ] Document trigger patterns that precede codebase queries
- [ ] Create proof-of-concept skill with trigger detection
- [ ] Measure token savings from lazy loading
- [ ] Recommend: skill conversion vs. explicit command vs. keep eager

### Token Impact
POTENTIAL SAVINGS: ~15k tokens (largest single opportunity)

---

## Issue #9: System Tool Audit
**Priority:** P1 | **Labels:** enhancement | **State:** OPEN

### Summary
Audit the built-in Claude Code system tools that consume **22.6k tokens (11.3%)** of context.

### Current System Tools
| Tool | Purpose | HO Need |
|------|---------|---------|
| Bash | Shell execution | USEFUL |
| Read | File reading | ESSENTIAL |
| Write | File creation | QUESTIONABLE |
| Edit | File modification | QUESTIONABLE |
| Glob | Pattern search | ESSENTIAL |
| Grep | Content search | ESSENTIAL |
| WebFetch | URL fetching | USEFUL |
| WebSearch | Web search | USEFUL |
| Task | Subagent spawning | ESSENTIAL |
| TodoWrite | Task tracking | ESSENTIAL |
| AskUserQuestion | User interaction | USEFUL |
| NotebookEdit | Jupyter editing | QUESTIONABLE |

### HO-Specific Requirements
- **ESSENTIAL**: Task, Read, Grep/Glob, TodoWrite
- **USEFUL**: Bash, WebFetch/WebSearch
- **QUESTIONABLE**: Write/Edit (HO shouldn't implement), NotebookEdit

### Acceptance Criteria
- [ ] Document all system tools and their token costs
- [ ] Analyze HO tool usage patterns
- [ ] Identify tools that could be disabled for HO
- [ ] Research Claude Code tool configuration options
- [ ] Recommend minimal tool set for HO role

### Token Impact
POTENTIAL SAVINGS: ~4-5k tokens (if questionable tools can be disabled)

---

## Issue #10: RAPH Audit
**Priority:** P2 | **Labels:** enhancement | **State:** OPEN

### Summary
Investigate the effectiveness of the full RAPH (Read-Absorb-Perceive-Harmonise) protocol and determine optimal activation strategy.

### Current RAPH Implementation
| Step | Description | Est. Tokens |
|------|-------------|-------------|
| 1 | Read constitution (PRIMACY) | ~350 lines read |
| 2 | Micro-RAPH anchor (LOCK) | ~100 tokens |
| 3 | Load PROJECT-CONTEXT | ~116 lines read |
| 4 | Load CHECKLIST + NORTH-STAR | ~400 lines read |
| 5 | Load git state | ~200 tokens |
| 6 | Pack codebase (repomix) | ~15k tokens |
| 7-10 | Full RAPH phases | ~2k tokens |
| 11 | Dashboard synthesis | ~300 tokens |

### Alternative Approaches
| Mode | Steps | Est. Tokens |
|------|-------|-------------|
| MICRO-RAPH | 1-2, 11 | ~500 |
| CACHED-RAPH | Store output, regenerate on change | ~0 repeat |
| SELECTIVE-RAPH | Full for complex, micro for routine | Variable |
| NO-RAPH | Just constitution read | ~350 lines |

### Proposed Experiment
Run parallel sessions:
- **A**: Full RAPH (current)
- **B**: Micro-RAPH only (steps 1-2, 11)
- **C**: No RAPH (just constitution read)

Measure: Session quality, alignment violations, task completion rate

### Integration with Other Enhancements
| Enhancement | RAPH Interaction |
|-------------|------------------|
| Episodic Memory (#1) | May replace ABSORB "context grounding" |
| WHY Synthesis (#3) | May replace PERCEIVE "session scenarios" |
| North Star Summary (#7) | May replace READ "constitution extraction" |

### Acceptance Criteria
- [ ] Define measurable criteria for RAPH effectiveness
- [ ] Run controlled comparison (full vs micro vs none)
- [ ] Document which RAPH outputs are actually referenced
- [ ] Analyze interaction with other enhancements
- [ ] Recommend: keep/simplify/replace RAPH

### Token Impact
POTENTIAL SAVINGS: ~5-10k tokens (if micro-RAPH sufficient)

---

## Recommended Investigation Order

```
PHASE_1::SUBTRACT[
  #6 MCP Tool Audit      → 15k savings
  #9 System Tool Audit   → 4.5k savings
  #8 Repomix Audit       → 15k savings
  #7 North Star Audit    → 2.5k savings
]
TOTAL_POTENTIAL: ~37k tokens

PHASE_2::STREAMLINE[
  #10 RAPH Audit         → 5k savings
]

PHASE_3::ADD[
  #2 Role Compliance     → NEUTRAL (implement now)
  #1 Episodic Memory     → Use saved budget
  #3 WHY Synthesis       → Use saved budget
]

PHASE_4::DEFER[
  #4 Blockage Protocol   → P3 documentation
  #5 MUST_NEVER Monitor  → P4 research
]
```

---

## Context Budget Analysis

### Current State (after /load ho)
| Component | Tokens | % of 200k |
|-----------|--------|-----------|
| System prompt | 3.1k | 1.6% |
| System tools | 22.6k | 11.3% |
| MCP tools | 30.2k | 15.1% |
| Custom agents | 4.1k | 2.0% |
| Memory files | 15.4k | 7.7% |
| Messages | 39.3k | 19.7% |
| **TOTAL USED** | **115k** | **57%** |
| **FREE** | **85k** | **43%** |

### Target State (after Phase 1-2 optimizations)
| Optimization | Savings |
|--------------|---------|
| MCP tools (50% reduction) | 15k |
| Repomix (lazy) | 15k |
| RAPH (micro default) | 5k |
| North Star (summary) | 2.5k |
| System tools (minimal) | 4.5k |
| **TOTAL SAVINGS** | **~42k** |

**Projected:** 115k - 42k = **73k usage (36.5%)** → **63.5% free**

### Mathematical Limit
- Fixed tool overhead: ~57k (System + MCP)
- Even with 0 data: 28.5% used
- **Maximum achievable free space: ~71.5%**
- **Realistic target with optimizations: 55-65% free**

---

## Quick Reference

### By Priority
- **P1**: #1, #2, #6, #7, #8, #9
- **P2**: #3, #10
- **P3**: #4
- **P4**: #5

### By Token Impact
- **SUBTRACT**: #6, #7, #8, #9
- **STREAMLINE**: #10
- **NEUTRAL**: #2
- **ADD**: #1, #3, #4, #5

### By Implementation Complexity
- **Quick Win (~30 min)**: #2
- **Medium (~2-4 hours)**: #7, #10
- **Investigation Required**: #6, #8, #9
- **Documentation Only**: #4
- **Research/Deferred**: #5

---

*Report generated by holistic-orchestrator for cross-agent reference*
*Source: https://github.com/elevanaltd/hestai/issues*
