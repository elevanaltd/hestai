---
name: subagent-rules
description: Proper delegation patterns for Task() invocations with context injection
allowed-tools: ["Task", "Read"]
---

# Subagent Delegation Rules

SUBAGENT_ISOLATION::[
  PRINCIPLE::subagent_receives_ONLY[prompt_parameter]≠auto_context,
  IMPLICATION::YOU_provide[RAPH+governance+phase+authority+skills],
  WARNING::no_inherited_context[TRACED,DOD,methodology,phase,authority,skills,project_background]
]

---

## MANDATORY in Every Task() Prompt

```octave
REQUIRED_SECTIONS::[
  1::GOVERNANCE_CONTEXT[
    TRACED→full_definition[T/R/A/C/E/D_with_specifics],
    DOD_{phase}→applicable_criteria,
    AUTHORITY→R[responsibility],A[authority],C[consult],D[scope]
  ],
  2::PHASE_CONTEXT[
    current_phase→{D0-D3|B0-B5},
    phase_requirements→specific_constraints
  ],
  3::OPERATIONAL_SKILLS[
    Skill(command:"skill-name") // reason_why
  ],
  4::TASK_DESCRIPTION[
    detailed_requirements,
    technical_constraints,
    success_metrics
  ],
  5::DECISION_AUTHORITY[
    scope→what_agent_decides,
    consultations→required_reviews
  ]
]
```

---

## Minimal Template

```typescript
Task({
  subagent_type: "agent-name",
  description: "One-sentence summary",
  prompt: `
## GOVERNANCE CONTEXT

TRACED::[
  T::test_first[RED→GREEN→REFACTOR]→failing_test_before_code,
  R::code_review[every_change]→code-review-specialist_approval,
  A::critical-engineer[production_standards]→final_authority,
  C::domain_specialists→{technical-architect, security-specialist},
  E::quality_gates[lint+typecheck+test]→ALL_PASS_mandatory,
  D::TodoWrite[track_progress]→visible_accountability
]

DOD_{phase}::[
  criterion1→required,
  criterion2→required
]

AUTHORITY::[
  R[decision_scope],
  A[final_authority],
  C[must_consult],
  D[escalation_triggers]
]

## PHASE: {phase}
- {requirement1}
- {requirement2}

## OPERATIONAL SKILLS
- Skill(command:"skill-name") // reason

## TASK
{detailed_description}

## DECISION AUTHORITY
You decide: {scope}
You consult: {required_consultations}

## SUCCESS CRITERIA
{deliverables + DOD alignment}
  `
})
```

---

## Agent-to-Skills Quick Mapping

| Agent | Skills | When |
|-------|--------|------|
| **implementation-lead** | build-execution, test-infrastructure | B2, B5 |
| **error-architect** | error-triage, ci-error-resolution | Any (errors) |
| **workspace-architect** | workspace-setup | B1_02 |
| **code-review-specialist** | (self) | B2, B3 |
| **critical-engineer** | (phase-dependent) | B0, B1, B3, B4 |
| **technical-architect** | supabase-operations | DB work |
| **security-specialist** | smartsuite-patterns | SmartSuite work |
| **universal-test-engineer** | test-infrastructure | B2, B3 |

---

## Anti-Patterns ❌

### Minimal Context (WRONG)
```typescript
Task({
  subagent_type: "implementation-lead",
  prompt: "Implement authentication"
})
```
**Problem:** No TRACED, DOD, phase, skills, or authority.

### Assuming Auto-Injection (WRONG)
```typescript
Task({
  subagent_type: "implementation-lead",
  prompt: "Follow TRACED and use TDD"
})
```
**Problem:** Words without definitions. Subagent doesn't know what TRACED means.

### Incomplete Governance (WRONG)
```typescript
Task({
  subagent_type: "implementation-lead",
  prompt: `Use TDD for auth. Email/password + JWT.`
})
```
**Problem:** Missing DOD, authority matrix, phase context, skills, success criteria.

---

## Pre-Task Checklist

- [ ] TRACED methodology (full definition)
- [ ] DOD requirements (for current phase)
- [ ] Authority matrix (R/A/C/D)
- [ ] Phase context + requirements
- [ ] Operational skills loaded
- [ ] Task description (detailed)
- [ ] Decision authority (scope + consultations)
- [ ] Success criteria (deliverables + DOD)
