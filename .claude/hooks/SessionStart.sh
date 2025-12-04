#!/bin/bash

# SessionStart Hook - North Star Summary Auto-Loading
# Wrapper script to execute TypeScript implementation

HOOK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Execute TypeScript implementation
npx tsx "$HOOK_DIR/SessionStart.ts" "$@"
