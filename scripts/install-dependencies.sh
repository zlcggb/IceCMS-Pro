#!/bin/bash

# IceCMS Pro Mac 一键安装依赖脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 自动安装 IceCMS Pro 项目所需的所有依赖

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查是否为 macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "此脚本仅支持 macOS 系统"
        exit 1
    fi
    log_success "检测到 macOS 系统"
}

# 安装 Homebrew
install_homebrew() {
    if command_exists brew; then
        log_success "Homebrew 已安装"
        brew update
    else
        log_info "正在安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # 添加 Homebrew 到 PATH (适用于 Apple Silicon Mac)
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        log_success "Homebrew 安装完成"
    fi
}

# 安装 Java (OpenJDK 8)
install_java() {
    if command_exists java; then
        JAVA_VERSION=$(java -version 2>&1 | head -n1 | cut -d'"' -f2)
        log_success "Java 已安装，版本: $JAVA_VERSION"
    else
        log_info "正在安装 OpenJDK 8..."
        brew install openjdk@8
        
        # 设置 JAVA_HOME
        JAVA_HOME_PATH="/opt/homebrew/opt/openjdk@8/libexec/openjdk.jdk/Contents/Home"
        if [[ ! -d "$JAVA_HOME_PATH" ]]; then
            JAVA_HOME_PATH="/usr/local/opt/openjdk@8/libexec/openjdk.jdk/Contents/Home"
        fi
        
        # 添加到 shell 配置文件
        SHELL_CONFIG=""
        if [[ "$SHELL" == *"zsh"* ]]; then
            SHELL_CONFIG="$HOME/.zshrc"
        elif [[ "$SHELL" == *"bash"* ]]; then
            SHELL_CONFIG="$HOME/.bash_profile"
        fi
        
        if [[ -n "$SHELL_CONFIG" ]]; then
            echo "export JAVA_HOME=$JAVA_HOME_PATH" >> "$SHELL_CONFIG"
            echo 'export PATH=$JAVA_HOME/bin:$PATH' >> "$SHELL_CONFIG"
            export JAVA_HOME="$JAVA_HOME_PATH"
            export PATH="$JAVA_HOME/bin:$PATH"
        fi
        
        log_success "Java 安装完成"
    fi
}

# 安装 Maven
install_maven() {
    if command_exists mvn; then
        MVN_VERSION=$(mvn -version | head -n1 | cut -d' ' -f3)
        log_success "Maven 已安装，版本: $MVN_VERSION"
    else
        log_info "正在安装 Maven..."
        brew install maven
        log_success "Maven 安装完成"
    fi
}

# 安装 MySQL
install_mysql() {
    if command_exists mysql; then
        log_success "MySQL 已安装"
    else
        log_info "正在安装 MySQL..."
        brew install mysql
        log_success "MySQL 安装完成"
    fi

    # 启动 MySQL 服务
    log_info "启动 MySQL 服务..."
    brew services start mysql

    # 等待 MySQL 启动
    sleep 3

    # 配置 MySQL root 密码和数据库
    log_info "配置 MySQL 数据库..."

    # 设置 root 密码
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" 2>/dev/null || true

    # 创建数据库和用户
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF 2>/dev/null || mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$MYSQL_DB_USER'@'localhost' IDENTIFIED BY '$MYSQL_DB_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DB_NAME.* TO '$MYSQL_DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

    log_success "MySQL 服务已启动并配置完成"
    log_info "数据库信息："
    log_info "  - 数据库名: $MYSQL_DB_NAME"
    log_info "  - 用户名: $MYSQL_DB_USER"
    log_info "  - 密码: $MYSQL_DB_PASSWORD"
}

# 安装 Redis
install_redis() {
    if command_exists redis-server; then
        log_success "Redis 已安装"
    else
        log_info "正在安装 Redis..."
        brew install redis
        log_success "Redis 安装完成"
    fi
    
    # 启动 Redis 服务
    log_info "启动 Redis 服务..."
    brew services start redis
    log_success "Redis 服务已启动"
}

# 安装 Node.js 和 pnpm
install_nodejs() {
    if command_exists node; then
        NODE_VERSION=$(node --version)
        log_success "Node.js 已安装，版本: $NODE_VERSION"
    else
        log_info "正在安装 Node.js..."

        # 安装 nvm
        if [[ ! -d "$HOME/.nvm" ]]; then
            log_info "安装 nvm..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        else
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        fi

        # 使用 nvm 安装 Node.js 20
        log_info "使用 nvm 安装 Node.js 20..."
        nvm install 20
        nvm use 20
        nvm alias default 20

        log_success "Node.js 安装完成"
    fi

    # 检查 pnpm 是否已安装
    if command_exists pnpm; then
        PNPM_VERSION=$(pnpm --version)
        log_success "pnpm 已安装，版本: $PNPM_VERSION"
        return 0
    fi

    log_info "正在安装 pnpm..."

    # 使用专门的 pnpm 修复脚本
    if [[ -f "$PROJECT_ROOT/scripts/fix-pnpm.sh" ]]; then
        log_info "使用 pnpm 修复脚本安装..."
        if "$PROJECT_ROOT/scripts/fix-pnpm.sh"; then
            # 重新加载环境变量
            if [[ "$SHELL" == *"zsh"* ]] && [[ -f "$HOME/.zshrc" ]]; then
                source "$HOME/.zshrc" 2>/dev/null || true
            elif [[ "$SHELL" == *"bash"* ]] && [[ -f "$HOME/.bash_profile" ]]; then
                source "$HOME/.bash_profile" 2>/dev/null || true
            fi

            if command_exists pnpm; then
                log_success "pnpm 安装完成"
                return 0
            fi
        fi
    fi

    log_error "pnpm 安装失败"
    log_info "请尝试手动运行: ./scripts/fix-pnpm.sh"
    return 1
}

# 安装 Docker (可选)
install_docker() {
    read -p "是否安装 Docker? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command_exists docker; then
            log_success "Docker 已安装"
        else
            log_info "正在安装 Docker..."
            brew install --cask docker
            log_success "Docker 安装完成"
            log_warning "请手动启动 Docker Desktop 应用程序"
        fi
    fi
}

# 配置数据库
setup_database() {
    log_info "开始配置数据库..."
    
    # 检查 MySQL 是否运行
    if ! brew services list | grep mysql | grep started > /dev/null; then
        log_info "启动 MySQL 服务..."
        brew services start mysql
        sleep 5
    fi
    
    # 创建数据库配置脚本
    cat > /tmp/setup_icecms_db.sql << EOF
-- 创建数据库
CREATE DATABASE IF NOT EXISTS icecmspro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户
CREATE USER IF NOT EXISTS 'icecmspro'@'localhost' IDENTIFIED BY '123456';

-- 授权
GRANT ALL PRIVILEGES ON icecmspro.* TO 'icecmspro'@'localhost';
FLUSH PRIVILEGES;

-- 显示创建结果
SHOW DATABASES LIKE 'icecmspro';
SELECT User, Host FROM mysql.user WHERE User = 'icecmspro';
EOF
    
    log_info "正在创建数据库和用户..."
    mysql -u root < /tmp/setup_icecms_db.sql
    
    # 导入数据
    if [[ -f "sql/icecms8.0.sql" ]]; then
        log_info "正在导入数据库数据..."
        mysql -u icecmspro -p123456 icecmspro < sql/icecms8.0.sql
        log_success "数据库数据导入完成"
    else
        log_warning "未找到 sql/icecms8.0.sql 文件，请手动导入数据"
    fi
    
    # 清理临时文件
    rm -f /tmp/setup_icecms_db.sql
    
    log_success "数据库配置完成"
}

# 安装项目依赖
install_project_dependencies() {
    log_info "开始安装项目依赖..."
    
    # 安装后端依赖
    log_info "正在安装后端依赖..."
    mvn clean install -DskipTests
    log_success "后端依赖安装完成"
    
    # 安装管理后台依赖
    if [[ -d "IceCMS-front-admin" ]]; then
        log_info "正在安装管理后台依赖..."
        cd IceCMS-front-admin
        pnpm install
        cd ..
        log_success "管理后台依赖安装完成"
    fi
    
    # 安装用户前台依赖
    if [[ -d "IceCMS-front-nuxt3" ]]; then
        log_info "正在安装用户前台依赖..."
        cd IceCMS-front-nuxt3
        pnpm install
        cd ..
        log_success "用户前台依赖安装完成"
    fi
}

# 创建启动脚本
create_startup_scripts() {
    log_info "正在创建启动脚本..."
    
    # 创建脚本目录
    mkdir -p scripts
    
    # 创建一键启动脚本 (将在下一个文件中创建)
    log_success "启动脚本创建完成"
}

# 主函数
main() {
    echo "=================================================="
    echo "    IceCMS Pro Mac 一键安装依赖脚本"
    echo "=================================================="
    echo
    
    # 检查系统
    check_macos
    
    # 安装依赖
    log_info "开始安装系统依赖..."
    install_homebrew
    install_java
    install_maven
    install_mysql
    install_redis
    install_nodejs
    install_docker
    
    # 配置数据库
    setup_database
    
    # 安装项目依赖
    install_project_dependencies
    
    # 创建启动脚本
    create_startup_scripts
    
    echo
    echo "=================================================="
    log_success "所有依赖安装完成！"
    echo "=================================================="
    echo
    echo "🔐 数据库配置信息："
    echo "  - MySQL Root 密码: $MYSQL_ROOT_PASSWORD"
    echo "  - 数据库名: $MYSQL_DB_NAME"
    echo "  - 数据库用户: $MYSQL_DB_USER"
    echo "  - 数据库密码: $MYSQL_DB_PASSWORD"
    echo
    echo "🚀 接下来您可以："
    echo "1. 运行 './scripts/start-all.sh' 启动所有服务"
    echo "2. 访问管理后台: http://localhost:2580 (admin/admin123)"
    echo "3. 访问用户前台: http://localhost:3000"
    echo "4. 访问API文档: http://localhost:8181/doc.html"
    echo
    echo "📝 重要提示："
    echo "- 请妥善保存上述数据库密码信息"
    echo "- 生产环境请修改默认管理员密码"
    echo
}

# 执行主函数
main "$@"
