#!/bin/bash
# nkn-node-dashboard.sh
# Обединен TUI Dashboard за NKN Node

# Пътища
NKN_PATH="/home/nopeace/nkn/cmd/nknc/nknc"
WALLET_PATH="/home/nopeace/nkn/cmd/nknc/wallet.json"
NODE_SERVICE="nkn-node"

# Цветове
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# Log Activity Stats ключови думи
declare -A patterns=(
  ["Commit block"]="Commit block"
  ["Receive block proposal"]="Receive block proposal"
  ["Accept block"]="Accept block"
  ["Generate mining reward"]="Generate mining reward"
  ["RelayService"]="RelayService"
)

# Инициализация
declare -A counters
declare -A last_seen
for key in "${!patterns[@]}"; do
  counters["$key"]=0
  last_seen["$key"]=$(date +%s)
done

THRESHOLD=$((10 * 60))  # 10 минути застой

# Функция за печат на Log Stats
print_log_stats() {
  echo "----------------------------"
  echo "📊 Log Activity Stats"
  echo "----------------------------"
  now=$(date +%s)
  for key in "${!patterns[@]}"; do
    elapsed=$(( now - last_seen["$key"] ))
    if [[ $elapsed -gt $THRESHOLD ]]; then
      color=$RED
    else
      color=$GREEN
    fi
    printf "%-25s : ${color}%d${RESET}\n" "$key" "${counters[$key]}"
  done
}

# Функция за Health Check
print_health() {
  echo "=============================="
  echo "🔍 NKN Node Health Check"
  echo "=============================="

  # Sync State
  sync=$($NKN_PATH info -s 2>/dev/null | jq -r .result.syncState)
  if [[ "$sync" == "PERSIST_FINISHED" ]]; then
    echo -e "Sync State       : ${GREEN}$sync${RESET}"
  else
    echo -e "Sync State       : ${RED}$sync${RESET}"
  fi

  # Relay Messages
  relay=$($NKN_PATH info -s 2>/dev/null | jq -r .result.relayMessageCount)
  # Форматиране със запетая за хилядни
  relay_fmt=$(echo "$relay" | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta')
 if [[ "$relay" -gt 0 ]]; then
    echo -e "Relay Messages   : ${GREEN}${relay_fmt}${RESET}"
  else
    echo -e "Relay Messages   : ${RED}0${RESET}"
  fi 

  # Uptime
  uptime_sec=$($NKN_PATH info -s 2>/dev/null | jq -r .result.uptime)
  days=$(( uptime_sec / 86400 ))
  hours=$(( (uptime_sec % 86400) / 3600 ))
  minutes=$(( (uptime_sec % 3600) / 60 ))
  seconds=$(( uptime_sec % 60 ))

  echo -e "Uptime           : ${YELLOW}${days}d ${hours}h ${minutes}m ${seconds}s${RESET}"

  # Wallet Balance
  balance=$($NKN_PATH wallet -l balance -n $WALLET_PATH --password-file /home/nopeace/nkn/wallet1.pass 2>/dev/null | jq -r '.result.amount')
  if [[ -z "$balance" || "$balance" == "null" ]]; then
    echo -e "Wallet Balance   : ${RED}N/A${RESET}"
  else
    echo -e "Wallet Balance   : ${GREEN}$balance NKN${RESET}"
  fi
}

# Следене на логове и едновременно печат
journalctl -u $NODE_SERVICE -f -n0 --no-pager | while read -r line; do
  updated=0
  for key in "${!patterns[@]}"; do
    if [[ "$line" == *"${patterns[$key]}"* ]]; then
      counters["$key"]=$(( counters["$key"] + 1 ))
      last_seen["$key"]=$(date +%s)
      updated=1
    fi
  done

  if [[ $updated -eq 1 ]]; then
    clear
    print_health
    print_log_stats
    echo "=============================="
    echo "Обновено: $(date)"
  fi
done

