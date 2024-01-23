#!/bin/bash
check_port() {
    # 定义要检测的端口
    PORT=443

    # 检查端口占用情况
    result=$(ss -tulpn | grep ":$PORT")

    # 判断结果并输出相应信息
    if [ -n "$result" ]; then
        is_nginx_container=$(docker ps --format '{{.Names}}' | grep 'nginx')

        # 判断是否是Nginx容器占用端口
        if [ -n "$is_nginx_container" ]; then
            echo ""
        else
            clear
            echo -e "\e[1;31m端口 $PORT 已被占用，无法安装环境，卸载以下程序后重试！\e[0m"
            echo "$result"
            break_end
            kejilion

        fi
    else
        echo ""
    fi
}

install_dependency() {
      clear
      install wget socat unzip tar
}

# 定义安装 Docker 的函数
install_docker() {
    if ! command -v docker &>/dev/null; then
        curl -fsSL https://get.docker.com | sh && ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin
        systemctl start docker
        systemctl enable docker
    else
        echo "Docker 已经安装"
    fi
}

install_certbot() {
    install certbot

    # 切换到一个一致的目录（例如，家目录）
    cd ~ || exit

    # 下载并使脚本可执行
    curl -O https://raw.githubusercontent.com/kejilion/sh/main/auto_cert_renewal.sh
    chmod +x auto_cert_renewal.sh

    # 设置定时任务字符串
    cron_job="0 0 * * * ~/auto_cert_renewal.sh"

    # 检查是否存在相同的定时任务
    existing_cron=$(crontab -l 2>/dev/null | grep -F "$cron_job")

    # 如果不存在，则添加定时任务
    if [ -z "$existing_cron" ]; then
        (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
        echo "续签任务已添加"
    else
        echo "续签任务已存在，无需添加"
    fi
}

install_ldnmp() {
      cd /home/web && docker-compose up -d
      clear
      echo "正在配置LDNMP环境，请耐心稍等……"

      # 定义要执行的命令
      commands=(
          "docker exec nginx chmod -R 777 /var/www/html"
          "docker restart nginx > /dev/null 2>&1"

          "docker exec php apt update > /dev/null 2>&1"
          "docker exec php74 apt update > /dev/null 2>&1"

          # php安装包管理
          "curl -sL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions > /dev/null 2>&1"
          "docker exec php mkdir -p /usr/local/bin/ > /dev/null 2>&1"
          "docker exec php74 mkdir -p /usr/local/bin/ > /dev/null 2>&1"
          "docker cp /usr/local/bin/install-php-extensions php:/usr/local/bin/ > /dev/null 2>&1"
          "docker cp /usr/local/bin/install-php-extensions php74:/usr/local/bin/ > /dev/null 2>&1"
          "docker exec php chmod +x /usr/local/bin/install-php-extensions > /dev/null 2>&1"
          "docker exec php74 chmod +x /usr/local/bin/install-php-extensions > /dev/null 2>&1"

          # php安装扩展
          "docker exec php install-php-extensions mysqli > /dev/null 2>&1"
          "docker exec php install-php-extensions pdo_mysql > /dev/null 2>&1"
          "docker exec php install-php-extensions gd intl zip > /dev/null 2>&1"
          "docker exec php install-php-extensions exif > /dev/null 2>&1"
          "docker exec php install-php-extensions bcmath > /dev/null 2>&1"
          "docker exec php install-php-extensions opcache > /dev/null 2>&1"
          "docker exec php install-php-extensions imagick redis > /dev/null 2>&1"

          # php配置参数
          "docker exec php sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
          "docker exec php sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
          "docker exec php sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
          "docker exec php sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

          # php重启
          "docker exec php chmod -R 777 /var/www/html"
          "docker restart php > /dev/null 2>&1"

          # php7.4安装扩展
          "docker exec php74 install-php-extensions mysqli > /dev/null 2>&1"
          "docker exec php74 install-php-extensions pdo_mysql > /dev/null 2>&1"
          "docker exec php74 install-php-extensions gd intl zip > /dev/null 2>&1"
          "docker exec php74 install-php-extensions exif > /dev/null 2>&1"
          "docker exec php74 install-php-extensions bcmath > /dev/null 2>&1"
          "docker exec php74 install-php-extensions opcache > /dev/null 2>&1"
          "docker exec php74 install-php-extensions imagick redis > /dev/null 2>&1"

          # php7.4配置参数
          "docker exec php74 sh -c 'echo \"upload_max_filesize=50M \\n post_max_size=50M\" > /usr/local/etc/php/conf.d/uploads.ini' > /dev/null 2>&1"
          "docker exec php74 sh -c 'echo \"memory_limit=256M\" > /usr/local/etc/php/conf.d/memory.ini' > /dev/null 2>&1"
          "docker exec php74 sh -c 'echo \"max_execution_time=1200\" > /usr/local/etc/php/conf.d/max_execution_time.ini' > /dev/null 2>&1"
          "docker exec php74 sh -c 'echo \"max_input_time=600\" > /usr/local/etc/php/conf.d/max_input_time.ini' > /dev/null 2>&1"

          # php7.4重启
          "docker exec php74 chmod -R 777 /var/www/html"
          "docker restart php74 > /dev/null 2>&1"
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


}
  while true; do
    clear
    echo  "1. 安装LDNMP环境"
    echo  "------------------------"
    echo  "0. 返回主菜单"
    echo  "------------------------"
    read -p "请输入你的选择: " sub_choice


    case $sub_choice in
      1)
      check_port
      install_dependency
      install_docker
      install_certbot

      # 创建必要的目录和文件
      cd /home && mkdir -p web/html web/mysql web/certs web/conf.d web/redis web/log/nginx && touch web/docker-compose.yml

      wget -O /home/web/nginx.conf https://raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
      wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/kejilion/nginx/main/default10.conf
      default_server_ssl

      # 下载 docker-compose.yml 文件并进行替换
      wget -O /home/web/docker-compose.yml https://raw.githubusercontent.com/kejilion/docker/main/LNMP-docker-compose-10.yml

      dbrootpasswd=$(openssl rand -base64 16) && dbuse=$(openssl rand -hex 4) && dbusepasswd=$(openssl rand -base64 8)

      # 在 docker-compose.yml 文件中进行替换
      sed -i "s/webroot/$dbrootpasswd/g" /home/web/docker-compose.yml
      sed -i "s/kejilionYYDS/$dbusepasswd/g" /home/web/docker-compose.yml
      sed -i "s/kejilion/$dbuse/g" /home/web/docker-compose.yml

      install_ldnmp

        ;;
      0)
      cd ~
      ./7.sh
      exit
      ;;
