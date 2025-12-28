# Seraphine fDOM Explorer - macOS Guide

This guide explains how to run the Computer Use / fDOM framework on macOS.

## Prerequisites

1. **Python 3.11+**
2. **Accessibility Permissions** (required for mouse/keyboard control)

## Quick Setup

```bash
# 1. Make setup script executable
chmod +x setup_mac.sh

# 2. Run setup
./setup_mac.sh

# 3. Activate virtual environment
source .venv/bin/activate
```

## Grant Accessibility Permissions

**This is critical!** The framework needs to control mouse/keyboard.

1. Go to **System Preferences → Security & Privacy → Privacy → Accessibility**
2. Click the lock icon and enter your password
3. Add your terminal app:
   - **Terminal.app** (if using default terminal)
   - **iTerm** (if using iTerm2)
   - **Visual Studio Code** (if running from VS Code)
   - **Cursor** (if using Cursor IDE)

## Running the Explorer

### Interactive Mode
```bash
python utils/fdom/element_interactor_mac.py --app-name "TextEdit" --interactive
```

### Auto-Exploration (50 iterations)
```bash
python utils/fdom/element_interactor_mac.py --app-name "TextEdit" --auto 50
```

### With Full App Path
```bash
python utils/fdom/element_interactor_mac.py --app-name "TextEdit" --app-path "/System/Applications/TextEdit.app"
```

## Example Apps to Test

```bash
# TextEdit (simple text editor)
python utils/fdom/element_interactor_mac.py --app-name "TextEdit" --auto 50

# Safari
python utils/fdom/element_interactor_mac.py --app-name "Safari" --auto 50

# Notes
python utils/fdom/element_interactor_mac.py --app-name "Notes" --auto 50

# Calculator
python utils/fdom/element_interactor_mac.py --app-name "Calculator" --auto 50
```

## Interactive Mode Commands

| Command | Description |
|---------|-------------|
| `s` | Take screenshot |
| `c x y` | Click at position (x, y) |
| `e` | Send ESC key |
| `a N` | Auto-explore N iterations |
| `w` | List all windows |
| `q` | Quit and save |

## Output

The exploration creates:
- `apps/<app_name>/fdom.json` - The functional DOM structure
- `apps/<app_name>/screenshots/` - All captured screenshots

## Testing the Setup

```bash
# Test window manager
python utils/gui_controller_mac.py

# Test basic exploration
python utils/fdom/element_interactor_mac.py --app-name "Calculator" --auto 10
```

## Troubleshooting

### "Accessibility permissions required"
- Make sure you've added your terminal to Accessibility permissions
- Try restarting your terminal after granting permissions

### "App window not found"
- Make sure the app is running
- Try using the exact app name as shown in the menu bar
- Use `w` command in interactive mode to list all windows

### Mouse clicks not registering
- Check Accessibility permissions
- Some apps may block programmatic input

## Differences from Windows Version

| Feature | Windows | macOS |
|---------|---------|-------|
| Window API | Win32 | Quartz/AppKit |
| UI Automation | COM/UIA | Accessibility API |
| Key codes | Virtual keys | macOS key codes |
| Window control | Full | Limited (no resize/move) |

## Recording Video

For your YouTube submission, use macOS screen recording:
1. Press `Cmd + Shift + 5`
2. Select "Record Entire Screen" or "Record Selected Portion"
3. Run the exploration
4. Stop recording when done
