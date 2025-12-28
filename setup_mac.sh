#!/bin/bash
# macOS Setup Script for Seraphine (Computer Use / fDOM Framework)

echo "🍎 Setting up Seraphine for macOS..."
echo "============================================"

# Check Python version
python_version=$(python3 --version 2>&1)
echo "📍 Python: $python_version"

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv .venv
fi

# Activate virtual environment
source .venv/bin/activate

# Install macOS-specific dependencies
echo "📦 Installing macOS dependencies..."
pip install --upgrade pip

# Core dependencies (cross-platform)
pip install python-dotenv google-genai mss networkx numpy pillow psutil requests rich wget

# macOS-specific dependencies
pip install pyobjc pyobjc-framework-Quartz pyobjc-framework-ApplicationServices pyobjc-framework-Cocoa

# Optional: ONNX (CPU version for macOS)
pip install onnx onnxruntime

# OpenCV
pip install opencv-python-headless

echo ""
echo "✅ Dependencies installed!"
echo ""
echo "⚠️  IMPORTANT: You need to grant Accessibility permissions!"
echo "   1. Go to System Preferences → Security & Privacy → Privacy → Accessibility"
echo "   2. Click the lock to make changes"
echo "   3. Add your terminal app (Terminal, iTerm2, or your IDE)"
echo ""
echo "🧪 To test the setup, run:"
echo "   source .venv/bin/activate"
echo "   python utils/gui_controller_mac.py"
echo ""
echo "🚀 To run the fDOM explorer on an app:"
echo "   python utils/fdom/element_interactor_mac.py --app-name 'TextEdit'"
