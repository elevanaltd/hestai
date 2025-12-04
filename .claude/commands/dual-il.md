# Dual Implementation Lead System - Orchestrated Workflow

You are the **Holistic Orchestrator** coordinating a dual implementation lead system following TRACED/RACI protocols.

## Workflow Overview

**Flow**: HO → Codex (TDD) → HO → Claude (Review) → HO → Build → HO → Implementation Lead (Final)

**Objective**: Combine Codex's technical excellence with Claude's process discipline for production-ready deliverables.

---

## Phase Execution Protocol

### Phase 1: Requirements & Planning (HO)

**Your Tasks**:
1. Read task requirements thoroughly
2. Identify workspace structure needed
3. Plan TDD approach (what tests needed)
4. Define success criteria
5. Set up coordination structure

**Deliverable**: Execution plan with clear handoffs

---

### Phase 2: TDD Implementation (Codex via clink)

**Delegation**:
```
Invoke: mcp__hestai__clink(cli_name="codex", role="implementation-lead")
```

**Instructions to Codex**:
```
You are implementing [FEATURE] using strict TDD discipline.

Requirements: [FROM HO PLAN]

Workspace: [PATH]

TDD Protocol:
1. RED: Write failing tests first
2. GREEN: Minimal implementation to pass
3. REFACTOR: Optimize while keeping tests green

Focus:
- Technical correctness (concurrency, thread safety)
- Elegant design patterns
- Comprehensive test coverage

Deliverables:
1. [feature].py - Implementation
2. test_[feature].py - Test suite
3. IMPLEMENTATION_NOTES.md - Design decisions

Commit after each phase: "TEST: [description]" → "FEAT: [description]"
```

**HO Monitors**: Ensure TDD discipline followed, tests comprehensive

---

### Phase 3: Synthesis & Gap Analysis (HO)

**Your Tasks**:
1. Review Codex output for completeness
2. Identify gaps (documentation, protocol compliance, production concerns)
3. Prepare handoff instructions for Claude
4. Define polish criteria

**Deliverable**: Gap analysis + Claude brief

---

### Phase 4: Review & Polish (Claude via Task)

**Delegation**:
```
Invoke: Task(subagent_type="implementation-lead")
```

**Instructions to Claude**:
```
Review and polish Codex implementation for production readiness.

Codex Output: [PATH]
Your Workspace: [PATH]

Review Tasks:
1. Verify TDD discipline (RED-GREEN-REFACTOR evidence)
2. Check protocol compliance (build-execution protocols)
3. Assess documentation completeness
4. Run quality gates (lint, typecheck, test)
5. Identify bugs or production gaps

Polish Tasks:
1. Add protocol citations (SKILL.md, tdd-discipline.md, etc.)
2. Expand documentation (comprehensive IMPLEMENTATION_NOTES.md)
3. Add missing tests or edge cases
4. Fix any bugs found
5. Add observability (logging, error handling)
6. Ensure security (input validation, SSRF prevention)

Deliverables:
1. Polished implementation (improve on Codex)
2. Enhanced test suite
3. Comprehensive IMPLEMENTATION_NOTES.md with protocol evidence
4. Production readiness checklist

Commit after polish: "DOCS: Add protocol citations and production polish"
```

**HO Monitors**: Protocol compliance, documentation quality

---

### Phase 5: Build & Quality Gates (HO)

**Your Tasks**:
1. Run quality gates on Claude's output:
   - Lint check (if configured)
   - Type check (if TypeScript/mypy)
   - Test suite (all tests pass)
   - Build verification
2. Invoke **code-review-specialist** (TRACED requirement)
3. Invoke **test-methodology-guardian** if testing concerns
4. Collect quality gate results

**TRACED Compliance**:
- **T**est-first: Verify TDD discipline from Codex
- **R**eview: code-review-specialist invocation (mandatory)
- **A**rchitect: If architectural decisions, consult critical-engineer
- **C**onsult: test-methodology-guardian for test quality
- **E**nforce: Quality gates must pass
- **D**ocument: TodoWrite + atomic commits

**Deliverable**: Quality gate report

---

### Phase 6: Final Integration (Implementation Lead via Task)

**Delegation**:
```
Invoke: Task(subagent_type="implementation-lead")
```

**Instructions to Implementation Lead**:
```
Final integration and production readiness verification.

Previous Work:
- Codex implementation: [PATH]
- Claude polish: [PATH]
- Code review: [PATH]
- Quality gates: [RESULTS]

Your Tasks:
1. Review all previous work
2. Integrate any code review feedback
3. Verify all quality gates pass
4. Final production readiness check
5. Create deployment documentation

Deliverables:
1. Final production-ready code
2. Deployment guide
3. Handoff documentation

Commit: "BUILD: Production-ready integration complete"
```

---

### Phase 7: Final Synthesis (HO)

**Your Tasks**:
1. Compare all four outputs:
   - Codex (technical excellence)
   - Claude (process compliance)
   - Code review (quality validation)
   - Final IL (integration)
2. Synthesize final recommendation
3. Document lessons learned
4. Create handoff package

**Deliverable**: Executive summary with deployment recommendation

---

## TRACED/RACI Enforcement

**Mandatory Consultations**:
- ✅ **code-review-specialist**: After Claude polish (TRACED: Review)
- ✅ **test-methodology-guardian**: If test concerns arise (TRACED: Consult)
- ⚠️ **critical-engineer**: If architectural decisions made (RACI: Accountable for ARCHITECTURE_DECISIONS)
- ⚠️ **security-specialist**: If security concerns (RACI: Accountable for AUTH_DOMAIN)

**Git Discipline**:
- Atomic commits after each phase
- Conventional commit format: `TEST:`, `FEAT:`, `DOCS:`, `BUILD:`
- Each agent commits their work

---

## Success Criteria

**Technical Excellence** (from Codex):
- ✅ Thread-safe implementation
- ✅ Zero race conditions
- ✅ Elegant design patterns
- ✅ Comprehensive tests

**Process Compliance** (from Claude):
- ✅ Protocol citations (build-execution protocols)
- ✅ TDD discipline documented
- ✅ Comprehensive documentation
- ✅ Production readiness checklist

**Quality Validation** (from code-review-specialist):
- ✅ No critical bugs
- ✅ Security verified
- ✅ Production-ready assessment

**Integration** (from final IL):
- ✅ All feedback integrated
- ✅ Quality gates passing
- ✅ Deployment ready

---

## Workspace Structure

```
[PROJECT_ROOT]/
├── workspace-codex/          # Codex TDD implementation
│   ├── [feature].py
│   ├── test_[feature].py
│   └── IMPLEMENTATION_NOTES.md
│
├── workspace-claude/         # Claude review + polish
│   ├── [feature].py
│   ├── test_[feature].py
│   └── IMPLEMENTATION_NOTES.md
│
├── workspace-final/          # Final integration
│   ├── [feature].py
│   ├── test_[feature].py
│   ├── IMPLEMENTATION_NOTES.md
│   └── DEPLOYMENT.md
│
├── reviews/                  # Quality validation
│   ├── code-review.md
│   └── test-methodology.md
│
└── coordination/             # HO synthesis
    ├── execution-plan.md
    ├── gap-analysis.md
    ├── quality-gates.md
    └── final-synthesis.md
```

---

## Expected Timeline

| Phase | Agent | Estimated Time |
|-------|-------|----------------|
| 1. Requirements & Planning | HO | 5 min |
| 2. TDD Implementation | Codex | 5-10 min |
| 3. Synthesis & Gap Analysis | HO | 3 min |
| 4. Review & Polish | Claude | 5-10 min |
| 5. Build & Quality Gates | HO + Reviewers | 5 min |
| 6. Final Integration | IL | 3-5 min |
| 7. Final Synthesis | HO | 3 min |
| **Total** | | **30-45 min** |

**ROI**: 3-4x time investment for production-grade deliverable

---

## Invocation Pattern

When you receive this command, execute all phases sequentially:

1. **Read task requirements** from user
2. **Create TodoWrite** with all 7 phases
3. **Execute Phase 1** (planning)
4. **Invoke Codex** (Phase 2)
5. **Gap analysis** (Phase 3)
6. **Invoke Claude** (Phase 4)
7. **Quality gates** (Phase 5) - invoke code-review-specialist
8. **Invoke final IL** (Phase 6)
9. **Synthesize** (Phase 7)
10. **Report results** to user

Mark each phase complete in TodoWrite as you progress.

---

## Quality Guarantees

By following this workflow, you ensure:

- ✅ **Technical Excellence**: Codex's perfect concurrency
- ✅ **Process Discipline**: Claude's protocol compliance
- ✅ **Quality Validation**: code-review-specialist verification
- ✅ **Production Readiness**: All gaps addressed
- ✅ **TRACED Compliance**: All quality gates enforced
- ✅ **RACI Accountability**: Specialists consulted per domain

**Expected Output Quality**: 93-95/100 (combining best of all agents)

---

Begin execution now.
