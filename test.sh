#!/bin/bash

# WSL-Windows Bridge Test Script

set -e

echo "=== WSL-Windows Bridge Test Suite ==="
echo

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
test_command() {
    local description="$1"
    local command="$2"
    local expected_result="${3:-0}"
    
    echo -n "Testing: $description... "
    
    if eval "$command" >/dev/null 2>&1; then
        if [ "$expected_result" -eq 0 ]; then
            echo -e "${GREEN}✓ PASSED${NC}"
            ((TESTS_PASSED++))
        else
            echo -e "${RED}✗ FAILED (expected failure)${NC}"
            ((TESTS_FAILED++))
        fi
    else
        if [ "$expected_result" -ne 0 ]; then
            echo -e "${GREEN}✓ PASSED (expected failure)${NC}"
            ((TESTS_PASSED++))
        else
            echo -e "${RED}✗ FAILED${NC}"
            ((TESTS_FAILED++))
        fi
    fi
}

# Clean up any existing installation
echo "Cleaning up existing installation..."
rm -rf ~/.wsl-win-bridge
rm -f ~/bin/adb ~/bin/test-binary

# Install
echo -e "\n${YELLOW}Running installation...${NC}"
echo "5" | ./install.sh >/dev/null 2>&1 || {
    echo -e "${RED}Installation failed!${NC}"
    exit 1
}

# Tests
echo -e "\n${YELLOW}Running tests...${NC}\n"

# Test 1: Help command
test_command "Help command" "wsl-win-bridge help"

# Test 2: List (empty)
test_command "List empty wrappers" "wsl-win-bridge list"

# Test 3: Add ADB
test_command "Add ADB wrapper" "wsl-win-bridge add adb"

# Test 4: Test ADB wrapper
test_command "Test ADB wrapper" "wsl-win-bridge test adb"

# Test 5: Use ADB
test_command "Use ADB devices command" "adb devices"

# Test 6: List with ADB
test_command "List wrappers (with ADB)" "wsl-win-bridge list | grep -q adb"

# Test 7: Add non-existent binary
test_command "Add non-existent binary (should fail)" "wsl-win-bridge add fakebinary" 1

# Test 8: Remove wrapper
test_command "Remove ADB wrapper" "wsl-win-bridge remove adb"

# Test 9: Verify removal
test_command "Verify ADB removed" "[ ! -f ~/bin/adb ]"

# Test 10: Add with custom path
if [ -f "/mnt/c/Windows/System32/notepad.exe" ]; then
    test_command "Add notepad with custom path" "wsl-win-bridge add notepad '/mnt/c/Windows/System32/notepad.exe'"
    test_command "Remove notepad" "wsl-win-bridge remove notepad"
fi

# Summary
echo
echo "=== Test Summary ==="
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
echo

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi