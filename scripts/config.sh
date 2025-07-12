#!/bin/bash

# IceCMS Pro 配置文件
# 包含默认的强密码和配置信息

# 数据库配置（强密码）
export MYSQL_ROOT_PASSWORD="IceCMS@2024#Root"
export MYSQL_DB_NAME="icecmspro"
export MYSQL_DB_USER="icecmspro"
export MYSQL_DB_PASSWORD="IceCMS@2024#User"

# 应用配置
export BACKEND_PORT=8181
export ADMIN_PORT=2580
export FRONTEND_PORT=3000

# 默认管理员账号
export ADMIN_USERNAME="admin"
export ADMIN_PASSWORD="admin123"

# 项目路径
export PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
export BACKEND_DIR="$PROJECT_ROOT/IceCMS-main"
export ADMIN_DIR="$PROJECT_ROOT/IceCMS-front-admin"
export FRONTEND_DIR="$PROJECT_ROOT/IceCMS-front-nuxt3"

# PID 和日志目录
export PID_DIR="$PROJECT_ROOT/scripts/pids"
export LOG_DIR="$PROJECT_ROOT/logs"

# 颜色定义
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 显示配置信息
show_config() {
    echo "=================================================="
    echo "         IceCMS Pro 配置信息"
    echo "=================================================="
    echo
    echo "🔐 数据库配置："
    echo "  - MySQL Root 密码: $MYSQL_ROOT_PASSWORD"
    echo "  - 数据库名: $MYSQL_DB_NAME"
    echo "  - 数据库用户: $MYSQL_DB_USER"
    echo "  - 数据库密码: $MYSQL_DB_PASSWORD"
    echo
    echo "🌐 服务端口："
    echo "  - 后端服务: $BACKEND_PORT"
    echo "  - 管理后台: $ADMIN_PORT"
    echo "  - 用户前台: $FRONTEND_PORT"
    echo
    echo "👤 默认管理员："
    echo "  - 用户名: $ADMIN_USERNAME"
    echo "  - 密码: $ADMIN_PASSWORD"
    echo
    echo "📁 项目路径："
    echo "  - 项目根目录: $PROJECT_ROOT"
    echo "  - 后端目录: $BACKEND_DIR"
    echo "  - 管理后台目录: $ADMIN_DIR"
    echo "  - 用户前台目录: $FRONTEND_DIR"
    echo "=================================================="
}

# 如果直接运行此脚本，显示配置信息
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    show_config
fi
