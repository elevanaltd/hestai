#!/bin/bash
#
# Enforce archive headers for archived documents using a single-pass state machine.
#
# Validates two formats:
# 1. Standard:
#    Status: Archived → superseded by [path]
#    Archived: YYYY-MM-DD
#    Original-Path: [path]
#
# 2. Alternative:
#    Archive: [ISO-timestamp] - [description]
#    Original-Path: [path]
#
set -euo pipefail

# --- Constants and Globals ---
SUCCESS=0
VALIDATION_ERROR=1
OVERALL_EXIT_CODE=$SUCCESS

# --- Helper Functions ---

# Reports errors in a standard format to stderr.
# Usage: generate_error_report "file.md" 1 "Error message"
generate_error_report() {
    local filename="$1"
    local line_number="$2"
    local error_message="$3"
    echo "${filename}:${line_number}: ${error_message}" >&2
}

# Validates 'Status: Archived → superseded by [path]' format.
validate_status_line() {
    local line="$1"
    # Regex allows for flexible whitespace.
    if [[ ! "$line" =~ ^Status:[[:space:]]*Archived[[:space:]]+→[[:space:]]+superseded[[:space:]]+by[[:space:]]+(.+)$ ]]; then
        return 1
    fi
    # Check that the captured path is not empty.
    [[ -n "${BASH_REMATCH[1]}" ]]
}

# Validates 'Archived: YYYY-MM-DD' format.
validate_archived_line() {
    local line="$1"
    if [[ "$line" =~ ^Archived:[[:space:]]*([0-9]{4}-[0-9]{2}-[0-9]{2})$ ]]; then
        # This is a format check, not a date validity check (e.g. 2023-99-99 would pass).
        # This is an acceptable trade-off for simplicity in a shell script.
        return 0
    fi
    return 1
}

# Validates 'Archive: [ISO-timestamp] - [description]' format.
validate_archive_line() {
    local line="$1"
    # Regex for ISO 8601 timestamp
    local iso_ts_regex="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(Z|[+-][0-9]{2}:[0-9]{2})"
    if [[ "$line" =~ ^Archive:[[:space:]]*($iso_ts_regex)[[:space:]]*-[[:space:]]*(.+)$ ]]; then
        # Check that the captured description is not empty.
        [[ -n "${BASH_REMATCH[3]}" ]]
        return
    fi
    return 1
}

# Validates 'Original-Path: [path]' format.
validate_original_path_line() {
    local line="$1"
    if [[ "$line" =~ ^Original-Path:[[:space:]]*(.+)$ ]]; then
        # Check that the captured path is not empty.
        [[ -n "${BASH_REMATCH[1]}" ]]
        return
    fi
    return 1
}


# --- Core Validation Logic (State Machine) ---

# Processes a file stream line-by-line, validating archive headers.
# Reads from stdin.
# Usage: process_file_stream "file.md" < "file.md"
process_file_stream() {
    local filepath="$1"
    local line_num=0
    local state="START" # START, EXPECT_ARCHIVED, EXPECT_ORIGINAL_PATH, EXPECT_BLANK_LINE, DONE
    local has_error=0

    while IFS= read -r line; do
        ((line_num++))

        # Universal check: header capitalization.
        if [[ "$line" =~ ^(status|archived|original-path|archive): ]]; then
            generate_error_report "$filepath" "$line_num" "Header names must be properly capitalized"
            has_error=1
            break
        fi

        case "$state" in
            "START")
                if [[ "$line" =~ ^Status: ]]; then
                    if ! validate_status_line "$line"; then
                        generate_error_report "$filepath" "$line_num" "Invalid Status header format. Expected 'Status: Archived → superseded by [path]'"
                        has_error=1; break
                    fi
                    state="EXPECT_ARCHIVED"
                elif [[ "$line" =~ ^Archive: ]]; then
                    if ! validate_archive_line "$line"; then
                        generate_error_report "$filepath" "$line_num" "Invalid Archive header format. Expected 'Archive: [ISO-timestamp] - [description]'"
                        has_error=1; break
                    fi
                    state="EXPECT_ORIGINAL_PATH"
                else
                    generate_error_report "$filepath" "$line_num" "Archive headers must appear at the start of the file"
                    has_error=1; break
                fi
                ;;

            "EXPECT_ARCHIVED")
                if [[ "$line" =~ ^Archived: ]]; then
                    if ! validate_archived_line "$line"; then
                        generate_error_report "$filepath" "$line_num" "Invalid Archived date format. Expected 'Archived: YYYY-MM-DD'"
                        has_error=1; break
                    fi
                    state="EXPECT_ORIGINAL_PATH"
                else
                    generate_error_report "$filepath" "$line_num" "Missing or misplaced 'Archived' header. Expected after 'Status'."
                    has_error=1; break
                fi
                ;;

            "EXPECT_ORIGINAL_PATH")
                if [[ "$line" =~ ^Original-Path: ]]; then
                    if ! validate_original_path_line "$line"; then
                        generate_error_report "$filepath" "$line_num" "Invalid Original-Path header. Path cannot be empty."
                        has_error=1; break
                    fi
                    state="EXPECT_BLANK_LINE"
                else
                    generate_error_report "$filepath" "$line_num" "Missing or misplaced 'Original-Path' header."
                    has_error=1; break
                fi
                ;;

            "EXPECT_BLANK_LINE")
                if [[ -z "$line" ]]; then
                    state="DONE"
                else
                    generate_error_report "$filepath" "$line_num" "Missing blank line after archive headers"
                    has_error=1; break
                fi
                ;;

            "DONE")
                # Headers are valid, we can stop processing the file.
                break
                ;;
        esac
    done

    # After the loop, check the final state.
    if [[ $has_error -eq 0 ]]; then
        if [[ "$state" != "DONE" ]]; then
            # This means EOF was reached before the state machine completed.
            generate_error_report "$filepath" "$((line_num + 1))" "Incomplete archive headers. Unexpected end of file."
            has_error=1
        fi
    fi

    return $has_error
}

# Determines if a file needs validation and runs the processor.
validate_file() {
    local filepath="$1"

    if [[ ! -f "$filepath" ]] || [[ ! "$filepath" =~ \.md$ ]]; then
        return $SUCCESS
    fi

    # Read only the first line to determine if we should proceed.
    # `|| true` prevents script exit if file is empty.
    local first_line
    first_line=$(head -n 1 "$filepath" 2>/dev/null || true)

    local needs_validation=false
    if [[ "$filepath" =~ _archive ]]; then
        needs_validation=true
    elif [[ "$first_line" =~ ^(Status:|Archive:|status:|archive:) ]]; then
        needs_validation=true
    fi

    if [[ "$needs_validation" = true ]]; then
        if ! process_file_stream "$filepath" < "$filepath"; then
            OVERALL_EXIT_CODE=$VALIDATION_ERROR
        fi
    fi
}

# --- Main Execution ---

main() {
    # Check for jq dependency if reading from stdin
    if [[ $# -eq 0 ]] && ! command -v jq &> /dev/null; then
        echo "CRITICAL: jq is not installed. It is required for parsing stdin." >&2
        exit 2  # Using successful blocking exit code pattern
    fi

    local files_to_check=()
    if [[ $# -eq 0 ]]; then
        # Read from stdin (hook mode)
        local input_json
        input_json=$(cat)
        
        local tool_name
        tool_name=$(jq -r '.tool_name // ""' <<< "$input_json")

        if [[ "$tool_name" == "Write" || "$tool_name" == "MultiEdit" || "$tool_name" == "Edit" ]]; then
            local file_path
            file_path=$(jq -r '.tool_input.file_path // ""' <<< "$input_json")
            if [[ -n "$file_path" ]]; then
                files_to_check+=("$file_path")
            fi
        fi
    else
        # Read from command line arguments (test mode)
        files_to_check=("$@")
    fi

    for file in "${files_to_check[@]}"; do
        validate_file "$file"
    done

    exit $OVERALL_EXIT_CODE
}

main "$@"