# Custom Binary Examples

Examples of wrapping various Windows executables for use in WSL2.

## Visual Studio Code

```bash
# Auto-detect VS Code
wsl-win-bridge add code

# Usage
code .                    # Open current directory
code file.txt            # Open specific file
```

## Node.js

```bash
# Use Windows Node.js
wsl-win-bridge add node

# Also add npm
wsl-win-bridge add npm "/mnt/c/Program Files/nodejs/npm.cmd"

# Usage
node --version
npm install
```

## Python

```bash
# Add Windows Python
wsl-win-bridge add python

# Usage
python --version
python script.py
```

## Docker Desktop

```bash
# Add Docker CLI
wsl-win-bridge add docker "/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"

# Usage
docker ps
docker run hello-world
```

## Custom Application

For any Windows application:

```bash
# Add custom executable
wsl-win-bridge add myapp "/mnt/c/Program Files/MyApp/myapp.exe"

# Usage
myapp --help
```

## PowerShell

```bash
# Add PowerShell
wsl-win-bridge add pwsh "/mnt/c/Program Files/PowerShell/7/pwsh.exe"

# Usage
pwsh -c "Get-Process"
```

## Path Conversion

The wrapper automatically handles WSL path conversion:

```bash
# This WSL path:
code /home/user/project

# Is automatically converted to:
code \\wsl$\Ubuntu\home\user\project
```

## Creating Aliases

You can create multiple wrappers for the same binary:

```bash
# Different Python versions
wsl-win-bridge add python3.9 "/mnt/c/Python39/python.exe"
wsl-win-bridge add python3.10 "/mnt/c/Python310/python.exe"

# Usage
python3.9 --version
python3.10 --version
```

## Tips

1. **Auto-detection**: Try auto-detection first before specifying paths
2. **Path handling**: The wrapper handles path conversions automatically
3. **Arguments**: All command arguments are passed through correctly
4. **Performance**: Direct execution means native Windows performance
5. **Integration**: Works seamlessly with WSL2 scripts and tools