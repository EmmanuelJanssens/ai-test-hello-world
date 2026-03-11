#!/usr/bin/env bash
# sort_orchestrator.sh - Master sort script that delegates to a chosen sort algorithm
#
# Usage:   ./sort_orchestrator.sh <sort_type> <num1> <num2> ... <numN>
# Example: ./sort_orchestrator.sh quick 5 3 8 1 2
#          ./sort_orchestrator.sh merge 5 3 8 1 2
#
# Sort types:
#   quick  | quicksort   — Sort using the QuickSort algorithm
#   merge  | merge_sort  — Sort using the Merge Sort algorithm
#
# Notes:
#   - Accepts integers only (negative integers are supported, e.g. -5)
#   - Use -- after the sort type to separate flags from negative numbers:
#       ./sort_orchestrator.sh quick -- -5 3 1
#   - The script exits with the same exit code as the underlying sort script

set -euo pipefail

# ---------------------------------------------------------------------------
# Resolve the directory where this script lives so it can locate siblings
# ---------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# usage / help
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") <sort_type> <num1> <num2> ... <numN>
       $(basename "$0") <sort_type> -- <num1> <num2> ... <numN>  (use -- before negative numbers)

Sort a list of integers using the specified algorithm and print the sorted
result together with the method name.

Sort types:
  quick, quicksort    Use the QuickSort algorithm
  merge, merge_sort   Use the Merge Sort algorithm

Options:
  -h, --help          Show this help message and exit

Examples:
  $(basename "$0") quick 5 3 8 1 2
  $(basename "$0") merge 10 -3 7 0 -1
  $(basename "$0") quick -- -5 3 1 -2
  $(basename "$0") merge_sort 9 4 6 2 7

Output format:
  Sorted list: 1 2 3 5 8
  Method: quicksort
EOF
}

# ---------------------------------------------------------------------------
# argument handling
# ---------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    echo "Error: No arguments provided." >&2
    echo >&2
    usage >&2
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

# First argument is the sort type
SORT_TYPE="$1"
shift

# ---------------------------------------------------------------------------
# validate sort type and resolve to canonical name + script path
# ---------------------------------------------------------------------------
case "$SORT_TYPE" in
    quick|quicksort)
        METHOD="quicksort"
        SORT_SCRIPT="${SCRIPT_DIR}/quicksort.sh"
        ;;
    merge|merge_sort)
        METHOD="merge_sort"
        SORT_SCRIPT="${SCRIPT_DIR}/merge_sort.sh"
        ;;
    *)
        echo "Error: Unknown sort type '${SORT_TYPE}'." >&2
        echo "       Valid types are: quick, quicksort, merge, merge_sort" >&2
        echo >&2
        usage >&2
        exit 1
        ;;
esac

# ---------------------------------------------------------------------------
# ensure at least one number was supplied
# ---------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    echo "Error: No numbers provided." >&2
    echo >&2
    usage >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# ensure the target sort script exists and is executable
# ---------------------------------------------------------------------------
if [[ ! -f "$SORT_SCRIPT" ]]; then
    echo "Error: Sort script not found: ${SORT_SCRIPT}" >&2
    exit 1
fi

if [[ ! -x "$SORT_SCRIPT" ]]; then
    echo "Error: Sort script is not executable: ${SORT_SCRIPT}" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# delegate to the chosen sort script, capturing its output
# ---------------------------------------------------------------------------
# All remaining arguments (including any -- separator) are forwarded as-is.
if ! SORTED="$("$SORT_SCRIPT" "$@")"; then
    echo "Error: '${METHOD}' script failed." >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# output results
# ---------------------------------------------------------------------------
echo "Sorted list: ${SORTED}"
echo "Method: ${METHOD}"
