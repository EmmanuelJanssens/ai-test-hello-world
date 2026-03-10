# ai-test-hello-world

A simple project demonstrating "Hello World" programs in JavaScript and Python, organized by programming language.

## Project Structure

```
ai-test-hello-world/
├── README.md
├── scripts/
│   ├── quicksort.sh
│   └── remove-dup.sh
├── javascript/
│   └── main.js
└── python/
    └── hello.py
```

## Hello World Javascript

To run the JavaScript Hello World program:

**Prerequisites:** Node.js must be installed on your system.

```bash
node javascript/main.js
```

## Hello World Python

To run the Python Hello World program:

**Prerequisites:** Python must be installed on your system.

```bash
python python/hello.py
```

or

```bash
python3 python/hello.py
```

## QuickSort Bash

Sorts a list of integers using the QuickSort algorithm.

**Prerequisites:** Bash must be available on your system. It is standard on Linux and macOS. Windows users can use [Git Bash](https://git-scm.com/) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/).

Before running the script for the first time, make sure it has execute permissions:

```bash
chmod +x scripts/quicksort.sh
```

**Usage:**

```bash
./scripts/quicksort.sh 5 3 8 1 2
./scripts/quicksort.sh 10 -3 7 0 -1
./scripts/quicksort.sh -- -5 3 1 -2
```

> **Note:** Use the `--` separator before negative numbers to prevent them from being interpreted as flags (e.g. `./scripts/quicksort.sh -- -5 3 1 -2`).

For help and usage information, run:

```bash
./scripts/quicksort.sh --help
```

## QuickSort Tests

A small test suite is provided to verify the quicksort script against three high-value scenarios: basic sorting, mixed positive/negative numbers, and duplicate values.

Before running the tests for the first time, make sure the test script has execute permissions:

```bash
chmod +x scripts/quicksort_test.sh
```

Run all tests from the project root:

```bash
./scripts/quicksort_test.sh
```

A passing run will look like:

```
PASS: Basic sorting (positive integers)
PASS: Mixed positive and negative numbers
PASS: Duplicate values and reverse-sorted input

Results: 3 passed, 0 failed.
```

## Remove Duplicates Bash

Removes duplicate strings from a list, preserving first-occurrence order.

**Prerequisites:** Bash >= 4.0 must be available on your system. It is standard on Linux. macOS users should verify their Bash version with `bash --version` (macOS ships Bash 3.2 by default; install a newer version via [Homebrew](https://brew.sh/)). Windows users can use [Git Bash](https://git-scm.com/) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/).

Before running the script for the first time, make sure it has execute permissions:

```bash
chmod +x scripts/remove-dup.sh
```

**Usage:**

```bash
./scripts/remove-dup.sh banana banana apple pear
./scripts/remove-dup.sh a b a c b d
```

For help and usage information, run:

```bash
./scripts/remove-dup.sh --help
```

## Count Words Bash

Counts the frequency of each word in the provided arguments, outputting results in first-occurrence order.

**Prerequisites:** Bash >= 4.0 must be available on your system. It is standard on Linux. macOS users should verify their Bash version with `bash --version` (macOS ships Bash 3.2 by default; install a newer version via [Homebrew](https://brew.sh/)). Windows users can use [Git Bash](https://git-scm.com/) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/)).

Before running the script for the first time, make sure it has execute permissions:

```bash
chmod +x scripts/count.sh
```

**Usage:**

```bash
./scripts/count.sh how many apples are in the apple tree
./scripts/count.sh the cat sat on the mat
```

> **Note:** Comparison is case-insensitive (e.g. `Apple` and `apple` are counted together). Punctuation and special characters are stripped from words before counting.

For help and usage information, run:

```bash
./scripts/count.sh --help
```

## Count Tests

A small test suite is provided to verify the count script against two high-value scenarios: basic word counting and case-insensitive counting with punctuation stripping.

Before running the tests for the first time, make sure the test script has execute permissions:

```bash
chmod +x scripts/count_test.sh
```

Run all tests from the project root:

```bash
./scripts/count_test.sh
```

A passing run will look like:

```
PASS: Basic word count (task description example)
PASS: Case-insensitive duplicates and punctuation stripping

Results: 2 passed, 0 failed.
```