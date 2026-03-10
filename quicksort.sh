#!/usr/bin/env bash
# quicksort.sh - Sort a list of integers using the QuickSort algorithm
#
# Usage:   ./quicksort.sh <num1> <num2> ... <numN>
# Example: ./quicksort.sh 5 3 8 1 2
#
# Notes:
#   - Accepts integers only (negative integers are supported, e.g. -5)
#   - Use -- to separate flags from negative numbers: ./quicksort.sh -- -5 3 1
#   - Bash recursion limit (FUNCNEST, default ~200) applies for very large inputs
#   - Worst-case O(n²) performance on already-sorted input (last-element pivot)

set -euo pipefail

# ---------------------------------------------------------------------------
# usage / help
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") <num1> <num2> ... <numN>
       $(basename "$0") -- <num1> <num2> ... <numN>   (use -- before negative numbers)

Sort a list of integers using the QuickSort algorithm.

Examples:
  $(basename "$0") 5 3 8 1 2
  $(basename "$0") 10 -3 7 0 -1
  $(basename "$0") -- -5 3 1 -2

Options:
  -h, --help    Show this help message and exit
EOF
}

# ---------------------------------------------------------------------------
# argument handling
# ---------------------------------------------------------------------------
if [[ $# -eq 0 ]]; then
    echo "Error: No numbers provided." >&2
    echo >&2
    usage >&2
    exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    usage
    exit 0
fi

# Support -- separator to allow negative numbers starting with -
if [[ "$1" == "--" ]]; then
    shift
    if [[ $# -eq 0 ]]; then
        echo "Error: No numbers provided after --." >&2
        echo >&2
        usage >&2
        exit 1
    fi
fi

# ---------------------------------------------------------------------------
# input validation
# ---------------------------------------------------------------------------
input=("$@")

for arg in "${input[@]}"; do
    if ! [[ "$arg" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid input '${arg}'. Only integers are accepted." >&2
        exit 1
    fi
done

# ---------------------------------------------------------------------------
# QuickSort implementation
# ---------------------------------------------------------------------------
# sorted_result accumulates the final sorted array (global)
sorted_result=()

quicksort() {
    local arr=("$@")
    local n=${#arr[@]}

    # Base case: 0 or 1 element is already sorted
    if (( n <= 1 )); then
        sorted_result+=("${arr[@]}")
        return
    fi

    # Choose the last element as pivot
    local pivot="${arr[$((n - 1))]}"

    local less=()
    local greater=()

    # Partition elements (all except the pivot)
    local i
    for (( i = 0; i < n - 1; i++ )); do
        if (( arr[i] <= pivot )); then
            less+=("${arr[i]}")
        else
            greater+=("${arr[i]}")
        fi
    done

    # Recursively sort partitions
    if (( ${#less[@]} > 0 )); then
        quicksort "${less[@]}"
    fi

    # Insert pivot between partitions
    sorted_result+=("$pivot")

    if (( ${#greater[@]} > 0 )); then
        quicksort "${greater[@]}"
    fi
}

# ---------------------------------------------------------------------------
# sort and print result
# ---------------------------------------------------------------------------
quicksort "${input[@]}"

echo "${sorted_result[*]}"
