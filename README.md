> Fix Linux Bluetooth A2DP missing issue (PipeWire/BlueZ) + one-key toggle between A2DP and HFP

# 🔵 Bluetooth Audio Manager (Linux)

Fix missing A2DP profile issues on Linux Bluetooth (PipeWire) and toggle easily between high-quality audio and mic mode.

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
✔ Works only if A2DP exists

---

### Disable auto-switch
```ini
bluetooth.autoswitch-to-headset-profile = false
```
✔ Prevents unwanted switching  
❌ Does not restore missing A2DP

---

### Re-pair / reset earbuds
✔ Temporary fix  
❌ Not reliable

---

### Restart Bluetooth
```bash
sudo systemctl restart bluetooth
```
✔ Always works  
❌ Manual and inconvenient

---

## ✅ Solution

This project provides a **Bluetooth Manager script** that:

### Automatically:
- Detects missing A2DP
- Restarts Bluetooth
- Reconnects device
- Restores A2DP

### Also:
- Toggles between:
  - 🎧 A2DP (music)
  - 🎤 HFP (mic)

---

## 🚀 Features

- 🔁 Auto-recovery for A2DP issues  
- 🎧 High-quality audio by default  
- 🎤 One-key mic toggle  
- ⚡ Keyboard shortcut support  
- 🔒 Passwordless Bluetooth restart  
- 🧠 State-aware logic  

---

## 📁 Project Structure

```
bluetooth-audio-manager/
├── docs/
├── scripts/
│   └── bt-manager.sh
├── setup/
│   └── install.sh
├── README.md
├── LICENSE
└── .gitignore
```

---

## ⚙️ Installation

### 1. Clone repo

```bash
git clone https://github.com/YOUR_USERNAME/bluetooth-audio-manager-linux.git
cd bluetooth-audio-manager-linux
```

---

### 2. Run installer

```bash
chmod +x setup/install.sh
./setup/install.sh
```

---

### 3. Allow passwordless Bluetooth restart

```bash
echo 'YOUR_USERNAME ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart bluetooth' | sudo tee /etc/sudoers.d/bluetooth-restart
sudo chmod 440 /etc/sudoers.d/bluetooth-restart
sudo visudo -cf /etc/sudoers.d/bluetooth-restart
```

Expected:
```
parsed OK
```

---

### 4. Add keyboard shortcut

Use this command:

```bash
/bin/bash -lc "$HOME/.local/bin/bt-manager.sh"
```

---

## 🧠 How It Works

### Normal case
- Detects current profile
- Toggles between A2DP and HFP

---

### Recovery case
If A2DP is missing:

1. Restart Bluetooth
2. Reconnect device
3. Restore profiles
4. Switch to A2DP

---

## 🔧 Useful Debug Commands

```bash
pactl list cards
```

```bash
pactl list cards short
```

```bash
bluetoothctl
```

```bash
which systemctl
```

```bash
whoami
```

---

## 🧠 Key Learnings

### 1. A2DP missing ≠ switching issue
If it's missing, it's a negotiation failure.

---

### 2. Bluetooth profiles are exclusive
You cannot have:
- High-quality audio + mic at the same time

---

### 3. sudoers requires exact path
```bash
/usr/bin/systemctl restart bluetooth
```

NOT:
```bash
systemctl restart bluetooth
```

---

### 4. GNOME shortcuts need shell
```bash
/bin/bash -lc "<script>"
```

---

### 5. Scripts must not assume working directory
Always use absolute or resolved paths.

---

## ⚠️ Limitations

- Bluetooth stack on Linux is not perfect
- Some reconnect issues may still occur
- Script mitigates, not eliminates root issue

---

## 💡 Future Improvements

- Auto-switch for Zoom/Meet
- Background auto-healing daemon
- GUI tray app
- Battery + codec display

---

## 🙌 Why this project exists

This is a real-world fix for a common Linux issue that is:

- Hard to debug
- Poorly documented
- Frustrating to deal with

This project makes it:

👉 Reliable  
👉 Automated  
👉 Easy to use  

---

## ⭐ If this helped

Give it a star — it helps others find it.

---

## 📜 License

MIT
