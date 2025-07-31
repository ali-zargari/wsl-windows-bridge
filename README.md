# WSL-Windows Bridge

A universal tool for seamlessly running Windows executables from WSL2. No more connection issues, port forwarding, or complex networking setups.

## What It Does

WSL-Windows Bridge creates lightweight wrapper scripts that allow you to run Windows executables from WSL2 as if they were native Linux commands. Perfect for:

- Android development (ADB)
- Using Windows Git from WSL
- Running VS Code
- Any Windows executable you need in WSL

## Quick Start

```bash
# Install
./install.sh

# Add Android ADB
wsl-win-bridge add adb

# Now use it normally
adb devices
```

## Installation

### Method 1: Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/[user]/wsl-windows-bridge/main/install.sh | bash
```

### Method 2: Clone and Install

```bash
git clone https://github.com/[user]/wsl-windows-bridge
cd wsl-windows-bridge
./install.sh
```

## Usage

### Add a Windows Binary

```bash
# Auto-detect common binaries
wsl-win-bridge add adb
wsl-win-bridge add git
wsl-win-bridge add code

# Or specify path manually
wsl-win-bridge add myapp "/mnt/c/Program Files/MyApp/myapp.exe"
```

### List Wrappers

```bash
wsl-win-bridge list
```

### Remove a Wrapper

```bash
wsl-win-bridge remove adb
```

### Test a Wrapper

```bash
wsl-win-bridge test adb
```

### Update All Wrappers

```bash
wsl-win-bridge update
```

## Supported Auto-Detection

The tool can automatically find these common Windows binaries:

- **adb** - Android Debug Bridge
- **git** - Git for Windows
- **code** - Visual Studio Code
- **node** - Node.js
- **python** - Python for Windows
- **docker** - Docker Desktop

## How It Works

1. Creates a wrapper script in `~/bin/` for each Windows executable
2. The wrapper calls the Windows .exe directly through WSL's interop
3. Handles path conversion automatically
4. No network setup or port forwarding needed

## Examples

### Android Development

```bash
# Add ADB
wsl-win-bridge add adb

# Use normally
adb devices
adb install app.apk
adb logcat
```

### Git Integration

```bash
# Use Windows Git (for consistent line endings)
wsl-win-bridge add git

# All git commands work
git clone https://github.com/user/repo
git commit -m "message"
```

### Multiple Versions

```bash
# Add different Python versions
wsl-win-bridge add python39 "/mnt/c/Python39/python.exe"
wsl-win-bridge add python310 "/mnt/c/Python310/python.exe"

# Use them
python39 script.py
python310 script.py
```

## Advanced Features

### Path Conversion

The wrapper automatically converts WSL paths to Windows paths:

```bash
# This WSL path:
code /home/user/project

# Is converted to:
code \\wsl$\Ubuntu\home\user\project
```

### Custom Wrappers

Create wrappers for any Windows executable:

```bash
wsl-win-bridge add notepad "/mnt/c/Windows/System32/notepad.exe"
notepad file.txt  # Opens in Windows Notepad
```

## Troubleshooting

### Binary Not Found

If auto-detection fails:

1. Locate the .exe file in Windows
2. Convert path: `C:\Program Files\App\app.exe` → `/mnt/c/Program Files/App/app.exe`
3. Add manually: `wsl-win-bridge add app "/mnt/c/Program Files/App/app.exe"`

### Permission Issues

```bash
chmod +x ~/.wsl-win-bridge/wsl-win-bridge
```

### PATH Not Updated

```bash
source ~/.bashrc
# or start a new terminal
```

## Architecture

```
wsl-win-bridge/
├── wsl-win-bridge      # Main CLI tool
├── install.sh          # Installation script
├── lib/
│   ├── create-wrapper.sh   # Wrapper creation logic
│   ├── detect-binary.sh    # Auto-detection logic
│   └── config.sh          # Configuration management
└── examples/           # Usage examples
```

## Benefits

- **No Network Configuration**: Direct execution, no TCP/IP setup
- **Universal**: Works with any Windows executable
- **Transparent**: Use Windows tools as if they were Linux commands
- **Fast**: Native Windows performance
- **Simple**: One command to set up

## Contributing

Contributions welcome! To add auto-detection for a new binary:

1. Edit `lib/detect-binary.sh`
2. Add a new detection function
3. Submit a pull request

## License

MIT License - See LICENSE file for details

## Acknowledgments

Originally created to solve WSL2-Android emulator connectivity issues, expanded to support any Windows executable.