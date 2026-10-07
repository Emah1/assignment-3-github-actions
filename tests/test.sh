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
echo "        APPLICATION TESTS"
echo "======================================"

APP="./app/app.sh"

if [[ ! -x "$APP" ]]; then
    fail "app/app.sh is not executable"
    exit 1
fi

if "$APP" help >/dev/null 2>&1; then
    pass "help command works"
else
    fail "help command failed"
fi

if "$APP" system-info >/dev/null 2>&1; then
    pass "system-info command works"
else
    fail "system-info command failed"
fi

"$APP" >/dev/null 2>&1
rc=$?

if [[ "$rc" -eq 2 ]]; then
    pass "missing command returns exit code 2"
else
    fail "missing command returned exit code $rc"
fi

"$APP" check-port localhost abc >/dev/null 2>&1
rc=$?

if [[ "$rc" -eq 2 ]]; then
    pass "non-numeric port returns exit code 2"
else
    fail "non-numeric port returned exit code $rc"
fi

"$APP" check-port localhost 0 >/dev/null 2>&1
rc=$?

if [[ "$rc" -eq 2 ]]; then
    pass "port 0 is rejected"
else
    fail "port 0 returned exit code $rc"
fi

"$APP" check-port localhost 65536 >/dev/null 2>&1
rc=$?

if [[ "$rc" -eq 2 ]]; then
    pass "port 65536 is rejected"
else
    fail "port 65536 returned exit code $rc"
fi

echo
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [[ "$FAIL" -eq 0 ]]; then
    echo "ALL TESTS PASSED"
    exit 0
else
    echo "SOME TESTS FAILED"
    exit 1
fi
