#!/bin/bash

# 颜色定义
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[36m"
PLAIN="\033[0m"


# 检测系统类型和包管理器
detect_os() {
    if [[ -f /etc/os-release ]]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [[ -f /etc/lsb-release ]]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [[ -f /etc/debian_version ]]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    elif [[ -f /etc/centos-release ]]; then
        # Older CentOS
        OS=CentOS
        VER=$(cat /etc/centos-release | sed 's/^.*release //;s/ .*$//')
    elif [[ -f /etc/redhat-release ]]; then
        # Older Red Hat, CentOS, etc.
        OS=RedHat
        VER=$(cat /etc/redhat-release | sed 's/^.*release //;s/ .*$//')
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    # 将OS转换为小写
    OS=$(echo "$OS" | tr '[:upper:]' '[:lower:]')
    
    # 根据OS确定包管理器
    if [[ "$OS" == *"debian"* ]] || [[ "$OS" == *"ubuntu"* ]] || [[ "$OS" == *"mint"* ]]; then
        PKG_MANAGER="apt"
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
    elif [[ "$OS" == *"centos"* ]] || [[ "$OS" == *"rhel"* ]] || [[ "$OS" == *"fedora"* ]] || [[ "$OS" == *"rocky"* ]] || [[ "$OS" == *"alma"* ]]; then
        if [[ $(command -v dnf) ]]; then
            PKG_MANAGER="dnf"
            PKG_UPDATE="dnf check-update || true"
            PKG_INSTALL="dnf install -y"
        else
            PKG_MANAGER="yum"
            PKG_UPDATE="yum check-update || true"
            PKG_INSTALL="yum install -y"
        fi
    elif [[ "$OS" == *"arch"* ]] || [[ "$OS" == *"manjaro"* ]]; then
        PKG_MANAGER="pacman"
        PKG_UPDATE="pacman -Sy"
        PKG_INSTALL="pacman -S --noconfirm"
    elif [[ "$OS" == *"alpine"* ]]; then
        PKG_MANAGER="apk"
        PKG_UPDATE="apk update"
        PKG_INSTALL="apk add"
    else
        echo -e "${RED}不支持的操作系统: $OS${PLAIN}"
        echo -e "${YELLOW}尝试使用默认的apt包管理器...${PLAIN}"
        PKG_MANAGER="apt"
        PKG_UPDATE="apt update"
        PKG_INSTALL="apt install -y"
    fi
    
    echo -e "${GREEN}检测到操作系统: $OS $VER${PLAIN}"
    echo -e "${GREEN}使用包管理器: $PKG_MANAGER${PLAIN}"
}

# 检查是否为root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}错误: 请使用root用户运行此脚本${PLAIN}"
        exit 1
    fi
}

# 检查系统要求
check_system() {
    if ! command -v systemctl &> /dev/null; then
        echo -e "${RED}错误: 此脚本需要systemd支持${PLAIN}"
        exit 1
    fi
}

# 安装依赖
install_dependencies() {
    echo -e "${BLUE}正在安装依赖...${PLAIN}"
    # 安装必要的软件包
    $PKG_UPDATE || {
        echo -e "${RED}更新软件包列表失败${PLAIN}"
        exit 1
    }
    
    $PKG_INSTALL curl wget || {
        echo -e "${RED}依赖安装失败${PLAIN}"
        exit 1
    }
    
    # 在CentOS/RHEL等系统上，确保已安装systemd相关工具
    if [[ "$PKG_MANAGER" == "yum" ]] || [[ "$PKG_MANAGER" == "dnf" ]]; then
        $PKG_INSTALL systemd || true
    fi
    
    echo -e "${GREEN}依赖安装成功${PLAIN}"
}

# 检查并安装ShadowTLS
check_and_install_shadowtls() {
    # 检查是否已安装
    if [ -f "/usr/local/bin/e-shadowtls" ]; then
        echo -e "${GREEN}检测到e-shadowtls已安装，将直接使用现有版本${PLAIN}"
        return 0
    else
        echo -e "${YELLOW}未检测到e-shadowtls，将进行安装...${PLAIN}"
        install_shadowtls
    fi
}

# 安装ShadowTLS
install_shadowtls() {
    echo -e "${BLUE}正在安装ShadowTLS...${PLAIN}"
    
    # 获取系统架构
    ARCH="shadow-tls-$(uname -m | sed 's/x86_64/x86_64-unknown-linux-musl/;s/aarch64/aarch64-unknown-linux-musl/')"
    
    # 获取最新版本号
    VERSION=$(curl -s https://api.github.com/repos/ihciah/shadow-tls/releases/latest | grep tag_name | cut -d '"' -f4)
    
    echo -e "${GREEN}检测到最新版本: ${VERSION}${PLAIN}"
    
    # 使用临时文件然后移动，避免"text file busy"错误
    TMP_FILE="/tmp/e-shadowtls-${VERSION}"
    
    # 下载ShadowTLS可执行文件到临时位置
    wget -O ${TMP_FILE} https://github.com/ihciah/shadow-tls/releases/download/${VERSION}/${ARCH} || {
        echo -e "${RED}下载ShadowTLS失败${PLAIN}"
        exit 1
    }
    
    # 授权执行
    chmod +x ${TMP_FILE}
    
    # 移动到目标位置，使用新名称e-shadowtls
    mv ${TMP_FILE} /usr/local/bin/e-shadowtls || {
        echo -e "${RED}安装e-shadowtls失败${PLAIN}"
        exit 1
    }
    
    echo -e "${GREEN}e-shadowtls安装成功${PLAIN}"
}

# 配置防火墙规则
configure_firewall() {
    local port=$1
    echo -e "${BLUE}正在配置防火墙规则，放行端口: ${port}...${PLAIN}"
    
    # 尝试使用ufw
    if command -v ufw &> /dev/null; then
        echo -e "${YELLOW}检测到ufw防火墙，正在添加规则...${PLAIN}"
        ufw allow ${port}/tcp &>/dev/null || true
    fi
    
    # 尝试使用iptables
    if command -v iptables &> /dev/null; then
        echo -e "${YELLOW}检测到iptables防火墙，正在添加规则...${PLAIN}"
        iptables -C INPUT -p tcp --dport ${port} -j ACCEPT &>/dev/null || 
        iptables -I INPUT -p tcp --dport ${port} -j ACCEPT &>/dev/null || true
    fi
    
    # 尝试使用nftables
    if command -v nft &> /dev/null; then
        echo -e "${YELLOW}检测到nftables防火墙，正在添加规则...${PLAIN}"
        nft add rule inet filter input tcp dport ${port} accept &>/dev/null || true
    fi
    
    # 尝试使用firewalld
    if command -v firewall-cmd &> /dev/null; then
        echo -e "${YELLOW}检测到firewalld防火墙，正在添加规则...${PLAIN}"
        firewall-cmd --zone=public --add-port=${port}/tcp --permanent &>/dev/null
        firewall-cmd --reload &>/dev/null || true
    fi
    
    echo -e "${GREEN}防火墙规则配置完成，端口 ${port} 已放行${PLAIN}"
}

# 删除防火墙规则
remove_firewall() {
    local port=$1
    echo -e "${BLUE}正在移除防火墙规则，关闭端口: ${port}...${PLAIN}"
    
    # 尝试使用ufw
    if command -v ufw &> /dev/null; then
        echo -e "${YELLOW}检测到ufw防火墙，正在移除规则...${PLAIN}"
        ufw delete allow ${port}/tcp &>/dev/null || true
    fi
    
    # 尝试使用iptables
    if command -v iptables &> /dev/null; then
        echo -e "${YELLOW}检测到iptables防火墙，正在移除规则...${PLAIN}"
        iptables -D INPUT -p tcp --dport ${port} -j ACCEPT &>/dev/null || true
    fi
    
    # 尝试使用nftables
    if command -v nft &> /dev/null; then
        echo -e "${YELLOW}检测到nftables防火墙，正在移除规则...${PLAIN}"
        nft delete rule inet filter input tcp dport ${port} accept &>/dev/null || true
    fi
    
    # 尝试使用firewalld
    if command -v firewall-cmd &> /dev/null; then
        echo -e "${YELLOW}检测到firewalld防火墙，正在移除规则...${PLAIN}"
        firewall-cmd --zone=public --remove-port=${port}/tcp --permanent &>/dev/null
        firewall-cmd --reload &>/dev/null || true
    fi
    
    echo -e "${GREEN}防火墙规则移除完成，端口 ${port} 已关闭${PLAIN}"
}

# 生成随机密码
generate_password() {
    openssl rand -base64 16
}

# 创建ShadowTLS服务
create_service() {
    local listen_port=$1
    local server_port=$2
    local sni=$3
    local password=$4
    local wildcard_sni_option=""
    local fastopen_option=""
    local reply
    
    echo -e "${BLUE}正在创建ShadowTLS服务 (端口: ${listen_port})...${PLAIN}"
    
    # 询问是否启用泛域名SNI
    echo -e "${YELLOW}是否开启泛域名SNI？(开启后客户端伪装域名无需与服务端一致) (y/n, 默认不开启):${PLAIN}"
    read -p "> " reply
    if [[ "${reply,,}" == "y" ]]; then
        wildcard_sni_option="--wildcard-sni=authed "
        WILDCARD_SNI="true"
        echo -e "${GREEN}泛域名SNI已开启${PLAIN}"
    else
        wildcard_sni_option=""
        WILDCARD_SNI="false"
        echo -e "${YELLOW}泛域名SNI未开启${PLAIN}"
    fi
    
    # 询问是否启用TCP Fast Open
    echo -e "${YELLOW}是否开启TCP Fast Open？(y/n, 默认不开启):${PLAIN}"
    read -p "> " reply
    if [[ "${reply,,}" == "y" ]]; then
        fastopen_option="--fastopen "
        FASTOPEN="true"
        echo -e "${GREEN}TCP Fast Open已开启${PLAIN}"
    else
        fastopen_option=""
        FASTOPEN="false"
        echo -e "${YELLOW}TCP Fast Open未开启${PLAIN}"
    fi
    
    # 创建systemd服务文件
    cat > /etc/systemd/system/shadow-tls-${listen_port}.service <<EOF
[Unit]
Description=ShadowTLS Instance on Port ${listen_port}
After=network-online.target
Wants=network-online.target systemd-networkd-wait-online.service

[Service]
LimitNOFILE=32767
Type=simple
User=root
Restart=on-failure
RestartSec=5s
ExecStartPre=/bin/sh -c "ulimit -n 51200"
ExecStart=/usr/local/bin/e-shadowtls ${fastopen_option}--v3 --strict server ${wildcard_sni_option}\\
  --listen [::]:${listen_port} \\
  --server 127.0.0.1:${server_port} \\
  --tls ${sni}:443 \\
  --password ${password}

[Install]
WantedBy=multi-user.target
EOF
    
    # 重新加载systemd配置
    systemctl daemon-reload
    
    # 启用并启动服务
    systemctl enable --now shadow-tls-${listen_port}
    
    # 配置防火墙
    configure_firewall ${listen_port}
    
    echo -e "${GREEN}ShadowTLS服务创建成功 (端口: ${listen_port})${PLAIN}"
    echo -e "${YELLOW}服务信息:${PLAIN}"
    echo -e "  监听端口: ${listen_port}"
    echo -e "  后端端口: ${server_port}"
    echo -e "  SNI: ${sni}"
    echo -e "  Shadowtls密码: ${password}"
    echo -e "  泛域名SNI: ${WILDCARD_SNI}"
    echo -e "  TCP Fast Open: ${FASTOPEN}"
}

# 列出现有服务
list_services() {
    echo -e "${BLUE}现有ShadowTLS服务:${PLAIN}"
    
    if ! ls /etc/systemd/system/shadow-tls-*.service &> /dev/null; then
        echo -e "${YELLOW}未找到ShadowTLS服务${PLAIN}"
        return
    fi
    
    echo -e "${YELLOW}端口\t后端端口\tSNI\t\t密码\t\t泛域名SNI\tFastOpen${PLAIN}"
    echo -e "-----------------------------------------------------------------------------------"
    
    for service_file in /etc/systemd/system/shadow-tls-*.service; do
        local port=$(basename $service_file | cut -d'-' -f3 | cut -d'.' -f1)
        local server_port=$(grep -oP '(?<=--server 127.0.0.1:)[0-9]+' $service_file)
        local sni=$(grep -oP '(?<=--tls )[^:]+' $service_file)
        local password=$(grep -oP '(?<=--password )[^ ]+' $service_file)
        
        # 检查是否启用了泛域名SNI
        if grep -q -- "--wildcard-sni" $service_file; then
            local wildcard="是"
        else
            local wildcard="否"
        fi
        
        # 检查是否启用了TCP Fast Open
        if grep -q -- "--fastopen" $service_file; then
            local fastopen="是"
        else
            local fastopen="否"
        fi
        
        echo -e "${port}\t${server_port}\t${sni}\t${password}\t${wildcard}\t\t${fastopen}"
    done
}

# 删除ShadowTLS服务
delete_service() {
    echo -e "${YELLOW}请输入要删除的ShadowTLS服务端口:${PLAIN}"
    read -p "> " port
    
    # 验证端口
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo -e "${RED}错误: 无效的端口号${PLAIN}"
        return
    fi
    
    local service_file="/etc/systemd/system/shadow-tls-${port}.service"
    
    # 检查服务是否存在
    if [ ! -f "$service_file" ]; then
        echo -e "${RED}错误: 端口 ${port} 的ShadowTLS服务不存在${PLAIN}"
        return
    fi
    
    # 停止并禁用服务
    echo -e "${BLUE}正在停止并删除端口 ${port} 的ShadowTLS服务...${PLAIN}"
    systemctl stop shadow-tls-${port}
    systemctl disable shadow-tls-${port}
    
    # 删除服务文件
    rm -f "$service_file"
    systemctl daemon-reload
    
    # 移除防火墙规则
    remove_firewall ${port}
    
    echo -e "${GREEN}端口 ${port} 的ShadowTLS服务已成功删除${PLAIN}"
}

# 安装ShadowTLS向导
install_wizard() {
    echo -e "${YELLOW}请输入监听端口 (1-65535):${PLAIN}"
    read -p "> " listen_port
    
    # 验证端口
    if ! [[ "$listen_port" =~ ^[0-9]+$ ]] || [ "$listen_port" -lt 1 ] || [ "$listen_port" -gt 65535 ]; then
        echo -e "${RED}错误: 无效的端口号${PLAIN}"
        return
    fi
    
    # 检查端口是否已被使用
    if systemctl list-units --full --all | grep -q "shadow-tls-${listen_port}.service"; then
        echo -e "${RED}错误: 端口 ${listen_port} 已被使用${PLAIN}"
        return
    fi
    
    echo -e "${YELLOW}请输入后端端口 (1-65535):${PLAIN}"
    read -p "> " server_port
    
    # 验证端口
    if ! [[ "$server_port" =~ ^[0-9]+$ ]] || [ "$server_port" -lt 1 ] || [ "$server_port" -gt 65535 ]; then
        echo -e "${RED}错误: 无效的端口号${PLAIN}"
        return
    fi
    
    echo -e "${YELLOW}请输入SNI (例如: www.example.com):${PLAIN}"
    read -p "> " sni
    
    # 验证SNI
    if [ -z "$sni" ]; then
        echo -e "${RED}错误: SNI不能为空${PLAIN}"
        return
    fi
    
    echo -e "${YELLOW}是否使用随机密码? (y/n):${PLAIN}"
    read -p "> " use_random_password
    
    if [[ "$use_random_password" =~ ^[Yy]$ ]]; then
        password=$(generate_password)
    else
        echo -e "${YELLOW}请输入密码:${PLAIN}"
        read -p "> " password
        
        # 验证密码
        if [ -z "$password" ]; then
            echo -e "${RED}错误: 密码不能为空${PLAIN}"
            return
        fi
    fi
    
    # 创建服务
    create_service "$listen_port" "$server_port" "$sni" "$password"
}

# 完全卸载ShadowTLS
uninstall_shadowtls() {
    echo -e "${YELLOW}警告: 此操作将完全卸载ShadowTLS及所有相关服务!${PLAIN}"
    echo -e "${YELLOW}所有端口的服务都将被停止并删除!${PLAIN}"
    echo -e "${RED}确定要继续吗? (y/n):${PLAIN}"
    read -p "> " confirm
    
    if [[ "${confirm,,}" != "y" ]]; then
        echo -e "${GREEN}已取消卸载操作${PLAIN}"
        return
    fi
    
    echo -e "${BLUE}正在卸载ShadowTLS...${PLAIN}"
    
    # 查找所有可能的端口以便关闭防火墙
    local all_ports=()
    
    # 查找并停止所有ShadowTLS服务
    echo -e "${BLUE}正在停止所有ShadowTLS服务...${PLAIN}"
    local services=$(systemctl list-units --full --all | grep shadow-tls | awk '{print $1}')
    
    if [[ -z "$services" ]]; then
        echo -e "${YELLOW}未找到运行中的ShadowTLS服务${PLAIN}"
    else
        for service in $services; do
            # 提取端口号
            local port=$(echo $service | grep -oP 'shadow-tls-\K[0-9]+(?=\.service)')
            if [[ ! -z "$port" ]]; then
                all_ports+=($port)
            fi
            
            echo -e "${YELLOW}正在停止并禁用服务: $service${PLAIN}"
            systemctl stop $service
            systemctl disable $service
        done
    fi
    
    # 删除所有服务文件
    echo -e "${BLUE}正在删除所有服务文件...${PLAIN}"
    rm -f /etc/systemd/system/shadow-tls-*.service
    systemctl daemon-reload
    
    # 移除二进制文件
    echo -e "${BLUE}正在删除ShadowTLS二进制文件...${PLAIN}"
    if [[ -f "/usr/local/bin/e-shadowtls" ]]; then
        rm -f /usr/local/bin/e-shadowtls
    fi
    
    # 关闭防火墙端口
    echo -e "${BLUE}正在关闭所有相关防火墙端口...${PLAIN}"
    for port in "${all_ports[@]}"; do
        echo -e "${YELLOW}正在关闭端口: $port${PLAIN}"
        remove_firewall $port
    done
    
    echo -e "${GREEN}ShadowTLS已完全卸载!${PLAIN}"
}

# 主菜单
show_menu() {
    echo -e "
${GREEN}ShadowTLS 一键管理脚本${PLAIN}
  ${GREEN}1.${PLAIN} 检查安装并添加服务
  ${GREEN}2.${PLAIN} 查看现有服务
  ${GREEN}3.${PLAIN} 删除特定服务
  ${GREEN}9.${PLAIN} 彻底卸载
  ${GREEN}0.${PLAIN} 退出脚本
"
    read -p "请输入选项: " option
    
    case "$option" in
        1)
            check_root
            check_system
            detect_os
            install_dependencies
            check_and_install_shadowtls
            install_wizard
            ;;
        2)
            list_services
            ;;
        3)
            delete_service
            ;;
        9)
            uninstall_shadowtls
            ;; 
        0)
            exit 0
            ;;
        *)
            echo -e "${RED}错误: 请输入正确的选项${PLAIN}"
            ;;
    esac
}

# 主程序
main() {
    clear
    show_menu
}

main
