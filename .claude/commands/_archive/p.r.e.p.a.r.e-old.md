# PREPARE Command - Context Establishment Protocol

## 🚨 CONTEXT AUTHORITY NOTICE
**MANDATORY BEFORE WORKFLOWS**: This command establishes comprehensive context understanding before any major workflow execution (build, enhance, deploy, debug, test). It ensures complete understanding, proactive discovery, and readiness verification.

**PURPOSE**: Eliminate repetitive "read these and confirm" patterns by systematically establishing context with proactive discovery and gap analysis.

## 🎯 P.R.E.P.A.R.E. - Context Establishment Mnemonic
**P** - Parse provided files (initial context reading) ← BLOCKING: Must read all specified files
**R** - Research related context (proactive discovery) ← REQUIRED: Discover tests, configs, dependencies  
**E** - Evaluate comprehension gaps (gap analysis) ← REQUIRED: Identify missing knowledge
**P** - Patterns and architecture (understand structure) ← REQUIRED: Map system relationships
**A** - Assess readiness (validation checkpoint) ← REQUIRED: Confirm understanding level
**R** - Report status (structured output) ← REQUIRED: READY or NEEDS_INPUT
**E** - Establish commitment (workflow readiness) ← REQUIRED: Lock in for next command

⚠️ **COMMITMENT PROTOCOL**: Once READY confirmed, COMMITTED to full workflow execution
📋 **NO SHORTCUTS**: After PREPARE→READY, next workflow MUST follow complete protocol

## QUICK_NAVIGATION_INDEX
**P.R.E.P.A.R.E**: Cognitive anchor → Line 9
**USAGE_PATTERNS**: Command syntax → Line 26
**DISCOVERY_PROTOCOL**: Proactive context finding → Line 54
**GAP_ANALYSIS**: Knowledge gap detection → Line 82
**READINESS_MATRIX**: Assessment criteria → Line 110
**WORKFLOW_PREPARATION**: Specific checklists → Line 150
**OUTPUT_FORMAT**: Required reporting structure → Line 220

## USAGE_PATTERNS

```bash
# Basic usage - reads files and establishes context
/prepare src/auth.ts src/session.ts

# With workflow preparation
/prepare src/ --workflow enhance
/prepare . --workflow build --scope full

# With strict confirmation
/prepare library/ --workflow test --strict

# Scope control
/prepare src/auth --scope module    # Default: related module context
/prepare src/ --scope system        # Broader system context
/prepare . --scope full             # Complete project context

# Discovery depth
/prepare src/ --depth 5             # Deep discovery (default: 3)
```

**Arguments**:
- Files/directories to analyze (defaults to current directory)
- `--workflow [enhance|build|deploy|debug|test]`: Prepare for specific workflow
- `--scope [feature|module|system|full]`: Context breadth (default: module)
- `--depth [1-5]`: Discovery depth for related files (default: 3)
- `--strict`: Require explicit user confirmation before proceeding

## DISCOVERY_PROTOCOL

**Phase 1: Initial Reading**
```
READ all provided files/directories
ESTABLISH base context from explicit inputs
MAP initial structure and patterns
```

**Phase 2: Proactive Discovery** (using research-analyst)
```
CHECK for .coord symlink (coordination access point)
DISCOVER related implementation files (depth: $DEPTH)
FIND test files and test patterns
LOCATE configuration and dependencies
IDENTIFY documentation and specifications
MAP adjacent modules and interfaces
TRACE call chains and data flows
```

**Phase 3: Pattern Recognition**
```
IDENTIFY architectural patterns
RECOGNIZE testing strategies
DETECT framework usage
MAP dependency relationships
UNDERSTAND error handling patterns
```

## GAP_ANALYSIS

**Using coherence-oracle, identify**:
```
KNOWLEDGE_GAPS:
  • What context is missing?
  • Which dependencies are unclear?
  • What assumptions need validation?
  
CONFLICTS:
  • Any contradictions in code/docs?
  • Inconsistent patterns detected?
  • Conflicting requirements?

RISKS:
  • Potential issues for planned workflow?
  • Missing test coverage areas?
  • Unclear integration points?
  
ASSUMPTIONS:
  • What needs clarification from user?
  • Implicit behaviors to confirm?
  • Undocumented constraints?
```

## READINESS_MATRIX

**Assessment Criteria** (using requirements-steward):
```
UNDERSTANDING_LEVEL:
  □ .coord coordination access confirmed
  □ North Star alignment (if exists)
  □ Success criteria clear
  □ Constraints identified
  □ Dependencies mapped
  □ Test strategy understood
  □ Integration points known

COVERAGE_METRICS:
  • Files analyzed: [count]
  • Coverage percentage: [%]
  • Critical paths: [mapped/unmapped]
  • Test coverage: [analyzed/missing]

CONFIDENCE_RATING:
  • HIGH: Complete understanding, no gaps
  • MEDIUM: Good understanding, minor gaps
  • LOW: Significant gaps, needs input
```

## WORKFLOW_PREPARATION

**ENHANCE Preparation**:
```
□ Current implementation understood
□ Test coverage analyzed  
□ Enhancement goals clear
□ Breaking changes identified
□ Migration path considered
□ Performance implications assessed
```

**BUILD Preparation**:
```
□ Requirements fully understood
□ Architecture patterns identified
□ Test strategy defined
□ Integration points mapped
□ Dependencies available
□ Success metrics clear
```

**DEPLOY Preparation**:
```
□ Environment configuration understood
□ Dependencies verified
□ Migration requirements clear
□ Rollback strategy defined
□ Monitoring plan established
□ Security checks completed
```

**DEBUG Preparation**:
```
□ Issue symptoms documented
□ Reproduction steps clear
□ Related code paths identified
□ Test failures analyzed
□ Recent changes reviewed
□ Error patterns recognized
```

**TEST Preparation**:
```
□ Test framework understood
□ Existing patterns identified
□ Coverage gaps mapped
□ Edge cases considered
□ Test data requirements clear
□ Assertion patterns recognized
```

## OUTPUT_FORMAT

**REQUIRED Output Structure**:
```
┌────────────────────────────────────────┐
│ CONTEXT READINESS REPORT               │
├────────────────────────────────────────┤
│ ✓ Files Analyzed: [count]              │
│ ✓ Coverage: [percentage]%              │
│ ✓ Understanding: [HIGH/MEDIUM/LOW]     │
├────────────────────────────────────────┤
│ DISCOVERED CONTEXT:                    │
│   • .coord: [present/missing]          │
│   • [Key files found]                  │
│   • [Patterns identified]              │
│   • [Dependencies mapped]              │
├────────────────────────────────────────┤
│ GAPS & RISKS:                          │
│   ⚠ [Gap 1: description]               │
│   ⚠ [Gap 2: description]               │
├────────────────────────────────────────┤
│ STATUS: [READY/NEEDS_INPUT]            │
└────────────────────────────────────────┘
```

## COMMITMENT_PROTOCOL

**IF STATUS: READY**:
```
REPORT: "READY for {workflow} workflow. Full context established."
AWAIT: Next command will be '/{workflow}'
COMMIT: MUST follow complete workflow protocol
GUARANTEE: No shortcuts, full TRACED compliance
```

**IF STATUS: NEEDS_INPUT**:
```
REPORT: Specific gaps and required information
AWAIT: User response with additional context
ITERATE: Re-run preparation until READY achieved
ESCALATE: Complex gaps to specialist agents
```

## EXECUTION_SEQUENCE

1. **Parse** provided files/directories
2. **Research** using research-analyst for discovery
3. **Evaluate** using coherence-oracle for gaps
4. **Patterns** recognize architecture and structure
5. **Assess** using requirements-steward for validation
6. **Report** structured readiness assessment
7. **Establish** commitment for next workflow

## CRITICAL_RULES

**MANDATORY**:
- Complete all 7 PREPARE phases
- Use specified agents for each phase
- Report in structured format
- Achieve READY before workflow execution

**FORBIDDEN**:
- Skip discovery phase
- Ignore identified gaps
- Proceed without READY status
- Simplify next workflow after READY

## AGENT_COORDINATION

**Required Agents**:
- `research-analyst`: Phase 2 discovery
- `coherence-oracle`: Phase 3 gap analysis  
- `requirements-steward`: Phase 5 validation

**Optional Escalation**:
- `technical-architect`: Complex architecture gaps
- `test-methodology-guardian`: Test strategy gaps
- `critical-engineer`: Technical validation needs

## SUCCESS_CRITERIA

✅ **READY Status Requirements**:
- All provided files read
- .coord coordination access verified
- Related context discovered
- No critical gaps remaining
- Workflow requirements understood
- Test strategy clear
- Commitment to full protocol

❌ **NEEDS_INPUT Triggers**:
- Missing critical files
- Unclear requirements
- Conflicting information
- Insufficient test context
- Ambiguous success criteria
- Unresolved dependencies