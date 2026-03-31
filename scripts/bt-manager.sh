#!/bin/bash

DEVICE="${BT_DEVICE_MAC:-}"

notify() {
    /usr/bin/notify-send -r 9991 -t 1500 "Bluetooth Manager" "$1"
}

get_card() {
    /usr/bin/pactl list cards short | /usr/bin/grep bluez_card | /usr/bin/awk '{print $2}' | /usr/bin/head -n1
}

has_a2dp() {
    local card="$1"
    /usr/bin/pactl list cards | /usr/bin/grep -A20 "$card" | /usr/bin/grep -q "a2dp-sink"
}

get_current_profile() {
    local card="$1"
    /usr/bin/pactl list cards | /usr/bin/grep -A20 "$card" | /usr/bin/grep "Active Profile" | /usr/bin/awk '{print $3}'
}

restart_and_reconnect() {
    notify "Recovering Bluetooth..."

    sudo /usr/bin/systemctl daemon-reload
    sudo /usr/bin/systemctl restart bluetooth

    for i in {1..10}; do
        /usr/bin/bluetoothctl show >/dev/null 2>&1 && break
        /usr/bin/sleep 1
    done

    /usr/bin/sleep 1

    echo -e "power on\nconnect $DEVICE\nquit" | /usr/bin/bluetoothctl

    for i in {1..10}; do
        CARD="$(get_card)"
        [ -n "$CARD" ] && break
        /usr/bin/sleep 1
    done
}

if [ -z "$DEVICE" ]; then
    notify "No device MAC set. Please set BT_DEVICE_MAC."
    exit 1
fi

CARD="$(get_card)"

# Case 1: Device not connected
if [ -z "$CARD" ]; then
    notify "Device not connected, attempting recovery..."
    restart_and_reconnect
    CARD="$(get_card)"

    if [ -z "$CARD" ]; then
        notify "Failed to reconnect device"
        exit 1
    fi

    if ! has_a2dp "$CARD"; then
        notify "A2DP still missing after reconnect"
        exit 1
    fi
fi

# Case 2: A2DP missing
if ! has_a2dp "$CARD"; then
    notify "A2DP missing, fixing..."
    restart_and_reconnect
    CARD="$(get_card)"

    if [ -z "$CARD" ]; then
        notify "Reconnect failed after A2DP recovery"
        exit 1
    fi

    if ! has_a2dp "$CARD"; then
        notify "A2DP still unavailable after recovery"
        exit 1
    fi
fi

CURRENT="$(get_current_profile "$CARD")"

# Toggle profiles
if [[ "$CURRENT" == a2dp-sink* ]]; then
    /usr/bin/pactl set-card-profile "$CARD" headset-head-unit
    /usr/bin/sleep 1
    notify "Mic Mode (HFP)"
else
    /usr/bin/pactl set-card-profile "$CARD" a2dp-sink-sbc_xq || \
    /usr/bin/pactl set-card-profile "$CARD" a2dp-sink
    /usr/bin/sleep 1
    notify "Music Mode (A2DP)"
fi
