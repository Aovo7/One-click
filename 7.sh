#!/bin/bash
#安装wget curl依赖包
#yum update -y && yum install curl -y #CentOS/Fedora
#apt-get update -y && apt-get install curl -y #Debian/Ubuntu
#远程下载代码curl -sS -O https://raw.githubusercontent.com/ecouus/Shell/main/ecouu.sh && sudo chmod +x ecouu.sh && ./ecouu.sh
ln -sf ~/7.sh /usr/local/bin/7

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
    curl -sS -O https://raw.githubusercontent.com/ecouus/Shell/main/ecouu.sh && sudo chmod +x ecouu.sh && ./ecouu.sh
}

menu() {
    7
}

while true; do
    clear
    echo "1.重装系统               2.流媒体检测 "
    echo "3.添加warp v4出站          "
    echo "5.XUI                   6.3-XUI "
    echo "7.ss                    8.singbox      "
    echo " "
    echo "0.退出脚本         88.更新脚本"
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
            bash <(curl -Ls IP.Check.Place)
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
        0)
            clear
            exit
            ;;
        88)
            renew
            ;;
        *)
            echo "无效输入"
            sleep 1
            ;;
    esac
done
