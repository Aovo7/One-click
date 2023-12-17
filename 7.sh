#!/bin/bash
#安装weget curl依赖包
#yum update -y && yum install curl -y #CentOS/Fedora
#apt-get update -y && apt-get install curl -y #Debian/Ubuntu
#远程下载代码curl -sS -O https://raw.githubusercontent.com/Aovo7/One-click/main/7.sh && chmod +x 7.sh && ./7.sh
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
echo "OwO —————— OwO"
# 清空输入缓冲区
read -t 0.1 -n 10000

read -p "请输入数字或指令: " choice

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
			echo "源于https://likeable-fuschia-f06.notion.site/VPS-76f1905f566942dabfa7f95317a0d2ca"
			echo -e "\033[32m节点搭建菜单\033[0m"
			echo "节点搭建："
			echo "1.安装 Snell"
			echo "2.安装 Shadowsocks"
			echo "3.安装 TUIC"
			echo "4.安装 Reality Hy2 vmess+ws三合一"
			echo "5.安装 SingBox"
			echo "6.安装 Trojan"
			echo "7.安装 V2Ray(VMESS/Trojan+WS/gRPC/TCP(+TLS)"
			echo "6.安装 Trojan"
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
					bash <(curl -fsSL https://github.com/vveg26/sing-box-reality-hysteria2/raw/main/install.sh)
			 	;;
				4)
					bash <(curl -fsSL https://github.com/vveg26/sing-box-reality-hysteria2/raw/main/beta.sh)
				 ;;
				5)
					wget -N -O /root/singbox.sh https://raw.githubusercontent.com/TinrLin/sing-box/main/Install.sh && chmod +x /root/singbox.sh && ln -sf /root/singbox.sh /usr/local/bin/singbox && bash /root/singbox.sh
					;;
				6)
					source <(curl -L https://github.com/trojanpanel/install-script/raw/main/install_script.sh)
					;;
				7)
					bash <(wget -qO- -o- https://git.io/v2ray.sh)
					;;
				hy2)
					wget -N --no-check-certificate https://raw.githubusercontent.com/Misaka-blog/hysteria-install/main/hy2/hysteria.sh && bash hysteria.sh
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
			echo  "源于https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh"
			echo -e "\033[33m ▼ \033[0m"
			echo -e "\033[33mLDNMP建站\033[0m"
			echo  "------------------------"
			echo  "1. 安装LDNMP环境"
			echo  "------------------------"
			echo  "2. 安装WordPress"
			echo  "3. 安装Discuz论坛"
			echo  "4. 安装可道云桌面"
			echo  "5. 安装苹果CMS网站"
			echo  "6. 安装独角数发卡网"
			echo  "7. 安装BingChatAI聊天网站"
			echo  "8. 安装flarum论坛网站"
			echo  "9. 安装Bitwarden密码管理平台"
			echo  "10. 安装Halo博客网站"
			echo  "11. 安装typecho轻量博客网站"
			echo  "------------------------"
			echo  "21. 站点重定向"
			echo  "22. 站点反向代理"
			echo  "------------------------"
			echo  "31. 站点数据管理"
			echo  "32. 备份全站数据"
			echo  "33. 定时远程备份"
			echo  "34. 还原全站数据"
			echo  "------------------------"
			echo  "35. 站点防御程序"
			echo  "------------------------"
			echo -e "36. 优化LDNMP环境 \033[33mNEW\033[0m"
			echo  "37. 更新LDNMP环境"
			echo  "38. 卸载LDNMP环境"
			echo  "------------------------"
			echo  "0. 返回主菜单"
			echo  "------------------------"
			read -p "请输入你的选择: " sub_choice


			case $sub_choice in
				1)
					clear

					# 更新并安装必要的软件包
					if command -v apt &>/dev/null; then
					  DEBIAN_FRONTEND=noninteractive apt update -y
					  DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
					  apt install -y curl wget sudo socat unzip tar htop
					elif command -v yum &>/dev/null; then
					  yum -y update && yum -y install curl wget sudo socat unzip tar htop
					else
					  echo "未知的包管理器!"
					fi

					# 检查并安装 Docker（如果需要）
					if ! command -v docker &>/dev/null; then
					  curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
					  systemctl start docker
					  systemctl enable docker
					else
					  echo "Docker 已经安装"
					fi

					# 创建必要的目录和文件
					cd /home && mkdir -p web/html web/mysql web/certs web/conf.d web/redis web/log/nginx && touch web/docker-compose.yml

					wget -O /home/web/nginx.conf https://raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
					wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default10.conf
					localhostIP=$(curl -s ipv4.ip.sb)
					sed -i "s/localhost/$localhostIP/g" /home/web/conf.d/default.conf

					# 下载 docker-compose.yml 文件并进行替换
					wget -O /home/web/docker-compose.yml https://raw.githubusercontent.com/kejilion/docker/main/LNMP-docker-compose-10.yml

					dbrootpasswd=$(openssl rand -base64 16) && dbuse=$(openssl rand -hex 4) && dbusepasswd=$(openssl rand -base64 8)

					# 在 docker-compose.yml 文件中进行替换
					sed -i "s/webroot/$dbrootpasswd/g" /home/web/docker-compose.yml
					sed -i "s/kejilionYYDS/$dbusepasswd/g" /home/web/docker-compose.yml
					sed -i "s/kejilion/$dbuse/g" /home/web/docker-compose.yml

					if ! command -v iptables &> /dev/null; then
					echo ""
					else
					  # iptables命令
					  iptables -P INPUT ACCEPT
					  iptables -P FORWARD ACCEPT
					  iptables -P OUTPUT ACCEPT
					  iptables -F
					fi

					cd /home/web && docker-compose up -d


					clear
					echo "正在配置LDNMP环境，请耐心稍等……"

					# 定义要执行的命令
					commands=(
					  "docker exec php apt update > /dev/null 2>&1"
					  "docker exec php apt install -y libmariadb-dev-compat libmariadb-dev libzip-dev libmagickwand-dev imagemagick > /dev/null 2>&1"
					  "docker exec php docker-php-ext-install mysqli pdo_mysql zip exif gd intl bcmath opcache > /dev/null 2>&1"
					  "docker exec php pecl install imagick > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"extension=imagick.so\" > /usr/local/etc/php/conf.d/imagick.ini' > /dev/null 2>&1"
					  "docker exec php pecl install redis > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"extension=redis.so\" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

					  "docker exec php74 apt update > /dev/null 2>&1"
					  "docker exec php74 apt install -y libmariadb-dev-compat libmariadb-dev libzip-dev libmagickwand-dev imagemagick > /dev/null 2>&1"
					  "docker exec php74 docker-php-ext-install mysqli pdo_mysql zip gd intl bcmath opcache > /dev/null 2>&1"
					  "docker exec php74 pecl install imagick > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"extension=imagick.so\" > /usr/local/etc/php/conf.d/imagick.ini' > /dev/null 2>&1"
					  "docker exec php74 pecl install redis > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"extension=redis.so\" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

					)

					total_commands=${#commands[@]}  # 计算总命令数

					for ((i = 0; i < total_commands; i++)); do
					  command="${commands[i]}"
					  eval $command  # 执行命令

					  # 打印百分比和进度条
					  percentage=$(( (i + 1) * 100 / total_commands ))
					  completed=$(( percentage / 2 ))
					  remaining=$(( 50 - completed ))
					  progressBar="["
					  for ((j = 0; j < completed; j++)); do
						  progressBar+="#"
					  done
					  for ((j = 0; j < remaining; j++)); do
						  progressBar+="."
					  done
					  progressBar+="]"
					  echo -ne "\r[$percentage%] $progressBar"
					done

					echo  # 打印换行，以便输出不被覆盖


					clear
					echo "LDNMP环境安装完毕"
					echo "------------------------"

					# 获取nginx版本
					nginx_version=$(docker exec nginx nginx -v 2>&1)
					nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
					echo -n "nginx : v$nginx_version"

					# 获取mysql版本
					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					mysql_version=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
					echo -n "            mysql : v$mysql_version"

					# 获取php版本
					php_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
					echo -n "            php : v$php_version"

					# 获取redis版本
					redis_version=$(docker exec redis redis-server -v 2>&1 | grep -oP "v=+\K[0-9]+\.[0-9]+")
					echo "            redis : v$redis_version"

					echo "------------------------"
					echo ""

					;;
				2)
					clear
					# wordpress
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/wordpress.com.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming
					wget -O latest.zip https://cn.wordpress.org/latest-zh_CN.zip
					unzip latest.zip
					rm latest.zip

					echo "define('FS_METHOD', 'direct'); define('WP_REDIS_HOST', 'redis'); define('WP_REDIS_PORT', '6379');" >> /home/web/html/$yuming/wordpress/wp-config-sample.php

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx

					clear
					echo "您的WordPress搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "WP安装信息如下: "
					echo "数据库名: $dbname"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo "数据库主机: mysql"
					echo "表前缀: wp_"

					;;
				3)
					clear
					# Discuz论坛
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/discuz.com.conf

					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming
					wget https://github.com/kejilion/Website_source_code/raw/main/Discuz_X3.5_SC_UTF8_20230520.zip
					unzip -o Discuz_X3.5_SC_UTF8_20230520.zip
					rm Discuz_X3.5_SC_UTF8_20230520.zip

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx


					clear
					echo "您的Discuz论坛搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "安装信息如下: "
					echo "数据库主机: mysql"
					echo "数据库名: $dbname"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo "表前缀: discuz_"


					;;

				4)
					clear
					# 可道云桌面
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/kdy.com.conf

					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming
					wget https://github.com/kalcaddle/kodbox/archive/refs/tags/1.42.04.zip
					unzip -o 1.42.04.zip
					rm 1.42.04.zip

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx


					clear
					echo "您的可道云桌面搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "安装信息如下: "
					echo "数据库主机: mysql"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo "数据库名: $dbname"
					echo "redis主机: redis"
					;;

				5)
					clear
					# 苹果CMS
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/maccms.com.conf

					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming
					wget https://github.com/magicblack/maccms_down/raw/master/maccms10.zip && unzip maccms10.zip && rm maccms10.zip
					cd /home/web/html/$yuming/maccms10-master/template/ && wget https://github.com/kejilion/Website_source_code/raw/main/DYXS2.zip && unzip DYXS2.zip && rm /home/web/html/$yuming/maccms10-master/template/DYXS2.zip
					cp /home/web/html/$yuming/maccms10-master/template/DYXS2/asset/admin/Dyxs2.php /home/web/html/$yuming/maccms10-master/application/admin/controller
					cp /home/web/html/$yuming/maccms10-master/template/DYXS2/asset/admin/dycms.html /home/web/html/$yuming/maccms10-master/application/admin/view/system
					mv /home/web/html/$yuming/maccms10-master/admin.php /home/web/html/$yuming/maccms10-master/vip.php && wget -O /home/web/html/$yuming/maccms10-master/application/extra/maccms.php https://raw.githubusercontent.com/kejilion/Website_source_code/main/maccms.php

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx


					clear
					echo "您的苹果CMS搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "安装信息如下: "
					echo "数据库主机: mysql"
					echo "数据库端口: 3306"
					echo "数据库名: $dbname"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo "数据库前缀: mac_"
					echo "------------------------"
					echo "安装成功后登录后台地址"
					echo "https://$yuming/vip.php"
					echo ""
					;;

				6)
					clear
					# 独脚数卡
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/dujiaoka.com.conf

					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming
					wget https://github.com/assimon/dujiaoka/releases/download/2.0.6/2.0.6-antibody.tar.gz && tar -zxvf 2.0.6-antibody.tar.gz && rm 2.0.6-antibody.tar.gz

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx


					clear
					echo "您的独角数卡网站搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "安装信息如下: "
					echo "数据库主机: mysql"
					echo "数据库端口: 3306"
					echo "数据库名: $dbname"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo ""
					echo "redis地址: redis"
					echo "redis密码: 默认不填写"
					echo "redis端口: 6379"
					echo ""
					echo "网站url: https://$yuming"
					echo "后台登录路径: /admin"
					echo "------------------------"
					echo "用户名: admin"
					echo "密码: admin"
					echo "------------------------"
					echo "登录时右上角如果出现红色error0请使用如下命令: "
					echo "我也很气愤独角数卡为啥这么麻烦，会有这样的问题！"
					echo "sed -i 's/ADMIN_HTTPS=false/ADMIN_HTTPS=true/g' /home/web/html/$yuming/dujiaoka/.env"
					echo ""
					;;

				7)
					clear
					# BingChat
					read -p "请输入你解析的域名: " yuming

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					docker run -d -p 3099:8080 --name go-proxy-bingai --restart=unless-stopped adams549659584/go-proxy-bingai

					# Get external IP address
					external_ip=$(curl -s ipv4.ip.sb)

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0.0.0.0/$external_ip/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0000/3099/g" /home/web/conf.d/$yuming.conf

					docker restart nginx

					clear
					echo "您的BingChat网站搭建好了！"
					echo "https://$yuming"
					echo ""
					;;

				8)
					clear
					# flarum论坛
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/flarum.com.conf

					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming

					docker exec php sh -c "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\""
					docker exec php sh -c "php composer-setup.php"
					docker exec php sh -c "php -r \"unlink('composer-setup.php');\""
					docker exec php sh -c "mv composer.phar /usr/local/bin/composer"

					docker exec php composer create-project flarum/flarum /var/www/html/$yuming
					docker exec php sh -c "cd /var/www/html/$yuming && composer require flarum-lang/chinese-simplified"
					docker exec php sh -c "cd /var/www/html/$yuming && composer require fof/polls"

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx


					clear
					echo "您的flarum论坛网站搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "安装信息如下: "
					echo "数据库主机: mysql"
					echo "数据库名: $dbname"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo "表前缀: flarum_"
					echo "管理员信息自行设置"
					echo ""
					;;

				9)
					clear
					# Bitwarden
					read -p "请输入你解析的域名: " yuming

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					docker run -d \
					--name bitwarden \
					--restart always \
					-p 3280:80 \
					-v /home/web/html/$yuming/bitwarden/data:/data \
					vaultwarden/server

					# Get external IP address
					external_ip=$(curl -s ipv4.ip.sb)

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0.0.0.0/$external_ip/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0000/3280/g" /home/web/conf.d/$yuming.conf

					docker restart nginx

					clear
					echo "您的Bitwarden网站搭建好了！"
					echo "https://$yuming"
					echo ""
					;;

				10)
					clear
					# Bitwarden
					read -p "请输入你解析的域名: " yuming

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					docker run -d --name halo --restart always --network web_default -p 8010:8090 -v /home/web/html/$yuming/.halo2:/root/.halo2 halohub/halo:2.9

					# Get external IP address
					external_ip=$(curl -s ipv4.ip.sb)

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0.0.0.0/$external_ip/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0000/8010/g" /home/web/conf.d/$yuming.conf

					docker restart nginx

					clear
					echo "您的Halo网站搭建好了！"
					echo "https://$yuming"
					echo ""
					;;

				11)
					clear
					# typecho
					read -p "请输入你解析的域名: " yuming
					dbname=$(echo "$yuming" | sed -e 's/[^A-Za-z0-9]/_/g')
					dbname="${dbname}"

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					docker start nginx

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/typecho.com.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf

					cd /home/web/html
					mkdir $yuming
					cd $yuming
					wget -O latest.zip https://github.com/typecho/typecho/releases/latest/download/typecho.zip
					unzip latest.zip
					rm latest.zip

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html

					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbuse=$(grep -oP 'MYSQL_USER:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					dbusepasswd=$(grep -oP 'MYSQL_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					docker exec mysql mysql -u root -p"$dbrootpasswd" -e "CREATE DATABASE $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO \"$dbuse\"@\"%\";"

					docker restart php
					docker restart php74
					docker restart nginx


					clear
					echo "您的typecho搭建好了！"
					echo "https://$yuming"
					echo "------------------------"
					echo "安装信息如下: "
					echo "数据库前缀: typecho_"
					echo "数据库地址: mysql"
					echo "用户名: $dbuse"
					echo "密码: $dbusepasswd"
					echo "数据库名: $dbname"

					;;



				21)
					clear
					read -p "请输入你的域名: " yuming
					read -p "请输入跳转域名: " reverseproxy

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/rewrite.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
					sed -i "s/baidu.com/$reverseproxy/g" /home/web/conf.d/$yuming.conf

					docker start nginx

					clear
					echo "您的重定向网站做好了！"
					echo "https://$yuming"

					;;

				22)
					clear
					read -p "请输入你的域名: " yuming
					read -p "请输入你的反代IP: " reverseproxy
					read -p "请输入你的反代端口: " port

					docker stop nginx

					cd ~
					curl https://get.acme.sh | sh
					~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force

					wget -O /home/web/conf.d/$yuming.conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
					sed -i "s/yuming.com/$yuming/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0.0.0.0/$reverseproxy/g" /home/web/conf.d/$yuming.conf
					sed -i "s/0000/$port/g" /home/web/conf.d/$yuming.conf

					docker start nginx

					clear
					echo "您的反向代理网站做好了！"
					echo "https://$yuming"

					;;


				31)
					while true; do
						clear
						echo "LDNMP环境"
						echo "------------------------"
						# 获取nginx版本
						nginx_version=$(docker exec nginx nginx -v 2>&1)
						nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
						echo -n "nginx : v$nginx_version"
						# 获取mysql版本
						dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
						mysql_version=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
						echo -n "            mysql : v$mysql_version"
						# 获取php版本
						php_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
						echo -n "            php : v$php_version"
						# 获取redis版本
						redis_version=$(docker exec redis redis-server -v 2>&1 | grep -oP "v=+\K[0-9]+\.[0-9]+")
						echo "            redis : v$redis_version"
						echo "------------------------"
						echo ""


						# ls -t /home/web/conf.d | sed 's/\.[^.]*$//'
						echo "站点信息                      证书到期时间"
						echo "------------------------"
						for cert_file in /home/web/certs/*_cert.pem; do
						  domain=$(basename "$cert_file" | sed 's/_cert.pem//')
						  if [ -n "$domain" ]; then
							expire_date=$(openssl x509 -noout -enddate -in "$cert_file" | awk -F'=' '{print $2}')
							formatted_date=$(date -d "$expire_date" '+%Y-%m-%d')
							printf "%-30s%s\n" "$domain" "$formatted_date"
						  fi
						done

						echo "------------------------"
						echo ""
						echo "数据库信息"
						echo "------------------------"
						dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
						docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SHOW DATABASES;" 2> /dev/null | grep -Ev "Database|information_schema|mysql|performance_schema|sys"

						echo "------------------------"
						echo ""
						echo "操作"
						echo "------------------------"
						echo "1. 申请/更新域名证书               2. 更换站点域名               3. 清理站点缓存"
						echo "------------------------"
						echo "7. 删除指定站点                    8. 删除指定数据库"
						echo "------------------------"
						echo "0. 返回上一级选单"
						echo "------------------------"
						read -p "请输入你的选择: " sub_choice
						case $sub_choice in
							1)
								read -p "请输入你的域名: " yuming

								docker stop nginx

								cd ~
								curl https://get.acme.sh | sh
								~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $yuming --standalone --key-file /home/web/certs/${yuming}_key.pem --cert-file /home/web/certs/${yuming}_cert.pem --force
								docker start nginx

								;;

							2)
								read -p "请输入旧域名: " oddyuming
								read -p "请输入新域名: " newyuming
								mv /home/web/conf.d/$oddyuming.conf /home/web/conf.d/$newyuming.conf
								sed -i "s/$oddyuming/$newyuming/g" /home/web/conf.d/$newyuming.conf
								mv /home/web/html/$oddyuming /home/web/html/$newyuming

								rm /home/web/certs/${oddyuming}_key.pem
								rm /home/web/certs/${oddyuming}_cert.pem

								docker stop nginx

								cd ~
								curl https://get.acme.sh | sh
								~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com --issue -d $newyuming --standalone --key-file /home/web/certs/${newyuming}_key.pem --cert-file /home/web/certs/${newyuming}_cert.pem --force
								docker start nginx

								;;


							3)
								docker exec -it nginx rm -rf /var/cache/nginx
								docker restart nginx
								;;

							7)
								read -p "请输入你的域名: " yuming
								rm -r /home/web/html/$yuming
								rm /home/web/conf.d/$yuming.conf
								rm /home/web/certs/${yuming}_key.pem
								rm /home/web/certs/${yuming}_cert.pem
								;;
							8)
								read -p "请输入数据库名: " shujuku
								dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
								docker exec mysql mysql -u root -p"$dbrootpasswd" -e "DROP DATABASE $shujuku;" 2> /dev/null
								;;
							0)
								break  # 跳出循环，退出菜单
								;;
							*)
								break  # 跳出循环，退出菜单
								;;
						esac
						done

						;;


				32)
					clear
					cd /home/ && tar czvf web_$(date +"%Y%m%d%H%M%S").tar.gz web

					while true; do
					clear
					read -p "要传送文件到远程服务器吗？(Y/N): " choice
					case "$choice" in
					  [Yy])
						read -p "请输入远端服务器IP:  " remote_ip
						if [ -z "$remote_ip" ]; then
						  echo "错误: 请输入远端服务器IP。"
						  continue
						fi
						latest_tar=$(ls -t /home/*.tar.gz | head -1)
						if [ -n "$latest_tar" ]; then
						  ssh-keygen -f "/root/.ssh/known_hosts" -R "$remote_ip"
						  sleep 2  # 添加等待时间
						  scp -o StrictHostKeyChecking=no "$latest_tar" "root@$remote_ip:/home/"
						  echo "文件已传送至远程服务器home目录。"
						else
						  echo "未找到要传送的文件。"
						fi
						break
						;;
					  [Nn])
						break
						;;
					  *)
						echo "无效的选择，请输入 Y 或 N。"
						;;
					esac
					done
					;;

				33)
					clear
					read -p "输入远程服务器IP: " useip
					read -p "输入远程服务器密码: " usepasswd

					wget -O ${useip}_beifen.sh https://raw.githubusercontent.com/kejilion/sh/main/beifen.sh > /dev/null 2>&1
					chmod +x ${useip}_beifen.sh

					sed -i "s/0.0.0.0/$useip/g" ${useip}_beifen.sh
					sed -i "s/123456/$usepasswd/g" ${useip}_beifen.sh

					echo "------------------------"
					echo "1. 每周备份                 2. 每天备份"
					read -p "请输入你的选择: " dingshi

					case $dingshi in
					  1)
						  read -p "选择每周备份的星期几 (0-6，0代表星期日): " weekday
						  (crontab -l ; echo "0 0 * * $weekday ./${useip}_beifen.sh") | crontab - > /dev/null 2>&1
						  ;;
					  2)
						  read -p "选择每天备份的时间（小时，0-23）: " hour
						  (crontab -l ; echo "0 $hour * * * ./${useip}_beifen.sh") | crontab - > /dev/null 2>&1
						  ;;
					  *)
						  break  # 跳出
						  ;;
					esac

					if ! command -v sshpass &>/dev/null; then
					  if command -v apt &>/dev/null; then
						  apt update -y && apt install -y sshpass
					  elif command -v yum &>/dev/null; then
						  yum -y update && yum -y install sshpass
					  else
						  echo "未知的包管理器!"
					  fi
					else
					  echo "sshpass 已经安装，跳过安装步骤。"
					fi

					;;

				34)
					clear
					cd /home/ && ls -t /home/*.tar.gz | head -1 | xargs -I {} tar -xzf {}

					# 更新并安装必要的软件包
					if command -v apt &>/dev/null; then
					  DEBIAN_FRONTEND=noninteractive apt update -y
					  DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
					  apt install -y curl wget sudo socat unzip tar htop
					elif command -v yum &>/dev/null; then
					  yum -y update && yum -y install curl wget sudo socat unzip tar htop
					else
					  echo "未知的包管理器!"
					fi

					# 检查并安装 Docker（如果需要）
					if ! command -v docker &>/dev/null; then
					  curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
					  systemctl start docker
					  systemctl enable docker
					else
					  echo "Docker 已经安装"
					fi

					cd /home/web && docker-compose up -d

					clear
					echo "正在配置LDNMP环境，请耐心稍等……"

					# 定义要执行的命令
					commands=(
					  "docker exec php apt update > /dev/null 2>&1"
					  "docker exec php apt install -y libmariadb-dev-compat libmariadb-dev libzip-dev libmagickwand-dev imagemagick > /dev/null 2>&1"
					  "docker exec php docker-php-ext-install mysqli pdo_mysql zip exif gd intl bcmath opcache > /dev/null 2>&1"
					  "docker exec php pecl install imagick > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"extension=imagick.so\" > /usr/local/etc/php/conf.d/imagick.ini' > /dev/null 2>&1"
					  "docker exec php pecl install redis > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"extension=redis.so\" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

					  "docker exec php74 apt update > /dev/null 2>&1"
					  "docker exec php74 apt install -y libmariadb-dev-compat libmariadb-dev libzip-dev libmagickwand-dev imagemagick > /dev/null 2>&1"
					  "docker exec php74 docker-php-ext-install mysqli pdo_mysql zip gd intl bcmath opcache > /dev/null 2>&1"
					  "docker exec php74 pecl install imagick > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"extension=imagick.so\" > /usr/local/etc/php/conf.d/imagick.ini' > /dev/null 2>&1"
					  "docker exec php74 pecl install redis > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"extension=redis.so\" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

					  "docker exec nginx chmod -R 777 /var/www/html > /dev/null 2>&1"
					  "docker exec php chmod -R 777 /var/www/html > /dev/null 2>&1"
					  "docker exec php74 chmod -R 777 /var/www/html > /dev/null 2>&1"

					  "docker restart php > /dev/null 2>&1"
					  "docker restart php74 > /dev/null 2>&1"
					  "docker restart nginx > /dev/null 2>&1"

					)

					total_commands=${#commands[@]}  # 计算总命令数

					for ((i = 0; i < total_commands; i++)); do
					  command="${commands[i]}"
					  eval $command  # 执行命令

					  # 打印百分比和进度条
					  percentage=$(( (i + 1) * 100 / total_commands ))
					  completed=$(( percentage / 2 ))
					  remaining=$(( 50 - completed ))
					  progressBar="["
					  for ((j = 0; j < completed; j++)); do
						  progressBar+="#"
					  done
					  for ((j = 0; j < remaining; j++)); do
						  progressBar+="."
					  done
					  progressBar+="]"
					  echo -ne "\r[$percentage%] $progressBar"
					done

					echo  # 打印换行，以便输出不被覆盖



					clear
					echo "LDNMP环境安装完毕"
					echo "------------------------"

					# 获取nginx版本
					nginx_version=$(docker exec nginx nginx -v 2>&1)
					nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
					echo -n "nginx : v$nginx_version"

					# 获取mysql版本
					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					mysql_version=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
					echo -n "            mysql : v$mysql_version"

					# 获取php版本
					php_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
					echo -n "            php : v$php_version"

					# 获取redis版本
					redis_version=$(docker exec redis redis-server -v 2>&1 | grep -oP "v=+\K[0-9]+\.[0-9]+")
					echo "            redis : v$redis_version"

					echo "------------------------"
					echo ""


					;;

				35)
					if [ -x "$(command -v fail2ban-client)" ] && [ -d "/etc/fail2ban" ]; then
					  while true; do
						  clear
						  echo "服务器防御程序已启动"
						  echo "------------------------"
						  echo "1. 开启SSH防暴力破解              2. 关闭SSH防暴力破解"
						  echo "3. 开启网站保护                   4. 关闭网站保护"
						  echo "------------------------"
						  echo "5. 查看SSH拦截记录                6. 查看网站拦截记录"
						  echo "7. 查看防御规则列表               8. 查看日志实时监控"
						  echo "------------------------"
						  echo "9. 卸载防御程序"
						  echo "------------------------"
						  echo "0. 退出"
						  echo "------------------------"
						  read -p "请输入你的选择: " sub_choice
						  case $sub_choice in
							  1)
								  sed -i 's/false/true/g' /etc/fail2ban/jail.d/sshd.local
								  systemctl restart fail2ban
								  sleep 1
								  fail2ban-client status
								  ;;
							  2)
								  sed -i 's/true/false/g' /etc/fail2ban/jail.d/sshd.local
								  systemctl restart fail2ban
								  sleep 1
								  fail2ban-client status
								  ;;
							  3)
								  sed -i 's/false/true/g' /etc/fail2ban/jail.d/nginx.local
								  systemctl restart fail2ban
								  sleep 1
								  fail2ban-client status
								  ;;
							  4)
								  sed -i 's/true/false/g' /etc/fail2ban/jail.d/nginx.local
								  systemctl restart fail2ban
								  sleep 1
								  fail2ban-client status
								  ;;
							  5)
								  echo "------------------------"
								  fail2ban-client status sshd
								  echo "------------------------"
								  ;;
							  6)
								  echo "------------------------"
								  fail2ban-client status nginx-bad-request
								  echo "------------------------"
								  fail2ban-client status nginx-botsearch
								  echo "------------------------"
								  fail2ban-client status nginx-http-auth
								  echo "------------------------"
								  fail2ban-client status nginx-limit-req
								  echo "------------------------"
								  fail2ban-client status php-url-fopen
								  echo "------------------------"
								  ;;

							  7)
								  fail2ban-client status
								  ;;
							  8)
								  tail -f /var/log/fail2ban.log

								  ;;
							  9)
								  systemctl disable fail2ban
								  systemctl stop fail2ban
								  apt remove -y --purge fail2ban
								  if [ $? -eq 0 ]; then
									  echo "Fail2ban已卸载"
								  else
									  echo "卸载失败"
								  fi
								  rm -rf /etc/fail2ban
								  break
								  ;;
							  0)
								  break
								  ;;
							  *)
								  echo "无效的选择，请重新输入。"
								  ;;
						  esac
						  echo -e "\033[0;32m操作完成\033[0m"
						  echo "按任意键继续..."
						  read -n 1 -s -r -p ""
						  echo ""
					  done
					else
					  clear
					  # 安装Fail2ban
					  if [ -f /etc/debian_version ]; then
						  # Debian/Ubuntu系统
						  apt update -y
						  apt install -y fail2ban
					  elif [ -f /etc/redhat-release ]; then
						  # CentOS系统
						  yum update -y
						  yum install -y epel-release
						  yum install -y fail2ban
					  else
						  echo "不支持的操作系统类型"
						  exit 1
					  fi

					  # 启动Fail2ban
					  systemctl start fail2ban

					  # 设置Fail2ban开机自启
					  systemctl enable fail2ban

					  # 配置Fail2ban
					  rm -rf /etc/fail2ban/jail.d/*
					  cd /etc/fail2ban/jail.d/
					  curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/sshd.local
					  systemctl restart fail2ban
					  docker rm -f nginx

					  wget -O /home/web/nginx.conf https://raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
					  wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default10.conf
					  localhostIP=$(curl -s ipv4.ip.sb)
					  sed -i "s/localhost/$localhostIP/g" /home/web/conf.d/default.conf

					  docker run -d --name nginx --restart always --network web_default -p 80:80 -p 443:443 -v /home/web/nginx.conf:/etc/nginx/nginx.conf -v /home/web/conf.d:/etc/nginx/conf.d -v /home/web/certs:/etc/nginx/certs -v /home/web/html:/var/www/html -v /home/web/log/nginx:/var/log/nginx nginx
					  docker exec -it nginx chmod -R 777 /var/www/html

					  # 获取宿主机当前时区
					  HOST_TIMEZONE=$(timedatectl show --property=Timezone --value)

					  # 调整多个容器的时区
					  docker exec -it nginx ln -sf "/usr/share/zoneinfo/$HOST_TIMEZONE" /etc/localtime
					  docker exec -it php ln -sf "/usr/share/zoneinfo/$HOST_TIMEZONE" /etc/localtime
					  docker exec -it php74 ln -sf "/usr/share/zoneinfo/$HOST_TIMEZONE" /etc/localtime
					  docker exec -it mysql ln -sf "/usr/share/zoneinfo/$HOST_TIMEZONE" /etc/localtime
					  docker exec -it redis ln -sf "/usr/share/zoneinfo/$HOST_TIMEZONE" /etc/localtime
					  rm -rf /home/web/log/nginx/*
					  docker restart nginx

					  curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/nginx.local
					  systemctl restart fail2ban
					  sleep 1
					  fail2ban-client status
					  echo "防御程序已开启"
					fi

					;;

				36)
					  while true; do
						  clear
						  echo "优化LDNMP环境"
						  echo "------------------------"
						  echo "1. 标准模式              2. 高性能模式 (推荐2H2G以上)"
						  echo "------------------------"
						  echo "0. 退出"
						  echo "------------------------"
						  read -p "请输入你的选择: " sub_choice
						  case $sub_choice in
							  1)
							  # nginx调优
							  sed -i 's/worker_connections.*/worker_connections 1024;/' /home/web/nginx.conf

							  # php调优
							  wget -O /home/www.conf https://raw.githubusercontent.com/kejilion/sh/main/www-1.conf
							  docker cp /home/www.conf php:/usr/local/etc/php-fpm.d/www.conf
							  docker cp /home/www.conf php74:/usr/local/etc/php-fpm.d/www.conf
							  rm -rf /home/www.conf

							  # mysql调优
							  wget -O /home/custom_mysql_config.cnf https://raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config-1.cnf
							  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
							  rm -rf /home/custom_mysql_config.cnf

							  docker restart nginx
							  docker restart php
							  docker restart php74
							  docker restart mysql

							  echo "LDNMP环境已设置成 标准模式"

								  ;;
							  2)

							  # nginx调优
							  sed -i 's/worker_connections.*/worker_connections 131072;/' /home/web/nginx.conf

							  # php调优
							  wget -O /home/www.conf https://raw.githubusercontent.com/kejilion/sh/main/www.conf
							  docker cp /home/www.conf php:/usr/local/etc/php-fpm.d/www.conf
							  docker cp /home/www.conf php74:/usr/local/etc/php-fpm.d/www.conf
							  rm -rf /home/www.conf

							  # mysql调优
							  wget -O /home/custom_mysql_config.cnf https://raw.githubusercontent.com/kejilion/sh/main/custom_mysql_config.cnf
							  docker cp /home/custom_mysql_config.cnf mysql:/etc/mysql/conf.d/
							  rm -rf /home/custom_mysql_config.cnf

							  docker restart nginx
							  docker restart php
							  docker restart php74
							  docker restart mysql

							  echo "LDNMP环境已设置成 高性能模式"

								  ;;
							  0)
								  break
								  ;;
							  *)
								  echo "无效的选择，请重新输入。"
								  ;;
						  esac
						  echo -e "\033[0;32m操作完成\033[0m"
						  echo "按任意键继续..."
						  read -n 1 -s -r -p ""
						  echo ""
					  done
					;;


				37)
					clear
					docker rm -f nginx php php74 mysql redis
					docker rmi nginx php:fpm php:7.4.33-fpm mysql redis

					# 更新并安装必要的软件包
					if command -v apt &>/dev/null; then
					  DEBIAN_FRONTEND=noninteractive apt update -y
					  DEBIAN_FRONTEND=noninteractive apt full-upgrade -y
					  apt install -y curl wget sudo socat unzip tar htop
					elif command -v yum &>/dev/null; then
					  yum -y update && yum -y install curl wget sudo socat unzip tar htop
					else
					  echo "未知的包管理器!"
					fi

					# 检查并安装 Docker（如果需要）
					if ! command -v docker &>/dev/null; then
					  curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
					  systemctl start docker
					  systemctl enable docker
					else
					  echo "Docker 已经安装"
					fi

					cd /home/web && docker-compose up -d

					clear
					echo "正在配置LDNMP环境，请耐心稍等……"

					# 定义要执行的命令
					commands=(
					  "docker exec php apt update > /dev/null 2>&1"
					  "docker exec php apt install -y libmariadb-dev-compat libmariadb-dev libzip-dev libmagickwand-dev imagemagick > /dev/null 2>&1"
					  "docker exec php docker-php-ext-install mysqli pdo_mysql zip exif gd intl bcmath opcache > /dev/null 2>&1"
					  "docker exec php pecl install imagick > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"extension=imagick.so\" > /usr/local/etc/php/conf.d/imagick.ini' > /dev/null 2>&1"
					  "docker exec php pecl install redis > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"extension=redis.so\" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
					  "docker exec php sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

					  "docker exec php74 apt update > /dev/null 2>&1"
					  "docker exec php74 apt install -y libmariadb-dev-compat libmariadb-dev libzip-dev libmagickwand-dev imagemagick > /dev/null 2>&1"
					  "docker exec php74 docker-php-ext-install mysqli pdo_mysql zip gd intl bcmath opcache > /dev/null 2>&1"
					  "docker exec php74 pecl install imagick > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"extension=imagick.so\" > /usr/local/etc/php/conf.d/imagick.ini' > /dev/null 2>&1"
					  "docker exec php74 pecl install redis > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"extension=redis.so\" > /usr/local/etc/php/conf.d/docker-php-ext-redis.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
					  "docker exec php74 sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

					  "docker exec nginx chmod -R 777 /var/www/html > /dev/null 2>&1"
					  "docker exec php chmod -R 777 /var/www/html > /dev/null 2>&1"
					  "docker exec php74 chmod -R 777 /var/www/html > /dev/null 2>&1"

					  "docker restart php > /dev/null 2>&1"
					  "docker restart php74 > /dev/null 2>&1"
					  "docker restart nginx > /dev/null 2>&1"

					)

					total_commands=${#commands[@]}  # 计算总命令数

					for ((i = 0; i < total_commands; i++)); do
					  command="${commands[i]}"
					  eval $command  # 执行命令

					  # 打印百分比和进度条
					  percentage=$(( (i + 1) * 100 / total_commands ))
					  completed=$(( percentage / 2 ))
					  remaining=$(( 50 - completed ))
					  progressBar="["
					  for ((j = 0; j < completed; j++)); do
						  progressBar+="#"
					  done
					  for ((j = 0; j < remaining; j++)); do
						  progressBar+="."
					  done
					  progressBar+="]"
					  echo -ne "\r[$percentage%] $progressBar"
					done

					echo  # 打印换行，以便输出不被覆盖

					docker exec nginx chmod -R 777 /var/www/html
					docker exec php chmod -R 777 /var/www/html
					docker exec php74 chmod -R 777 /var/www/html
					docker restart php
					docker restart php74
					docker restart nginx

					clear
					clear
					echo "LDNMP环境安装完毕"
					echo "------------------------"
					# 获取nginx版本
					nginx_version=$(docker exec nginx nginx -v 2>&1)
					nginx_version=$(echo "$nginx_version" | grep -oP "nginx/\K[0-9]+\.[0-9]+\.[0-9]+")
					echo -n "nginx : v$nginx_version"
					# 获取mysql版本
					dbrootpasswd=$(grep -oP 'MYSQL_ROOT_PASSWORD:\s*\K.*' /home/web/docker-compose.yml | tr -d '[:space:]')
					mysql_version=$(docker exec mysql mysql -u root -p"$dbrootpasswd" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
					echo -n "            mysql : v$mysql_version"
					# 获取php版本
					php_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
					echo -n "            php : v$php_version"
					# 获取redis版本
					redis_version=$(docker exec redis redis-server -v 2>&1 | grep -oP "v=+\K[0-9]+\.[0-9]+")
					echo "            redis : v$redis_version"
					echo "------------------------"
					echo ""

					;;



				38)
					clear
					read -p "强烈建议先备份全部网站数据，再卸载LDNMP环境。确定删除所有网站数据吗？(Y/N): " choice
					case "$choice" in
					  [Yy])
						docker rm -f nginx php php74 mysql redis
						docker rmi nginx php:fpm php:7.4.33-fpm mysql redis
						rm -r /home/web
						;;
					  [Nn])

						;;
					  *)
						echo "无效的选择，请输入 Y 或 N。"
						;;
					esac
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
				echo -e "\033[0;32m操作完成\033[0m"
				echo "按任意键继续..."
				read -n 1 -s -r -p ""
				echo ""
				clear
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
		exit 0 && exit 0 && exit 0 && exit 0 && exit 0 && exit 0
		;;
	*) 
		echo "0.0此地无银三百两 请输入正确的数字或指令哦~"
		;;
esac
	echo -e "\033[0;32m操作完成\033[0m"
	echo "按任意键返回主菜单..."
	read -n 1 -s -r -p ""
	echo ""
done
