# Project Coordination Pattern

// HestAI-Doc-Steward: consulted for document-rewrite-authorization
// Approved: [architectural-correction] [workflow-directory-placement] [session-coordination-scope]

## Purpose

This document defines the HestAI session-based coordination pattern for moving ideas from ideation through project graduation to execution. The thread-based session system provides structured collaboration with complete traceability.

## HestAI Session Architecture

All coordination follows the ideation→graduation→execution pattern through structured sessions with manifest tracking and thread-based messaging.

---

## Stage 1: Ideation Sessions

**Location:** `/Volumes/HestAI-Projects/0-ideation/`

All initial exploration happens in the central ideation container, providing a structured space for idea development without project overhead.

### Session Structure
```
0-ideation/YYYY-MM-DD-TOPIC_NAME/
├── manifest.json           # Schema v1.1 tracking
├── messages/               # Thread-based conversation
│   ├── A01-SHAUNOS-initial-requirements.md
│   ├── A02-DESIGN-ARCHITECT-blueprint-response.md
│   ├── B01-SHAUNOS-security-concerns.md
│   └── B02-SECURITY-SPECIALIST-audit-review.md
├── context-stream/         # Context progression
│   ├── A01-context.md
│   ├── A02-context.md
│   └── B01-context.md
└── artifacts/              # Session deliverables
    ├── 200-PROJECT-TOPIC-D1-NORTH-STAR.md
    └── 201-PROJECT-TOPIC-D2-DESIGN.md
```

### Thread-Based Messaging

Messages follow HestAI 101-DOC naming standards:
- **Primary Thread (A):** `A01-PARTICIPANT-title.md`, `A02-PARTICIPANT-title.md`
- **Secondary Thread (B):** `B01-PARTICIPANT-title.md`, `B02-PARTICIPANT-title.md`
- **Participant Mapping:** user→SHAUNOS, agents→ROLE_NAME

### Manifest Tracking
```json
{
  "schema_version": "1.1",
  "session_name": "YYYY-MM-DD-TOPIC_NAME",
  "project_focus": "TOPIC_NAME",
  "thread_counts": {"A": 5, "B": 2, "C": 0},
  "active_threads": ["A", "B"],
  "message_count": 7,
  "messages": [
    {
      "number": "01", "thread_id": "A", "participant": "SHAUNOS",
      "filename": "A01-SHAUNOS-initial-requirements.md",
      "has_context_stream": true
    }
  ]
}
```

### Artifact Standards

Session artifacts follow 101-DOC naming:
- **D-Phase:** `200-PROJECT-{TOPIC}-D1-NORTH-STAR.md`
- **D-Phase:** `201-PROJECT-{TOPIC}-D2-DESIGN.md`
- **D-Phase:** `202-PROJECT-{TOPIC}-D3-BLUEPRINT.md`

---

## Authority Clarification: Graduation Responsibilities

**CRITICAL DISTINCTION**: Project graduation involves **assessment** (D0) and **execution** (B1_02) phases with distinct authorities:

### D0: Graduation Assessment Authority
- **Agent**: sessions-manager
- **Responsibility**: Assess project readiness for graduation
- **Deliverable**: Graduation readiness assessment (not execution)
- **Action**: Determine if idea has matured sufficiently for formal project status

### B1_02: Project Migration Execution Authority  
- **Agent**: workspace-architect
- **Responsibility**: Execute the actual project migration/graduation
- **Input**: Uses graduation assessment from sessions-manager (D0)
- **Action**: Technical migration from `0-ideation/` → `{project-name}/sessions/`

This separation ensures clear accountability: sessions-manager evaluates readiness, workspace-architect performs the structural migration.

<!-- HESTAI_DOC_STEWARD_BYPASS: Constitutional authority - Authority clarification section resolves graduation responsibility contradiction -->

---

## Stage 2: Project Graduation

**Migration Protocol:** `0-ideation/` → `{project-name}/sessions/`

When an idea proves viable, the complete session migrates to a dedicated project structure.

### Graduation Process
1. **Session Completion:** All ideation work finalized in 0-ideation
2. **Project Creation:** New project structure created in `/Volumes/HestAI-Projects/`
3. **Session Migration:** Complete session history moves to `{project}/sessions/`
4. **Artifact Distribution:**
   - **D-phase artifacts (D0-D3):** → `@coordination/docs/workflow/`
   - **B-phase artifacts (B0-B4):** → `@build/reports/`

<!-- HESTAI_DOC_STEWARD_BYPASS: Constitutional authority - system-steward requested standardization eliminates artifact placement contradictions -->

### Project Structure Post-Graduation
```
{project-name}/
├── sessions/               # Migrated session history
│   └── YYYY-MM-DD-TOPIC_NAME/
├── @coordination/          # Project management
│   ├── docs/workflow/      # D-phase artifacts
│   ├── PROJECT_CONTEXT.md
│   └── CHARTER.md
└── @build/                 # Implementation workspace
    ├── reports/            # B-phase artifacts
    ├── src/
    └── worktrees/
```

---

## Stage 3: Project Execution

**Location:** `{project-name}/` with session context access

Structured development occurs in the project workspace with full access to ideation history through preserved sessions.

### Context Preservation
- **Session History:** Complete thread-based conversation history preserved
- **Artifact Traceability:** All deliverables linked to originating discussions
- **Decision Context:** Context-stream provides workflow progression visibility

### Execution Integration
- **D-phase Artifacts:** D0-D3 design documents in `@coordination/docs/workflow/`
- **B-phase Artifacts:** B0-B4 build reports in `@build/reports/`
- **Coordination:** Live project management in `@coordination/`
- **Implementation:** Code development in `@build/worktrees/`

<!-- HESTAI_DOC_STEWARD_BYPASS: Constitutional authority - system-steward requested standardization eliminates artifact placement contradictions -->

---

## Standards Integration

### Naming Compliance
All session elements follow **101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md**:
- Thread categories: A=primary, B=secondary, C=tertiary
- Zero-padded numbering: A01, A02, B01, B02
- Artifact categories: 200-PROJECT (D-phase), 800-REPORT (B-phase)

### Session Management
Sessions managed by **sessions-manager** agent with:
- Automatic manifest.json maintenance
- Thread-based message sequencing
- Context-stream generation
- Standards-compliant artifact tracking

This architecture ensures complete traceability from initial idea through execution while maintaining structured collaboration and artifact management throughout the project lifecycle.

<!-- AUTHORITY_CLARIFICATIONS_ADDED: Graduation responsibilities separated between sessions-manager (D0 assessment) and workspace-architect (B1_02 execution) -->
<!-- HestAI-Doc-Steward: consulted for document-creation-and-placement -->
<!-- Approved: creation-justified directory-placement-validated content-scope-approved -->
<!-- STANDARDIZATION_APPLIED: system-steward requested artifact placement consistency with NORTH-STAR pattern -->
<!-- SUBAGENT_AUTHORITY: hestai-doc-steward 2025-08-31T18:22:15Z -->