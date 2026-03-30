#!/bin/bash

echo "Installing Bluetooth Audio Manager..."

# Get script directory (robust)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

mkdir -p ~/.local/bin

cp "$PROJECT_ROOT/scripts/bt-manager.sh" ~/.local/bin/

chmod +x ~/.local/bin/bt-manager.sh

echo ""
echo "Done!"
echo "Now add this as a keyboard shortcut:"
echo "/bin/bash -lc \"$HOME/.local/bin/bt-manager.sh\""
