#!/bin/bash

DEVICE="98:47:44:D3:60:65"   # your earbuds MAC

notify() {
    /usr/bin/notify-send "Bluetooth Manager" "$1"
}

# Get Bluetooth card
CARD=$(/usr/bin/pactl list cards short | /usr/bin/grep bluez_card | /usr/bin/awk '{print $2}' | /usr/bin/head -n1)

# Check if card exists
if [ -z "$CARD" ]; then
    notify "Device not connected → trying recovery..."

    sudo /usr/bin/systemctl restart bluetooth
    sleep 2

    echo -e "connect $DEVICE\nexit" | bluetoothctl
    sleep 2

    CARD=$(/usr/bin/pactl list cards short | /usr/bin/grep bluez_card | /usr/bin/awk '{print $2}' | /usr/bin/head -n1)

    if [ -z "$CARD" ]; then
        notify "Failed to reconnect ❌"
        exit 1
    fi
fi

# Check if A2DP exists
HAS_A2DP=$(/usr/bin/pactl list cards | /usr/bin/grep -A20 "$CARD" | /usr/bin/grep "a2dp-sink")

if [ -z "$HAS_A2DP" ]; then
    notify "A2DP missing → fixing..."

    sudo /usr/bin/systemctl restart bluetooth
    sleep 2

    echo -e "connect $DEVICE\nexit" | bluetoothctl
    sleep 2

    CARD=$(/usr/bin/pactl list cards short | /usr/bin/grep bluez_card | /usr/bin/awk '{print $2}' | /usr/bin/head -n1)
fi

# Get current profile
CURRENT=$(/usr/bin/pactl list cards | /usr/bin/grep -A20 "$CARD" | /usr/bin/grep "Active Profile" | /usr/bin/awk '{print $3}')

# Toggle logic
if [[ "$CURRENT" == a2dp-sink* ]]; then
    /usr/bin/pactl set-card-profile "$CARD" headset-head-unit
    notify "🎤 Mic Mode (HFP)"
else
    /usr/bin/pactl set-card-profile "$CARD" a2dp-sink-sbc_xq || \
    /usr/bin/pactl set-card-profile "$CARD" a2dp-sink
    notify "🎧 Music Mode (A2DP)"
fi
