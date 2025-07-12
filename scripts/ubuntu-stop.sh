#!/bin/bash

# IceCMS Pro Ubuntu 停止所有服务脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 停止 IceCMS Pro 的所有服务

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
PID_DIR="$PROJECT_ROOT/scripts/pids"

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

# 停止进程
stop_process() {
    local service_name=$1
    local pid_file="$PID_DIR/${service_name}.pid"
    
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            log_info "停止 $service_name (PID: $pid)..."
            kill "$pid"
            
            # 等待进程结束
            local count=0
            while kill -0 "$pid" 2>/dev/null && [ $count -lt 10 ]; do
                sleep 1
                count=$((count + 1))
            done
            
            # 如果进程仍在运行，强制杀死
            if kill -0 "$pid" 2>/dev/null; then
                log_warning "强制停止 $service_name..."
                kill -9 "$pid"
            fi
            
            log_success "$service_name 已停止"
        else
            log_warning "$service_name 进程不存在 (PID: $pid)"
        fi
        rm -f "$pid_file"
    else
        log_warning "$service_name PID 文件不存在"
    fi
}

# 通过端口停止进程
stop_by_port() {
    local port=$1
    local service_name=$2
    
    local pid=$(ss -tulpn | grep ":$port " | awk '{print $7}' | cut -d',' -f2 | cut -d'=' -f2)
    if [[ -n "$pid" ]]; then
        log_info "停止运行在端口 $port 的 $service_name (PID: $pid)..."
        kill "$pid" 2>/dev/null || true
        
        # 等待进程结束
        sleep 2
        
        # 检查是否还在运行
        if ss -tulpn | grep ":$port " >/dev/null 2>&1; then
            log_warning "强制停止端口 $port 上的进程..."
            kill -9 "$pid" 2>/dev/null || true
        fi
        
        log_success "$service_name 已停止"
    else
        log_info "$service_name 未在端口 $port 运行"
    fi
}

# 主函数
main() {
    echo "=================================================="
    echo "         IceCMS Pro Ubuntu 停止所有服务"
    echo "=================================================="
    echo
    
    # 停止后端服务
    log_info "停止后端服务..."
    stop_process "backend"
    stop_by_port 8181 "后端服务"
    
    # 停止管理后台
    log_info "停止管理后台..."
    stop_process "admin"
    stop_by_port 2580 "管理后台"
    
    # 停止用户前台
    log_info "停止用户前台..."
    stop_process "frontend"
    stop_by_port 3000 "用户前台"
    
    # 清理 PID 目录
    if [[ -d "$PID_DIR" ]]; then
        rm -f "$PID_DIR"/*.pid
    fi
    
    echo
    log_success "所有服务已停止"
    echo "=================================================="
}

# 执行主函数
main "$@"
