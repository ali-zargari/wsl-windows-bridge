#!/bin/bash

# WSL-Windows Bridge Installation Script

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}WSL-Windows Bridge Installer${NC}"
echo "=============================="
echo

# Check if running in WSL
if ! grep -q Microsoft /proc/version && ! grep -q WSL /proc/version; then
    echo -e "${RED}Error: This tool must be run in WSL2${NC}"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if wsl-win-bridge exists
if [ ! -f "$SCRIPT_DIR/wsl-win-bridge" ]; then
    echo -e "${RED}Error: wsl-win-bridge not found in $SCRIPT_DIR${NC}"
    exit 1
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p "$HOME/.wsl-win-bridge/wrappers"
mkdir -p "$HOME/bin"

# Install the main script
echo "Installing wsl-win-bridge..."
INSTALL_PATH="$HOME/.wsl-win-bridge/wsl-win-bridge"
cp -r "$SCRIPT_DIR"/* "$HOME/.wsl-win-bridge/"
chmod +x "$INSTALL_PATH"

# Create symlink in user's bin
ln -sf "$INSTALL_PATH" "$HOME/bin/wsl-win-bridge"

# Update PATH if needed
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
    echo "Updating PATH..."
    echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/bin:$PATH"
    echo -e "${YELLOW}Note: PATH updated. Run 'source ~/.bashrc' or start a new terminal${NC}"
fi

echo
echo -e "${GREEN}✓ WSL-Windows Bridge installed successfully!${NC}"
echo

# Offer to set up common binaries
echo "Would you like to set up common Windows binaries?"
echo "1) Android ADB"
echo "2) Git for Windows"
echo "3) Visual Studio Code"
echo "4) All of the above"
echo "5) Skip"
echo
read -p "Select option (1-5): " -n 1 -r
echo

case $REPLY in
    1)
        wsl-win-bridge add adb
        ;;
    2)
        wsl-win-bridge add git
        ;;
    3)
        wsl-win-bridge add code
        ;;
    4)
        echo "Setting up all common binaries..."
        wsl-win-bridge add adb 2>/dev/null || echo "ADB not found"
        wsl-win-bridge add git 2>/dev/null || echo "Git not found"
        wsl-win-bridge add code 2>/dev/null || echo "VS Code not found"
        ;;
    *)
        echo "Skipping automatic setup"
        ;;
esac

echo
echo -e "${BLUE}Quick Start:${NC}"
echo "  wsl-win-bridge add <name>        # Add a Windows binary"
echo "  wsl-win-bridge list              # List all wrappers"
echo "  wsl-win-bridge help              # Show help"
echo
echo "Example:"
echo "  wsl-win-bridge add adb"
echo "  adb devices                      # Now works from WSL!"
echo