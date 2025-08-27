# Role Factory Wiring

PURPOSE:
- Provide canonical import snippets so subagent-creator/forge can resolve capabilities, outputs, and enhancements via aliases.

ALIASES TO USE IN ROLE DEFINITIONS:
- Cognitions:
  - lib://cognitions/logos
  - lib://cognitions/ethos
  - lib://cognitions/pathos
- Archetypes:
  - lib://archetypes/db
  - lib://archetypes/weaving
- Capabilities (5D matrices):
  - lib://capabilities/implementation
  - lib://capabilities/review
  - lib://capabilities/governance
  - lib://capabilities/validator
- Output Frameworks:
  - lib://output/technical
  - lib://output/governance
- Enhancements:
  - lib://enhancements/cognition
  - lib://enhancements/core
  - lib://enhancements/enhanced
  - lib://enhancements/security
  - lib://enhancements/governance

WEAVING ORDER (from 122-SYSTEM-ARCHETYPE-WEAVING.oct.md):
1. UNIVERSAL_FOUNDATION
2. COGNITIVE_SHANK (single cognition mode)
3. CONDITIONAL_ENHANCEMENTS (governance/security/core)
4. DOMAIN_CAPABILITIES (5D matrices)
5. OUTPUT_FRAMEWORK (technical or governance)
6. ROLE_OVERRIDES (minimal)

MANDATORY QUALITY GATES:
- Claims→Checks→Artifacts→Status present
- 5D matrices include Functional Reliability and FR ≥ 2 for pass
- Cognition MUST_ALWAYS/MUST_NEVER enforced

