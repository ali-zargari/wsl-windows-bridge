#!/bin/bash

# Configuration management library for WSL-Windows Bridge

# Initialize configuration
init_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        touch "$CONFIG_FILE"
        echo "# WSL-Windows Bridge Configuration" > "$CONFIG_FILE"
        echo "# Format: name=windows_path" >> "$CONFIG_FILE"
    fi
}

# Save wrapper configuration
save_wrapper_config() {
    local name="$1"
    local win_path="$2"
    
    init_config
    
    # Remove existing entry if present
    remove_wrapper_config "$name"
    
    # Add new entry
    echo "${name}=${win_path}" >> "$CONFIG_FILE"
}

# Remove wrapper configuration
remove_wrapper_config() {
    local name="$1"
    
    if [ -f "$CONFIG_FILE" ]; then
        # Create temp file without the entry
        grep -v "^${name}=" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" || true
        mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    fi
}

# Get wrapper configuration
get_wrapper_config() {
    local name="$1"
    
    if [ -f "$CONFIG_FILE" ]; then
        grep "^${name}=" "$CONFIG_FILE" | cut -d'=' -f2-
    fi
}

# List all configured wrappers
list_wrapper_configs() {
    if [ -f "$CONFIG_FILE" ]; then
        grep -v "^#" "$CONFIG_FILE" | grep -v "^$"
    fi
}

# Backup configuration
backup_config() {
    if [ -f "$CONFIG_FILE" ]; then
        cp "$CONFIG_FILE" "$CONFIG_FILE.bak.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Restore configuration
restore_config() {
    local backup=$(ls -t "$CONFIG_FILE.bak."* 2>/dev/null | head -1)
    
    if [ -n "$backup" ] && [ -f "$backup" ]; then
        cp "$backup" "$CONFIG_FILE"
        return 0
    fi
    
    return 1
}

# Export configuration
export_config() {
    local export_file="${1:-wsl-win-bridge-export.conf}"
    
    if [ -f "$CONFIG_FILE" ]; then
        cp "$CONFIG_FILE" "$export_file"
        echo "Configuration exported to: $export_file"
    else
        echo "No configuration to export"
        return 1
    fi
}

# Import configuration
import_config() {
    local import_file="${1:-wsl-win-bridge-export.conf}"
    
    if [ ! -f "$import_file" ]; then
        echo "Import file not found: $import_file"
        return 1
    fi
    
    backup_config
    cp "$import_file" "$CONFIG_FILE"
    echo "Configuration imported from: $import_file"
    
    # Recreate all wrappers
    while IFS='=' read -r name win_path; do
        if [ -n "$name" ] && [ -n "$win_path" ] && [[ ! "$name" =~ ^# ]]; then
            if [ -f "$win_path" ]; then
                create_wrapper "$name" "$win_path"
                echo "Recreated wrapper: $name"
            else
                echo "Warning: Binary not found for $name at $win_path"
            fi
        fi
    done < "$CONFIG_FILE"
}