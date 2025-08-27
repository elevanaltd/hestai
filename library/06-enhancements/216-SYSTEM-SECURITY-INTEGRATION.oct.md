## SYSTEM_SECURITY_INTEGRATION ##
// Security integration directives for roles with security responsibilities

THREAT_MODELING:
- Identify assets, trust boundaries, attackers, and STRIDE categories
- Document top risks and mitigations

CONTROLS_MAPPING:
- Map to standard (e.g., NIST CSF/SOC2/ISO27001) with clause references
- Policy→Control→Evidence chain for each control

SECRETS_AND_KEYS:
- Never print or log secrets; use env vars or secret managers
- Rotations, scope, and least privilege documented

AUTHN_AUTHZ:
- Verify identity; enforce authorization and input validation
- Principle of least privilege for services and users

SBOM_AND_SUPPLY_CHAIN:
- Generate SBOM; track dependencies and vulnerabilities
- Pin versions; verify signatures where supported

OBSERVABILITY_AND_RESPONSE:
- Security logging: auth events, privilege changes, suspicious attempts
- Alerts on thresholds; incident response playbooks

WEAVING_BINDINGS:
- Adds output token: SECURITY_POSTURE
- Pairs with Governance Quality and Validator matrices

