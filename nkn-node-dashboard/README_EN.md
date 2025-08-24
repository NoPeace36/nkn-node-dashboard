# NKN Node Dashboard

A simple **Bash monitoring tool** for your NKN Node.  
It provides real-time **health check**, **relay statistics**, **uptime**, and basic log activity counters.
---
## 📌 Features

- ✅ Shows **Sync State** (e.g., `PERSIST_FINISHED`)  
- ✅ Displays **Relay Messages** (formatted with commas)  
- ✅ Tracks **Node Uptime** (days, hours, minutes, seconds)  
- ✅ Shows **Wallet Balance** (or `N/A` if not available)  
- ✅ Parses logs for activity counters:
  - Commit block  
  - Receive block proposal  
  - Generate mining reward  
  - RelayService  
  - Accept block  
- ✅ Timestamp for **last update**

---
## 📥 Installation

Clone this repository and make the script executable:

```bash
git clone https://github.com/NoPeace36/nkn-node-dashboard.git
cd nkn-node-dashboard
chmod +x nkn-node-dashboard.sh

▶️ Usage

Run the script:
./nkn-node-dashboard.sh

📊 Example Output:

==============================
🔍 NKN Node Health Check
==============================
Sync State       : PERSIST_FINISHED
Relay Messages   : 3,521,325
Uptime           : 2d 13h 31m 27s
Wallet Balance   : N/A
----------------------------
📊 Log Activity Stats
----------------------------
Commit block              : 0
Receive block proposal    : 3671
Generate mining reward    : 0
RelayService              : 0
Accept block              : 3668
==============================
Reloaded: 25.08.2025 (monday)  0:41:22 EEST

🛠️ Requirements

Linux server or VPS (Ubuntu recommended)
jq installed for JSON parsing:

sudo apt install jq -y

👨‍💻 Author

Created with ❤️ by NoPeace36
A simple monitoring tool for all NKN pioneers.

📜 License

MIT License – free to use, modify, and share.
