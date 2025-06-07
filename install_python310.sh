#!/bin/bash

#chmod +x install_python310.sh && ./install_python310.sh

set -e

echo "🛠️ 正在安装 Python 3.10，请稍候..."

# 安装构建依赖
apt update && apt install -y \
  wget build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl \
  libncursesw5-dev xz-utils tk-dev libxml2-dev \
  libxmlsec1-dev libffi-dev liblzma-dev git make gcc

# 安装 pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  echo "📦 安装 pyenv..."
  curl https://pyenv.run | bash
fi

# 设置 pyenv 环境变量（适用于 root 或当前用户）
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# 安装并设置 Python 3.10.14
if ! pyenv versions | grep -q "3.10.14"; then
  echo "📥 安装 Python 3.10.14..."
  pyenv install 3.10.14
fi

pyenv global 3.10.14

# 写入 ~/.bashrc
echo "🔧 正在将 pyenv 初始化配置写入 ~/.bashrc ..."
grep -qxF 'export PATH="$HOME/.pyenv/bin:$PATH"' ~/.bashrc || echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
grep -qxF 'eval "$(pyenv init -)"' ~/.bashrc || echo 'eval "$(pyenv init -)"' >> ~/.bashrc
grep -qxF 'eval "$(pyenv virtualenv-init -)"' ~/.bashrc || echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

# 验证
echo "✅ Python 版本：$(python3 --version)"
echo "✅ pip 版本：$(pip3 --version)"

echo -e "\n🎉 Python 3.10 安装完成，pyenv 配置已自动写入 ~/.bashrc。"
echo "请运行以下命令使其立即生效："
echo "  source ~/.bashrc"
