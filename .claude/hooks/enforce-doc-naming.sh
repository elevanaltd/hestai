#!/bin/bash
# Enhanced documentation naming enforcement with intelligent suggestions
# From 101-DOC-STRUCTURE-AND-NAMING-STANDARDS with constructive guidance

# Read JSON input from stdin
INPUT_JSON=$(cat)

# Extract tool_name and file_path from the JSON (file_path is in tool_input)
TOOL_NAME=$(echo "$INPUT_JSON" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"tool_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
FILE_PATH=$(echo "$INPUT_JSON" | grep -o '"tool_input"[^}]*"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

# Only process Write, MultiEdit, and Edit tools
if [[ "$TOOL_NAME" != "Write" && "$TOOL_NAME" != "MultiEdit" && "$TOOL_NAME" != "Edit" ]]; then
  exit 0
fi

# If no file_path found, exit successfully
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

FILE_NAME=$(basename "$FILE_PATH")
DIR_PATH=$(dirname "$FILE_PATH")

# Check if this is a HestAI project (has specific markers)
PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

if [[ ! "$PROJECT_ROOT" =~ (HestAI|HestAI-New|hestai|eav-orchestrator) ]] && 
   [[ ! -f "$PROJECT_ROOT/docs/101-DOC-STRUCTURE-AND-NAMING-STANDARDS"* ]]; then
  # Not a HestAI project, skip enforcement
  exit 0
fi

# Only check files in docs/, reports/, or _archive/
if [[ ! "$DIR_PATH" =~ (^|/)(docs|reports|_archive)(/|$) ]]; then
  exit 0
fi

# Skip README files, PROJECT_CONTEXT files, and registry files
if [[ "$FILE_NAME" == "README.md" ]] || [[ "$FILE_NAME" == "PROJECT_CONTEXT.md" ]] || [[ "$DIR_PATH" =~ \.registry ]]; then
  exit 0
fi

# Function to save content to /tmp for preservation
save_to_tmp() {
  local original_file="$1"
  local suggested_name="$2"
  local timestamp=$(date +%Y%m%d_%H%M%S)
  local clean_suggested=$(echo "$suggested_name" | sed 's/[^A-Za-z0-9._-]/_/g')
  local tmp_filename="/tmp/hestai_rejected_${timestamp}_${clean_suggested}"

  # Extract content from the JSON input (handling Write tool)
  if [[ "$TOOL_NAME" == "Write" ]]; then
    # Extract content field from tool_input
    CONTENT=$(echo "$INPUT_JSON" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if 'tool_input' in data and 'content' in data['tool_input']:
    print(data['tool_input']['content'])
" 2>/dev/null)

    if [[ -n "$CONTENT" ]]; then
      echo "$CONTENT" > "$tmp_filename"
      echo "$tmp_filename"
    fi
  fi
}

# Check for forbidden version suffixes FIRST - handle with simple cleanup
if [[ "$FILE_NAME" =~ (_v[0-9]+|_final|_latest|_draft|_old|_new) ]]; then
  CLEAN_FILENAME="$(echo "$FILE_NAME" | sed 's/_v[0-9][0-9]*//g; s/_final//g; s/_latest//g; s/_draft//g; s/_old//g; s/_new//g')"

  # Save content to /tmp
  SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$CLEAN_FILENAME")

  cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $CLEAN_FILENAME

Issue: Contains forbidden version suffix
Fix:   Removed version suffix (git handles versioning)

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$CLEAN_FILENAME"

EOF
  exit 2
fi

#==============================================================================
# INTELLIGENT SUGGESTION FUNCTIONS
#==============================================================================

# Function to parse filename components
parse_filename_components() {
  local filename="$1"
  local parsed_seq=""
  local parsed_context=""
  local parsed_name=""
  local parsed_phase=""
  local parsed_ext=""
  
  # Extract extension
  if [[ "$filename" =~ \.oct\.md$ ]]; then
    parsed_ext="oct.md"
    filename="${filename%.oct.md}"
  elif [[ "$filename" =~ \.md$ ]]; then
    parsed_ext="md"
    filename="${filename%.md}"
  fi
  
  # Extract sequence if present
  if [[ "$filename" =~ ^([0-9]{3})-(.+)$ ]]; then
    parsed_seq="${BASH_REMATCH[1]}"
    filename="${BASH_REMATCH[2]}"
  fi
  
  # Extract context and phase for PROJECT files
  if [[ "$filename" =~ ^PROJECT-(.+)-(D0|D1|D2|D3|B0|B1|B2|B3|B4|B5)-(.+)$ ]]; then
    parsed_context="PROJECT"
    parsed_name="${BASH_REMATCH[1]}"
    parsed_phase="${BASH_REMATCH[3]}"
    parsed_name="${parsed_name}-${BASH_REMATCH[3]}"
  elif [[ "$filename" =~ ^PROJECT-(.+)$ ]]; then
    parsed_context="PROJECT"
    parsed_name="${BASH_REMATCH[1]}"
  elif [[ "$filename" =~ ^(DOC|SYSTEM|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)-(.+)$ ]]; then
    parsed_context="${BASH_REMATCH[1]}"
    parsed_name="$filename"  # Keep full filename as name for reconstruction
  else
    # No recognizable pattern, use full filename as name
    parsed_name="$filename"
  fi
  
  echo "$parsed_seq|$parsed_context|$parsed_name|$parsed_phase|$parsed_ext"
}

# Function to get next available sequence for directory
# ENHANCED: Now scans existing files to prevent conflicts, uses registry as hint only
get_next_sequence() {
  local target_dir="$1"
  local registry_file="/Volumes/HestAI/docs/.registry/sequence-tracker.json"

  # Determine range based on directory
  local range_start=1
  local range_end=99

  if [[ "$target_dir" =~ /workflow ]]; then
    range_start=0; range_end=99
  elif [[ "$target_dir" =~ /standards ]]; then
    range_start=100; range_end=199
  elif [[ "$target_dir" =~ /future-phases ]]; then
    range_start=200; range_end=299
  elif [[ "$target_dir" =~ /security ]]; then
    range_start=400; range_end=499
  elif [[ "$target_dir" =~ /reports ]]; then
    range_start=800; range_end=899
  fi

  # SCAN EXISTING FILES to find all used sequences (more reliable than registry)
  local used_sequences=""
  if [[ -d "$target_dir" ]]; then
    # Recursively find all sequence numbers in use
    used_sequences=$(find "$target_dir" -name "[0-9][0-9][0-9]-*.md" -type f 2>/dev/null | \
      sed 's|.*/||' | \
      grep -o '^[0-9]\{3\}' | \
      sort -u)
  fi

  # Find first available sequence in range
  for seq in $(seq "$range_start" "$range_end"); do
    local padded=$(printf "%03d" "$seq")
    if ! echo "$used_sequences" | grep -q "^${padded}$"; then
      echo "$padded"
      return
    fi
  done

  # Fallback to registry if scan found nothing or range exhausted
  if [[ -f "$registry_file" ]]; then
    local next_seq=""
    if [[ "$target_dir" =~ /workflow ]]; then
      next_seq=$(jq -r '.next_available["docs/workflow"] // 1' "$registry_file" 2>/dev/null)
    elif [[ "$target_dir" =~ /standards ]]; then
      next_seq=$(jq -r '.next_available["docs/standards"] // 101' "$registry_file" 2>/dev/null)
    elif [[ "$target_dir" =~ /future-phases ]]; then
      next_seq=$(jq -r '.next_available["docs/future-phases"] // 201' "$registry_file" 2>/dev/null)
    elif [[ "$target_dir" =~ /security ]]; then
      next_seq=$(jq -r '.next_available["docs/security"] // 401' "$registry_file" 2>/dev/null)
    elif [[ "$target_dir" =~ /reports ]]; then
      next_seq=$(jq -r '.next_available["reports"] // 801' "$registry_file" 2>/dev/null)
    fi

    if [[ -n "$next_seq" ]]; then
      printf "%03d" "$next_seq" 2>/dev/null
      return
    fi
  fi

  # Ultimate fallback
  printf "%03d" "$range_start"
}

# Function to suggest appropriate context based on directory and content
suggest_context() {
  local target_dir="$1"
  local attempted_context="$2"
  local attempted_name="$3"
  
  # Directory-based context suggestions
  if [[ "$target_dir" =~ /workflow ]]; then
    echo "WORKFLOW"
  elif [[ "$target_dir" =~ /standards ]]; then
    if [[ "$attempted_name" =~ (DOC|DOCUMENTATION) ]]; then
      echo "DOC"
    else
      echo "SYSTEM"
    fi
  elif [[ "$target_dir" =~ /security ]]; then
    echo "SEC"
  elif [[ "$target_dir" =~ /reports ]]; then
    echo "REPORT"
  elif [[ "$attempted_name" =~ (PROJECT|IMPLEMENTATION|PLAN) ]]; then
    echo "PROJECT"
  elif [[ "$attempted_context" =~ ^(DOC|SYSTEM|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)$ ]]; then
    echo "$attempted_context"
  else
    echo "DOC"
  fi
}

# Function to normalize name to UPPERCASE-WITH-HYPHENS
normalize_name() {
  local name="$1"
  # Convert to uppercase and replace non-alphanumeric with hyphens
  echo "$name" | tr '[:lower:]' '[:upper:]' | sed 's/[^A-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g'
}

# Function to detect if PROJECT file needs phase
detect_project_phase() {
  local name="$1"
  local target_dir="$2"
  
  # Check if this appears to be a project deliverable
  if [[ "$name" =~ (IMPLEMENTATION|PLAN|DESIGN|BLUEPRINT|STRATEGY|ROADMAP) ]]; then
    if [[ "$name" =~ (IMPLEMENTATION|PLAN) ]]; then
      echo "B2"
    elif [[ "$name" =~ (DESIGN|BLUEPRINT) ]]; then
      echo "D3"
    elif [[ "$name" =~ (STRATEGY|ROADMAP) ]]; then
      echo "B1"
    elif [[ "$name" =~ (NORTH.?STAR) ]]; then
      echo "D1"
    else
      echo "B2"
    fi
  else
    echo ""
  fi
}

# Function to generate intelligent filename suggestion
generate_suggestion() {
  local original_filename="$1"
  local target_dir="$2"
  
  # Parse components
  IFS='|' read -r parsed_seq parsed_context parsed_name parsed_phase parsed_ext <<< "$(parse_filename_components "$original_filename")"
  
  # Generate suggestions
  local suggested_seq=""
  local suggested_context=""
  local suggested_name=""
  local suggested_phase=""
  local suggested_ext=""
  
  # Sequence: use parsed if valid for directory, otherwise get next available
  if [[ -n "$parsed_seq" && "$parsed_seq" =~ ^[0-9]{3}$ ]]; then
    # Check if sequence is valid for target directory
    local seq_valid=false
    if [[ "$target_dir" =~ /workflow && "$parsed_seq" -ge 0 && "$parsed_seq" -le 99 ]]; then
      seq_valid=true
    elif [[ "$target_dir" =~ /standards && "$parsed_seq" -ge 100 && "$parsed_seq" -le 199 ]]; then
      seq_valid=true
    elif [[ "$target_dir" =~ /future-phases && "$parsed_seq" -ge 200 && "$parsed_seq" -le 299 ]]; then
      seq_valid=true
    elif [[ "$target_dir" =~ /security && "$parsed_seq" -ge 400 && "$parsed_seq" -le 499 ]]; then
      seq_valid=true
    elif [[ "$target_dir" =~ /reports && "$parsed_seq" -ge 800 && "$parsed_seq" -le 899 ]]; then
      seq_valid=true
    fi
    
    if [[ "$seq_valid" == "true" ]]; then
      suggested_seq="$parsed_seq"
    else
      suggested_seq="$(get_next_sequence "$target_dir")"
    fi
  else
    suggested_seq="$(get_next_sequence "$target_dir")"
  fi
  
  # Context: use parsed context if valid, otherwise suggest
  if [[ "$parsed_context" =~ ^(DOC|SYSTEM|PROJECT|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)$ ]]; then
    suggested_context="$parsed_context"
  else
    suggested_context="$(suggest_context "$target_dir" "$parsed_context" "$parsed_name")"
  fi
  
  # Name: normalize and clean up
  suggested_name="$(normalize_name "$parsed_name")"
  
  # Phase: detect if PROJECT needs phase
  if [[ "$suggested_context" == "PROJECT" && -z "$parsed_phase" ]]; then
    suggested_phase="$(detect_project_phase "$suggested_name" "$target_dir")"
    if [[ -n "$suggested_phase" ]]; then
      suggested_name="${suggested_name}-${suggested_phase}"
    fi
  elif [[ -n "$parsed_phase" ]]; then
    suggested_name="${suggested_name}"
  fi
  
  # Extension: use parsed or default to md
  if [[ -n "$parsed_ext" ]]; then
    suggested_ext="$parsed_ext"
  else
    suggested_ext="md"
  fi
  
  # Construct suggestion
  local suggestion="${suggested_seq}-${suggested_context}-${suggested_name}.${suggested_ext}"
  
  echo "$suggestion"
}

# Function to analyze what's wrong with current filename
analyze_filename_issues() {
  local filename="$1"
  local target_dir="$2"
  local issues=()
  
  # Check sequence format
  if [[ ! "$filename" =~ ^[0-9]{3}- ]]; then
    issues+=("Missing 3-digit sequence (e.g., 001-)")
  fi
  
  # Check context
  if [[ ! "$filename" =~ -(DOC|SYSTEM|PROJECT|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)- ]]; then
    issues+=("Missing or invalid CONTEXT")
  fi
  
  # Check PROJECT phase requirement
  if [[ "$filename" =~ ^[0-9]{3}-PROJECT ]]; then
    if [[ ! "$filename" =~ -(D0|D1|D2|D3|B0|B1|B2|B3|B4|B5)- ]]; then
      issues+=("PROJECT deliverable missing phase (D0-D3, B0-B5)")
    fi
  fi
  
  # Check extension
  if [[ ! "$filename" =~ \.(md|oct\.md)$ ]]; then
    issues+=("Must end with .md or .oct.md")
  fi
  
  # Check for version suffixes
  if [[ "$filename" =~ (_v[0-9]+|_final|_latest|_draft|_old|_new) ]]; then
    issues+=("Contains forbidden version suffix")
  fi
  
  printf '%s\n' "${issues[@]}"
}

#==============================================================================
# ENHANCED VALIDATION WITH SUGGESTIONS
#==============================================================================

# Check for sequence conflicts and range validation using registry
if [[ "$FILE_NAME" =~ ^([0-9]{3})-(.+)\.md$ ]]; then
  SEQUENCE_NUM="${BASH_REMATCH[1]}"
  DOC_NAME="${BASH_REMATCH[2]}"
  
  # Validate sequence number against directory ranges
  if [[ "$DIR_PATH" =~ /workflow ]]; then
    if [[ "$SEQUENCE_NUM" -lt 0 || "$SEQUENCE_NUM" -gt 99 ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issue: Sequence $SEQUENCE_NUM invalid for workflow directory (requires 000-099)
Fix:   Using next available sequence in correct range

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

EOF
      exit 2
    fi
  elif [[ "$DIR_PATH" =~ /standards ]]; then
    if [[ "$SEQUENCE_NUM" -lt 100 || "$SEQUENCE_NUM" -gt 199 ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issue: Sequence $SEQUENCE_NUM invalid for standards directory (requires 100-199)
Fix:   Using next available sequence in correct range

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

EOF
      exit 2
    fi
  elif [[ "$DIR_PATH" =~ /future-phases ]]; then
    if [[ "$SEQUENCE_NUM" -lt 200 || "$SEQUENCE_NUM" -gt 299 ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issue: Sequence $SEQUENCE_NUM invalid for future-phases directory (requires 200-299)
Fix:   Using next available sequence in correct range

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

EOF
      exit 2
    fi
  elif [[ "$DIR_PATH" =~ /security ]]; then
    if [[ "$SEQUENCE_NUM" -lt 400 || "$SEQUENCE_NUM" -gt 499 ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issue: Sequence $SEQUENCE_NUM invalid for security directory (requires 400-499)
Fix:   Using next available sequence in correct range

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

EOF
      exit 2
    fi
  fi
  
  # Check registry for conflicts within same directory
  REGISTRY_DIR="/Volumes/HestAI/docs/.registry"
  SEQUENCE_TRACKER="$REGISTRY_DIR/sequence-tracker.json"
  
  if [[ -f "$SEQUENCE_TRACKER" ]]; then
    # Check for existing documents with same sequence in same directory
    DOC_DIR=$(dirname "$FILE_PATH")
    EXISTING_DOCS=$(find "$DOC_DIR" -name "${SEQUENCE_NUM}-*.md" 2>/dev/null | grep -v "$FILE_PATH")
    if [[ -n "$EXISTING_DOCS" ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issue: Sequence $SEQUENCE_NUM already used in directory
Conflicts with: $(basename "$EXISTING_DOCS")
Fix: Using next available sequence number

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

EOF
      exit 2
    fi
  fi
fi

# Check if this is a PROJECT deliverable requiring phase validation
if [[ "$FILE_NAME" =~ ^[0-9]{3}-PROJECT ]]; then
  # Check if this is in a project directory - use more flexible validation
  if [[ "$FILE_PATH" =~ /Volumes/HestAI-Projects/ ]] || [[ "$FILE_PATH" =~ /Volumes/HestAI/builds/ ]]; then
    # Flexible pattern for project directories: allow more variations in naming
    # Pattern: {CATEGORY}{NN}-PROJECT-{NAME}-{PHASE}-{NAME}.{EXT} or similar variations
    PROJECT_FLEXIBLE_PATTERN='^[0-9]{3}-PROJECT(-[A-Z0-9]+)*-(D0|D1|D2|D3|B0|B1|B2|B3|B4|B5)-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'
    
    if [[ ! "$FILE_NAME" =~ $PROJECT_FLEXIBLE_PATTERN ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      ISSUES="$(analyze_filename_issues "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issues detected:
$(echo "$ISSUES" | sed 's/^/  ❌ /')

Fix: Complete PROJECT deliverable pattern with phase

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

Valid phases: D0, D1, D2, D3, B0, B1, B2, B3, B4, B5
EOF
      exit 2
    fi
  else
    # Strict pattern for core HestAI docs
    # Phase pattern: {CATEGORY}{NN}-PROJECT[-{NAME}]-(D0|D1|D2|D3|B0|B1|B2|B3|B4|B5)-{NAME}.{EXT}
    PHASE_PATTERN='^[0-9]{3}-PROJECT(-[A-Z0-9]+)?-(D0|D1|D2|D3|B0|B1|B2|B3|B4|B5)-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'
    
    if [[ ! "$FILE_NAME" =~ $PHASE_PATTERN ]]; then
      SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
      ISSUES="$(analyze_filename_issues "$FILE_NAME" "$DIR_PATH")"
      SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
      cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issues detected:
$(echo "$ISSUES" | sed 's/^/  ❌ /')

Fix: Complete PROJECT deliverable pattern with phase

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

Phase Reference:
  D0: Ideation Setup & Session Establishment
  D1: Understanding & North Star
  D2: Ideation & Solution Approaches
  D3: Architecture & Technical Blueprint
  B0: Validation Gate
  B1: Planning & Build Roadmap
  B2: Implementation & Code Construction
  B3: Integration & System Unification
  B4: Delivery & Production Handoff
  B5: Enhancement & Post-Delivery Evolution
EOF
      exit 2
    fi
  fi
else
  # Non-PROJECT documents use standard pattern
  PATTERN='^[0-9]{3}-(DOC|SYSTEM|WORKFLOW|SCRIPT|AUTH|UI|RUNTIME|DATA|SEC|OPS|BUILD|REPORT)(-[A-Z0-9]+)?-[A-Z0-9]+(-[A-Z0-9]+)*\.(md|oct\.md)$'
  
  if [[ ! "$FILE_NAME" =~ $PATTERN ]]; then
    SUGGESTED_FILENAME="$(generate_suggestion "$FILE_NAME" "$DIR_PATH")"
    ISSUES="$(analyze_filename_issues "$FILE_NAME" "$DIR_PATH")"
    SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
    cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_NAME
To:   $SUGGESTED_FILENAME

Issues detected:
$(echo "$ISSUES" | sed 's/^/  ❌ /')

Fix: Complete standard document pattern

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$DIR_PATH/$SUGGESTED_FILENAME"

Valid CONTEXT: DOC, SYSTEM, WORKFLOW, SCRIPT, AUTH, UI, RUNTIME, DATA, SEC, OPS, BUILD, REPORT
Pattern: {SEQUENCE}-{CONTEXT}[-{QUALIFIER}]-{NAME}.{EXT}
EOF
    exit 2
  fi
fi

# Version suffix check moved to top of file

# Check directory depth for docs/
if [[ "$FILE_PATH" =~ ^(.*/)?docs/ ]]; then
  # Count depth under docs/
  DOCS_PORTION=${FILE_PATH#*docs/}
  DEPTH=$(echo "$DOCS_PORTION" | tr '/' '\n' | wc -l)
  
  if [[ $DEPTH -gt 2 ]]; then
    SUGGESTED_PATH=$(echo "$FILE_PATH" | sed 's|\(/docs/[^/]*/\)[^/]*/|\1|')
    SUGGESTED_FILENAME=$(basename "$SUGGESTED_PATH")
    SAVED_FILE=$(save_to_tmp "$FILE_PATH" "$SUGGESTED_FILENAME")
    cat >&2 <<EOF

🚨 SUGGESTED CORRECTION:

From: $FILE_PATH
To:   $SUGGESTED_PATH

Issue: Directory too deep ($DEPTH levels under docs/)
Fix:   Move to shallower structure (max 2 levels)

✅ CONTENT PRESERVED: $SAVED_FILE

🔧 TO RECOVER:
mv "$SAVED_FILE" "$SUGGESTED_PATH"

EOF
    exit 2
  fi
fi

exit 0