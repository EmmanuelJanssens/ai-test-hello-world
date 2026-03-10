#!/usr/bin/env bash
# quicksort_test.sh - Test suite for quicksort.sh
#
# Usage: ./quicksort_test.sh
#
# Runs 3 high-value test cases against quicksort.sh and reports results.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUICKSORT="$SCRIPT_DIR/quicksort.sh"

passed=0
failed=0

# ---------------------------------------------------------------------------
# Helper: run one test and compare actual vs expected output
# ---------------------------------------------------------------------------
run_test() {
    local name="$1"
    local expected="$2"
    shift 2
    local actual
    actual=$("$QUICKSORT" "$@" 2>&1)
    if [[ "$actual" == "$expected" ]]; then
        echo "PASS: $name"
        (( passed++ )) || true
    else
        echo "FAIL: $name"
        echo "      Expected : $expected"
        echo "      Actual   : $actual"
        (( failed++ )) || true
    fi
}

# ---------------------------------------------------------------------------
# Test Case 1: Basic sorting with positive integers
# Validates core quicksort functionality on a typical unsorted list.
# ---------------------------------------------------------------------------
run_test "Basic sorting (positive integers)" \
    "1 2 3 5 8" \
    5 3 8 1 2

# ---------------------------------------------------------------------------
# Test Case 2: Mixed positive and negative numbers
# Ensures negative integers and zero are handled and ordered correctly.
# ---------------------------------------------------------------------------
run_test "Mixed positive and negative numbers" \
    "-3 -1 0 7 10" \
    10 -3 7 0 -1

# ---------------------------------------------------------------------------
# Test Case 3: Duplicate values and reverse-sorted input
# Validates robustness with duplicates and the O(n²) worst-case scenario
# (reverse-sorted input with last-element pivot).
# ---------------------------------------------------------------------------
run_test "Duplicate values and reverse-sorted input" \
    "1 1 2 3 3" \
    3 1 3 1 2

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Results: $passed passed, $failed failed."

if (( failed > 0 )); then
    exit 1
fi
