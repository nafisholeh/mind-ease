# VSCode to Xcode Sync

This document explains how to use the sync script to ensure changes made in VSCode are reflected in Xcode.

## The Problem

When you make changes to files in VSCode, Xcode doesn't automatically detect these changes because:
- Xcode maintains its own file index
- Xcode caches project information
- Xcode's build system may use cached versions of files

## The Solution

A sync script has been created to force Xcode to recognize changes made in VSCode.

## How to Use

### Option 1: Run the Script Manually

After making changes in VSCode, run the sync script:

```bash
./sync-to-xcode.sh
```

### Option 2: Use the VSCode Task (Recommended)

A VSCode task has been set up to run the sync script:

1. Press `Cmd+Shift+P` to open the command palette
2. Type "Tasks: Run Build Task" and select it
3. The "Sync to Xcode" task will run automatically

### Option 3: Use the Keyboard Shortcut

A keyboard shortcut has been configured:

- Press `Cmd+Shift+X` to sync changes to Xcode

## What the Script Does

1. Touches the Xcode project file to force Xcode to refresh
2. If Xcode is running, attempts to send a refresh command
3. Displays a notification when the sync is complete

## Best Practices

For the most reliable workflow:

1. Make changes in one editor at a time (VSCode or Xcode)
2. Run the sync script after making changes in VSCode
3. If making extensive changes, consider closing Xcode while working in VSCode

## Troubleshooting

If changes are still not reflecting in Xcode after running the sync script:

1. Close and reopen the file in Xcode
2. Clean the build folder in Xcode (Cmd+Shift+K)
3. Close and reopen Xcode
4. As a last resort, clean the derived data folder:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/*
   ```
