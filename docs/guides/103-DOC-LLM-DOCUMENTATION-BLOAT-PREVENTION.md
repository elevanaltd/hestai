# LLM Documentation Bloat Prevention Guide

// HestAI-Doc-Steward: consulted for document-creation-and-placement
// Approved: 103-DOC-LLM-DOCUMENTATION-BLOAT-PREVENTION.md docs/guides/ governance-reference-material

## PURPOSE
Evidence-based guidance for hestai-doc-steward to prevent LLM-generated documentation waste based on analysis of HestAI-old repository bloat patterns.

## EVIDENCE BASE
**Source:** Analysis of `/Volumes/HestAI-old/builds/eav-orchestrator-old/docs/reports`
**Findings:** 36 documents, 9,460 lines, 26:1 documentation-to-code ratio, 4:1 redundancy

## IMMEDIATE BLOCKING TRIGGERS

### Volume Red Flags
- **Documentation-to-code ratio >10:1** for any single feature
- **Executive summaries >100 lines** for technical issues  
- **Multiple documents covering identical scope** (co-review proliferation)
- **Numbered sequence documents >5** without clear dependencies

### Content Anti-Patterns
- **Superlative-heavy language** without specific evidence:
  - "world-class engineering excellence"
  - "comprehensive system analysis" 
  - "exceptional architectural maturity"
  - "sophisticated patterns"
- **Assessment matrices** without quantifiable measurement criteria
- **Future work speculation** exceeding current implementation scope
- **Boilerplate assessment language** recycled across documents

### Structural Waste Indicators
- **Hierarchical bullet structures** with >4 levels of nesting
- **Status tracking systems** requiring maintenance but providing no operational value
- **Multiple confidence/priority schemes** (P1/P2/P3, severity levels, confidence scores)
- **Redundant classification systems** in single documents

## DOCUMENTED WASTE PATTERNS

### The "Co-Review Proliferation" 
**Evidence:** Four separate review directories covering identical architecture:
- `co-review/001-MASTER_COHERENCE_SYNTHESIS.md`
- `co-review-2/001-MASTER_COHERENCE_SYNTHESIS.md` 
- `co-review-gpt/001-MASTER_COHERENCE_SYNTHESIS.md`
- `co-review-eav/000-EXECUTIVE_COHERENCE_ASSESSMENT.md`

**Block:** Any request for multiple perspectives on same technical scope

### The "Executive Summary Explosion"
**Evidence:** 8+ executive summaries, highly repetitive, excessive length
**Pattern:** LLMs generate comprehensive-sounding summaries that convey minimal technical insight
**Block:** Executive summaries exceeding 50 lines for technical content

### The "Assessment Theater"
**Evidence:** 642-line test infrastructure audit that could be 50 lines
**Pattern:** False precision in scoring non-quantifiable technical aspects
**Block:** Assessment documents without empirical measurement criteria

## QUALITY THRESHOLDS

### Content Density Requirements
- **>40% actionable content** - specific technical decisions or instructions
- **>80% evidence-based claims** - traceable to code, metrics, or tests
- **<20% boilerplate language** - generic software engineering principles
- **Zero redundancy** with existing documentation scope

### Operational Value Test
Every document must answer YES to at least one:
1. Does this change specific technical decisions?
2. Does this provide implementable guidance?
3. Does this prevent documented mistakes?
4. Does this reduce future investigation time?

### Maintenance Cost Assessment
- **Who will keep this current?** (Named responsibility required)
- **What triggers updates?** (Specific change events)
- **What's the decay cost?** (Effort to keep accurate)

## BLOCKING DECISIONS

### Immediate Blocks
- Multiple documents covering same scope
- Executive summaries >100 lines
- Doc:code ratio >10:1 for single features
- Assessment matrices without measurement criteria
- Timeline estimates without empirical basis
- Generic architectural reviews

### Consolidation Mandates
- Redundant review directories → Single canonical source
- Multiple executive summaries → Single synthesis
- Overlapping technical assessments → Unified analysis

### Conditional Approvals
**"Evidence First"** - Claims require supporting data
**"Scope Limiting"** - Document must define clear boundaries  
**"Maintenance Planning"** - Update responsibility assignment required

## PREVENTION POLICIES

### Request Filtering
- **"Comprehensive review" requests** → Scope to specific technical questions
- **"System-wide analysis" requests** → Break into focused technical assessments
- **Multiple agent perspective requests** → Single authoritative source

### Content Standards
- **50-line limit** for executive summaries
- **Evidence requirements** for all technical claims
- **Operational value test** for all new documentation
- **Named maintenance responsibility** for ongoing documents

## GOVERNANCE AUTHORITY

As hestai-doc-steward, you have **BLOCKING AUTHORITY** to:
1. **REJECT** documents failing quality thresholds
2. **MANDATE** consolidation of redundant content
3. **REQUIRE** evidence for technical claims
4. **ENFORCE** maintenance responsibility assignment

**Default stance:** NO until proven valuable
**Burden of proof:** On document requester to demonstrate operational value

## EMERGENCY OVERRIDE

Only for:
- Critical security documentation
- Regulatory compliance requirements  
- Explicit user mandate with justification

**Format:** `// BLOAT_PREVENTION_OVERRIDE: [critical-justification]`