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

while true; do
    echo -e "\e[38;5;214mMenu:\e[0m"
    echo "1.重装系统                2.流媒体检测 "
    echo "3.添加warp v4出站          "
    echo "5.XUI                    6.3-XUI "
    echo "7.ss                     8.snell      "
    echo "9.singbox                10.sub-store "
    echo " "
    echo "0.退出脚本         00.更新脚本"
    echo "rm.删除脚本"
    read -p "等待输入" choice
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
                    menu
                    ;;
                *)
                    echo "无效输入"
                    ;;
            esac
            ;;
        2)   
            bash <(curl -L -s media.ispvps.com)
            ;;
        3)  
            wget -N https://gitlab.com/fscarmen/warp/-/raw/main/menu.sh && bash menu.sh 4
            ;;
        5)  
            bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
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
                    menu
                    ;;
                *)
                    echo "无效输入"
                    ;;
            esac
            ;;
        10)
            while true; do
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
                        read -n 1 -s -r -p "按任意键返回"
                        echo
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
                        read -n 1 -s -r -p "按任意键返回"
                        echo
                        ;;

                    0)
                        echo "返回主菜单。"
                        exit
                        ;;

                    *)
                        echo "无效输入，请重新选择。"
                        sleep 1
                        ;;
                esac
            done
            ;;
        0)
            clear
            exit
            ;;
        00)
            renew
            ;;
        rm)
            remove_script
            exit
            ;;
        *)
            echo "无效输入"
            sleep 1
            ;;
    esac
done
