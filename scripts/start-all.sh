#!/bin/bash

# IceCMS Pro 一键启动脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 一键启动 IceCMS Pro 的所有服务

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

# PID 文件目录
PID_DIR="$PROJECT_ROOT/scripts/pids"
mkdir -p "$PID_DIR"

# 日志文件目录
LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$LOG_DIR"

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

# 检查端口是否被占用
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null; then
        return 0  # 端口被占用
    else
        return 1  # 端口未被占用
    fi
}

# 等待端口可用
wait_for_port() {
    local port=$1
    local timeout=${2:-60}
    local count=0
    
    log_info "等待端口 $port 可用..."
    while ! check_port $port && [ $count -lt $timeout ]; do
        sleep 1
        count=$((count + 1))
    done
    
    if [ $count -ge $timeout ]; then
        log_error "等待端口 $port 超时"
        return 1
    fi
    
    log_success "端口 $port 已可用"
    return 0
}

# 检查必要的服务
check_services() {
    log_step "检查必要的服务..."
    
    # 检查 MySQL
    if ! brew services list | grep mysql | grep started > /dev/null; then
        log_info "启动 MySQL 服务..."
        brew services start mysql
        sleep 3
    fi
    log_success "MySQL 服务正在运行"
    
    # 检查 Redis
    if ! brew services list | grep redis | grep started > /dev/null; then
        log_info "启动 Redis 服务..."
        brew services start redis
        sleep 2
    fi
    log_success "Redis 服务正在运行"
}

# 启动后端服务
start_backend() {
    log_step "启动后端服务..."
    
    if [[ ! -d "$BACKEND_DIR" ]]; then
        log_error "后端目录不存在: $BACKEND_DIR"
        return 1
    fi
    
    cd "$BACKEND_DIR"
    
    # 检查是否已经启动
    if check_port 8181; then
        log_warning "后端服务已在运行 (端口 8181)"
        return 0
    fi
    
    # 编译项目
    log_info "编译后端项目..."
    mvn clean package -DskipTests > "$LOG_DIR/backend-build.log" 2>&1
    
    if [[ ! -f "target/main.jar" ]]; then
        log_error "后端编译失败，请检查日志: $LOG_DIR/backend-build.log"
        return 1
    fi
    
    # 启动后端服务
    log_info "启动后端服务..."
    nohup java -jar target/main.jar > "$LOG_DIR/backend.log" 2>&1 &
    echo $! > "$PID_DIR/backend.pid"
    
    # 等待后端启动
    if wait_for_port 8181 120; then
        log_success "后端服务启动成功 (http://localhost:8181)"
    else
        log_error "后端服务启动失败"
        return 1
    fi
    
    cd "$PROJECT_ROOT"
}

# 启动管理后台
start_admin() {
    log_step "启动管理后台..."

    if [[ ! -d "$ADMIN_DIR" ]]; then
        log_warning "管理后台目录不存在: $ADMIN_DIR"
        return 0
    fi

    cd "$ADMIN_DIR"

    # 检查是否已经启动 (检查多个可能的端口)
    local admin_ports=(5173 2580 3001)
    local admin_port=""

    for port in "${admin_ports[@]}"; do
        if check_port $port; then
            admin_port=$port
            break
        fi
    done

    if [[ -n "$admin_port" ]]; then
        log_warning "管理后台已在运行 (端口 $admin_port)"
        return 0
    fi

    # 检查依赖
    if [[ ! -d "node_modules" ]]; then
        log_info "安装管理后台依赖..."
        # 确保环境变量正确加载
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        pnpm install
    fi

    # 启动管理后台
    log_info "启动管理后台..."
    # 确保环境变量正确加载
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    nohup pnpm dev > "$LOG_DIR/admin.log" 2>&1 &
    echo $! > "$PID_DIR/admin.pid"

    # 等待管理后台启动 (检查多个端口)
    local started=false
    for port in "${admin_ports[@]}"; do
        if wait_for_port $port 30; then
            log_success "管理后台启动成功 (http://localhost:$port)"
            started=true
            break
        fi
    done

    if [[ "$started" != "true" ]]; then
        log_error "管理后台启动失败"
        return 1
    fi

    cd "$PROJECT_ROOT"
}

# 启动用户前台
start_frontend() {
    log_step "启动用户前台..."

    if [[ ! -d "$FRONTEND_DIR" ]]; then
        log_warning "用户前台目录不存在: $FRONTEND_DIR"
        return 0
    fi

    cd "$FRONTEND_DIR"

    # 检查是否已经启动
    if check_port 3000; then
        log_warning "用户前台已在运行 (端口 3000)"
        return 0
    fi

    # 检查依赖
    if [[ ! -d "node_modules" ]]; then
        log_info "安装用户前台依赖..."
        # 确保环境变量正确加载
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        pnpm install
    fi

    # 启动用户前台
    log_info "启动用户前台..."
    # 确保环境变量正确加载
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    nohup pnpm dev > "$LOG_DIR/frontend.log" 2>&1 &
    echo $! > "$PID_DIR/frontend.pid"

    # 等待用户前台启动
    if wait_for_port 3000 60; then
        log_success "用户前台启动成功 (http://localhost:3000)"
    else
        log_error "用户前台启动失败"
        return 1
    fi

    cd "$PROJECT_ROOT"
}

# 显示状态
show_status() {
    echo
    echo "=================================================="
    echo "              IceCMS Pro 服务状态"
    echo "=================================================="
    echo
    
    # 检查后端
    if check_port 8181; then
        echo -e "${GREEN}✓${NC} 后端服务: http://localhost:8181"
        echo -e "  ${CYAN}→${NC} API文档: http://localhost:8181/doc.html"
    else
        echo -e "${RED}✗${NC} 后端服务: 未运行"
    fi
    
    # 检查管理后台
    if check_port 5173; then
        echo -e "${GREEN}✓${NC} 管理后台: http://localhost:5173"
        echo -e "  ${CYAN}→${NC} 默认账号: admin / admin123"
    else
        echo -e "${RED}✗${NC} 管理后台: 未运行"
    fi
    
    # 检查用户前台
    if check_port 3000; then
        echo -e "${GREEN}✓${NC} 用户前台: http://localhost:3000"
    else
        echo -e "${RED}✗${NC} 用户前台: 未运行"
    fi
    
    echo
    echo "日志文件位置: $LOG_DIR"
    echo "PID文件位置: $PID_DIR"
    echo
    echo "停止所有服务: ./scripts/stop-all.sh"
    echo "查看日志: ./scripts/logs.sh"
    echo "=================================================="
}

# 主函数
main() {
    echo "=================================================="
    echo "         IceCMS Pro 一键启动脚本"
    echo "=================================================="
    echo
    
    # 检查必要的命令
    if ! command_exists java; then
        log_error "Java 未安装，请先运行 ./scripts/install-dependencies.sh"
        exit 1
    fi
    
    if ! command_exists mvn; then
        log_error "Maven 未安装，请先运行 ./scripts/install-dependencies.sh"
        exit 1
    fi
    
    if ! command_exists pnpm; then
        log_error "pnpm 未安装，请先运行 ./scripts/install-dependencies.sh"
        exit 1
    fi
    
    # 检查服务
    check_services
    
    # 启动服务
    start_backend
    start_admin
    start_frontend
    
    # 显示状态
    show_status
    
    log_success "所有服务启动完成！"
}

# 处理中断信号
trap 'echo -e "\n${YELLOW}正在停止服务...${NC}"; ./scripts/stop-all.sh; exit 0' INT TERM

# 执行主函数
main "$@"
