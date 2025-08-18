# docs/ README

Purpose
- Quick reference for documentation structure, profiles, and naming.

Profiles
- Org profile (documentation-first repos): required dirs docs/, reports/, _archive/; optional sessions/, scripts/
- Code profile (code + docs repos): required dirs src/, tests/, docs/, docs/adr/, reports/, _archive/; optional builds/, lib/, sessions/, scripts/

Top-level directories (intent)
- docs/: canonical standards, guides, ADR index
- reports/: time-bound analyses, audits, retros
- _archive/: retired docs; preserve original prefixes
- sessions/ (optional): raw notes, explorations, scratch
- scripts/ (optional): tooling scripts (hooks, generators)

Naming pattern
- {CATEGORY}{NN}-{CONTEXT[-QUALIFIER]-NAME}.{EXT}
  - CATEGORY{NN}: 3-digit range taxonomy (first digit family; next two sequence)
  - CONTEXT: DOC, SYSTEM, PROJECT, SCRIPT, AUTH, UI, RUNTIME, DATA, SEC, OPS, BUILD, REPORT
  - QUALIFIER: optional (single token) only to disambiguate
  - NAME: UPPERCASE-WITH-HYPHENS (hyphens only)
  - EXT: md or oct.md (compressed canonical)

Nesting rule (docs/)
- Max depth = 2 (e.g., docs/adr/401-SEC-AUTHZ-MODEL.md)
- Prefer shallow tree + rich filenames over deep nesting

Anti-proliferation
- One canonical standards doc: 101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md
- Use Git branches/PRs for review. Do not create parallel numbered drafts.

Anchors
- 1xx-DOC-NORTH-STAR.oct.md
- 1xx-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md

Examples
- 103-DOC-NORTH-STAR.oct.md
- adr/401-SEC-AUTHZ-MODEL.md
- reports/801-REPORT-SECURITY-AUDIT.oct.md


