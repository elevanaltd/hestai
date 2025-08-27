## CORE_DIRECTIVES ##
// Domain-specific operational directives and special instructions

[DIRECTIVE_CATEGORY1]:
  [INSTRUCTION1]::"Specific operational requirement"
  [INSTRUCTION2]::"Specific operational requirement"
  [INSTRUCTION3]::"Specific operational requirement"

[DIRECTIVE_CATEGORY2]:
  [INSTRUCTION1]::"Specific operational requirement"
  [INSTRUCTION2]::"Specific operational requirement"
  [INSTRUCTION3]::"Specific operational requirement"

[DIRECTIVE_CATEGORY3]:
  [INSTRUCTION1]::"Specific operational requirement"
  [INSTRUCTION2]::"Specific operational requirement"
  [INSTRUCTION3]::"Specific operational requirement"

/*
TEMPLATE USAGE NOTES:

PURPOSE:
- Provide specific operational instructions that don't fit elsewhere
- Handle domain-specific technical requirements
- Address legacy system integration needs
- Ensure compliance with specific technical standards

WHEN TO USE:
- Agents that interface with specific systems or formats
- Roles with unique technical requirements
- Agents adapted from existing system prompts
- Specialized domains with particular operational needs

EXAMPLE DIRECTIVE CATEGORIES:

CRITICAL_LINE_NUMBER_INSTRUCTIONS (Code review agents):
  CODE_PRESENTATION::"LINE│ code markers for reference ONLY"
  NEVER_INCLUDE::"LINE│ markers in generated code"
  ALWAYS_REFERENCE::"Specific line numbers with short excerpts"

FILE_HANDLING_DIRECTIVES (File manipulation agents):
  BACKUP_PROTOCOL::"Always create backups before major modifications"
  VERSION_CONTROL::"Commit changes with descriptive messages"
  PERMISSION_CHECK::"Verify write permissions before file operations"

SECURITY_COMPLIANCE_DIRECTIVES (Security-focused agents):
  DATA_PROTECTION::"Never log or display sensitive information"
  ACCESS_VALIDATION::"Verify authorization before security operations"
  AUDIT_TRAIL::"Document all security-related actions"

INTEGRATION_DIRECTIVES (System integration agents):
  API_VERSIONING::"Always specify API version in requests"
  ERROR_HANDLING::"Implement graceful degradation for service failures"
  TIMEOUT_MANAGEMENT::"Set appropriate timeouts for all external calls"

FORMATTING_DIRECTIVES (Output formatting agents):
  MARKUP_COMPLIANCE::"Follow strict markdown specification"
  ENCODING_STANDARDS::"Use UTF-8 encoding for all text output"
  ACCESSIBILITY::"Include alt-text for all generated images"

TESTING_DIRECTIVES (Testing agents):
  COVERAGE_REQUIREMENTS::"Aim for minimum 90% code coverage"
  TEST_ISOLATION::"Ensure tests are independent and idempotent"
  MOCK_STRATEGY::"Mock external dependencies in unit tests"

COMMON PATTERNS:
1. Technical Compliance: Standards and protocol adherence
2. System Integration: Interaction with specific systems
3. Output Formatting: Specific format requirements
4. Security Protocols: Security-specific operational needs
5. Legacy Adaptation: Requirements from existing systems

DO NOT USE FOR:
- General behavioral guidance (use BEHAVIORAL_SYNTHESIS instead)
- Quality requirements (use QUALITY_GATES instead)
- Analysis methodologies (use ANALYTICAL_CAPABILITIES instead)
- Output structure (use OUTPUT_CONFIGURATION instead)

Use only for specific operational instructions that are unique to the agent's domain.
*/
