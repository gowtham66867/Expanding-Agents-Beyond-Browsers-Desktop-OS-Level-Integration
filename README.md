# Seraphine fDOM Explorer - macOS Edition

## What is This?

**Computer Use** is an AI-powered framework that autonomously explores desktop applications by simulating human interactions (clicks, keystrokes) and capturing UI states. This creates a **Functional DOM (fDOM)** — a structured map of how an application's UI behaves.

This is the **macOS port** of the originally Windows-only Seraphine framework.

---

## What Does It Do?

The fDOM Explorer:

1. **Launches** a target application (e.g., Calculator, Notes, Safari)
2. **Systematically clicks** through the UI using a grid-based pattern
3. **Captures screenshots** before and after each click
4. **Detects state changes** by comparing screenshots (image similarity analysis)
5. **Records everything** into a structured JSON file (fDOM)

**Use Cases:**
- Automated UI testing without writing test scripts
- Accessibility audits — mapping all interactive elements
- Application documentation — generating UI flow diagrams
- Regression testing — detecting unintended UI changes

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   element_interactor_mac.py                 │
│              (Main exploration engine)                      │
├─────────────────────────────────────────────────────────────┤
│                   gui_controller_mac.py                     │
│              (High-level window/mouse/keyboard API)         │
├─────────────────────────────────────────────────────────────┤
│     window_manager_mac.py  │  window_functions_mac.py       │
│     (Quartz/PyObjC)        │  (Window controller)           │
├─────────────────────────────────────────────────────────────┤
│                   macOS Quartz / AppKit                     │
│              (System-level window & input control)          │
└─────────────────────────────────────────────────────────────┘
```

**Key Components:**

| File | Purpose |
|------|---------|
| `element_interactor_mac.py` | Main exploration loop — launches app, clicks grid, captures states |
| `gui_controller_mac.py` | Simplified API for window discovery, mouse clicks, keyboard input |
| `window_manager_mac.py` | Low-level macOS window control using PyObjC and Quartz |
| `window_functions_mac.py` | Window controller wrapper for consistent API |

---

## Prerequisites

- **macOS 10.15+** (Catalina or later)
- **Python 3.9+**
- **Accessibility Permissions** (required for programmatic mouse/keyboard control)

---

## Installation

### Step 1: Clone and Setup

```bash
cd /path/to/S14B

# Make setup script executable
chmod +x setup_mac.sh

# Run setup (creates virtual environment and installs dependencies)
./setup_mac.sh
```

### Step 2: Activate Virtual Environment

```bash
source .venv_mac/bin/activate
```

### Step 3: Grant Accessibility Permissions (CRITICAL)

The framework needs permission to control your mouse and keyboard.

1. Open **System Preferences** → **Security & Privacy** → **Privacy** → **Accessibility**
2. Click the **lock icon** (bottom left) and enter your password
3. Click **+** and add your terminal application:
   - `/Applications/Utilities/Terminal.app` (default terminal)
   - `/Applications/iTerm.app` (if using iTerm2)
   - `/Applications/Visual Studio Code.app` (if running from VS Code)
   - `/Applications/Cursor.app` (if using Cursor IDE)
4. **Restart your terminal** after granting permissions

---

## Usage

### Run Automated Exploration (50 iterations)

```bash
python utils/fdom/element_interactor_mac.py --app-name "Calculator" --auto 50
```

This will:
1. Launch Calculator
2. Click 50 positions in a grid pattern within the app window
3. Take before/after screenshots at each click
4. Detect UI state changes
5. Save results to `apps/calculator/`

### Run Interactive Mode

```bash
python utils/fdom/element_interactor_mac.py --app-name "TextEdit" --interactive
```

**Interactive Commands:**

| Command | Description |
|---------|-------------|
| `s` | Take a screenshot |
| `c x y` | Click at screen position (x, y) |
| `e` | Send ESC key (close dialogs/menus) |
| `a N` | Run N automated exploration iterations |
| `w` | List all open windows |
| `q` | Quit and save fDOM |

### Specify Full App Path

```bash
python utils/fdom/element_interactor_mac.py \
  --app-name "TextEdit" \
  --app-path "/System/Applications/TextEdit.app" \
  --auto 50
```

---

## Example Apps to Explore

```bash
# Calculator (compact UI, many buttons — good for demos)
python utils/fdom/element_interactor_mac.py --app-name "Calculator" --auto 50

# Notes (sidebar + content area)
python utils/fdom/element_interactor_mac.py --app-name "Notes" --auto 50

# TextEdit (simple text editor)
python utils/fdom/element_interactor_mac.py --app-name "TextEdit" --auto 50

# Safari (complex UI with tabs, toolbar)
python utils/fdom/element_interactor_mac.py --app-name "Safari" --auto 50

# System Preferences
python utils/fdom/element_interactor_mac.py --app-name "System Preferences" --auto 50
```

---

## Output Structure

After exploration, results are saved to:

```
apps/<app_name>/
├── fdom.json              # Functional DOM data
└── screenshots/           # All captured images
    ├── initial_state_*.png
    ├── iter001_before_*.png
    ├── iter001_after_*.png
    ├── iter002_before_*.png
    ├── iter002_after_*.png
    └── ...
```

### fDOM JSON Structure

```json
{
  "app_name": "calculator",
  "platform": "macos",
  "created": "2025-12-27T09:05:21.464571",
  "states": {
    "root": {
      "image": "/path/to/initial_state.png",
      "discovered_at": "2025-12-27T09:05:23.970824"
    },
    "state_1": {
      "image": "/path/to/state_change.png",
      "triggered_by": {"x": 150, "y": 200},
      "discovered_at": "2025-12-27T09:05:45.123456"
    }
  },
  "clicks": [
    {
      "iteration": 1,
      "position": {"x": 100, "y": 150},
      "similarity": 0.9994,
      "state_changed": false,
      "timestamp": "2025-12-27T09:05:25.760290"
    }
  ],
  "exploration_stats": {
    "total_clicks": 50,
    "states_discovered": 3,
    "elements_found": 3
  }
}
```

---

## How It Works

### Exploration Algorithm

1. **Launch App** → Open the target application using macOS `open` command
2. **Detect Window** → Find the app's window bounds using Quartz APIs
3. **Generate Grid** → Create a grid of click points within the window (50px spacing)
4. **For each grid point:**
   - Focus the app window
   - Take "before" screenshot
   - Click at position
   - Wait for UI response (400ms)
   - Take "after" screenshot
   - Compare images (if similarity < 98%, state changed)
   - If state changed, record it and send ESC to reset
5. **Save fDOM** → Write all data to JSON file

### State Change Detection

Screenshots are compared using grayscale image similarity:

```
similarity = 1 - (mean_pixel_difference / 255)
```

If similarity < 98%, we consider it a UI state change (e.g., menu opened, button pressed, dialog appeared).

---

## Troubleshooting

### "Accessibility permissions required"
- Ensure your terminal is added to **System Preferences → Privacy → Accessibility**
- **Restart your terminal** after granting permissions
- Try running with `sudo` if permissions still fail

### "App window not found"
- Make sure the app is **running** before exploration
- Use the **exact app name** as shown in the menu bar (case-sensitive)
- Run `python utils/gui_controller_mac.py` to list all windows

### Mouse clicks not registering
- Check Accessibility permissions
- Some apps (especially sandboxed ones) may block programmatic input
- Try a different app

### Exploration clicks outside the app
- The window detection may have failed
- Try specifying `--app-path` with the full `.app` path

---

## Differences from Windows Version

| Feature | Windows | macOS |
|---------|---------|-------|
| Window API | Win32 / pywin32 | Quartz / PyObjC |
| UI Automation | COM / UIA | Accessibility API |
| Key codes | Virtual key codes | macOS key codes |
| Window control | Full (resize, move, minimize) | Limited |
| Element introspection | Full UI tree | Screenshot-based |

---

## Recording a Demo Video

For YouTube submission:

1. **Start Recording:**
   - Press `Cmd + Shift + 5`
   - Select "Record Entire Screen" or "Record Selected Portion"
   - Click "Record"

2. **Run Exploration:**
   ```bash
   source .venv_mac/bin/activate
   python utils/fdom/element_interactor_mac.py --app-name "Calculator" --auto 50
   ```

3. **Show in Video:**
   - Terminal output (iteration counter, click positions, state changes)
   - The app window with cursor clicking automatically
   - Final results panel

4. **Stop Recording:**
   - Click the stop button in the menu bar
   - Video saves to Desktop

---

## Dependencies

See `pyproject_mac.toml`:

- `pyobjc-core` — Python-Objective-C bridge
- `pyobjc-framework-Quartz` — macOS Quartz/CoreGraphics
- `pyobjc-framework-Cocoa` — macOS AppKit/Foundation
- `mss` — Fast cross-platform screenshots
- `Pillow` — Image processing
- `numpy` — Image comparison
- `rich` — Beautiful terminal output

---

## License

Part of the Seraphine Agentic Pipeline project.
