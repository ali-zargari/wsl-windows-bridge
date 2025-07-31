# Android ADB Example

This example shows how to use WSL-Windows Bridge to connect to Android devices/emulators from WSL2.

## Setup

```bash
# Add ADB wrapper (auto-detects Android SDK)
wsl-win-bridge add adb

# Or specify path manually
wsl-win-bridge add adb "/mnt/c/Users/YOUR_USER/AppData/Local/Android/Sdk/platform-tools/adb.exe"
```

## Usage

Once set up, you can use all ADB commands normally:

```bash
# List devices
adb devices

# Install APK
adb install app.apk

# Port forwarding
adb reverse tcp:8081 tcp:8081

# Shell access
adb shell

# Logcat
adb logcat
```

## React Native Development

For React Native development in WSL2:

1. Start Android emulator in Windows
2. Use the ADB wrapper to connect:

```bash
# The wrapper handles everything automatically
adb devices
npm run android
```

## Troubleshooting

If ADB is not auto-detected:

1. Check if Android SDK is installed in Windows
2. Find adb.exe location:
   - Usually in: `C:\Users\[USER]\AppData\Local\Android\Sdk\platform-tools\`
3. Add manually:
   ```bash
   wsl-win-bridge add adb "/mnt/c/path/to/adb.exe"
   ```

## Benefits

- No TCP/IP configuration needed
- No port forwarding setup
- Works with all ADB features
- Seamless integration with development tools