#!/bin/bash

while true; do
    clear
    echo "------------------------"
    echo "脚本目录"
    echo "1.系统信息"
    echo "2."
    echo "3.节点搭建"
    echo "8.融合怪测试"
    echo "9.三网回程速度测试"
    echo "10.三网回程检测"
    echo "------------------------"
    echo "a.科技lion脚本工具"
    echo "------------------------"
    echo "0.退出此脚本"
    echo "输入renew更新此脚本"
    echo "当运行相应脚本后 会进入对应脚本的菜单 若想调出此菜单 请输入./7.sh"
    echo "OwO  ——————"
    echo "请输入数字或指令:"
    read choice

    case $choice in
        renew) 
            curl -sS -O https://raw.githubusercontent.com/Aovo7/One-click/main/7.sh && chmod +x 7.sh && ./7.sh
            ;;
        a) 
            curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh
            ;;
        1) 
            clear
            echo "收集 VPS 系统信息中..."
            # 系统信息收集脚本的内容
            ;;
        2) 
            # 选项2的命令
            ;;
        3)
            while true; do
                clear
                echo "节点搭建："
                echo "1.安装 Snell"
                echo "2.安装 Shadowsocks-Rust"
                echo "3.安装 TUIC"
                echo "4.安装 Hysteria"
                echo "5.安装 SingBox"
                echo "6.安装 Trojan"
                echo "7.安装 V2Ray"
                echo "0.返回主菜单"
                read -p "请输入数字或指令:" sub_choice

                case $sub_choice in
                    1)
                        wget -O snell.sh --no-check-certificate https://git.io/Snell.sh && chmod +x snell.sh && ./snell.sh
                        ;;
                    2)
                        wget -O ss-rust.sh --no-check-certificate https://raw.githubusercontent.com/xOS/Shadowsocks-Rust/master/ss-rust.sh && chmod +x ss-rust.sh && ./ss-rust.sh
                        ;;
                    3)
                        wget -N --no-check-certificate https://raw.githubusercontent.com/CCCOrz/auto-tuic/main/tuic.sh && bash tuic.sh
                        ;;
                    4)
                        wget -N --no-check-certificate https://raw.githubusercontent.com/Misaka-blog/hysteria-install/main/hy2/hysteria.sh && bash hysteria.sh
                        ;;
                    5)
                        wget -N -O /root/singbox.sh https://raw.githubusercontent.com/TinrLin/sing-box/main/Install.sh && chmod +x /root/singbox.sh && ln -sf /root/singbox.sh /usr/local/bin/singbox && bash /root/singbox.sh
                        ;;
                    6)
                        curl -O https://raw.githubusercontent.com/atrandys/trojan/master/trojan_mult.sh && chmod +x trojan_mult.sh
                        ;;
                    7)
                        bash <(wget -qO- -o- https://git.io/v2ray.sh)
                        ;;
                    0)
                        cd ~
                        ./7.sh
                        exit
                        ;;
                    *)
                        echo "请输入正确的数字或指令哦"
                        ;;
                esac
            done
            ;;
        8) 
            curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
            ;;
        9) 
            bash <(curl -Lso- https://down.wangchao.info/sh/superspeed.sh)
            ;;
        10) 
            curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
            ;;
        0) 
            clear
            exit
             ;;
        *) 
            echo "请输入正确的数字或指令哦"
            ;;
    esac
done
