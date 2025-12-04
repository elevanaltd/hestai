# Claude Code Hook Exit Code Architecture

## CRITICAL ARCHITECTURAL FINDING

**Root Cause**: Claude Code hook system treats different exit codes differently:
- `exit 1` - **DOES NOT BLOCK** tool execution (hook failure is ignored)
- `exit 2` - **SUCCESSFULLY BLOCKS** tool execution (hook vetoes the operation)

## Evidence
This was discovered through systematic debugging where hooks using `exit 1` failed to block file creation despite:
- Executing correctly
- Detecting violations correctly  
- Logging blocking messages correctly
- Calling `exit 1` correctly

Meanwhile, identical hooks using `exit 2` successfully blocked operations.

## Working Pattern (Anchor Hook Pattern)
```bash
# If we have violations, block the operation using anchor hook pattern
if [[ -n "$violations" ]]; then
  cat >&2 <<EOF
🚨 BLOCKING: [Violation description]
[Details and required actions]
EOF
  exit 2  # Using anchor hook's successful exit code
fi
```

## Migration Completed
All hooks have been migrated from `exit 1` to `exit 2`:
- enforce-test-first.sh ✓
- enforce-archive-headers.sh ✓
- enforce-doc-governance.sh ✓
- require-validation-evidence.sh ✓
- validate-links.sh ✓
- enforce-context7-consultation.sh ✓
- enforce-doc-naming.sh ✓

## Prevention Strategy
1. **ALWAYS use `exit 2` for blocking** in Claude Code hooks
2. Comment pattern: `exit 2  # Using successful blocking exit code pattern`
3. Test blocking behavior after creating new hooks
4. Reference "anchor hook pattern" from context7_enforcement_gate.sh

## Hook Development Guidelines
```bash
#!/usr/bin/env bash
set -euo pipefail

# Read JSON input
input=$(cat)

# Process and validate...

# BLOCKING PATTERN - ALWAYS USE exit 2
if [[ "$should_block" == "true" ]]; then
  echo "🚨 BLOCKING: [Clear reason]" >&2
  echo "[Required actions]" >&2
  exit 2  # CRITICAL: Must be exit 2, not exit 1
fi

# Allow operation
exit 0
```

## System Architecture Notes
This appears to be an undocumented feature of Claude Code's hook system where:
- Exit code 0 = Allow operation
- Exit code 1 = Hook failed but continue (non-blocking error)
- Exit code 2 = Hook veto (blocking error)

This aligns with some Unix conventions where exit 2 indicates "misuse of shell command" which Claude Code interprets as a veto signal.

## Testing Protocol
To verify a hook blocks correctly:
1. Create a test scenario that should trigger blocking
2. Verify hook executes (check debug logs if present)
3. Verify tool operation is prevented
4. If blocking fails despite hook execution, check exit code is 2 not 1

## Historical Context
The "anchor hook" (context7_enforcement_gate.sh) was the first to use this pattern successfully, with the comment "Using anchor hook's successful exit code" indicating this was a discovered solution to blocking failures.