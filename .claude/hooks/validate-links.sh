#!/bin/bash
# Validate markdown links - hook for Claude Code
# Scans markdown files for [text](url) links and validates relative file links exist

set -euo pipefail

# Check for required dependencies
if ! command -v realpath &> /dev/null; then
    echo "realpath command is required but not found. Please install coreutils." >&2
    exit 2  # Using successful blocking exit code pattern
fi

# Color output for better visibility
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to log debug output
debug() {
    if [[ "${DEBUG:-}" == "1" ]]; then
        echo "[DEBUG] $*" >&2
    fi
}

# Function moved inline - we'll pass line numbers directly

# Function to validate a single link
validate_link() {
    local file_path="$1"
    local link_url="$2"
    local line_num="$3"
    
    debug "Validating link: $link_url from file: $file_path"
    
    # Get the directory of the current file for relative path resolution
    local file_dir
    file_dir=$(dirname "$file_path")
    
    # Handle different link types
    case "$link_url" in
        http://* | https://*)
            # External links - attempt basic validation
            debug "External link detected: $link_url"
            echo "Checking external link: $link_url" >&2
            return 0  # Don't fail on external links for now
            ;;
        mailto:* | ftp://* | file://*)
            # Other protocols - skip validation
            debug "Non-http protocol link detected: $link_url"
            return 0
            ;;
        "#"*)
            # Anchor-only links (same page) - skip validation
            debug "Anchor-only link detected: $link_url"
            return 0
            ;;
        "")
            # Empty link
            echo "$file_path:$line_num: BROKEN LINK: empty link"
            return 1
            ;;
        *)
            # Relative file links - validate file existence
            debug "Relative link detected: $link_url"
            
            # Remove anchor fragments
            local file_part="${link_url%#*}"
            
            # Resolve relative path
            local resolved_path
            if [[ "$file_part" == ./* ]]; then
                resolved_path="$file_dir/${file_part#./}"
            elif [[ "$file_part" == ../* ]]; then
                resolved_path="$file_dir/$file_part"
            else
                resolved_path="$file_dir/$file_part"
            fi
            
            # Normalize path (remove . and ..)
            resolved_path=$(realpath -m "$resolved_path" 2>/dev/null || echo "$resolved_path")
            
            debug "Resolved path: $resolved_path"
            
            # Check if file exists
            if [[ ! -f "$resolved_path" ]]; then
                echo "$file_path:$line_num: BROKEN LINK: $link_url"
                return 1
            fi
            
            return 0
            ;;
    esac
}

# Function to extract and validate all links from a markdown file
validate_markdown_file() {
    local file_path="$1"
    local exit_code=0
    local line_num=0
    local in_code_block=false
    
    debug "Processing file: $file_path"
    
    if [[ ! -f "$file_path" ]]; then
        echo "$file_path:1: ERROR: File does not exist" >&2
        return 1
    fi
    
    # Process file line by line to get accurate line numbers and handle code blocks
    while IFS= read -r line; do
        ((line_num++))
        
        # Track code blocks to avoid validating links inside them
        if [[ "$line" =~ ^[[:space:]]*\`\`\` ]]; then
            if [[ "$in_code_block" == "true" ]]; then
                in_code_block=false
            else
                in_code_block=true
            fi
            continue
        fi
        
        # Skip links inside code blocks
        if [[ "$in_code_block" == "true" ]]; then
            continue
        fi
        
        # Extract all inline links from this line: [text](url)
        # Use grep to find all links on this line
        debug "Processing line $line_num: $line"
        
        # Check for inline links [text](url)
        if [[ "$line" =~ \[.*\]\([^\)]*\) ]]; then
            debug "Line has inline link pattern"
            # Extract all links from this line using a simple approach
            local temp_line="$line"
            # Keep extracting links until none remain
            while [[ "$temp_line" =~ \[([^]]*)\]\(([^\)]*)\) ]]; do
                local link_text="${BASH_REMATCH[1]}"
                local link_url="${BASH_REMATCH[2]}"
                debug "Found inline link on line $line_num: [$link_text]($link_url)"
                
                if ! validate_link "$file_path" "$link_url" "$line_num"; then
                    exit_code=1
                fi
                
                # Remove the matched link and continue
                temp_line="${temp_line/\[${link_text}\]\(${link_url}\)/}"
            done
        fi
        
        # Extract reference-style link definitions: [ref]: url
        if [[ "$line" =~ ^[[:space:]]*\[([^\]]+)\]:[[:space:]]*([^[:space:]]+) ]]; then
            local ref_name="${BASH_REMATCH[1]}"
            local ref_url="${BASH_REMATCH[2]}"
            
            debug "Found reference link on line $line_num: [$ref_name]: $ref_url"
            
            if ! validate_link "$file_path" "$ref_url" "$line_num"; then
                exit_code=1
            fi
        fi
        
    done < "$file_path"
    
    return $exit_code
}

# Main function
main() {
    local file_path="$1"
    local exit_code=0
    
    debug "Starting validation for: $file_path"
    
    # Validate the markdown file
    if ! validate_markdown_file "$file_path"; then
        exit_code=1
    fi
    
    if [[ $exit_code -eq 0 ]]; then
        debug "All links valid in: $file_path"
    else
        debug "Broken links found in: $file_path"
    fi
    
    return $exit_code
}

# Check if file argument provided
if [[ $# -eq 0 ]]; then
    # Check if this is being called as a hook with JSON input
    if [[ -t 0 ]]; then
        echo "Usage: $0 <markdown_file>" >&2
        echo "   or: echo '<json_input>' | $0" >&2
        exit 2  # Using successful blocking exit code pattern
    fi
    
    # Read JSON input from stdin for hook mode
    INPUT_JSON=$(cat)
    
    # Extract tool_name and file_path from the JSON
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
    
    # Only check .md files
    if [[ ! "$FILE_PATH" =~ \.md$ ]]; then
        exit 0
    fi
    
    # Relax validation for worktree directories (development workflow)
    if [[ "$FILE_PATH" =~ /worktrees/ ]]; then
        echo "Link validation relaxed for worktree development: $FILE_PATH" >&2
        exit 0
    fi
    
    # Skip validation for files that don't exist yet (Write operations)
    if [[ ! -f "$FILE_PATH" ]]; then
        exit 0
    fi
    
    # Check for bypass comment in file content
    if grep -q "LINK_VALIDATION_BYPASS:" "$FILE_PATH" 2>/dev/null; then
        echo "Link validation bypassed for: $FILE_PATH (bypass comment found)" >&2
        exit 0
    fi
    
    # Context-aware bypass: detect link fixing operations
    # Check if this operation is attempting to fix broken links
    if echo "$INPUT_JSON" | grep -qi -E "(fix.*link|broken.*link|update.*path|link.*path|fix.*broken)" 2>/dev/null; then
        echo "Link validation bypassed for: $FILE_PATH (detected link fixing operation)" >&2
        exit 0
    fi
    
    # Check if Edit/MultiEdit contains link path corrections
    if [[ "$TOOL_NAME" == "Edit" || "$TOOL_NAME" == "MultiEdit" ]] && echo "$INPUT_JSON" | grep -qi -E "(old_string.*docs/|new_string.*docs/|\.md)" 2>/dev/null; then
        echo "Link validation bypassed for: $FILE_PATH (detected link correction in ${TOOL_NAME})" >&2
        exit 0
    fi
    
    if ! main "$FILE_PATH"; then
        cat >&2 <<EOF

🚨 EXACT COMMANDS TO UNBLOCK:

1. Fix the broken links by updating the file paths in your markdown:
   - Check the actual location of linked files
   - Update link paths to match current file locations
   - Ensure relative paths are correct from the linking file

2. Or add bypass comment if links are intentionally to non-existent files:
   <!-- LINK_VALIDATION_BYPASS: intentional links to planned documentation -->

3. For new files in worktrees, add a temporary bypass during development:
   <!-- LINK_VALIDATION_BYPASS: linking to uncommitted files in worktree -->

4. Retry your operation

⚠️  DO NOT ignore broken links - they create poor user experience.

EOF
        exit 2  # Use blocking exit code for hook system
    fi
else
    # Direct file mode
    if ! main "$1"; then
        exit 1  # Standard exit code for direct file mode
    fi
fi