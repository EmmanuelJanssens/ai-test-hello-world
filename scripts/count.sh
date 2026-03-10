#!/usr/bin/env bash
# count.sh - Count the frequency of each word in the provided arguments
#
# Usage:   ./count.sh <word1> <word2> ... <wordN>
# Example: ./count.sh how many apples are in the apple tree
#
# Notes:
#   - Comparison is case-insensitive (e.g. "Apple" and "apple" are counted together)
#   - Output is in "word: count" format, one word per line
#   - Words are output in first-occurrence order
#   - Punctuation and special characters are stripped; numbers are stripped
#   - Requires Bash >= 4.0 (uses associative arrays)

set -euo pipefail

# ---------------------------------------------------------------------------
# usage / help
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") <word1> <word2> ... <wordN>

Count the frequency of each word in the provided arguments.

Examples:
  $(basename "$0") how many apples are in the apple tree
  $(basename "$0") the cat sat on the mat

Options:
  -h, --help    Show this help message and exit
EOF
}

# ---------------------------------------------------------------------------
# argument handling
# ---------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    echo "Error: No words provided." >&2
    echo >&2
    usage >&2
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

# ---------------------------------------------------------------------------
# word counting
# ---------------------------------------------------------------------------
declare -A counts
order=()

for arg in "$@"; do
    # Lowercase and strip non-alpha characters
    word="${arg,,}"
    word="${word//[^a-z]/}"

    # Skip empty strings (e.g. if arg was purely punctuation/numbers)
    [[ -z "$word" ]] && continue

    if [[ -z "${counts[$word]+set}" ]]; then
        counts[$word]=1
        order+=("$word")
    else
        (( counts[$word]++ )) || true
    fi
done

# ---------------------------------------------------------------------------
# output
# ---------------------------------------------------------------------------
for word in "${order[@]}"; do
    echo "$word: ${counts[$word]}"
done
