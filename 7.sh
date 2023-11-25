#!/bin/bash

while true; do
clear
echo "------------------------"
echo 本脚本由 "One-click by 7" 整合提供。尽管我们尽力确保脚本的安全性和有效性，
echo 但我们不对由于使用此脚本而可能引起的任何损害或数据丢失承担责任。
echo 本脚本中部分内容来自互联网，因此对这些内容的准确性、可靠性或者适用性不作保证。
echo 使用本脚本即表示您理解并同意承担所有相关风险。
echo 在使用任何网络脚本之前，我们建议您先进行充分的研究和测试，遵守适用的法律法规，并尊重原作者的版权和许可协议。
echo "------------------------"
echo -e "\033[0;32mOne-click by 7\033[0m"
echo "脚本目录"
echo "1.系统信息"
echo "2.系统更新"
echo "3.节点搭建"
echo "4.网站搭建"
echo "8.融合怪测试"
echo "9.三网回程检测"
echo "10.三网回程速度测试"
echo "------------------------"
echo "0.退出此脚本"
echo "输入renew更新此脚本"
#echo "当运行相应脚本后 会进入对应脚本的菜单 若想调出此菜单 请输入./7.sh"
echo "OwO  ——————"
echo "请输入数字或指令:"
read choice

case $choice in
	renew) 
		curl -sS -O https://raw.githubusercontent.com/Aovo7/One-click/main/7.sh && chmod +x 7.sh && ./7.sh
		;;
	1) 
		clear
		echo "收集 VPS 系统信息中..."

		# 获取操作系统信息
		os_info=$(uname -o)
		os_version=$(uname -r)

		# CPU 信息
		cpu_model=$(grep -m1 'model name' /proc/cpuinfo | cut -d ":" -f2)
		cpu_cores=$(grep -c 'model name' /proc/cpuinfo)

		# 内存信息
		mem_total=$(free -m | awk '/Mem:/ { print $2 "MB" }')
		mem_used=$(free -m | awk '/Mem:/ { print $3 "MB" }')

		# 磁盘使用情况
		disk_usage=$(df -h | awk '$NF=="/"{printf "%s of %s Used (%s)", $3,$2,$5}')

		# 网络信息
		ipv4=$(curl -s ipv4.icanhazip.com)
		ipv6=$(curl -s ipv6.icanhazip.com)

		# 系统运行时间
		uptime_info=$(uptime -p)

		# 主机名
		host_name=$(hostname)

		# 当前时间
		current_time=$(date)
		# 显示信息
		echo "系统信息"
		echo "----------"
		echo "操作系统: $os_info $os_version"
		echo "CPU 型号: $cpu_model"
		echo "CPU 核心数: $cpu_cores"
		echo "内存使用: $mem_used / $mem_total"
		echo "磁盘使用: $disk_usage"
		echo "公网 IPv4 地址: $ipv4"
		echo "公网 IPv6 地址: $ipv6"
		echo "系统运行时间: $uptime_info"
		echo "主机名: $host_name"
		echo "当前时间: $current_time"
		echo "----------"
		;;
	2) 
		clear
		echo "正在更新系统..."

		# 检测 Debian/Ubuntu 系统
		if [ -f "/etc/debian_version" ]; then
			echo "检测到 Debian/Ubuntu 系统"
			sudo apt autoremove -y

		# 检测 CentOS/RHEL 系统
		elif [ -f "/etc/redhat-release" ]; then
			echo "检测到 CentOS/RHEL 系统"
			sudo yum update -y
			sudo yum autoremove -y

		else
			echo "未知的系统类型，无法更新"
		fi
		;;
	3)
		while true; do
			clear
			echo "节点搭建："
			echo "1.安装 Snell"
			echo "2.安装 Shadowsocks"
			echo "3.安装 TUIC"
			echo "4.安装 Hysteria"
			echo "5.安装 SingBox"
			echo "6.安装 Trojan"
			echo "7.安装 V2Ray(VMESS/Trojan+WS/gRPC/TCP(+TLS)"
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
					echo "0.0此地无银三百两 请输入正确的数字或指令哦~"
					;;
			esac
		done
		;;
	4)
		while true; do
			clear
			echo "1.安装宝塔面板"
			echo "肝不动了 休息休息T.T"
			echo "0.返回主菜单"
			read -p "请输入数字或指令:" sub_choice

			case $sub_choice in
    1)
     clear
     echo "正在检测操作系统并安装宝塔面板..."
     # 检测 Debian/Ubuntu 系统
     if [ -f "/etc/debian_version" ]; then
         echo "检测到 Debian/Ubuntu 系统"
         wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
     # 检测 CentOS/RHEL 系统
     elif [ -f "/etc/redhat-release" ]; then
         echo "检测到 CentOS/RHEL 系统"
         yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
     # 检测 Fedora 系统
     elif [ -f "/etc/fedora-release" ]; then
         echo "检测到 Fedora 系统"
         wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh
     else
         echo "未知的系统类型，无法安装宝塔面板"
     fi
			
				0)
					cd ~
					./7.sh
					exit
					;;
				*)
					echo "0.0此地无银三百两 请输入正确的数字或指令哦~"
					;;
			esac
		done
		;;
	8) 
		curl -L https://gitlab.com/spiritysdx/za/-/raw/main/ecs.sh -o ecs.sh && chmod +x ecs.sh && bash ecs.sh
		;;
	9) 
		curl https://raw.githubusercontent.com/zhanghanyun/backtrace/main/install.sh -sSf | sh
		;;
	10) 
		bash <(curl -Lso- https://down.wangchao.info/sh/superspeed.sh)
		;;
	0) 
		clear
		exit 0
		 ;;
	*) 
		echo "0.0此地无银三百两 请输入正确的数字或指令哦~"
		;;
esac
	echo -e "\033[0;32m操作完成\033[0m"
	echo "按任意键返回主菜单..."
	read -n 1 -s -r -p ""
	echo ""
	clear
done
