#!/usr/bin/env bash
# random_test.sh - Test suite for random.sh
#
# Usage: ./random_test.sh
#
# Runs 3 high-value test cases against random.sh and reports results.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RANDOM_SH="$SCRIPT_DIR/random.sh"

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
    actual=$("$RANDOM_SH" "$@" 2>&1)
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

# Helper: run random.sh and check the result is within [min, max]
run_range_test() {
    local name="$1"
    local min="$2"
    local max="$3"
    local iterations="${4:-20}"
    local all_ok=true
    local i result

    for (( i = 0; i < iterations; i++ )); do
        result=$("$RANDOM_SH" "$min" "$max" 2>&1)
        if ! [[ "$result" =~ ^-?[0-9]+$ ]] || (( result < min || result > max )); then
            echo "FAIL: $name"
            echo "      Got '$result' which is outside [$min, $max] (iteration $((i+1)))"
            (( failed++ )) || true
            all_ok=false
            break
        fi
    done

    if $all_ok; then
        echo "PASS: $name"
        (( passed++ )) || true
    fi
}

# ---------------------------------------------------------------------------
# Test Case 1: Basic random number within a positive range
# Runs random.sh multiple times with a small positive range and verifies
# every result falls within the specified [min, max] bounds.
# ---------------------------------------------------------------------------
run_range_test "Random output within positive range [10, 30]" 10 30 20

# ---------------------------------------------------------------------------
# Test Case 2: Negative-to-positive range including zero
# Validates that random.sh correctly handles negative min, positive max,
# and that the result always falls within [min, max].
# ---------------------------------------------------------------------------
run_range_test "Random output within negative-to-positive range [-5, 5]" -5 5 20

# ---------------------------------------------------------------------------
# Test Case 3: Error handling for invalid arguments
# Validates that random.sh returns a non-zero exit code and a meaningful
# error message when given non-integer input or when min > max.
# ---------------------------------------------------------------------------
test3_name="Error handling for invalid arguments"
test3_all_ok=true

# Sub-test 3a: non-integer argument
output=$("$RANDOM_SH" abc 10 2>&1)
exit_code=$?
if (( exit_code == 0 )); then
    echo "FAIL: $test3_name"
    echo "      Non-integer input 'abc' should produce non-zero exit code, got 0"
    test3_all_ok=false
fi

# Sub-test 3b: min > max
if $test3_all_ok; then
    output=$("$RANDOM_SH" 50 10 2>&1)
    exit_code=$?
    if (( exit_code == 0 )); then
        echo "FAIL: $test3_name"
        echo "      min > max should produce non-zero exit code, got 0"
        test3_all_ok=false
    fi
fi

# Sub-test 3c: no arguments
if $test3_all_ok; then
    output=$("$RANDOM_SH" 2>&1)
    exit_code=$?
    if (( exit_code == 0 )); then
        echo "FAIL: $test3_name"
        echo "      No arguments should produce non-zero exit code, got 0"
        test3_all_ok=false
    fi
fi

if $test3_all_ok; then
    echo "PASS: $test3_name"
    (( passed++ )) || true
else
    (( failed++ )) || true
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "Results: $passed passed, $failed failed."

if (( failed > 0 )); then
    exit 1
fi
