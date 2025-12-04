#!/bin/bash
# Shared utilities for document naming enforcement
# Used by: enforce-doc-naming.sh, pre-commit hooks, registry updates

# Get next available sequence number by scanning existing files
# Usage: get_next_sequence_from_scan <directory> <range_start> <range_end>
get_next_sequence_from_scan() {
  local target_dir="$1"
  local range_start="${2:-800}"
  local range_end="${3:-899}"

  if [[ ! -d "$target_dir" ]]; then
    printf "%03d" "$range_start"
    return
  fi

  # Find all sequence numbers in use
  local used_sequences=$(find "$target_dir" -name "[0-9][0-9][0-9]-*.md" -type f 2>/dev/null | \
    sed 's|.*/||' | \
    grep -o '^[0-9]\{3\}' | \
    sort -u)

  # Find first available in range
  for seq in $(seq "$range_start" "$range_end"); do
    local padded=$(printf "%03d" "$seq")
    if ! echo "$used_sequences" | grep -q "^${padded}$"; then
      echo "$padded"
      return
    fi
  done

  # Range exhausted
  echo "RANGE_EXHAUSTED"
}

# Validate filename against HestAI naming standard
# Usage: validate_doc_filename <filename> <directory>
# Returns: 0 if valid, 1 if invalid with error message on stderr
validate_doc_filename() {
  local filename="$1"
  local dir_path="$2"

  # Skip exempted files
  case "$filename" in
    README.md|LICENSE|CONTRIBUTING.md|CHANGELOG.md|SECURITY.md|CODE_OF_CONDUCT.md|CLAUDE.md|CODEOWNERS|package.json|pyproject.toml|Cargo.toml|.gitignore|.editorconfig)
      return 0
      ;;
  esac

  # Check if in docs/, reports/, or _archive/
  if [[ ! "$dir_path" =~ (^|/)(docs|reports|_archive)(/|$) ]]; then
    return 0  # Not in controlled directories
  fi

  # Check for forbidden patterns
  if [[ "$filename" =~ (_v[0-9]+|_final|_latest|_draft|_old|_new) ]]; then
    echo "ERROR: Contains forbidden version suffix" >&2
    return 1
  fi

  # Validate pattern for reports
  if [[ "$dir_path" =~ /reports ]]; then
    local PATTERN='^[0-9]{3}-REPORT(-[A-Z0-9]+)+-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'
    if [[ ! "$filename" =~ $PATTERN ]]; then
      echo "ERROR: Reports must match pattern: {SEQ}-REPORT-{CATEGORY}-{NAME}.md" >&2
      echo "       Example: 855-REPORT-AUDIT-SECURITY-2025-11-26.md" >&2
      return 1
    fi

    # Validate sequence range
    local seq=$(echo "$filename" | grep -o '^[0-9]\{3\}')
    if [[ "$seq" -lt 800 || "$seq" -gt 899 ]]; then
      echo "ERROR: Reports sequence must be 800-899, got: $seq" >&2
      return 1
    fi
  fi

  # Validate pattern for docs
  if [[ "$dir_path" =~ /docs(/|$) && ! "$dir_path" =~ /reports ]]; then
    local PATTERN='^[0-9]{3}-(DOC|SYSTEM|PROJECT|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)(-[A-Z0-9]+)?-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'
    if [[ ! "$filename" =~ $PATTERN ]]; then
      echo "ERROR: Docs must match pattern: {SEQ}-{CONTEXT}-{NAME}.md" >&2
      return 1
    fi
  fi

  return 0
}

# Update sequence tracker registry
# Usage: update_sequence_registry <directory_type> <new_sequence>
update_sequence_registry() {
  local dir_type="$1"
  local new_seq="$2"
  local registry_file="/Volumes/HestAI/docs/.registry/sequence-tracker.json"

  if [[ ! -f "$registry_file" ]]; then
    echo "WARNING: Registry file not found: $registry_file" >&2
    return 1
  fi

  # Update using jq if available, otherwise skip
  if command -v jq &> /dev/null; then
    local next_seq=$((new_seq + 1))
    local tmp_file=$(mktemp)

    jq --arg dir "$dir_type" \
       --argjson last "$new_seq" \
       --argjson next "$next_seq" \
       '.last_sequences[$dir] = $last | .next_available[$dir] = $next | .metadata.last_updated = (now | strftime("%Y-%m-%dT%H:%M:%SZ"))' \
       "$registry_file" > "$tmp_file" 2>/dev/null

    if [[ $? -eq 0 && -s "$tmp_file" ]]; then
      mv "$tmp_file" "$registry_file"
      return 0
    else
      rm -f "$tmp_file"
      return 1
    fi
  fi

  return 1
}

# Suggest correct filename for non-compliant file
# Usage: suggest_filename <original_filename> <directory>
suggest_filename() {
  local filename="$1"
  local dir_path="$2"

  # Determine directory type and get next sequence
  local next_seq=""
  if [[ "$dir_path" =~ /reports ]]; then
    next_seq=$(get_next_sequence_from_scan "$dir_path" 800 899)

    # Extract name part, normalize to uppercase
    local name_part=$(echo "$filename" | sed 's/\.[^.]*$//' | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')

    # Suggest with REPORT context
    if [[ ! "$name_part" =~ ^REPORT- ]]; then
      name_part="REPORT-$name_part"
    fi

    echo "${next_seq}-${name_part}.md"
  else
    # Default suggestion for docs
    next_seq=$(get_next_sequence_from_scan "$dir_path" 100 199)
    local name_part=$(echo "$filename" | sed 's/\.[^.]*$//' | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z0-9]/-/g')
    echo "${next_seq}-DOC-${name_part}.md"
  fi
}
