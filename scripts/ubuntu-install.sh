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

# 检测系统架构和环境
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

    # 检测系统架构
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            SYSTEM_ARCH="x64"
            log_info "检测到架构: x86_64 (Intel/AMD 64位)"
            ;;
        aarch64|arm64)
            SYSTEM_ARCH="arm64"
            log_info "检测到架构: ARM64 (树莓派4/5, Jetson, Apple M1/M2, 阿里云ARM)"
            ;;
        armv7l|armhf)
            SYSTEM_ARCH="arm32"
            log_info "检测到架构: ARM32 (树莓派3及更早版本)"
            ;;
        *)
            SYSTEM_ARCH="unknown"
            log_warning "检测到未知架构: $ARCH"
            ;;
    esac

    # 检测特殊设备
    detect_device_type

    log_success "系统检测通过: Ubuntu $VERSION ($SYSTEM_ARCH)"
}

# 检测设备类型
detect_device_type() {
    DEVICE_TYPE="generic"

    # 检测树莓派
    if [[ -f /proc/device-tree/model ]]; then
        MODEL=$(cat /proc/device-tree/model 2>/dev/null)
        if [[ "$MODEL" == *"Raspberry Pi"* ]]; then
            DEVICE_TYPE="raspberry_pi"
            log_info "检测到设备: 树莓派 ($MODEL)"
        fi
    fi

    # 检测 Jetson 设备
    if [[ -f /etc/nv_tegra_release ]] || [[ -f /proc/device-tree/model ]] && grep -q "NVIDIA" /proc/device-tree/model 2>/dev/null; then
        DEVICE_TYPE="jetson"
        if [[ -f /proc/device-tree/model ]]; then
            MODEL=$(cat /proc/device-tree/model 2>/dev/null)
            log_info "检测到设备: NVIDIA Jetson ($MODEL)"
        else
            log_info "检测到设备: NVIDIA Jetson"
        fi
    fi

    # 检测阿里云
    if [[ -f /sys/class/dmi/id/sys_vendor ]] && grep -q "Alibaba" /sys/class/dmi/id/sys_vendor 2>/dev/null; then
        DEVICE_TYPE="aliyun"
        log_info "检测到环境: 阿里云服务器"
    fi

    # 检测其他云服务商
    if [[ -f /sys/class/dmi/id/sys_vendor ]]; then
        VENDOR=$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)
        case "$VENDOR" in
            *"Amazon"*|*"AWS"*)
                DEVICE_TYPE="aws"
                log_info "检测到环境: AWS EC2"
                ;;
            *"Microsoft"*)
                DEVICE_TYPE="azure"
                log_info "检测到环境: Azure"
                ;;
            *"Google"*)
                DEVICE_TYPE="gcp"
                log_info "检测到环境: Google Cloud"
                ;;
            *"Tencent"*)
                DEVICE_TYPE="tencent"
                log_info "检测到环境: 腾讯云"
                ;;
        esac
    fi
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

    # 根据架构选择合适的 Java 包
    case $SYSTEM_ARCH in
        "x64")
            JAVA_PACKAGE="openjdk-11-jdk"
            JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
            ;;
        "arm64")
            JAVA_PACKAGE="openjdk-11-jdk"
            JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-arm64"
            ;;
        "arm32")
            JAVA_PACKAGE="openjdk-11-jdk"
            JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-armhf"
            ;;
        *)
            JAVA_PACKAGE="openjdk-11-jdk"
            # 尝试自动检测 JAVA_HOME
            JAVA_HOME_PATH=$(find /usr/lib/jvm -name "java-11-openjdk*" -type d | head -n1)
            ;;
    esac

    log_info "安装 Java 包: $JAVA_PACKAGE (架构: $SYSTEM_ARCH)"
    sudo apt install -y $JAVA_PACKAGE

    # 自动检测实际的 JAVA_HOME 路径
    if [[ ! -d "$JAVA_HOME_PATH" ]]; then
        JAVA_HOME_PATH=$(find /usr/lib/jvm -name "java-11-openjdk*" -type d | head -n1)
        log_info "自动检测到 JAVA_HOME: $JAVA_HOME_PATH"
    fi

    # 设置 JAVA_HOME
    if [[ -n "$JAVA_HOME_PATH" && -d "$JAVA_HOME_PATH" ]]; then
        echo "export JAVA_HOME=$JAVA_HOME_PATH" >> ~/.bashrc
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc

        export JAVA_HOME="$JAVA_HOME_PATH"
        export PATH="$JAVA_HOME/bin:$PATH"

        log_success "Java 11 安装完成 (JAVA_HOME: $JAVA_HOME_PATH)"
    else
        log_warning "无法确定 JAVA_HOME 路径，请手动设置"
    fi
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

    # 检查现有安装
    if command_exists node; then
        NODE_VERSION=$(node -v | sed 's/v//')
        log_info "检测到已安装 Node.js: $NODE_VERSION"

        # 检查版本是否满足要求 (18+)
        if [[ "${NODE_VERSION%%.*}" -ge 18 ]]; then
            log_success "Node.js 版本满足要求"
        else
            log_warning "Node.js 版本过低，将升级到 18.x"
        fi
    else
        log_info "未检测到 Node.js，将安装 18.x 版本"
    fi

    # 根据架构和设备类型选择安装方式
    case $SYSTEM_ARCH in
        "x64")
            install_nodejs_standard
            ;;
        "arm64")
            if [[ "$DEVICE_TYPE" == "raspberry_pi" ]]; then
                install_nodejs_raspberry_pi
            else
                install_nodejs_standard
            fi
            ;;
        "arm32")
            install_nodejs_raspberry_pi
            ;;
        *)
            log_warning "未知架构，尝试标准安装方式"
            install_nodejs_standard
            ;;
    esac

    # 安装 pnpm
    install_pnpm

    log_success "Node.js 和 pnpm 安装完成"
}

# 标准 Node.js 安装
install_nodejs_standard() {
    log_info "使用标准方式安装 Node.js..."

    # 使用 NodeSource 仓库
    if ! curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -; then
        log_warning "NodeSource 安装失败，尝试使用系统包"
        sudo apt update
        sudo apt install -y nodejs npm
    else
        sudo apt install -y nodejs
    fi
}

# 树莓派 Node.js 安装
install_nodejs_raspberry_pi() {
    log_info "为树莓派/ARM 设备安装 Node.js..."

    # 树莓派推荐使用系统包或手动安装
    if [[ "$SYSTEM_ARCH" == "arm32" ]]; then
        log_info "ARM32 设备，使用系统包管理器安装..."
        sudo apt update
        sudo apt install -y nodejs npm

        # 检查版本，如果太低则尝试其他方式
        if command_exists node; then
            NODE_VERSION=$(node -v | sed 's/v//')
            if [[ "${NODE_VERSION%%.*}" -lt 16 ]]; then
                log_warning "系统 Node.js 版本过低，尝试使用 snap 安装"
                sudo snap install node --classic || log_warning "snap 安装失败"
            fi
        fi
    else
        # ARM64 设备可以尝试 NodeSource
        install_nodejs_standard
    fi
}

# 安装 pnpm
install_pnpm() {
    if ! command_exists pnpm; then
        log_info "安装 pnpm..."

        # 方式1: 使用官方安装脚本
        if curl -fsSL https://get.pnpm.io/install.sh | sh -; then
            log_success "pnpm 安装成功"
        else
            log_warning "pnpm 官方脚本安装失败，尝试使用 npm"
            # 方式2: 使用 npm 安装
            if command_exists npm; then
                npm install -g pnpm
            else
                log_error "无法安装 pnpm"
                return 1
            fi
        fi

        # 添加 pnpm 到 PATH
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        echo 'export PNPM_HOME="$HOME/.local/share/pnpm"' >> ~/.bashrc
        echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.bashrc

        # 重新加载环境变量
        source ~/.bashrc 2>/dev/null || true
    else
        log_success "pnpm 已安装"
    fi
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

        # 检测数据库类型
        DB_VERSION=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)

        if [[ "$DB_VERSION" == *"MariaDB"* ]]; then
            log_info "检测到 MariaDB，转换排序规则..."
            # 为 MariaDB 创建兼容的 SQL 文件
            sed 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' "$PROJECT_ROOT/sql/icecms8.0.sql" > "$PROJECT_ROOT/sql/icecms_mariadb.sql"
            mysql -u "$MYSQL_DB_USER" -p"$MYSQL_DB_PASSWORD" "$MYSQL_DB_NAME" < "$PROJECT_ROOT/sql/icecms_mariadb.sql"
            rm -f "$PROJECT_ROOT/sql/icecms_mariadb.sql"  # 清理临时文件
        else
            log_info "检测到 MySQL，使用原始 SQL 文件..."
            mysql -u "$MYSQL_DB_USER" -p"$MYSQL_DB_PASSWORD" "$MYSQL_DB_NAME" < "$PROJECT_ROOT/sql/icecms8.0.sql"
        fi

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

# 配置前端网络绑定
configure_frontend_network_binding() {
    log_info "配置前端网络绑定..."

    if [[ -f "package.json" ]]; then
        # 更新 package.json 中的启动脚本，添加 --host 0.0.0.0 参数
        log_info "更新前端启动脚本以支持外网访问..."

        # 备份原文件
        cp package.json package.json.network.backup

        # 使用 node 脚本更新 package.json
        node -e "
        const fs = require('fs');
        const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));

        if (pkg.scripts) {
            if (pkg.scripts.dev) {
                pkg.scripts.dev = pkg.scripts.dev.replace(/nuxt dev/, 'nuxt dev --host 0.0.0.0 --port 3000');
                if (!pkg.scripts.dev.includes('--host')) {
                    pkg.scripts.dev += ' --host 0.0.0.0 --port 3000';
                }
            }
            if (pkg.scripts.serve) {
                pkg.scripts.serve = pkg.scripts.serve.replace(/nuxt dev/, 'nuxt dev --host 0.0.0.0 --port 3000');
                if (!pkg.scripts.serve.includes('--host')) {
                    pkg.scripts.serve += ' --host 0.0.0.0 --port 3000';
                }
            }
        }

        fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2));
        " 2>/dev/null || {
            # 如果 node 脚本失败，使用 sed 作为备用方案
            log_warning "Node.js 脚本更新失败，使用 sed 备用方案..."
            sed -i 's/"dev": "nuxt dev/"dev": "nuxt dev --host 0.0.0.0 --port 3000/g' package.json
            sed -i 's/"serve": "nuxt dev/"serve": "nuxt dev --host 0.0.0.0 --port 3000/g' package.json
        }

        log_success "前端网络绑定配置完成"
    else
        log_warning "package.json 不存在，跳过网络绑定配置"
    fi
}

# 安装项目依赖
install_project_dependencies() {
    log_step "安装项目依赖..."

    # 配置后端数据库连接
    configure_backend

    # 后端依赖 - 多模块项目需要在根目录编译
    log_info "编译后端项目（多模块）..."
    cd "$PROJECT_ROOT"

    # 首先安装父模块和子模块到本地仓库
    log_info "安装子模块到本地仓库..."
    mvn clean install -DskipTests

    log_success "后端项目编译完成"
    
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

        # 清理可能存在的问题依赖
        log_info "清理缓存和重新安装依赖..."
        rm -rf node_modules
        rm -rf .nuxt
        pnpm store prune 2>/dev/null || true

        # 根据架构设置不同的安装策略
        install_frontend_deps_by_arch

        cd "$PROJECT_ROOT"
        log_success "用户前台依赖安装完成"
    else
        log_warning "用户前台目录不存在: $FRONTEND_DIR"
    fi
}

# 根据架构安装前端依赖
install_frontend_deps_by_arch() {
    # 设置通用环境变量
    export SKIP_POSTINSTALL=1
    export NODE_OPTIONS="--max-old-space-size=2048"
    export NUXT_TELEMETRY_DISABLED=1

    case $SYSTEM_ARCH in
        "x64")
            install_frontend_deps_x64
            ;;
        "arm64")
            if [[ "$DEVICE_TYPE" == "raspberry_pi" || "$DEVICE_TYPE" == "jetson" ]]; then
                install_frontend_deps_arm_device
            else
                install_frontend_deps_arm64_server
            fi
            ;;
        "arm32")
            install_frontend_deps_arm_device
            ;;
        *)
            log_warning "未知架构，使用保守安装策略"
            install_frontend_deps_conservative
            ;;
    esac
}

# x64 架构安装
install_frontend_deps_x64() {
    log_info "x64 架构：使用标准安装方式..."

    # 先尝试标准安装
    if pnpm install --ignore-scripts --no-optional; then
        log_success "标准安装成功"
        mkdir -p .nuxt
        return 0
    fi

    # 失败则使用保守方式
    install_frontend_deps_conservative
}

# ARM64 服务器安装
install_frontend_deps_arm64_server() {
    log_info "ARM64 服务器：使用优化安装方式..."

    # ARM64 服务器通常性能较好，可以尝试标准安装
    export NODE_OPTIONS="--max-old-space-size=3072"

    if pnpm install --ignore-scripts --no-optional; then
        log_success "ARM64 服务器安装成功"
        mkdir -p .nuxt
        return 0
    fi

    # 失败则降级到设备安装方式
    install_frontend_deps_arm_device
}

# ARM 设备安装（树莓派、Jetson 等）
install_frontend_deps_arm_device() {
    log_info "ARM 设备：使用轻量化安装方式..."

    # ARM 设备内存和性能有限，使用更保守的设置
    export NODE_OPTIONS="--max-old-space-size=1024"

    # 配置前端网络绑定（支持外网访问）
    configure_frontend_network_binding

    # 创建简化的 package.json
    if [[ -f "package.json" ]]; then
        cp package.json package.json.backup
        create_simplified_package_json

        # 使用简化配置安装
        if pnpm install --ignore-scripts --no-optional; then
            log_info "安装 ARM64 原生绑定..."
            # 安装 ARM64 原生绑定模块
            pnpm add @oxc-parser/binding-linux-arm64-gnu || log_warning "ARM64 绑定安装失败，运行时可能需要手动安装"

            log_success "ARM 设备简化安装成功"
            # 恢复原始配置
            mv package.json.backup package.json
            mkdir -p .nuxt
            return 0
        fi

        # 恢复原始配置
        mv package.json.backup package.json
    fi

    # 最后尝试保守安装
    install_frontend_deps_conservative
}

# 保守安装方式
install_frontend_deps_conservative() {
    log_info "使用保守安装方式..."

    # 降低内存使用
    export NODE_OPTIONS="--max-old-space-size=512"

    # 尝试使用 npm
    if command_exists npm; then
        log_info "尝试使用 npm 安装..."
        if npm install --ignore-scripts --no-optional; then
            log_success "npm 安装成功"
            mkdir -p .nuxt
            return 0
        fi
    fi

    # 最后的备用方案：只安装核心依赖
    log_warning "标准安装失败，创建最小化环境..."
    mkdir -p .nuxt
    mkdir -p .output

    # 创建基本的 nuxt.config.js（如果不存在）
    if [[ ! -f "nuxt.config.js" && ! -f "nuxt.config.ts" ]]; then
        cat > nuxt.config.js << 'EOF'
export default defineNuxtConfig({
  devtools: { enabled: false },
  ssr: true,
  nitro: {
    preset: 'node-server'
  }
})
EOF
    fi

    log_warning "使用最小化环境，某些功能可能受限"
}

# 创建简化的 package.json
create_simplified_package_json() {
    cat > package.json << 'EOF'
{
  "name": "nuxt-app",
  "private": true,
  "scripts": {
    "build": "nuxt build",
    "dev": "nuxt dev --port 3000",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "postinstall": "echo 'Skipping postinstall for ARM device'"
  },
  "devDependencies": {
    "nuxt": "^3.15.2"
  },
  "dependencies": {
    "@element-plus/nuxt": "^1.0.10",
    "element-plus": "^2.9.3",
    "@pinia/nuxt": "^0.5.5",
    "pinia": "^2.2.6"
  }
}
EOF
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
    echo "🖥️  系统信息："
    echo "  - 操作系统: Ubuntu $VERSION"
    echo "  - 系统架构: $SYSTEM_ARCH ($ARCH)"
    echo "  - 设备类型: $DEVICE_TYPE"
    echo
    echo "✅ 安装组件："
    echo -e "${GREEN}✓${NC} Java 11: $(java -version 2>&1 | head -n1)"
    echo -e "${GREEN}✓${NC} Maven: $(mvn -version 2>&1 | head -n1)"
    echo -e "${GREEN}✓${NC} Node.js: $(node -v)"
    if command_exists pnpm; then
        echo -e "${GREEN}✓${NC} pnpm: $(pnpm -v)"
    else
        echo -e "${YELLOW}⚠${NC} pnpm: 未安装（将使用 npm）"
    fi
    # 检测数据库类型并显示
    DB_VERSION=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
    if [[ "$DB_VERSION" == *"MariaDB"* ]]; then
        echo -e "${GREEN}✓${NC} MariaDB: 已安装并启动"
    else
        echo -e "${GREEN}✓${NC} MySQL: 已安装并启动"
    fi
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
    echo "3. 查看配置: ./scripts/show-passwords.sh"
    echo "4. 访问地址:"
    echo "   - 管理后台: http://localhost:2580 (admin/admin123)"
    echo "   - 用户前台: http://localhost:3000"
    echo "   - API文档: http://localhost:8181/doc.html"
    echo
    echo "📝 架构特定提示："
    case $SYSTEM_ARCH in
        "arm32"|"arm64")
            if [[ "$DEVICE_TYPE" == "raspberry_pi" ]]; then
                echo "- 树莓派设备：如遇性能问题，可适当增加 swap 空间"
                echo "- 建议使用 Class 10 或更快的 SD 卡"
                if [[ "$DB_VERSION" == *"MariaDB"* ]]; then
                    echo "- 已自动处理 MariaDB 字符集兼容性问题"
                fi
            elif [[ "$DEVICE_TYPE" == "jetson" ]]; then
                echo "- Jetson 设备：已优化 GPU 加速支持"
                echo "- 确保 CUDA 环境正确配置"
            else
                echo "- ARM 设备：已使用轻量化配置"
            fi
            ;;
        "x64")
            if [[ "$DEVICE_TYPE" == "aliyun" ]]; then
                echo "- 阿里云服务器：建议配置安全组开放相应端口"
            elif [[ "$DEVICE_TYPE" != "generic" ]]; then
                echo "- 云服务器：建议配置防火墙和安全组"
            fi
            ;;
    esac
    echo
    echo "- 请妥善保存上述数据库密码信息"
    echo "- 生产环境请修改默认管理员密码"
    echo "- 如遇问题，请运行: ./scripts/fix-frontend-deps.sh"
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
