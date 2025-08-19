# DOC-ARCHIVAL-RULES

Status: Final
Scope: Rules for archiving documentation artifacts in this repository
Audience: All contributors (Org and Code profiles)

Purpose
- Enforce a single source of truth while preserving history.
- Prevent draft proliferation; keep the main tree clean and scannable.

Archive Location
- Use a parallel tree rooted at: _archive/
- Mirror the original relative path under _archive/.
  - Example: docs/103-DOC-NORTH-STAR.oct.md → _archive/docs/103-DOC-NORTH-STAR.oct.md

What to Archive
- Retired or superseded standards, guides, ADRs, and reports.
- Review-only interim drafts created during a PR (if any existed) — move to _archive/ and replace originals with a pointer (or delete, per PR decision).
- Do NOT archive ephemeral sessions: prefer deleting sessions/ content after it’s no longer useful.

What NOT to Archive
- Active canonical standards (keep in docs/)
- Code (src/, tests/, builds/, lib/) — use VCS history and deprecate via code mechanisms

Required Archive Header (first lines)
- Status: Archived → superseded by <relative-link-to-successor>
- Archived: <YYYY-MM-DD>
- Original-Path: <original relative path>

Example Header
Status: Archived → superseded by docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS.oct.md
Archived: 2025-08-17
Original-Path: docs/100-DOC-NAMING-STANDARDS.md

Filename & Prefix Rules
- Preserve the entire original filename and prefix when archiving.
- Do NOT renumber files in the archive.
- Do NOT edit the archived content beyond adding the required header.

Superseding Workflow (canonical → archive)
1) Update the canonical document with the new, approved content.
2) Move the prior canonical document to _archive/<same-relative-path>.
3) Add the Required Archive Header to the archived file.
4) Optionally add a one-line pointer stub file in the original location for 1–2 releases (then remove).
5) Ensure links in other docs are updated to the new canonical.

Pointer Stubs (optional, temporary)
- When replacing a file in-place, create a minimal file at the old path with:
  - Title: Archived: <original-title>
  - One line: "Superseded by <new-canonical-path>"
- Remove pointer stubs within two release cycles to avoid clutter.

Deletion vs. Archiving
- Prefer archiving over deletion for documents that were referenced or reviewed.
- Delete only if the document was never referenced, never merged, and adds no historical value.

Reports and Dates
- Reports may include an ISO date prefix when chronology materially matters.
- When archiving a report, keep any date prefix intact.

CI/Pre-commit Enforcement (guidance)
- Reject PRs that rename files during archiving (prefix must remain intact).
- Require Required Archive Header in any file under _archive/.
- Forbid edits to archived content beyond the header lines (hash comparison allowed).
- Forbid multiple canonical files for the same standard (heuristic: CONTEXT & NAME collision); require archiving the older one.

Profiles (Org vs Code)
- Same archive rules apply. Only the eligible directories differ by profile.
- Org: archive docs/, reports/ materials.
- Code: additionally archive docs/adr/ and reports/; code deprecation is handled via code processes.

Rationale
- Keeps the primary tree concise and the history intact.
- Plays well with LLM retrieval (prevents embedding stale content).
- Git remains the ground truth for diffs; archive is for human discoverability and link stability.

