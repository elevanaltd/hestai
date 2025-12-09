# Research: Multi-Agent Debate Pattern for Complex Decisions

**Date**: 2025-12-08
**Session**: Context Steward Implementation (#71)
**Orchestrator**: holistic-orchestrator (Claude Opus 4.5)

---

## 1. Pattern Overview

### Problem Statement

Initial quality gate reviews (CRS + CE) identified issues but proposed fixes without:
- Implementation-lead input (who knows the codebase intimately)
- Cross-validation of proposed solutions
- Edge case exploration

**User Insight**: "Multi-Agent Debate pattern is proven to solve complex logic puzzles better than single-agent refinement."

### Pattern Applied

```
FOCUSED_DEBATE_PATTERN::[
  STEP_1::initial_review[CRS+CE]→identify_issues,
  STEP_2::assess_debate_value[MIP_analysis],
  STEP_3::parallel_execution[
    edge-optimizer→find_hidden_improvements,
    focused_debate→CE_evaluates_options
  ],
  STEP_4::synthesis→converged_solution,
  STEP_5::implement_agreed_fix
]
```

---

## 2. Agents Used and Invocation Methods

### TIER1 Exploration (Free/Flat-Rate)

| Agent | Invocation | Purpose | Duration |
|-------|------------|---------|----------|
| critical-engineer | `mcp__hestai__clink(cli_name="gemini", role="critical-engineer")` | Architectural validation, JSONL debate | ~27s |

### TIER2 Validation (Quota-Preserved)

| Agent | Invocation | Purpose | Duration |
|-------|------------|---------|----------|
| code-review-specialist | `mcp__hestai__clink(cli_name="codex", role="code-review-specialist")` | Code review, security analysis | ~229s |

### TIER3 Implementation (Claude Subagents)

| Agent | Invocation | Purpose | Duration |
|-------|------------|---------|----------|
| implementation-lead | `Task(subagent_type="implementation-lead")` | Tool implementation | ~10min |
| edge-optimizer | `Task(subagent_type="edge-optimizer")` | Hidden improvement discovery | ~3min |

### Invocation Patterns

```python
# TIER1/TIER2: clink for external CLIs
mcp__hestai__clink(
    cli_name="gemini",           # or "codex"
    role="critical-engineer",     # Agent role to activate
    prompt="...",                 # Task description
    files=[...]                   # Files for context
)

# TIER3: Task() for Claude subagents
Task(
    subagent_type="edge-optimizer",
    description="Review for hidden improvements",
    prompt="...",
    run_in_background=True        # Optional: parallel execution
)
```

---

## 3. MIP Assessment: When to Debate

**Minimal Intervention Principle** applied to decide debate value:

| Issue Type | Debate Value | Rationale |
|------------|--------------|-----------|
| Well-known security pattern | LOW | Standard fix, debate unlikely to yield novel solution |
| Multiple valid approaches | HIGH | Debate finds best synthesis |
| Hidden edge cases | HIGH | Edge-optimizer adds value |
| Textbook implementation | LOW | Coordination theater risk |

### Decision Framework

```octave
DEBATE_DECISION::[
  IF[solution_is_textbook]→skip_debate,
  IF[multiple_valid_approaches]→run_focused_debate,
  IF[complex_integration]→invoke_edge-optimizer,
  IF[security_critical]→both_debate_AND_edge_analysis
]
```

---

## 4. Results from This Session

### Initial Quality Gate Findings

**CRS (Codex)**: NO-GO
- Path traversal vulnerability in session_id
- Proposed standard sanitization fix

**CE (Gemini)**: NO-GO (Production) / CONDITIONAL (Dev)
- JSONL path brittleness
- Proposed env var fallback

### Debate Question

"Which JSONL extraction approach is best?"
- Option A: Environment variable fallback
- Option B: Use hook metadata directly
- Option C: Graceful degradation

### CE Debate Verdict

**OPTION B WINS** - Use Hook Metadata Directly

Reasoning:
- Transforms probabilistic (guessing) to deterministic (knowing)
- Removes heuristic entirely
- Option A rejected as "WORKAROUND_CULTURE"
- Option C rejected as "Validation Theater"

### Edge-Optimizer Discovery: Third Way

**Breakthrough**: Don't pick sides - use BOTH strategies:

```python
transcript_path = (
    session_data.get('transcript_path')  # Hook-provided (Option B)
    or self._find_session_jsonl(project_root)  # Fallback for resilience
)
```

**Additional Findings**:
1. Path traversal fix already half-implemented in `session_models.py`
2. Session resurrection pattern for crash recovery
3. Shared infrastructure could reduce 50% code duplication
4. Race condition in conflict detection (low priority)

### Synthesis

The debate and edge analysis **converged** on an enhanced solution:
- **Primary**: Option B (hook metadata)
- **Enhancement**: Keep fallback reconstruction for resilience
- **Result**: Best of both worlds, zero brittleness

---

## 5. Key Learnings

### L1: Focused Debate > Full Debate

**Finding**: Not everything needs debate. Apply MIP:
- Security fixes with standard patterns → Skip debate
- Multiple valid approaches → Run focused debate
- Overall architecture → Edge-optimizer

**Metric**: This session debated 1 of 2 issues (50%), saving ~15 min coordination time.

### L2: Edge-Optimizer Finds Third Ways

**Finding**: Edge-optimizer discovered solutions that transcended the original options:
- "Keep both approaches" wasn't in the original 3 options
- "Session resurrection" turned crash liability into feature
- "Fix already half-implemented" reduced implementation effort

**Recommendation**: Always run edge-optimizer for complex integrations.

### L3: Parallel Execution Matters

**Finding**: Running edge-optimizer and debate in parallel:
```python
# Parallel invocation pattern
Task(subagent_type="edge-optimizer", run_in_background=True)
mcp__hestai__clink(cli_name="gemini", role="critical-engineer", ...)
```

**Metric**: Total time ~5 min vs ~10 min sequential.

### L4: Debate Surfaced Hidden Dependencies

**Finding**: The debate revealed that clock_in and clock_out have a **contract dependency**:
- clock_in must store `transcript_path` in session.json
- clock_out must read it

This dependency wasn't in the original implementation spec.

### L5: TIER1/TIER2/TIER3 Separation Works

**Finding**: Using Gemini (free) for debate and Codex for code review preserved Claude quota for actual implementation:
- ~47K tokens Gemini (debate)
- ~600K tokens Codex (code review)
- Claude quota used only for implementation-lead and edge-optimizer

---

## 6. Protocol Template

### When to Use Multi-Agent Debate

```octave
TRIGGER_CONDITIONS::[
  quality_gate_returns_NO-GO,
  multiple_valid_solutions_exist,
  implementation_impacts_multiple_tools,
  security_or_reliability_concern
]
```

### Execution Pattern

```
1. INITIAL_REVIEW
   - Route to CRS (Codex) for code review
   - Route to CE (Gemini) for architectural validation

2. ASSESS_FINDINGS
   - Identify textbook fixes (skip debate)
   - Identify complex decisions (debate candidates)

3. PARALLEL_ANALYSIS
   - Edge-optimizer (Task): Hidden improvements
   - Focused debate (clink): CE evaluates options

4. SYNTHESIS
   - Combine CE verdict with edge insights
   - Look for third-way solutions

5. IMPLEMENTATION
   - Delegate to implementation-lead
   - Include debate findings in context

6. RE-VALIDATION
   - Route back through CRS + CE
   - Confirm issues resolved
```

### Debate Prompt Template

```markdown
## FOCUSED DEBATE: {Topic}

**Context**: {Brief problem statement}

### Current Implementation
{Code snippet}

### Proposed Options

**OPTION A: {Name}**
{Description}
- Pro: {benefits}
- Con: {drawbacks}

**OPTION B: {Name}**
...

**OPTION C: {Name}**
...

### Evaluation Criteria
1. **WILL_IT_BREAK** - Which is most reliable?
2. **WHO_MAINTAINS** - Which has lowest maintenance burden?
3. **WHY_COMPLEX** - Which is simplest while solving the problem?

Provide your ranking with reasoning. Which option do you recommend?
```

---

## 7. Future Research Directions

1. **Debate Escalation**: When should debate escalate to human?
2. **Debate Quorum**: Should multiple CEs debate each other?
3. **Debate Caching**: Can debate verdicts be reused for similar problems?
4. **Adversarial Debate**: Would pro/con advocacy improve outcomes?

---

## 8. References

- Issue: #71 (Context Steward Session Lifecycle)
- Branch: `feat/context-steward-session-lifecycle`
- Session: 2025-12-08
- Orchestrator: holistic-orchestrator

---

**Authority**: holistic-orchestrator
**Research Category**: Multi-Agent Coordination Patterns
