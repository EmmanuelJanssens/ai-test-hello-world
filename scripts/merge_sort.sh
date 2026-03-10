#!/usr/bin/env bash
# merge_sort.sh - Sort a list of integers using the Merge Sort algorithm
#
# Usage:   ./merge_sort.sh <num1> <num2> ... <numN>
# Example: ./merge_sort.sh 5 3 8 1 2
#
# Notes:
#   - Accepts integers only (negative integers are supported, e.g. -5)
#   - Use -- to separate flags from negative numbers: ./merge_sort.sh -- -5 3 1
#   - Bash recursion limit (FUNCNEST, default ~200) applies for very large inputs
#   - O(n log n) time complexity; balanced splits keep recursion depth to O(log n)
#   - Merge sort is a stable sort: equal elements preserve their original order

set -euo pipefail

# ---------------------------------------------------------------------------
# usage / help
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") <num1> <num2> ... <numN>
       $(basename "$0") -- <num1> <num2> ... <numN>   (use -- before negative numbers)

Sort a list of integers using the Merge Sort algorithm.

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
# Merge Sort implementation
# ---------------------------------------------------------------------------
# sorted_result accumulates the final sorted array (global)
sorted_result=()

# merge: merges two sorted subarrays into sorted_result
# Arguments: left_size right_size left_elem... right_elem...
merge() {
    local left_size=$1
    local right_size=$2
    shift 2

    local left=("${@:1:$left_size}")
    local right=("${@:$((left_size + 1)):$right_size}")

    local i=0
    local j=0

    while (( i < left_size && j < right_size )); do
        if (( left[i] <= right[j] )); then
            sorted_result+=("${left[i]}")
            (( i++ )) || true
        else
            sorted_result+=("${right[j]}")
            (( j++ )) || true
        fi
    done

    # Append any remaining elements
    while (( i < left_size )); do
        sorted_result+=("${left[i]}")
        (( i++ )) || true
    done

    while (( j < right_size )); do
        sorted_result+=("${right[j]}")
        (( j++ )) || true
    done
}

merge_sort() {
    local arr=("$@")
    local n=${#arr[@]}

    # Base case: 0 or 1 element is already sorted
    if (( n <= 1 )); then
        sorted_result+=("${arr[@]}")
        return
    fi

    local mid=$(( n / 2 ))
    local left=("${arr[@]:0:$mid}")
    local right=("${arr[@]:$mid}")

    # Recursively sort each half, collecting results into temp arrays
    local saved_result=("${sorted_result[@]+"${sorted_result[@]}"}")

    sorted_result=()
    merge_sort "${left[@]}"
    local sorted_left=("${sorted_result[@]}")

    sorted_result=()
    merge_sort "${right[@]}"
    local sorted_right=("${sorted_result[@]}")

    # Restore any previously accumulated result and merge the two halves
    sorted_result=("${saved_result[@]+"${saved_result[@]}"}")
    merge "${#sorted_left[@]}" "${#sorted_right[@]}" "${sorted_left[@]}" "${sorted_right[@]}"
}

# ---------------------------------------------------------------------------
# sort and print result
# ---------------------------------------------------------------------------
merge_sort "${input[@]}"

echo "${sorted_result[*]}"
