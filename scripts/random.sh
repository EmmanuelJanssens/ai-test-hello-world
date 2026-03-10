#!/usr/bin/env bash
# random.sh - Generate a random integer between two bounds (inclusive)
#
# Usage:   ./random.sh <min> <max>
# Example: ./random.sh 10 30
#
# Notes:
#   - Both arguments must be integers (negative integers are supported)
#   - min must be less than or equal to max
#   - Uses bash $RANDOM (range 0-32767); suitable for small ranges

set -euo pipefail

# ---------------------------------------------------------------------------
# usage / help
# ---------------------------------------------------------------------------
usage() {
    cat <<EOF
Usage: $(basename "$0") <min> <max>

Generate a random integer between min and max (inclusive).

Examples:
  $(basename "$0") 10 30
  $(basename "$0") 1 100
  $(basename "$0") -5 5

Options:
  -h, --help    Show this help message and exit
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

if [[ $# -ne 2 ]]; then
    echo "Error: Exactly two arguments required (min and max)." >&2
    echo >&2
    usage >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# input validation
# ---------------------------------------------------------------------------
for arg in "$@"; do
    if ! [[ "$arg" =~ ^-?[0-9]+$ ]]; then
        echo "Error: Invalid input '${arg}'. Only integers are accepted." >&2
        exit 1
    fi
done

min=$1
max=$2

if (( min > max )); then
    echo "Error: min (${min}) must be less than or equal to max (${max})." >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# generate random number
# ---------------------------------------------------------------------------
range=$(( max - min + 1 ))
echo $(( RANDOM % range + min ))
