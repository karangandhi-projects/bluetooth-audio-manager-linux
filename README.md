# 🔵 Bluetooth Audio Manager (Linux)

> Fix the "A2DP missing" Bluetooth issue on Linux (PipeWire/BlueZ) + one-key toggle between A2DP and HFP

---

## 🎬 Demo

https://github.com/karangandhi-projects/bluetooth-audio-manager-linux/blob/main/docs/demo-fast.mp4

---

## 📌 Problem

On Linux (Ubuntu with PipeWire), Bluetooth earbuds/headphones may:

- Connect in **Handsfree (HFP/HSP)** instead of **A2DP**
- Lose the **A2DP profile completely after reconnect**
- Produce **low-quality / distorted audio**
- Require restarting Bluetooth to fix:

```bash
sudo systemctl restart bluetooth
```

---

## 🧠 Background

Bluetooth audio uses two main profiles:

| Profile | Purpose | Quality | Mic |
|--------|--------|--------|-----|
| A2DP | Music playback | High | ❌ |
| HFP/HSP | Calls | Low | ✅ |

Important:

> If `a2dp-sink` is missing in `pactl list cards`, it cannot be selected later — it must be recreated.

---

## 🔍 Root Cause

On reconnect, Linux Bluetooth stack (BlueZ + PipeWire):

1. Negotiates available profiles  
2. Sometimes exposes **only HFP**  
3. Skips A2DP entirely  
4. System gets stuck in low-quality mode  

👉 This is a **negotiation issue**, not just a settings problem.

---

## 🧪 What Was Tried

### Manual switching
```bash
pactl set-card-profile <card> a2dp-sink
```

### Disable auto-switch
```ini
bluetooth.autoswitch-to-headset-profile = false
```

### Restart Bluetooth
```bash
sudo systemctl restart bluetooth
```

---

## ✅ Solution

This project provides a **Bluetooth Manager script** that:

- Detects missing A2DP  
- Restarts Bluetooth  
- Reconnects device  
- Restores A2DP  
- Toggles between A2DP and HFP  

---

## ⚙️ Installation

```bash
git clone https://github.com/YOUR_USERNAME/bluetooth-audio-manager-linux.git
cd bluetooth-audio-manager-linux
chmod +x setup/install.sh
./setup/install.sh
```

---

## 🔧 Set your Bluetooth device

```bash
export BT_DEVICE_MAC="AA:BB:CC:DD:EE:FF"
```

Find your device:

```bash
bluetoothctl devices
```

---

## 🧠 How It Works

### Normal case
- Detects current profile  
- Toggles between A2DP and HFP  

### Recovery case
If A2DP is missing:

1. Restart Bluetooth  
2. Reconnect device  
3. Restore profiles  
4. Switch to A2DP  

---

## ⚠️ Limitations

- Bluetooth stack on Linux is not perfect  
- Script mitigates, not eliminates root issue  

---

## ⭐ If this helped

Give it a star — it helps others find it.
