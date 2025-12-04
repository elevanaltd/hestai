#!/bin/bash

# RAPH Framework Command
# Version: 1.0.0
# Purpose: Sequential cognitive processing for quality improvement
# Evidence: 31.3% quality improvement through proper sequential processing

set -euo pipefail

# Color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default values
PATHWAY="feeling"
TIER="silver"
DOCUMENT=""
STAGE=""
VERBOSE=false

# Function to display usage
usage() {
    cat << EOF
${BOLD}RAPH Framework - Sequential Cognitive Processing${NC}

${CYAN}Usage:${NC}
    /raph [options] <document>         # Full feeling pathway (READ→ABSORB→PERCEIVE→HARMONISE)
    /raph-f [options] <document>       # Feeling pathway explicitly
    /raph-t [options] <document>       # Thinking pathway (RESEARCH→ANALYSE→PROCESS→HONE)

${CYAN}Shortcuts:${NC}
    /rap <document>                    # Quick RAPH (defaults to BRONZE tier)
    /ra <document>                     # Standard RAPH (defaults to SILVER tier)
    /r <document>                      # Full RAPH (defaults to GOLD tier)

${CYAN}Individual Stages:${NC}
    /read <document>                   # READ stage only
    /absorb <document>                 # ABSORB stage only
    /perceive <document>                # PERCEIVE stage only
    /harmonise <document>               # HARMONISE stage only
    /research <document>                # RESEARCH stage only
    /analyse <document>                 # ANALYSE stage only
    /process <document>                 # PROCESS stage only
    /hone <document>                    # HONE stage only

${CYAN}Options:${NC}
    --tier <bronze|silver|gold>        # Processing tier (default: silver)
    --pathway <feeling|thinking>        # Cognitive pathway (default: feeling)
    --verbose                           # Show detailed processing information
    --help                              # Display this help message

${CYAN}Tiers:${NC}
    ${YELLOW}BRONZE${NC} - Single-prompt, simulated sequential (lowest cost, routine work)
    ${YELLOW}SILVER${NC} - Multi-prompt, document-centric (default, high quality)
    ${YELLOW}GOLD${NC}   - Cumulative cascade (highest quality, research/synthesis)

${CYAN}Quality Metrics:${NC}
    • Sequential processing: ${GREEN}9.23/10${NC} vs non-sequential: ${RED}7.03/10${NC}
    • Quality improvement: ${GREEN}31.3%${NC}
    • Strongest gains: ABSORB (41.5%), PERCEIVE (41.9%)

${CYAN}Workflow Integration:${NC}
    ${BOLD}MANDATORY:${NC}
    • D1 NORTH-STAR documents
    • B0 Validation Gate documents
    • Role activation (.oct.md files)

    ${BOLD}RECOMMENDED:${NC}
    • D2 Solution approaches (RAPH-f for creativity)
    • D3 Technical blueprints (RAPH-t for analysis)
    • Complex error investigation (RAPH-t)
    • Phase transition documents

${CYAN}Examples:${NC}
    /raph docs/workflow/NORTH-STAR.md              # Process with default SILVER tier
    /raph-t --tier gold technical-blueprint.md     # Thinking pathway with GOLD tier
    /rap requirements.md                           # Quick BRONZE processing
    /read protocol.oct.md                          # READ stage only for role activation

EOF
}

# Function to validate document exists
validate_document() {
    local doc="$1"
    if [[ ! -f "$doc" ]]; then
        echo -e "${RED}Error: Document '$doc' not found${NC}" >&2
        return 1
    fi
}

# Function to execute BRONZE tier processing
process_bronze() {
    local doc="$1"
    local pathway="$2"

    echo -e "${YELLOW}Executing RAPH-BRONZE (Single-prompt, simulated)${NC}"
    echo -e "${CYAN}Document:${NC} $doc"
    echo -e "${CYAN}Pathway:${NC} $pathway"
    echo ""

    if [[ "$pathway" == "feeling" ]]; then
        cat << 'EOF'
Please process the document in four explicit stages—READ, ABSORB, PERCEIVE, HARMONISE—labeling each clearly.

1. **READ**: Extract and organize the literal information only (no connections or interpretations).
2. **ABSORB**: Identify relationships and patterns within the document (no external connections).
3. **PERCEIVE**: Map those relationships to broader meta-patterns or frameworks.
4. **HARMONISE**: Integrate all insights for cross-domain synthesis (remain within the document context).

CRITICAL INSTRUCTIONS:
- For each stage, first complete the prior one before starting the next.
- At each new stage, *incorporate your own previous analysis in your reasoning*, as if you are taking notes and building up understanding, but do not reference or quote prior outputs directly.
- Remain strictly within the document context—do not bring in outside knowledge unless asked.
- Do each stage sequentially. Simulate "building up" your thinking, as if stacking your notes. Do not blend stages or skip steps.
- Do not proceed until the prior step is complete.

Output all four stages clearly labeled.
EOF
    else
        cat << 'EOF'
Please process the document in four explicit stages—RESEARCH, ANALYSE, PROCESS, HONE—labeling each clearly.

1. **RESEARCH**: Gather evidence through methodical investigation of the document.
2. **ANALYSE**: Evaluate evidence after comprehensive research.
3. **PROCESS**: Create frameworks only after thorough analysis.
4. **HONE**: Refine strategy based on established frameworks.

CRITICAL INSTRUCTIONS:
- For each stage, first complete the prior one before starting the next.
- At each new stage, *incorporate your own previous analysis in your reasoning*.
- Build analytically from evidence to frameworks to refined strategy.
- Do not blend stages or skip steps.

Output all four stages clearly labeled.
EOF
    fi

    echo -e "\n${GREEN}Process the document: $doc${NC}"
}

# Function to execute SILVER tier processing
process_silver() {
    local doc="$1"
    local pathway="$2"
    local stage="${3:-all}"

    echo -e "${YELLOW}Executing RAPH-SILVER (Multi-prompt, document-centric)${NC}"
    echo -e "${CYAN}Document:${NC} $doc"
    echo -e "${CYAN}Pathway:${NC} $pathway"
    echo ""

    if [[ "$pathway" == "feeling" ]]; then
        if [[ "$stage" == "all" || "$stage" == "read" ]]; then
            echo -e "${BOLD}Stage 1: READ${NC}"
            echo "Please READ the document. Extract and organize only the literal information. No connections or interpretations."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi

        if [[ "$stage" == "all" || "$stage" == "absorb" ]]; then
            echo -e "${BOLD}Stage 2: ABSORB${NC}"
            echo "Please ABSORB the document."
            echo "You MUST use both:"
            echo "1. The original document"
            echo "2. Your output from the READ phase (visible in context above)"
            echo "Identify all relationships and patterns within the document, building upon your READ analysis."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi

        if [[ "$stage" == "all" || "$stage" == "perceive" ]]; then
            echo -e "${BOLD}Stage 3: PERCEIVE${NC}"
            echo "Please PERCEIVE the document."
            echo "You MUST use both:"
            echo "1. The original document"
            echo "2. Your outputs from READ and ABSORB phases (visible in context above)"
            echo "Map relationships to broader meta-patterns and frameworks, building upon your analysis."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi

        if [[ "$stage" == "all" || "$stage" == "harmonise" ]]; then
            echo -e "${BOLD}Stage 4: HARMONISE${NC}"
            echo "Please HARMONISE the document."
            echo "You MUST use both:"
            echo "1. The original document"
            echo "2. Your outputs from READ, ABSORB, and PERCEIVE phases (visible in context above)"
            echo "Integrate all insights to generate cross-domain synthesis."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi
    else
        # Thinking pathway stages
        if [[ "$stage" == "all" || "$stage" == "research" ]]; then
            echo -e "${BOLD}Stage 1: RESEARCH${NC}"
            echo "Please RESEARCH the document. Gather evidence through methodical investigation."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi

        if [[ "$stage" == "all" || "$stage" == "analyse" ]]; then
            echo -e "${BOLD}Stage 2: ANALYSE${NC}"
            echo "Please ANALYSE the document, building on your RESEARCH findings."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi

        if [[ "$stage" == "all" || "$stage" == "process" ]]; then
            echo -e "${BOLD}Stage 3: PROCESS${NC}"
            echo "Please PROCESS the document, creating frameworks from your analysis."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi

        if [[ "$stage" == "all" || "$stage" == "hone" ]]; then
            echo -e "${BOLD}Stage 4: HONE${NC}"
            echo "Please HONE your understanding, refining strategy based on frameworks."
            echo -e "${GREEN}Process: $doc${NC}\n"
        fi
    fi
}

# Function to execute GOLD tier processing
process_gold() {
    local doc="$1"
    local pathway="$2"

    echo -e "${YELLOW}Executing RAPH-GOLD (Cumulative cascade)${NC}"
    echo -e "${CYAN}Document:${NC} $doc"
    echo -e "${CYAN}Pathway:${NC} $pathway"
    echo -e "${RED}Note: This tier requires manual output insertion between stages${NC}"
    echo ""

    if [[ "$pathway" == "feeling" ]]; then
        echo -e "${BOLD}Stage 1: READ${NC}"
        echo "Please READ the document. Extract and organize only the literal information. No connections or interpretations."
        echo -e "${GREEN}Process: $doc${NC}"
        echo -e "${YELLOW}[Save READ output for next stage]${NC}\n"

        echo -e "${BOLD}Stage 2: ABSORB${NC}"
        echo "You have READ the document."
        echo "You MUST use both:"
        echo "1. The original document"
        echo "2. Your explicit READ output: [INSERT READ OUTPUT]"
        echo "ABSORB the material: identify relationships and patterns."
        echo -e "${YELLOW}[Save ABSORB output for next stage]${NC}\n"

        echo -e "${BOLD}Stage 3: PERCEIVE${NC}"
        echo "You have READ and ABSORBED the document."
        echo "You MUST use:"
        echo "1. The original document"
        echo "2. Your explicit outputs:"
        echo "   - READ output: [INSERT READ OUTPUT]"
        echo "   - ABSORB output: [INSERT ABSORB OUTPUT]"
        echo "PERCEIVE broader meta-patterns and frameworks."
        echo -e "${YELLOW}[Save PERCEIVE output for next stage]${NC}\n"

        echo -e "${BOLD}Stage 4: HARMONISE${NC}"
        echo "You have READ, ABSORBED, and PERCEIVED the document."
        echo "You MUST use all previous outputs for cross-domain synthesis."
        echo -e "${GREEN}Complete the full cascade integration${NC}"
    else
        echo -e "${CYAN}[Thinking pathway GOLD tier prompts follow similar cascade pattern]${NC}"
    fi
}

# Parse command line arguments
COMMAND="${0##*/}"
case "$COMMAND" in
    "raph")
        PATHWAY="feeling"
        ;;
    "raph-f")
        PATHWAY="feeling"
        ;;
    "raph-t")
        PATHWAY="thinking"
        ;;
    "rap")
        TIER="bronze"
        ;;
    "ra")
        TIER="silver"
        ;;
    "r")
        TIER="gold"
        ;;
    "read")
        STAGE="read"
        PATHWAY="feeling"
        ;;
    "absorb")
        STAGE="absorb"
        PATHWAY="feeling"
        ;;
    "perceive")
        STAGE="perceive"
        PATHWAY="feeling"
        ;;
    "harmonise"|"harmonize")
        STAGE="harmonise"
        PATHWAY="feeling"
        ;;
    "research")
        STAGE="research"
        PATHWAY="thinking"
        ;;
    "analyse"|"analyze")
        STAGE="analyse"
        PATHWAY="thinking"
        ;;
    "process")
        STAGE="process"
        PATHWAY="thinking"
        ;;
    "hone")
        STAGE="hone"
        PATHWAY="thinking"
        ;;
esac

# Process remaining arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --tier)
            TIER="$2"
            shift 2
            ;;
        --pathway)
            PATHWAY="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            DOCUMENT="$1"
            shift
            ;;
    esac
done

# Validate inputs
if [[ -z "$DOCUMENT" ]]; then
    echo -e "${RED}Error: No document specified${NC}" >&2
    usage
    exit 1
fi

# Check if document exists (allow for various formats)
if [[ "$DOCUMENT" != "["* ]] && [[ ! -f "$DOCUMENT" ]]; then
    echo -e "${YELLOW}Warning: Document '$DOCUMENT' not found as file${NC}"
    echo -e "${CYAN}Proceeding with document reference/content${NC}"
fi

# Display processing information if verbose
if [[ "$VERBOSE" == true ]]; then
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    echo -e "${BOLD}RAPH Framework Processing${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    echo -e "Document: $DOCUMENT"
    echo -e "Pathway: $PATHWAY"
    echo -e "Tier: $TIER"
    echo -e "Stage: ${STAGE:-all}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}\n"
fi

# Execute appropriate processing tier
case "$TIER" in
    bronze)
        process_bronze "$DOCUMENT" "$PATHWAY"
        ;;
    silver)
        process_silver "$DOCUMENT" "$PATHWAY" "${STAGE:-all}"
        ;;
    gold)
        process_gold "$DOCUMENT" "$PATHWAY"
        ;;
    *)
        echo -e "${RED}Error: Invalid tier '$TIER'${NC}" >&2
        exit 1
        ;;
esac

# Add workflow integration reminder
if [[ "$DOCUMENT" == *"NORTH-STAR"* ]] || [[ "$DOCUMENT" == *"north-star"* ]]; then
    echo -e "\n${YELLOW}📌 Reminder: NORTH-STAR documents require RAPH processing for D1 phase${NC}"
fi

if [[ "$DOCUMENT" == *".oct.md" ]]; then
    echo -e "\n${YELLOW}📌 This appears to be a role file - RAPH sequence is mandatory for activation${NC}"
fi

exit 0