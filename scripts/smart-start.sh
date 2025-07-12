#!/bin/bash

# IceCMS Pro 智能一键启动脚本
# 作者: AI Assistant
# 版本: 2.0
# 描述: 智能检测环境，一键启动所有服务，自动打开浏览器

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

# 服务端口配置
BACKEND_PORT=8181
ADMIN_PORTS=(2580 5173 3001)  # 管理后台可能的端口
FRONTEND_PORT=3000

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
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
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
    
    while ! check_port $port && [ $count -lt $timeout ]; do
        sleep 1
        count=$((count + 1))
        if [ $((count % 10)) -eq 0 ]; then
            echo -n "."
        fi
    done
    
    if [ $count -ge $timeout ]; then
        return 1
    fi
    
    return 0
}

# 设置环境变量
setup_environment() {
    log_info "设置环境变量..."
    
    # Java 环境
    if [[ -d "/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home" ]]; then
        export JAVA_HOME="/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
        export PATH="$JAVA_HOME/bin:$PATH"
    fi
    
    # pnpm 环境
    if [[ -d "$HOME/.local/share/pnpm" ]]; then
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
    fi
    
    # nvm 环境
    if [[ -d "$HOME/.nvm" ]]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi
}

# 检查必要的服务
check_services() {
    log_step "检查系统服务..."
    
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
    
    if check_port $BACKEND_PORT; then
        log_success "后端服务已在运行 (端口 $BACKEND_PORT)"
        return 0
    fi
    
    cd "$BACKEND_DIR"
    
    # 检查 JAR 文件是否存在
    if [[ ! -f "target/main.jar" ]]; then
        log_info "编译后端项目..."
        mvn clean package -DskipTests > "$LOG_DIR/backend-build.log" 2>&1
    fi
    
    # 启动后端服务
    log_info "启动后端服务..."
    nohup java -jar target/main.jar > "$LOG_DIR/backend.log" 2>&1 &
    echo $! > "$PID_DIR/backend.pid"
    
    # 等待后端启动
    log_info "等待后端服务启动"
    if wait_for_port $BACKEND_PORT 120; then
        echo
        log_success "后端服务启动成功 (http://localhost:$BACKEND_PORT)"
    else
        echo
        log_error "后端服务启动失败"
        return 1
    fi
    
    cd "$PROJECT_ROOT"
}

# 启动前端服务
start_frontend_services() {
    log_step "启动前端服务..."
    
    # 启动管理后台
    if [[ -d "$ADMIN_DIR" ]]; then
        local admin_running=false
        local admin_port=""
        
        # 检查管理后台是否已运行
        for port in "${ADMIN_PORTS[@]}"; do
            if check_port $port; then
                admin_running=true
                admin_port=$port
                break
            fi
        done
        
        if [[ "$admin_running" == "true" ]]; then
            log_success "管理后台已在运行 (端口 $admin_port)"
        else
            log_info "启动管理后台..."
            cd "$ADMIN_DIR"
            
            # 检查依赖
            if [[ ! -d "node_modules" ]]; then
                log_info "安装管理后台依赖..."
                pnpm install > "$LOG_DIR/admin-install.log" 2>&1
            fi
            
            # 启动管理后台
            nohup pnpm dev > "$LOG_DIR/admin.log" 2>&1 &
            echo $! > "$PID_DIR/admin.pid"
            
            # 等待启动
            log_info "等待管理后台启动"
            local started=false
            for port in "${ADMIN_PORTS[@]}"; do
                if wait_for_port $port 60; then
                    echo
                    log_success "管理后台启动成功 (http://localhost:$port)"
                    admin_port=$port
                    started=true
                    break
                fi
            done
            
            if [[ "$started" != "true" ]]; then
                echo
                log_error "管理后台启动失败"
            fi
            
            cd "$PROJECT_ROOT"
        fi
    fi
    
    # 启动用户前台
    if [[ -d "$FRONTEND_DIR" ]]; then
        if check_port $FRONTEND_PORT; then
            log_success "用户前台已在运行 (端口 $FRONTEND_PORT)"
        else
            log_info "启动用户前台..."
            cd "$FRONTEND_DIR"
            
            # 检查依赖
            if [[ ! -d "node_modules" ]]; then
                log_info "安装用户前台依赖..."
                pnpm install > "$LOG_DIR/frontend-install.log" 2>&1
            fi
            
            # 启动用户前台
            nohup pnpm dev > "$LOG_DIR/frontend.log" 2>&1 &
            echo $! > "$PID_DIR/frontend.pid"
            
            # 等待启动
            log_info "等待用户前台启动"
            if wait_for_port $FRONTEND_PORT 60; then
                echo
                log_success "用户前台启动成功 (http://localhost:$FRONTEND_PORT)"
            else
                echo
                log_error "用户前台启动失败"
            fi
            
            cd "$PROJECT_ROOT"
        fi
    fi
}

# 显示服务状态和访问链接
show_status_and_links() {
    echo
    echo "=================================================="
    echo "              🎉 IceCMS Pro 启动完成"
    echo "=================================================="
    echo
    
    # 检查后端
    if check_port $BACKEND_PORT; then
        echo -e "${GREEN}✓${NC} 后端服务: ${CYAN}http://localhost:$BACKEND_PORT${NC}"
        echo -e "  ${BLUE}→${NC} API文档: ${CYAN}http://localhost:$BACKEND_PORT/doc.html${NC}"
    else
        echo -e "${RED}✗${NC} 后端服务: 未运行"
    fi
    
    # 检查管理后台
    local admin_port=""
    for port in "${ADMIN_PORTS[@]}"; do
        if check_port $port; then
            admin_port=$port
            break
        fi
    done
    
    if [[ -n "$admin_port" ]]; then
        echo -e "${GREEN}✓${NC} 管理后台: ${CYAN}http://localhost:$admin_port${NC}"
        echo -e "  ${BLUE}→${NC} 默认账号: ${YELLOW}admin${NC} / ${YELLOW}admin123${NC}"
    else
        echo -e "${RED}✗${NC} 管理后台: 未运行"
    fi
    
    # 检查用户前台
    if check_port $FRONTEND_PORT; then
        echo -e "${GREEN}✓${NC} 用户前台: ${CYAN}http://localhost:$FRONTEND_PORT${NC}"
    else
        echo -e "${RED}✗${NC} 用户前台: 未运行"
    fi
    
    echo
    echo "管理命令:"
    echo "  停止所有服务: ${CYAN}./scripts/stop-all.sh${NC}"
    echo "  查看服务状态: ${CYAN}./scripts/status.sh${NC}"
    echo "  查看日志: ${CYAN}./scripts/logs.sh${NC}"
    echo "=================================================="
}

# 自动打开浏览器
open_browser() {
    read -p "是否自动打开浏览器访问服务? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "正在打开浏览器..."
        
        # 打开后端API文档
        if check_port $BACKEND_PORT; then
            open "http://localhost:$BACKEND_PORT/doc.html" 2>/dev/null &
        fi
        
        # 打开管理后台
        for port in "${ADMIN_PORTS[@]}"; do
            if check_port $port; then
                open "http://localhost:$port" 2>/dev/null &
                break
            fi
        done
        
        # 打开用户前台
        if check_port $FRONTEND_PORT; then
            open "http://localhost:$FRONTEND_PORT" 2>/dev/null &
        fi
        
        log_success "浏览器已打开"
    fi
}

# 主函数
main() {
    echo "=================================================="
    echo "         🚀 IceCMS Pro 智能一键启动"
    echo "=================================================="
    echo
    
    # 设置环境
    setup_environment
    
    # 检查系统服务
    check_services
    
    # 启动后端
    start_backend
    
    # 启动前端服务
    start_frontend_services
    
    # 显示状态
    show_status_and_links
    
    # 自动打开浏览器
    open_browser
    
    echo
    log_success "IceCMS Pro 启动完成！"
}

# 处理中断信号
trap 'echo -e "\n${YELLOW}正在停止服务...${NC}"; ./scripts/stop-all.sh; exit 0' INT TERM

# 执行主函数
main "$@"
