#!/bin/bash

# IceCMS Pro Ubuntu 一键安装脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 在 Ubuntu 系统上一键安装 IceCMS Pro 的所有依赖和服务
# 支持: Ubuntu 18.04+

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 配置
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BACKEND_DIR="$PROJECT_ROOT/IceCMS-main"
ADMIN_DIR="$PROJECT_ROOT/IceCMS-front-admin"
FRONTEND_DIR="$PROJECT_ROOT/IceCMS-front-nuxt3"

# 默认配置（强密码）
MYSQL_ROOT_PASSWORD="IceCMS@2024#Root"
MYSQL_DB_NAME="icecmspro"
MYSQL_DB_USER="icecmspro"
MYSQL_DB_PASSWORD="IceCMS@2024#User"

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

# 检查是否为 root 用户
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "检测到 root 用户，建议使用普通用户运行此脚本"
        read -p "是否继续？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# 检测系统版本
check_system() {
    log_step "检测系统环境..."
    
    if [[ ! -f /etc/os-release ]]; then
        log_error "无法检测系统版本"
        exit 1
    fi
    
    . /etc/os-release
    
    if [[ "$ID" != "ubuntu" ]]; then
        log_error "此脚本仅支持 Ubuntu 系统，当前系统: $ID"
        exit 1
    fi
    
    log_success "系统检测通过: Ubuntu $VERSION"
}

# 更新系统包
update_system() {
    log_step "更新系统包..."
    
    sudo apt update
    sudo apt upgrade -y
    
    # 安装基础工具
    sudo apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release
    
    log_success "系统包更新完成"
}

# 安装 Java 11
install_java() {
    log_step "安装 Java 11..."
    
    if command_exists java; then
        JAVA_VERSION=$(java -version 2>&1 | head -n1 | awk -F '"' '{print $2}')
        log_info "检测到已安装 Java: $JAVA_VERSION"
        
        # 检查是否为 Java 11
        if [[ "$JAVA_VERSION" =~ ^11\. ]]; then
            log_success "Java 11 已安装"
            return 0
        else
            log_warning "当前 Java 版本不是 11，将安装 Java 11"
        fi
    fi
    
    sudo apt install -y openjdk-11-jdk
    
    # 设置 JAVA_HOME
    echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
    
    export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    export PATH=$JAVA_HOME/bin:$PATH
    
    log_success "Java 11 安装完成"
}

# 安装 Maven
install_maven() {
    log_step "安装 Maven..."
    
    if command_exists mvn; then
        log_success "Maven 已安装"
        return 0
    fi
    
    sudo apt install -y maven
    
    log_success "Maven 安装完成"
}

# 安装 Node.js 和 pnpm
install_nodejs() {
    log_step "安装 Node.js 和 pnpm..."
    
    # 安装 Node.js 18.x
    if ! command_exists node; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
    else
        NODE_VERSION=$(node -v | sed 's/v//')
        log_info "检测到已安装 Node.js: $NODE_VERSION"
    fi
    
    # 安装 pnpm
    if ! command_exists pnpm; then
        curl -fsSL https://get.pnpm.io/install.sh | sh -
        
        # 添加 pnpm 到 PATH
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.bashrc
        echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.bashrc
        
        # 重新加载环境变量
        source ~/.bashrc
    else
        log_success "pnpm 已安装"
    fi
    
    log_success "Node.js 和 pnpm 安装完成"
}

# 安装 MySQL
install_mysql() {
    log_step "安装 MySQL..."

    if command_exists mysql; then
        log_success "MySQL 已安装"
        return 0
    fi

    # 预配置 MySQL root 密码
    log_info "预配置 MySQL root 密码..."
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"

    # 安装 MySQL
    sudo apt install -y mysql-server

    # 启动 MySQL 服务
    sudo systemctl start mysql
    sudo systemctl enable mysql

    # 等待 MySQL 启动
    sleep 5

    # 自动配置数据库
    log_info "配置数据库和用户..."
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$MYSQL_DB_USER'@'localhost' IDENTIFIED BY '$MYSQL_DB_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

    # 导入数据库结构
    if [[ -f "$PROJECT_ROOT/sql/icecms8.0.sql" ]]; then
        log_info "导入数据库结构..."
        mysql -u "$MYSQL_DB_USER" -p"$MYSQL_DB_PASSWORD" "$MYSQL_DB_NAME" < "$PROJECT_ROOT/sql/icecms8.0.sql"
        log_success "数据库结构导入完成"
    else
        log_warning "数据库 SQL 文件不存在，请手动导入"
    fi

    log_success "MySQL 安装和配置完成"
    log_info "数据库信息："
    log_info "  - 数据库名: $MYSQL_DB_NAME"
    log_info "  - 用户名: $MYSQL_DB_USER"
    log_info "  - 密码: $MYSQL_DB_PASSWORD"
}

# 安装 Redis
install_redis() {
    log_step "安装 Redis..."
    
    if command_exists redis-server; then
        log_success "Redis 已安装"
        return 0
    fi
    
    sudo apt install -y redis-server
    
    # 启动 Redis 服务
    sudo systemctl start redis-server
    sudo systemctl enable redis-server
    
    log_success "Redis 安装完成"
}

# 配置后端数据库连接
configure_backend() {
    log_step "配置后端数据库连接..."

    if [[ -d "$BACKEND_DIR" ]]; then
        local config_file="$BACKEND_DIR/src/main/resources/application.yml"

        if [[ -f "$config_file" ]]; then
            log_info "更新数据库配置..."

            # 备份原配置文件
            cp "$config_file" "$config_file.backup"

            # 更新数据库配置
            sed -i "s|url:.*|url: jdbc:mysql://localhost:3306/$MYSQL_DB_NAME?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai|g" "$config_file"
            sed -i "s|username:.*|username: $MYSQL_DB_USER|g" "$config_file"
            sed -i "s|password:.*|password: $MYSQL_DB_PASSWORD|g" "$config_file"

            log_success "后端数据库配置更新完成"
        else
            log_warning "后端配置文件不存在: $config_file"
        fi
    else
        log_warning "后端目录不存在: $BACKEND_DIR"
    fi
}

# 安装项目依赖
install_project_dependencies() {
    log_step "安装项目依赖..."

    # 配置后端数据库连接
    configure_backend

    # 后端依赖
    if [[ -d "$BACKEND_DIR" ]]; then
        log_info "编译后端项目..."
        cd "$BACKEND_DIR"
        mvn clean package -DskipTests
        cd "$PROJECT_ROOT"
        log_success "后端项目编译完成"
    else
        log_warning "后端目录不存在: $BACKEND_DIR"
    fi
    
    # 前端依赖
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    
    if [[ -d "$ADMIN_DIR" ]]; then
        log_info "安装管理后台依赖..."
        cd "$ADMIN_DIR"
        pnpm install
        cd "$PROJECT_ROOT"
        log_success "管理后台依赖安装完成"
    else
        log_warning "管理后台目录不存在: $ADMIN_DIR"
    fi
    
    if [[ -d "$FRONTEND_DIR" ]]; then
        log_info "安装用户前台依赖..."
        cd "$FRONTEND_DIR"
        pnpm install
        cd "$PROJECT_ROOT"
        log_success "用户前台依赖安装完成"
    else
        log_warning "用户前台目录不存在: $FRONTEND_DIR"
    fi
}

# 创建启动脚本
create_startup_scripts() {
    log_step "创建 Ubuntu 启动脚本..."
    
    # 创建 systemd 服务文件目录
    mkdir -p "$PROJECT_ROOT/scripts/systemd"
    
    log_success "Ubuntu 启动脚本创建完成"
}

# 显示安装结果
show_result() {
    echo
    echo "=================================================="
    echo "         IceCMS Pro Ubuntu 安装完成"
    echo "=================================================="
    echo
    echo -e "${GREEN}✓${NC} Java 11: $(java -version 2>&1 | head -n1)"
    echo -e "${GREEN}✓${NC} Maven: $(mvn -version 2>&1 | head -n1)"
    echo -e "${GREEN}✓${NC} Node.js: $(node -v)"
    echo -e "${GREEN}✓${NC} pnpm: $(pnpm -v)"
    echo -e "${GREEN}✓${NC} MySQL: 已安装并启动"
    echo -e "${GREEN}✓${NC} Redis: 已安装并启动"
    echo
    echo "🔐 数据库配置信息："
    echo "  - MySQL Root 密码: $MYSQL_ROOT_PASSWORD"
    echo "  - 数据库名: $MYSQL_DB_NAME"
    echo "  - 数据库用户: $MYSQL_DB_USER"
    echo "  - 数据库密码: $MYSQL_DB_PASSWORD"
    echo
    echo "🚀 下一步操作："
    echo "1. 启动服务: ./scripts/ubuntu-start.sh"
    echo "2. 查看状态: ./scripts/status.sh"
    echo "3. 访问地址:"
    echo "   - 管理后台: http://localhost:2580 (admin/admin123)"
    echo "   - 用户前台: http://localhost:3000"
    echo "   - API文档: http://localhost:8181/doc.html"
    echo
    echo "📝 重要提示："
    echo "- 请妥善保存上述数据库密码信息"
    echo "- 生产环境请修改默认管理员密码"
    echo "=================================================="
}

# 主函数
main() {
    echo "=================================================="
    echo "       IceCMS Pro Ubuntu 一键安装脚本"
    echo "=================================================="
    echo
    
    check_root
    check_system
    update_system
    install_java
    install_maven
    install_nodejs
    install_mysql
    install_redis
    install_project_dependencies
    create_startup_scripts
    show_result
    
    log_success "安装完成！"
}

# 执行主函数
main "$@"
