# Git for Windows Example

Use Git for Windows from WSL2 to maintain consistent line endings and Git configuration.

## Setup

```bash
# Auto-detect Git for Windows
wsl-win-bridge add git

# Or specify path manually
wsl-win-bridge add git "/mnt/c/Program Files/Git/bin/git.exe"
```

## Usage

```bash
# All git commands work normally
git status
git add .
git commit -m "message"
git push
```

## Benefits

- Consistent line endings (CRLF handling)
- Use Windows credential manager
- Same Git config as Windows
- Works with Windows-based Git GUIs

## Line Ending Configuration

When using Git for Windows from WSL:

```bash
# Configure line endings
git config --global core.autocrlf true  # Windows-style
# or
git config --global core.autocrlf input # Unix-style in repo, Windows-style in working dir
```

## Credential Management

Git for Windows can use Windows Credential Manager:

```bash
git config --global credential.helper manager
```

## Switching Between WSL and Windows Git

You can have both available:

```bash
# Add Windows Git with different name
wsl-win-bridge add git-win "/mnt/c/Program Files/Git/bin/git.exe"

# Use WSL Git
git status

# Use Windows Git
git-win status
```