# Assumption Management Framework

**Status:** Final  
**Purpose:** Systematic approach to detecting, flagging, and validating assumptions in workflow execution  
**Scope:** All phases where agent interpretation may diverge from explicit user requirements  
**Authority:** Prevents misdirection through assumption detection and validation

## The Assumption Problem

**Core Issue:** The largest source of build misdirection comes from assumptions made during requirement interpretation without explicit user validation.

**Pattern Recognition:**
- User says X
- Agent interprets as Y (assumption)
- Work proceeds on Y
- Final delivery misses user's actual intent (X)

**High-Risk Phases:**
- D1: North Star establishment (assumptions about user intent)
- D2: Solution ideation (assumptions about preferred approaches)
- D3: Architecture (assumptions about technical constraints)

## Solution Strategies

### Strategy 1: Conversation Preservation System
**Approach:** Maintain full conversation context for traceability

**Implementation Options:**
- Session capture with conversation indexing
- Quote-linking from North Star back to user statements
- Conversation analyzer agent for assumption detection

**Pros:**
- Complete traceability of decisions to user words
- Automatic assumption detection through pattern analysis
- Valuable for complex, multi-session projects

**Cons:**
- System complexity overhead
- May create dependency on tooling
- Unclear ROI for simple projects

See /Volumes/HestAI/sessions/2025-07-18-HERMES_V2_DESIGN/artifacts/000_NORTH_STAR.md as exmaple of possible way to implement this

### Strategy 2: User Responsibility Model
**Approach:** Place final validation responsibility with user

**Implementation:**
- User validates North Star against their intent
- Clear user sign-off required on requirements
- Simple accountability chain

**Pros:**
- User has final authority anyway
- No system complexity
- Forces user engagement with their requirements

**Cons:**
- Assumes user will catch all assumption drift
- May miss subtle interpretation errors

### Strategy 3: Assumption Detection Gates
**Approach:** Systematic assumption flagging at critical workflow points

**Implementation:**
- Mandatory assumption audits at phase transitions
- Agent self-reflection on interpretation choices
- Explicit assumption documentation and user validation

**Pros:**
- Lightweight system intervention
- Focuses on high-risk transition points
- Balances automation with user control

**Cons:**
- Relies on agent self-awareness
- May miss unconscious assumptions

### Strategy 4: Hybrid Validation System
**Approach:** Multi-layer assumption management

**Implementation:**
- Conversation context for complex projects
- Assumption detection gates for all projects
- User validation as final authority

**Pros:**
- Comprehensive coverage
- Scalable complexity based on project needs
- Multiple safety nets

**Cons:**
- Most complex implementation
- Risk of over-engineering

## Current Working State: Assumption Detection Gate

**Selected Strategy:** Strategy 3 - Assumption Detection Gates

**Implementation:** Systematic agent self-reflection at critical points

### Assumption Detection Protocol

**Trigger Points:**
- End of D1 (North Star creation)
- End of D2 (Solution approach)
- End of D3 (Architecture specification)
- Any major decision or interpretation

**Detection Questions:**
1. "Did I make any assumptions when creating this?"
2. "What did the user explicitly state vs. what did I interpret?"
3. "Where did I fill in gaps that the user didn't specify?"
4. "What choices did I make that the user might disagree with?"

**Output Format:**
```
## Assumptions Made

**Explicit User Requirements:**
- [Direct quotes or clear statements from user]

**Assumptions & Interpretations:**
- [List each assumption with rationale]
- [Flag areas where user clarification needed]

**Validation Required:**
- [Specific questions for user confirmation]
```

### Implementation Methods

**Option A: Agent Protocol Enhancement**
- Add assumption detection to existing role protocols
- Mandatory self-audit before deliverable submission
- Built into role completion criteria

**Option B: Dedicated Detection Agent**
- Create assumption-detector specialist agent
- Invoke at critical transition points
- Reviews work products for unstated assumptions

**Option C: Hook/Gate System**
- Pre-deliverable hook that triggers assumption audit
- Blocks completion until assumptions documented
- Automated enforcement like naming standards

**Option D: Assumption Check Tool Integration**
- Use dedicated assumption_check tool (planned for zen-mcp-server)
- Simple, focused assumption detection without context complexity
- Integration with existing workflow tools

## Recommended Implementation: Option A + Option D

**Primary:** Enhance existing role protocols with mandatory assumption detection (only for roles with clear deliverables after discussion)
**Secondary:** Use assumption_check tool for systematic assumption analysis when needed

### Enhanced Role Protocol Pattern

**For all critical deliverables, roles must include:**

```markdown
## Assumption Audit

**User Explicitly Stated:**
- [Direct requirements from user]

**My Interpretations/Assumptions:**
- [Areas where I made choices or filled gaps]

**Clarification Needed:**
- [Questions for user validation]
```

### Assumption Check Tool Integration

**For systematic assumption analysis:**
```
assumption_check: "Review this deliverable for assumptions made during creation. 
Identify areas where I interpreted, inferred, or filled gaps beyond explicit user statements."
```

**Note:** assumption_check tool is planned for zen-mcp-server implementation - does not currently exist

## Success Metrics

**Immediate Targets:**
- 100% of critical deliverables include assumption audit
- Zero major misdirection from unvalidated assumptions
- User confirmation on all flagged interpretations

**Quality Indicators:**
- Reduced rework from misunderstood requirements
- Faster user validation cycles
- Higher final delivery satisfaction

**Anti-Patterns to Prevent:**
- Delivering without assumption documentation
- Assuming user intent without validation
- Building on unconfirmed interpretations

## Evolution Path

**Phase 1:** Implement assumption detection in role protocols
**Phase 2:** Add ZEN tool integration for complex analysis
**Phase 3:** Consider conversation preservation for high-value projects
**Phase 4:** Evaluate need for automated detection systems

## Integration with Existing Systems

**Workflow Integration:**
- Assumption audits required at quality gates
- North Star validation includes assumption review
- RACI roles include assumption detection responsibilities

**Documentation Standards:**
- All critical deliverables include assumption sections
- Clear separation of explicit vs. interpreted requirements
- User validation checkpoints documented

**Enforcement:**
- Quality gates check for assumption documentation
- Roles cannot complete without assumption audit
- User sign-off required on flagged assumptions

---

**Implementation Authority:** Assumption Management Protocol  
**Validation Requirements:** User confirmation of all documented assumptions  
**Review Cycle:** Evaluate effectiveness after 10 projects  
**Status:** Ready for immediate implementation in workflow protocols