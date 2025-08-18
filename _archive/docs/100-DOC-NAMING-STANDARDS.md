Status: Archived → superseded by docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md
Archived: 2025-08-17
Original-Path: docs/100-DOC-NAMING-STANDARDS.md

# Naming Standard (Draft for Approval)

Status: Archived (superseded)
Scope: Documentation naming convention
Decision Scope: This file proposed the filename pattern only. It has been archived to preserve review history.

Proposed Pattern
- {CATEGORY}{NN}-{CONTEXT[-QUALIFIER]-NAME}.{EXT}
  - CATEGORY: 1 digit (0–9) → category family (see Category Map)
  - NN: 2 digits (00–99) → sequence within category (zero-padded)
  - CONTEXT: one from curated set (see Context Tokens)
  - QUALIFIER (optional): single token, only if needed to avoid collisions
  - NAME: concise UPPERCASE-WITH-HYPHENS
  - EXT: .md for prose, .oct.md for compressed canonical artifacts

Category Map (initial)
- 0xx Core Architecture & Design
- 1xx System Standards & Conventions
- 2xx Project Management & Planning
- 3xx UI/UX Specifications
- 4xx Security & Compliance
- 5xx Runtime / Ops
- 6xx Data / Analytics
- 7xx Integration / External Systems
- 8xx Reports & Audits
- 9xx Miscellaneous / Experimental

Context Tokens (curated set)
- DOC, SYSTEM, PROJECT, SCRIPT, AUTH, UI, RUNTIME, DATA, SEC, OPS, BUILD, REPORT

Author Rules (minimal)
1) Pick category (0xx–9xx) first; then the next available NN within that category.
2) Do not reuse numbers once published; if misfiled, reassign to correct category with a new number.
3) CONTEXT is mandatory for ambiguous names (e.g., NORTH-STAR, VAD, BUILD-PLAN, CONFIG/SETUP/README).
4) QUALIFIER is optional; use only to avoid collisions. One token max.
5) Use .oct.md for compressed, high-signal canonical artifacts; otherwise .md.

Examples
- 103-DOC-NORTH-STAR.oct.md
- 114-DOC-NAMING-STANDARDS.md
- 214-PROJECT-BUILD-PLAN.md
- 322-UI-GUIDELINES.md
- 406-SEC-POLICY.md
- 510-OPS-CHECKLIST.md
- 501-RUNTIME-OT-ADR.md (QUALIFIER=OT)

Approval Checklist (for you)
- Pattern structure acceptable? {CATEGORY}{NN}-{CONTEXT[-QUALIFIER]-NAME}.{EXT}
- Category Map sufficient as an initial set?
- Context token list acceptable as-is (12 tokens) or changes needed?
- Examples align with intent?

Superseded by
- docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md

