#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
}

echo "======================================"
echo "        BASH LINT CHECK"
echo "======================================"

FILES=(
    "app/app.sh"
    "scripts/lint.sh"
    "scripts/build.sh"
    "tests/test.sh"
)

for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then
        if bash -n "$file" >/dev/null 2>&1; then
            pass "Bash syntax: $file"
        else
            fail "Bash syntax error: $file"
        fi
    else
        fail "Missing file: $file"
    fi
done

echo
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
    echo "LINT PASSED"
    exit 0
else
    echo "LINT FAILED"
    exit 1
fi
