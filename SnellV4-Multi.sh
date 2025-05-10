#!/usr/bin/env bash
# Multi-instance Snell installer and manager

# ========== 配置 ========== 
BASE_DIR="/etc/snell"
BIN_PATH="/usr/local/bin/snell-server"
TEMPLATE_CONF="${BASE_DIR}/template.conf"

# ========== 工具函数 ==========
ensureSnellBinary() {
  if [[ -f /usr/local/bin/snell-server ]]; then
    echo "[√] 已检测到 snell-server 执行文件。"
    return
  fi

  echo "[!] 未检测到 snell-server，自动安装中..."

  arch=$(uname -m)
  case "$arch" in
    x86_64) arch="amd64" ;;
    aarch64) arch="aarch64" ;;
    armv7l) arch="armv7l" ;;
    *) echo "不支持的架构: $arch" && exit 1 ;;
  esac

  version="4.1.1"
  url="https://dl.nssurge.com/snell/snell-server-v${version}-linux-${arch}.zip"
  tmpdir=$(mktemp -d)
  cd "$tmpdir"

  echo "正在下载 Snell v${version}..."
  wget -q --show-progress "$url" -O snell.zip || { echo "下载失败"; exit 1; }
  unzip snell.zip || { echo "解压失败"; exit 1; }

  chmod +x snell-server
  mv snell-server /usr/local/bin/
  cd /
  rm -rf "$tmpdir"

  echo "[√] Snell 安装完成：/usr/local/bin/snell-server"
}

colorEcho() {
  local color="$1" text="$2"
  case "$color" in
    red) echo -e "\033[31m${text}\033[0m";;
    green) echo -e "\033[32m${text}\033[0m";;
    yellow) echo -e "\033[33m${text}\033[0m";;
    *) echo "$text";;
  esac
}

checkRoot() {
  [[ $EUID -ne 0 ]] && colorEcho red "请以 root 用户运行此脚本。" && exit 1
}

checkSnellBinary() {
  ensureSnellBinary
}

checkPortValid() {
  local port="$1"
  if [[ ! "$port" =~ ^[0-9]+$ ]] || [[ "$port" -lt 1 || "$port" -gt 65535 ]]; then
    colorEcho red "端口 $port 无效，必须是 1-65535 之间的整数。"
    exit 1
  fi
}

# ========== 主流程函数 ==========
createInstance() {
  read -rp "请输入实例端口号 (如 2345): " port
  checkPortValid "$port"

  local conf="${BASE_DIR}/config-${port}.conf"
  local svc="snell-${port}.service"

  if [[ -f "$conf" ]]; then
    colorEcho yellow "配置文件 $conf 已存在，无法创建。"
    exit 1
  fi

  read -rp "请输入预共享密钥 (psk)（可留空自动生成）: " psk
  [[ -z "$psk" ]] && psk=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

  mkdir -p "$BASE_DIR"
  cat > "$conf" <<EOF
[snell-server]
listen = ::0:${port}
ipv6 = false
psk = ${psk}
obfs = off
tfo = true
dns = 1.1.1.1, 8.8.8.8, 2001:4860:4860::8888
version = 4
reuse = true
ecn = true
EOF

  cat > "/etc/systemd/system/${svc}" <<EOF
[Unit]
Description=Snell Server on port ${port}
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
LimitNOFILE=32767
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStartPre=/bin/sh -c 'ulimit -n 51200'
ExecStart=${BIN_PATH} -c ${conf}

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable --now "$svc"
  colorEcho green "Snell 实例已创建并启动：端口 $port，密钥 $psk"
}

deleteInstance() {
  read -rp "请输入要删除的实例端口号: " port
  checkPortValid "$port"

  local conf="${BASE_DIR}/config-${port}.conf"
  local svc="snell-${port}.service"

  systemctl stop "$svc" 2>/dev/null
  systemctl disable "$svc" 2>/dev/null
  rm -f "/etc/systemd/system/${svc}"
  rm -f "$conf"
  systemctl daemon-reload

  colorEcho green "已删除 Snell 实例（端口：$port）"
}

listInstances() {
  echo -e "\n\033[1;36m已配置的 Snell 实例列表：\033[0m"
  printf "%-6s | %-20s | %-8s | %-6s | %-6s | %-6s | %-3s\n" "端口" "密钥" "状态" "OBFS" "IPv6" "TFO" "VER"
  echo "------------------------------------------------------------------------"
  find "$BASE_DIR" -name "config-*.conf" | while read -r conf; do
    port=$(basename "$conf" | sed 's/config-\([0-9]\+\)\.conf/\1/')
    psk=$(grep '^psk' "$conf" | awk -F '=' '{print $2}' | xargs)
    status=$(systemctl is-active "snell-${port}" 2>/dev/null)
    obfs=$(grep '^obfs' "$conf" | awk -F '=' '{print $2}' | xargs)
    ipv6=$(grep '^ipv6' "$conf" | awk -F '=' '{print $2}' | xargs)
    tfo=$(grep '^tfo' "$conf" | awk -F '=' '{print $2}' | xargs)
    ver=$(grep '^version' "$conf" | awk -F '=' '{print $2}' | xargs)
    printf "%-6s | %-20s | %-8s | %-6s | %-6s | %-6s | %-3s\n" "$port" "$psk" "$status" "$obfs" "$ipv6" "$tfo" "$ver"
  done
  echo
}

uninstallAll() {
  echo "⚠️  确定要卸载所有 Snell 实例并删除本脚本吗？此操作不可恢复！（y/N）"
  read -rp "请输入 y 确认卸载: " confirm
  if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "[*] 正在停止并删除所有 Snell 实例..."
    find "$BASE_DIR" -name "config-*.conf" | while read -r conf; do
      port=$(basename "$conf" | sed 's/config-\\([0-9]\\+\\)\\.conf/\\1/')
      systemctl stop "snell-${port}" 2>/dev/null
      systemctl disable "snell-${port}" 2>/dev/null
      rm -f "/etc/systemd/system/snell-${port}.service"
    done
    rm -rf "$BASE_DIR"
    rm -f "$BIN_PATH"
    systemctl daemon-reload
    echo "[√] 所有 Snell 实例及配置已删除。"

    echo "[*] 删除当前脚本本身..."
    rm -- \"$0\"
  else
    echo "已取消卸载操作。"
  fi
}


modifyInstance() {
  read -rp "请输入要修改配置的实例端口号: " port
  checkPortValid "$port"
  local conf="${BASE_DIR}/config-${port}.conf"
  local svc="snell-${port}.service"

  if [[ ! -f "$conf" ]]; then
    colorEcho red "未找到配置文件 $conf，实例可能不存在。"
    return
  fi

  read -rp "请输入新端口（留空则不变）: " new_port
  read -rp "请输入新 DNS（留空则不变）: " new_dns
  read -rp "请输入新 PSK（留空则不变）: " new_psk
  read -rp "是否启用 IPv6（true/false，留空不变）: " new_ipv6
  read -rp "是否启用 TFO（true/false，留空不变）: " new_tfo
  read -rp "是否启用 OBFS（off/http/tls，留空不变）: " new_obfs

  [[ -n "$new_port" ]] && checkPortValid "$new_port" && sed -i "s/^listen = .*$/listen = ::0:${new_port}/" "$conf"
  [[ -n "$new_dns" ]] && sed -i "s/^dns = .*$/dns = ${new_dns}/" "$conf"
  [[ -n "$new_psk" ]] && sed -i "s/^psk = .*$/psk = ${new_psk}/" "$conf"
  [[ -n "$new_ipv6" ]] && sed -i "s/^ipv6 = .*$/ipv6 = ${new_ipv6}/" "$conf"
  [[ -n "$new_tfo" ]] && sed -i "s/^tfo = .*$/tfo = ${new_tfo}/" "$conf"
  [[ -n "$new_obfs" ]] && sed -i "s/^obfs = .*$/obfs = ${new_obfs}/" "$conf"

  if [[ -n "$new_port" && "$new_port" != "$port" ]]; then
    systemctl stop "$svc" 2>/dev/null
    systemctl disable "$svc" 2>/dev/null
    mv "$conf" "${BASE_DIR}/config-${new_port}.conf"
    rm -f "/etc/systemd/system/${svc}"

    cat > "/etc/systemd/system/snell-${new_port}.service" <<EOF
[Unit]
Description=Snell Server on port ${new_port}
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
LimitNOFILE=32767
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStartPre=/bin/sh -c 'ulimit -n 51200'
ExecStart=${BIN_PATH} -c ${BASE_DIR}/config-${new_port}.conf

[Install]
WantedBy=multi-user.target
EOF
  fi

  systemctl daemon-reload
  systemctl restart "snell-${new_port:-$port}"
  colorEcho green "配置已更新并重启 Snell 实例。"
}

# ========== 菜单入口 ==========
mainMenu() {
  checkRoot
  checkSnellBinary
  while true; do
    echo -e "\n\033[1;34mSnell 多实例管理脚本\033[0m"
    echo -e "\033[32m──────────────────────────────────────\033[0m"
    echo -e "\033[33m 1\033[0m. 创建新实例"
    echo -e "\033[33m 2\033[0m. 删除已有实例"
    echo -e "\033[33m 3\033[0m. 查看所有实例"
    echo -e "\033[33m 4\033[0m. 修改实例配置"
    echo -e "\033[33m 5\033[0m. 卸载所有实例并删除本脚本"
    echo -e "\033[33m 0\033[0m. 退出"
    echo -e "\033[32m──────────────────────────────────────\033[0m"
    read -rp "请选择操作 [0-5]: " opt
    case "$opt" in
      1) createInstance;;
      2) deleteInstance;;
      3) listInstances;;
      4) modifyInstance;;
      5) uninstallAll;;
      0) exit 0;;
      *) colorEcho red "无效选项，请重试。";;
    esac
  done
}


mainMenu
