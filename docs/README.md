# HestAI Documentation Hub

This directory contains the complete operational standards, workflows, and enforcement mechanisms for the HestAI system.

The documentation is organized into two primary areas:

## 1. `/workflow` - The "How" of Operations
**Purpose:** Defines the end-to-end project lifecycle, agent roles, prompts, and enforcement mechanisms that govern our process.

### Core Workflow Documents
- **[000-WORKFLOW-ENFORCEMENT-MATRIX.md](./workflow/000-WORKFLOW-ENFORCEMENT-MATRIX.md)**: The single source of truth for all rule enforcement mechanisms. **START HERE** to understand what is enforced.
- **[001-WORKFLOW-NORTH-STAR.md](./workflow/001-WORKFLOW-NORTH-STAR.md)**: The complete 8-phase project workflow (D1-B4) with RACI charts and specialist roles.
- **[002-WORKFLOW-PROMPTS.md](./workflow/002-WORKFLOW-PROMPTS.md)**: Standardized prompts for each specialist agent in the workflow.
- **[004-WORKFLOW-HOOKS-GUIDE.md](./workflow/004-WORKFLOW-HOOKS-GUIDE.md)**: The complete guide to managing and referencing our automated quality hooks.

### Process & Structure
- **[003-WORKFLOW-ERROR-HANDLING.md](./workflow/003-WORKFLOW-ERROR-HANDLING.md)**: Systematic error resolution and escalation procedures.
- **[005-WORKFLOW-DIRECTORY-STRUCTURE.md](./workflow/005-WORKFLOW-DIRECTORY-STRUCTURE.md)**: Bridge/build content separation and repository organization.
- **[006-WORKFLOW-LINK-STANDARDS.md](./workflow/006-WORKFLOW-LINK-STANDARDS.md)**: Link validation, cross-repo references, and migration safety.
- **[008-WORKFLOW-LLM-CONSTELLATION-PROPOSAL.md](./workflow/008-WORKFLOW-LLM-CONSTELLATION-PROPOSAL.md)**: Multi-model collaboration architecture.

## 2. `/standards` - The "What" of Assets
**Purpose:** Defines canonical rules for documentation, naming, security, and data management.

### Documentation Standards
- **[100-DOC-NORTH-STAR.oct.md](./standards/100-DOC-NORTH-STAR.oct.md)**: The core principles of our documentation philosophy.
- **[101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md](./standards/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md)**: Rules for file naming, directory structure, and repository profiles.
- **[102-DOC-ARCHIVAL-RULES.md](./standards/102-DOC-ARCHIVAL-RULES.md)**: Document lifecycle management and archival procedures.
- **[103-DOC-OCTAVE-COMPRESSION-RULES.md](./standards/103-DOC-OCTAVE-COMPRESSION-RULES.md)**: OCTAVE format compression guidelines and standards.
- **[104-DOC-ENFORCEMENT-GATES.md](./standards/104-DOC-ENFORCEMENT-GATES.md)**: Technical implementation of documentation hooks and validators.
- **[105-DOC-ASSUMPTION-MANAGEMENT.md](./standards/105-DOC-ASSUMPTION-MANAGEMENT.md)**: Systematic assumption tracking and validation protocols.

### Security Standards
- **[/standards/security/](./standards/security/)**: Contains the complete Security-First integration architecture.
  - **[106-SEC-WORKFLOW-INTEGRATION-ARCHITECTURE.md](./standards/security/106-SEC-WORKFLOW-INTEGRATION-ARCHITECTURE.md)**: Security integration patterns and architectural guidelines.
  - **[107-SEC-PROMPTING-LIBRARY.md](./standards/security/107-SEC-PROMPTING-LIBRARY.md)**: Security-aware prompting templates and patterns.
  - **[108-SEC-SPECIALIST-ENHANCEMENT.md](./standards/security/108-SEC-SPECIALIST-ENHANCEMENT.md)**: Security specialist role definitions and capabilities.
  - **[109-SEC-IMPLEMENTATION-GUIDE.md](./standards/security/109-SEC-IMPLEMENTATION-GUIDE.md)**: Practical security implementation and deployment guide.

---

## Quick Navigation

### New to HestAI?
1. Start with [000-WORKFLOW-ENFORCEMENT-MATRIX.md](./workflow/000-WORKFLOW-ENFORCEMENT-MATRIX.md) to understand our quality enforcement
2. Review [001-WORKFLOW-NORTH-STAR.md](./workflow/001-WORKFLOW-NORTH-STAR.md) for the complete project lifecycle
3. Check [101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md](./standards/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.md) for naming conventions

### Working on a Project?
1. Use [001-WORKFLOW-NORTH-STAR.md](./workflow/001-WORKFLOW-NORTH-STAR.md) to identify your current phase (D1-B4)
2. Consult [002-WORKFLOW-PROMPTS.md](./workflow/002-WORKFLOW-PROMPTS.md) for specialist agent interactions
3. Reference [004-WORKFLOW-HOOKS-GUIDE.md](./workflow/004-WORKFLOW-HOOKS-GUIDE.md) for quality gate management

### Setting up Infrastructure?
1. Review [004-WORKFLOW-HOOKS-GUIDE.md](./workflow/004-WORKFLOW-HOOKS-GUIDE.md) for hook installation and management
2. Check [104-DOC-ENFORCEMENT-GATES.md](./standards/104-DOC-ENFORCEMENT-GATES.md) for technical implementation
3. Consult [/standards/security/](./standards/security/) for security integration requirements

### Troubleshooting?
1. Use [003-WORKFLOW-ERROR-HANDLING.md](./workflow/003-WORKFLOW-ERROR-HANDLING.md) for systematic error resolution
2. Check [000-WORKFLOW-ENFORCEMENT-MATRIX.md](./workflow/000-WORKFLOW-ENFORCEMENT-MATRIX.md) for enforcement status
3. Review [004-WORKFLOW-HOOKS-GUIDE.md](./workflow/004-WORKFLOW-HOOKS-GUIDE.md) for hook debugging

---

## Governance & Evolution

This structure is governed by:
- **[005-WORKFLOW-DIRECTORY-STRUCTURE.md](./workflow/005-WORKFLOW-DIRECTORY-STRUCTURE.md)**: Repository organization principles
- **[006-WORKFLOW-LINK-STANDARDS.md](./workflow/006-WORKFLOW-LINK-STANDARDS.md)**: Cross-reference and link management

The documentation evolves through the workflow processes defined in the `/workflow` directory, with quality enforcement managed through the mechanisms detailed in `/standards`.

---

*This documentation hub provides comprehensive coverage of the HestAI operational system. All standards are actively enforced through automated hooks and quality gates as detailed in the enforcement matrix.*


