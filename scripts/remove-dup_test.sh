#!/usr/bin/env bash
# remove-dup_test.sh - Test suite for remove-dup.sh
#
# Usage: ./remove-dup_test.sh
#
# Runs 3 high-value test cases against remove-dup.sh and reports results.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REMOVEDUP="$SCRIPT_DIR/remove-dup.sh"

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
    actual=$("$REMOVEDUP" "$@" 2>&1)
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
# Test Case 1: Basic deduplication with simple duplicates
# Validates core deduplication and order preservation using the example
# from the script's own usage documentation.
# ---------------------------------------------------------------------------
run_test "Basic deduplication (example from usage docs)" \
    "banana apple pear" \
    banana banana apple pear

# ---------------------------------------------------------------------------
# Test Case 2: Multiple duplicates across the list
# Ensures all duplicates are removed while maintaining first-occurrence order
# when duplicates are spread throughout the list.
# ---------------------------------------------------------------------------
run_test "Multiple duplicates across the list" \
    "a b c d" \
    a b a c b d

# ---------------------------------------------------------------------------
# Test Case 3: No duplicates
# Validates that the script passes through a list of unique items unchanged,
# preserving the original order without removing any elements.
# ---------------------------------------------------------------------------
run_test "No duplicates (all unique items pass through)" \
    "red green blue yellow" \
    red green blue yellow

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Results: $passed passed, $failed failed."

if (( failed > 0 )); then
    exit 1
fi
