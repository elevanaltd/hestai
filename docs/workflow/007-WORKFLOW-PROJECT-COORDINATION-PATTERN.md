# 007: Project Coordination Pattern

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

## Stage 2: Project Graduation

**Migration Protocol:** `0-ideation/` → `{project-name}/sessions/`

When an idea proves viable, the complete session migrates to a dedicated project structure.

### Graduation Process
1. **Session Completion:** All ideation work finalized in 0-ideation
2. **Project Creation:** New project structure created in `/Volumes/HestAI-Projects/`
3. **Session Migration:** Complete session history moves to `{project}/sessions/`
4. **Artifact Distribution:**
   - D1-D3 artifacts → `@coordination/docs/workflow/`
   - B1-B4 artifacts → `@build/reports/`

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
- **Build Phases:** B0-B4 artifacts stored in `@build/reports/`
- **Coordination:** Live project management in `@coordination/`
- **Implementation:** Code development in `@build/worktrees/`

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

<!-- HestAI-Doc-Steward: consulted for document-creation-and-placement -->
<!-- Approved: creation-justified directory-placement-validated content-scope-approved -->