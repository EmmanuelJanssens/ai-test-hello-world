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