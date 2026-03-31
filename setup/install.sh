#!/bin/bash

set -e

echo "Installing Bluetooth Audio Manager..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

mkdir -p "$HOME/.local/bin"

cp "$PROJECT_ROOT/scripts/bt-manager.sh" "$HOME/.local/bin/bt-manager.sh"
chmod +x "$HOME/.local/bin/bt-manager.sh"

echo
echo "Installed:"
echo "  $HOME/.local/bin/bt-manager.sh"
echo
echo "Recommended next steps:"
echo
echo "1. Set your Bluetooth device MAC address:"
echo '   export BT_DEVICE_MAC="AA:BB:CC:DD:EE:FF"'
echo
echo "2. Add this keyboard shortcut command:"
echo '   /bin/bash -lc "$HOME/.local/bin/bt-manager.sh"'
echo
echo "3. Add sudoers rule for passwordless Bluetooth recovery:"
echo "   echo '$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl daemon-reload, /usr/bin/systemctl restart bluetooth' | sudo tee /etc/sudoers.d/bluetooth-restart"
echo "   sudo chmod 440 /etc/sudoers.d/bluetooth-restart"
echo "   sudo visudo -cf /etc/sudoers.d/bluetooth-restart"
echo
echo "Done."
