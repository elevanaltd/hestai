# Capabilities

PURPOSE:
- Define and standardize role capabilities, including skills and system matrices
- Provide normative 5D capability matrices that drive weaving and validation
- Ensure Functional Reliability is explicitly assessed and enforced

FILE_TYPES:
- SYSTEM-MATRIX-*.oct.md: canonical 5D matrices
- SYSTEM-PATTERNS-*.oct.md: universal patterns and literacy
- SYSTEM-SKILL-*.oct.md: specific operational abilities

5D MATRICES (canonical):
- 150-SYSTEM-MATRIX-IMPLEMENTATION.oct.md
- 151-SYSTEM-MATRIX-CODE-REVIEW.oct.md
- 152-SYSTEM-MATRIX-GOVERNANCE-QUALITY.oct.md
- 153-SYSTEM-MATRIX-VALIDATOR.oct.md

USAGE IN ROLES:
- Import via weaving aliases (preferred):
  - lib://capabilities/implementation
  - lib://capabilities/review
  - lib://capabilities/governance
  - lib://capabilities/validator
- Or direct paths under ../04-capabilities

MANDATORY CONVENTIONS:
- Functional Reliability (FR) must be scored ≥ 2 for any pass
- Claims→Checks→Artifacts→Status required for all major assertions
- Use archetype weaving to add behavioral/output signals automatically

