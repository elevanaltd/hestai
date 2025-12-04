#!/usr/bin/env bash
# Context7 Enforcement Gate Hook v1.0
# Using successful anchor hook architecture pattern
# This hook blocks external library imports without Context7 consultation

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract tool information using jq (if available)
command_text=""
tool_name=""
content=""

if command -v jq >/dev/null 2>&1; then
  tool_name=$(echo "$input" | jq -r '.tool_name // empty' 2>/dev/null || echo "")
  
  # Only process Write, MultiEdit, and Edit tools
  if [[ "$tool_name" != "Write" && "$tool_name" != "MultiEdit" && "$tool_name" != "Edit" ]]; then
    exit 0
  fi
  
  # Extract file path to check if it's a code file
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || echo "")
  
  # Skip non-code files and non-HestAI directories
  if [[ -n "$file_path" ]]; then
    # Only enforce on HestAI project directories
    if [[ ! "$file_path" =~ ^(/Volumes/HestAI-Projects/|/Volumes/HestAI-Tools/) ]]; then
      exit 0
    fi
    
    file_ext="${file_path##*.}"
    if [[ ! "$file_ext" =~ ^(ts|tsx|js|jsx|py|go|rs|rb|php|cs|cpp|c|h)$ ]]; then
      exit 0
    fi
  fi
  
  # Extract content based on tool type
  if [[ "$tool_name" == "Write" ]]; then
    content=$(echo "$input" | jq -r '.tool_input.content // empty' 2>/dev/null || echo "")
  elif [[ "$tool_name" == "Edit" ]]; then
    content=$(echo "$input" | jq -r '.tool_input.new_string // empty' 2>/dev/null || echo "")
  elif [[ "$tool_name" == "MultiEdit" ]]; then
    content=$(echo "$input" | jq -r '.tool_input.edits[].new_string // empty' 2>/dev/null || echo "" | tr '\n' ' ')
  fi
fi

# If no content to check, allow operation
if [[ -z "$content" ]]; then
  exit 0
fi

# Check for structured bypass first
if echo "$content" | grep -qE "(//|#)[[:space:]]*CONTEXT7_BYPASS:[[:space:]]*\w+-\d+"; then
  bypass_reason=$(echo "$content" | grep -oE "CONTEXT7_BYPASS:[[:space:]]*\w+-\d+.*" | head -1)
  echo "AUDIT: Context7 bypass used - $bypass_reason" >&2
  exit 0
fi

# Function to check if a path is relative/local
is_relative_path() {
  local path="$1"
  # Check if starts with ./ ../ / or ~/
  if [[ "$path" =~ ^\./ ]] || [[ "$path" =~ ^\.\./ ]] || [[ "$path" =~ ^/ ]] || [[ "$path" =~ ^~/ ]]; then
    return 0  # Is relative/local
  else
    return 1  # Is external
  fi
}

# Detect external imports
external_imports=""

# JavaScript/TypeScript: import ... from "module"
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if ! is_relative_path "$line"; then
    external_imports+="$line"$'\n'
  fi
done < <(echo "$content" | grep -oE 'from[[:space:]]+["'\'']([^"'\'']+)["'\'']' 2>/dev/null | sed -E 's/from[[:space:]]+["'\'']([^"'\'']+)["'\''].*/\1/' || true)

# CommonJS: require("module")
while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if ! is_relative_path "$line"; then
    external_imports+="$line"$'\n'
  fi
done < <(echo "$content" | grep -oE 'require\(["'\'']([^"'\'']+)["'\'']' 2>/dev/null | sed -E 's/.*require\(["'\'']([^"'\'']+)["'\''].*/\1/' || true)

# Function to check if a module is Python stdlib
is_python_stdlib() {
  local module="$1"
  # Common Python standard library modules
  local stdlib_modules=(
    "os" "sys" "json" "re" "time" "datetime" "collections" "itertools"
    "functools" "operator" "pathlib" "tempfile" "shutil" "subprocess"
    "threading" "multiprocessing" "queue" "sqlite3" "unittest" "pytest"
    "math" "random" "decimal" "fractions" "statistics" "uuid" "hashlib"
    "hmac" "secrets" "base64" "binascii" "struct" "codecs" "io" "pickle"
    "configparser" "argparse" "logging" "warnings" "traceback" "pdb"
    "profile" "pstats" "timeit" "gc" "weakref" "copy" "types" "enum"
    "abc" "contextlib" "typing" "dataclasses" "asyncio" "concurrent"
    "urllib" "http" "email" "html" "xml" "csv" "zipfile" "tarfile"
    "gzip" "bz2" "lzma" "zlib" "socket" "ssl" "ftplib" "smtplib"
    "telnetlib" "socketserver" "select" "signal" "mmap" "ctypes"
    "platform" "getpass" "pwd" "grp" "crypt" "termios" "tty" "pty"
    "fcntl" "pipes" "resource" "sysconfig" "site" "importlib"
  )
  
  for stdlib_mod in "${stdlib_modules[@]}"; do
    if [[ "$module" == "$stdlib_mod" ]]; then
      return 0  # Is stdlib
    fi
  done
  return 1  # Not stdlib
}

# Python: import module, from module import (for .py files)
if [[ "$file_ext" == "py" ]]; then
  # Match "import module" patterns (but not "from ... import")
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if [[ ! "$line" =~ ^\. ]]; then
      base_module=$(echo "$line" | cut -d. -f1)
      if [[ -n "$base_module" ]] && ! is_python_stdlib "$base_module"; then
        external_imports+="$base_module"$'\n'
      fi
    fi
  done < <(echo "$content" | grep -v "from.*import" | grep -oE '(^|[[:space:]])import[[:space:]]+([a-zA-Z_][a-zA-Z0-9_\.]*)' 2>/dev/null | sed -E 's/.*import[[:space:]]+([a-zA-Z_][a-zA-Z0-9_\.]*).*/\1/' || true)
  
  # Match "from module import" patterns
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if [[ ! "$line" =~ ^\. ]]; then
      base_module=$(echo "$line" | cut -d. -f1)
      if [[ -n "$base_module" ]] && ! is_python_stdlib "$base_module"; then
        external_imports+="$base_module"$'\n'
      fi
    fi
  done < <(echo "$content" | grep -oE '(^|[[:space:]])from[[:space:]]+([a-zA-Z_][a-zA-Z0-9_\.]*)[[:space:]]+import' 2>/dev/null | sed -E 's/.*from[[:space:]]+([a-zA-Z_][a-zA-Z0-9_\.]*)[[:space:]]+import.*/\1/' || true)
fi

# Remove duplicates and empty lines
external_imports=$(echo "$external_imports" | sort -u | grep -v '^$' || true)

# If no external imports found, allow operation
if [[ -z "$external_imports" ]]; then
  exit 0
fi

# Check for Context7 consultation evidence for each import
blocked_imports=""
while IFS= read -r import_name; do
  [[ -z "$import_name" ]] && continue

  # Check if the module name is mentioned in a Context7 comment anywhere in the file
  # Look for patterns like: Context7: consulted for <module> (case-insensitive, flexible spacing)
  # Support both exact matches and module names within scoped packages (e.g., @supabase/supabase-js)
  escaped_import=$(echo "$import_name" | sed 's/[[\.*^$(){}?+|/]/\\&/g')
  if ! echo "$content" | grep -qiE "(//|#)[[:space:]]*(Context7|CONTEXT7):[[:space:]]*consulted[[:space:]]*for[[:space:]]*[^[:space:]]*${escaped_import}"; then
    blocked_imports+="  - $import_name"$'\n'
  fi
done <<< "$external_imports"

# If we have blocked imports, block the operation using anchor hook pattern
if [[ -n "$blocked_imports" ]]; then
  cat >&2 <<EOF

🚨 CONTEXT7 ENFORCEMENT ACTIVATED

External imports detected without Context7 consultation evidence.

File: ${file_path:-"unknown"}

Blocked imports requiring consultation:
$blocked_imports

REQUIRED ACTIONS:
1. Use Context7 to research each library:
   mcp__Context7__resolve-library-id for library lookup
   mcp__Context7__get-library-docs for documentation

2. Add consultation evidence as comments:
   // Context7: consulted for <library-name>
   Examples:
$(echo "$blocked_imports" | sed 's/^  - /   \/\/ Context7: consulted for /')

3. For emergency hotfixes, use structured bypass:
   // CONTEXT7_BYPASS: TICKET-123 - Production incident hotfix

PURPOSE: Prevent production failures from library misuse
POLICY: 100% Context7 consultation rate for external dependencies

EOF
  exit 2  # Using anchor hook's successful exit code
fi

# Allow operation if all checks passed
exit 0