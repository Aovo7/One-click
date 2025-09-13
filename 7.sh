#!/bin/bash
#curl -sS -O https://raw.githubusercontent.com/Aovo7/One-click/main/7.sh && sudo chmod +x 7.sh && ./7.sh
ln -sf ~/7.sh /usr/local/bin/7

check_ip_address() {
    local ipv4_address=$(curl -s --max-time 5 ipv4.ip.sb)
    local ipv6_address=$(curl -s --max-time 5 ipv6.ip.sb)

    # 判断IPv4地址是否获取成功
    if [[ -n "$ipv4_address" ]]; then
        ip_address=$ipv4_address
    elif [[ -n "$ipv6_address" ]]; then
        # 如果IPv4地址未获取到，但IPv6地址获取成功，则使用IPv6地址
        ip_address=[$ipv6_address]
    else
        # 如果两个地址都没有获取到，可以在这里处理这种情况
        echo "无法获取IP地址"
        ip_address=""
    fi
}


check_ports() {
    local ports=("$@")  # 接受一个数组参数，包含所有要检查的端口
    local port_errors=""

    for port in "${ports[@]}"; do
        if ss -ltn | grep -q ":$port "; then
            port_errors+="$port端口已被占用 "
        fi
    done

    if [ ! -z "$port_errors" ]; then
        echo "$port_errors 安装失败"
        return 1  # 返回1表示有端口被占用
    fi

    return 0  # 返回0表示所有端口都未被占用
}


iptables_open() {
    # 允许指定端口的流量通过
    ports="$user_port"
    iptables -A INPUT -p tcp --dport "$ports" -j ACCEPT
    iptables -A OUTPUT -p tcp --sport "$ports" -j ACCEPT
}

install_docker() {
    if ! command -v docker &>/dev/null; then
        if [ -f "/etc/alpine-release" ]; then
            apk update && apk add docker docker-compose
            rc-update add docker default && service docker start
        else
            curl -fsSL https://get.docker.com | sh
            if ! command -v docker-compose &>/dev/null; then
                curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                chmod +x /usr/local/bin/docker-compose
            fi
            systemctl start docker && systemctl enable docker
        fi
    else
        echo "Docker 已经安装."
    fi
}

renew(){
    curl -sS -O https://raw.githubusercontent.com/Aovo7/One-click/main/7.sh && sudo chmod +x 7.sh && ./7.sh
}

remove_script() {
    echo "正在删除脚本文件和符号链接..."
    rm -f ~/7.sh
    sudo rm -f /usr/local/bin/7
    echo "删除完成。"
}

menu() {
    7
}

# 修改为不使用无限循环
clear
# 定义颜色
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RED="\033[0;31m"
PURPLE="\033[0;35m"
NC="\033[0m" # 恢复默认颜色

# 绘制边框和标题
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}                 功能菜单                   ${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 菜单选项
echo -e "${GREEN}【系统工具】${NC}"
echo -e " ${BLUE}1.${NC} 重装系统               ${BLUE}2.${NC} 流媒体检测"
echo -e " ${BLUE}3.${NC} 添加warp v4出站        ${BLUE}4.${NC} IPCheck"

echo -e "${GREEN}【代理工具】${NC}"
echo -e " ${BLUE}5.${NC} XUI                   ${BLUE}6.${NC} 3-XUI"
echo -e " ${BLUE}7.${NC} ss                    ${BLUE}8.${NC} snell"
echo -e " ${BLUE}9.${NC} singbox               ${BLUE}10.${NC} sub-store"
echo -e " ${BLUE}11.${NC} vasma八合一           ${BLUE}12.${NC} ss2022/snell+shadowtls"
echo -e " ${BLUE}13.${NC} ShadowtlsV3                "
echo -e " ${BLUE}15.${NC} Multi-Shadowtls      ${BLUE}16.${NC} Telegram自走机器人PagerMaid         "
echo -e " ${BLUE}17.${NC} 安装 Python 3.10         ${BLUE}18.${NC} Rent.sh   "
echo -e " ${BLUE}20.${NC} Snell多用户    "
echo -e "${GREEN}【其他选项】${NC}"
echo -e " ${RED}0.${NC} 退出脚本               ${RED}00.${NC} 更新脚本"
echo -e " ${PURPLE}rm.${NC} 删除脚本"

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
read -p " 请输入选项 > " choice

case $choice in
    1)   
        clear
        
        echo "https://github.com/bin456789/reinstall"
        echo "     "
        echo "安装后运行以下指令即为重装为debian11"
        echo "bash reinstall.sh debian 11 "
        echo "Linux重装后	用户名:root	 密码:123@@@"
        echo "1:安装   2:退出"
        read -p " " inner_choice
        case $inner_choice in
            1)   
                curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
                ;;
            2)   
                exit 0
                ;;
            *)
                echo "无效输入"
                ;;
        esac
        ;;
    2)   
        bash <(curl -L -s https://raw.githubusercontent.com/1-stream/RegionRestrictionCheck/main/check.sh)
        ;;
    3)  
        wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh 4
        ;;
    4)  
        bash <(curl -sL IP.Check.Place)  
        ;;
    5)  
        bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
        ;;
    6)  
        bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
        ;;
    7)
        wget -O ss-rust.sh --no-check-certificate https://raw.githubusercontent.com/xOS/Shadowsocks-Rust/master/ss-rust.sh && chmod +x ss-rust.sh && ./ss-rust.sh
        ;;
    8)
        wget -O snell.sh --no-check-certificate https://git.io/Snell.sh && chmod +x snell.sh && ./snell.sh
        ;; 
    9)
        clear
        echo "https://233boy.com/sing-box/sing-box-script/ "
        echo "     "
        echo "sb add ss -> 添加一个 Shadowsocks 2022 配置"
        echo "sb add reality -> 添加一个 VLESS-REALITY 配置"
        echo "1:安装   2:退出"
        read -p " " inner_choice
        case $inner_choice in
            1)   
                bash <(wget -qO- -o- https://github.com/233boy/sing-box/raw/main/install.sh)
                ;;
            2)   
                exit 0
                ;;
            *)
                echo "无效输入"
                ;;
        esac
        ;;
    10)
        # 修改子菜单，使其在完成操作后不循环
        clear
        echo -e "\033[38;5;208m'子存储项目Sub-Store' \033[0m"
        echo "------------------------"
        echo "菜单栏："
        echo "------------------------"
        echo "1. 安装项目"
        echo "2. 删除项目"
        echo "0. 返回主菜单"
        read -p "请输入你的选择：" user_choice
        name="sub-store"

        case $user_choice in
            1)
                install_docker
                iptables_open

                # 检查名为sub-store的容器是否已存在
                container_exists=$(docker ps -a --format '{{.Names}}' | grep -w "$name")
                if [ "$container_exists" = "$name" ]; then
                    echo "子存储项目已安装"
                else
                    # 提示用户输入路径和端口
                    read -p "请输入加密路径 (默认: abc): " user_path
                    user_path=${user_path:-abc}  # 如果用户未输入，则使用默认值 "abc"

                    read -p "请输入端口号 (默认: 3001): " user_port
                    user_port=${user_port:-3001}  # 如果用户未输入，则使用默认值 "3001"


                    # 初始化端口占用信息变量
                    ports_to_check=$user_port
                    # 使用函数检查定义的端口数组
                    if ! check_ports "${ports_to_check[@]}"; then
                        exit 1  # 如果检查失败则退出
                    else
                        echo "端口未被占用，可以继续执行"
                    fi

                    # 运行Docker命令
                    docker run -it -d --restart=always \
                        -e "SUB_STORE_CRON=0 0 * * *" \
                        -e SUB_STORE_FRONTEND_BACKEND_PATH=/$user_path \
                        -p $user_port:3001 \
                        -v /root/sub-store-data:/opt/app/data \
                        --name $name \
                        xream/sub-store
                    check_ip_address
                    echo "Sub-Store 容器已启动，路径为 $user_path，端口为 $user_port"
                    echo "http://$ip_address:$user_port?api=http://$ip_address:$user_port/$user_path"
                    
                fi
                ;;

            2)
                # 提示用户确认是否删除挂载卷
                echo "是否删除宿主机挂载卷 /root/sub-store-data? (y/n)"
                read answer

                case $answer in
                    y)
                        echo "正在删除..."
                        docker stop $name
                        docker rm $name
                        rm -rf /root/sub-store-data
                        echo "项目和挂载卷已删除。"
                        ;;
                    n)
                        echo "正在删除 Docker 容器，但保留挂载卷..."
                        docker stop $name
                        docker rm $name
                        echo "Docker 项目已删除，但挂载卷保留。"
                        ;;
                    *)
                        echo "无效输入，请输入 'y' 或 'n'。"
                        ;;
                esac
                ;;

            0)
                echo "退出脚本。"
                exit 0
                ;;

            *)
                echo "无效输入。"
                ;;
        esac
        ;;
    11)
        wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
        ;; 
    12)
        bash <(curl -L -s menu.jinqians.com)
        ;; 
    13)
        wget -O ShadowTLS_Manager.sh --no-check-certificate https://raw.githubusercontent.com/Kismet0123/ShadowTLS-Manager/refs/heads/main/ShadowTLS_Manager.sh && chmod +x ShadowTLS_Manager.sh && ./ShadowTLS_Manager.sh
        ;; 
    15)
        bash <(curl -sL https://raw.githubusercontent.com/Aovo7/One-click/refs/heads/main/multi-shadowtls.sh) 
        ;; 
    16)
        bash <(curl -sL https://raw.githubusercontent.com/TeamPGM/PagerMaid-Pyro/development/utils/install.sh) 
        ;; 
    17)
        bash <(curl -sL https://raw.githubusercontent.com/Aovo7/One-click/refs/heads/main/install_python310.sh) 
        ;; 
    18)
        sudo apt install iptables bc python3 wget nano openssl && bash <(curl -sL https://raw.githubusercontent.com/BlackSheep-cry/Rent-PL/main/rent.sh) 
        ;; 
    20)
        #bash <(curl -sL https://raw.githubusercontent.com/Aovo7/One-click/refs/heads/main/SnellV4-Multi.sh)
        sh -c "$(curl -fsSL https://install.jinqians.com)"
        ;; 
    0)
        clear
        exit 0
        ;;
    00)
        renew
        ;;
    rm)
        remove_script
        exit 0
        ;;
    *)
        echo "无效输入"
        ;;
esac
