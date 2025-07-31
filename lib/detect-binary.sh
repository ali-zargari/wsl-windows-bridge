#!/bin/bash

# Binary detection library for WSL-Windows Bridge
# Auto-detects common Windows binaries

# Detect a Windows binary by name
detect_binary() {
    local name="$1"
    local result=""
    
    case "$name" in
        adb)
            result=$(detect_adb)
            ;;
        git)
            result=$(detect_git)
            ;;
        code)
            result=$(detect_vscode)
            ;;
        node)
            result=$(detect_node)
            ;;
        python|python3)
            result=$(detect_python)
            ;;
        docker)
            result=$(detect_docker)
            ;;
        *)
            # Try generic detection
            result=$(detect_generic "$name")
            ;;
    esac
    
    echo "$result"
}

# Detect Android ADB
detect_adb() {
    local paths=(
        "/mnt/c/Users/$USER/AppData/Local/Android/Sdk/platform-tools/adb.exe"
        "/mnt/c/Android/sdk/platform-tools/adb.exe"
        "/mnt/c/Android/Sdk/platform-tools/adb.exe"
        "/mnt/c/Program Files/Android/platform-tools/adb.exe"
        "/mnt/c/Program Files (x86)/Android/platform-tools/adb.exe"
    )
    
    # Check standard locations
    for path in "${paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # Try to find in common Android Studio locations
    local android_studio_paths=(
        "/mnt/c/Users/$USER/AppData/Local/Android"
        "/mnt/c/Program Files/Android"
        "/mnt/c/Android"
    )
    
    for base in "${android_studio_paths[@]}"; do
        if [ -d "$base" ]; then
            local found=$(find "$base" -name "adb.exe" -type f 2>/dev/null | head -1)
            if [ -n "$found" ]; then
                echo "$found"
                return 0
            fi
        fi
    done
    
    return 1
}

# Detect Git for Windows
detect_git() {
    local paths=(
        "/mnt/c/Program Files/Git/bin/git.exe"
        "/mnt/c/Program Files/Git/cmd/git.exe"
        "/mnt/c/Program Files (x86)/Git/bin/git.exe"
        "/mnt/c/Program Files (x86)/Git/cmd/git.exe"
        "/mnt/c/Users/$USER/AppData/Local/Programs/Git/bin/git.exe"
    )
    
    for path in "${paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Detect Visual Studio Code
detect_vscode() {
    local paths=(
        "/mnt/c/Users/$USER/AppData/Local/Programs/Microsoft VS Code/bin/code"
        "/mnt/c/Program Files/Microsoft VS Code/bin/code"
        "/mnt/c/Program Files (x86)/Microsoft VS Code/bin/code"
    )
    
    for path in "${paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # Check if code.exe is in Windows PATH
    local code_cmd=$(which code.exe 2>/dev/null)
    if [ -n "$code_cmd" ]; then
        echo "$code_cmd"
        return 0
    fi
    
    return 1
}

# Detect Node.js
detect_node() {
    local paths=(
        "/mnt/c/Program Files/nodejs/node.exe"
        "/mnt/c/Program Files (x86)/nodejs/node.exe"
        "/mnt/c/Users/$USER/AppData/Roaming/nvm/nodejs/node.exe"
    )
    
    for path in "${paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    # Check NVM installations
    local nvm_base="/mnt/c/Users/$USER/AppData/Roaming/nvm"
    if [ -d "$nvm_base" ]; then
        local latest=$(find "$nvm_base" -name "node.exe" -type f 2>/dev/null | sort -V | tail -1)
        if [ -n "$latest" ]; then
            echo "$latest"
            return 0
        fi
    fi
    
    return 1
}

# Detect Python
detect_python() {
    local paths=(
        "/mnt/c/Users/$USER/AppData/Local/Programs/Python/Python*/python.exe"
        "/mnt/c/Python*/python.exe"
        "/mnt/c/Program Files/Python*/python.exe"
        "/mnt/c/Program Files (x86)/Python*/python.exe"
    )
    
    # Check standard locations (newest version first)
    for pattern in "${paths[@]}"; do
        local matches=($(ls -1 $pattern 2>/dev/null | sort -Vr))
        if [ ${#matches[@]} -gt 0 ]; then
            echo "${matches[0]}"
            return 0
        fi
    done
    
    # Check Windows Store Python
    local store_python="/mnt/c/Users/$USER/AppData/Local/Microsoft/WindowsApps/python.exe"
    if [ -f "$store_python" ]; then
        echo "$store_python"
        return 0
    fi
    
    return 1
}

# Detect Docker Desktop
detect_docker() {
    local paths=(
        "/mnt/c/Program Files/Docker/Docker/resources/bin/docker.exe"
        "/mnt/c/Program Files/Docker/Docker/docker.exe"
        "/mnt/c/ProgramData/DockerDesktop/version-bin/docker.exe"
    )
    
    for path in "${paths[@]}"; do
        if [ -f "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    
    return 1
}

# Generic detection - try common patterns
detect_generic() {
    local name="$1"
    
    # First, check if it's already in Windows PATH
    local cmd_path=$(which "${name}.exe" 2>/dev/null)
    if [ -n "$cmd_path" ]; then
        echo "$cmd_path"
        return 0
    fi
    
    # Common installation directories
    local search_paths=(
        "/mnt/c/Program Files"
        "/mnt/c/Program Files (x86)"
        "/mnt/c/Users/$USER/AppData/Local/Programs"
        "/mnt/c/Users/$USER/AppData/Local"
        "/mnt/c/Users/$USER/AppData/Roaming"
        "/mnt/c/ProgramData"
        "/mnt/c/Windows/System32"
    )
    
    # Search for the executable
    for base in "${search_paths[@]}"; do
        if [ -d "$base" ]; then
            # Look for exact match
            local found=$(find "$base" -maxdepth 3 -name "${name}.exe" -type f 2>/dev/null | head -1)
            if [ -n "$found" ]; then
                echo "$found"
                return 0
            fi
            
            # Look for pattern match (e.g., in a folder with the app name)
            found=$(find "$base" -maxdepth 3 -ipath "*${name}*/${name}.exe" -type f 2>/dev/null | head -1)
            if [ -n "$found" ]; then
                echo "$found"
                return 0
            fi
        fi
    done
    
    return 1
}

# Check if a Windows path exists and is executable
verify_windows_binary() {
    local path="$1"
    
    if [ -f "$path" ] && [[ "$path" =~ \.exe$ ]]; then
        return 0
    fi
    
    return 1
}