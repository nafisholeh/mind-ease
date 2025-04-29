#!/bin/bash

# Script to sync changes from VSCode to Xcode
# Created for MindEase project

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Path to the Xcode project file
PROJECT_FILE="$SCRIPT_DIR/MindEase.xcodeproj"

echo "Syncing changes to Xcode..."

# Touch the project file to force Xcode to refresh
touch "$PROJECT_FILE"

# If Xcode is running, try to send it a refresh command
if pgrep -x "Xcode" > /dev/null; then
    echo "Xcode is running, attempting to refresh..."
    
    # Try to use AppleScript to tell Xcode to refresh
    osascript -e 'tell application "Xcode" to activate' \
              -e 'tell application "System Events" to tell process "Xcode" to keystroke "r" using {command down, shift down}' \
              2>/dev/null || echo "Could not send refresh command to Xcode"
    
    # Display notification
    osascript -e 'display notification "Changes synced to Xcode" with title "VSCode Sync" sound name "Purr"' 2>/dev/null
else
    echo "Xcode is not running. Changes will be visible when you open the project."
fi

echo "Sync completed!"
