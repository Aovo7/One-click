#!/bin/bash
#curl -sS -O https://raw.githubusercontent.com/Aovo7/One-click/main/7.sh && sudo chmod +x 7.sh && ./7.sh
ln -sf ~/7.sh /usr/local/bin/7


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
    echo "9.singbox                         "
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
            bash <(curl -sL IP.Check.Place)
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
