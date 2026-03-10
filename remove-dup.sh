#!/usr/bin/env bash
# remove-dup.sh - Remove duplicate strings from a list, preserving first-occurrence order
#
# Usage:   ./remove-dup.sh <str1> <str2> ... <strN>
# Example: ./remove-dup.sh banana banana apple pear
#
# Notes:
#   - Comparison is case-sensitive (e.g. "Banana" and "banana" are treated as different values)
#   - First occurrence of each string is kept; subsequent duplicates are discarded
#   - Requires Bash >= 4.0 (uses associative arrays)

set -euo pipefail

# ---------------------------------------------------------------------------
# usage / help
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") <str1> <str2> ... <strN>

Remove duplicate strings from a list, preserving first-occurrence order.

Examples:
  $(basename "$0") banana banana apple pear
  $(basename "$0") a b a c b d

Options:
  -h, --help    Show this help message and exit
EOF
}

# ---------------------------------------------------------------------------
# argument handling
# ---------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    echo "Error: No strings provided." >&2
    echo >&2
    usage >&2
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

# ---------------------------------------------------------------------------
# deduplication
# ---------------------------------------------------------------------------
declare -A seen
result=()

for arg in "$@"; do
    if [[ -z "${seen[$arg]+set}" ]]; then
        seen[$arg]=1
        result+=("$arg")
    fi
done

echo "${result[*]}"
