# Contributing to WSL-Windows Bridge

Thank you for your interest in contributing to WSL-Windows Bridge! This tool helps thousands of developers seamlessly integrate Windows binaries with their WSL2 environment.

## How to Contribute

### Reporting Issues

- Check if the issue already exists
- Include your WSL2 version, Windows version, and the binary you're trying to wrap
- Provide clear reproduction steps

### Adding Binary Detection

To add auto-detection for a new Windows binary:

1. Edit `lib/detect-binary.sh`
2. Add a new function following the existing pattern:
   ```bash
   detect_yourbinary() {
       local paths=(
           "/mnt/c/Program Files/YourApp/yourbinary.exe"
           "/mnt/c/Users/$USER/AppData/Local/YourApp/yourbinary.exe"
       )
       
       for path in "${paths[@]}"; do
           if [ -f "$path" ]; then
               echo "$path"
               return 0
           fi
       done
       
       return 1
   }
   ```

3. Add a case in the `detect_binary()` function
4. Test your detection
5. Submit a pull request

### Code Style

- Use bash best practices
- Add comments for complex logic
- Test on both Ubuntu and other WSL2 distributions
- Ensure scripts work with spaces in paths

### Testing

Before submitting:

1. Run the test script: `./test.sh`
2. Test installation: `./install.sh`
3. Test your specific binary wrapper
4. Verify uninstallation works

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/add-vscode-detection`)
3. Commit your changes (`git commit -m 'Add VS Code detection'`)
4. Push to the branch (`git push origin feature/add-vscode-detection`)
5. Open a pull request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/wsl-windows-bridge
cd wsl-windows-bridge

# Make scripts executable
chmod +x wsl-win-bridge install.sh test.sh lib/*.sh

# Test locally
./wsl-win-bridge help
```

## Areas for Contribution

- Add more binary detections
- Improve path conversion logic
- Add support for more complex Windows applications
- Improve error messages
- Add more examples
- Translate documentation

## Questions?

Feel free to open an issue for any questions about contributing!