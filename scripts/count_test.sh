#!/usr/bin/env bash
# count_test.sh - Test suite for count.sh
#
# Usage: ./count_test.sh
#
# Runs 2 high-value test cases against count.sh and reports results.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COUNT="$SCRIPT_DIR/count.sh"

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
    actual=$("$COUNT" "$@" 2>&1)
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
# Test Case 1: Example from the task description
# Validates basic word counting with repeated words ("apple"/"apples" are
# distinct words), preserving first-occurrence output order.
# ---------------------------------------------------------------------------
run_test "Basic word count (task description example)" \
    "how: 1
many: 1
apples: 1
are: 1
in: 1
the: 1
apple: 1
tree: 1" \
    how many apples are in the apple tree

# ---------------------------------------------------------------------------
# Test Case 2: Case-insensitive counting with repeated words and punctuation
# Validates that "The" and "the" are counted as the same word, that repeated
# words accumulate correctly, and that punctuation is stripped from tokens.
# ---------------------------------------------------------------------------
run_test "Case-insensitive duplicates and punctuation stripping" \
    "the: 3
cat: 2
sat: 1
on: 1
mat: 1" \
    The cat sat on the mat, the cat.

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Results: $passed passed, $failed failed."

if (( failed > 0 )); then
    exit 1
fi
