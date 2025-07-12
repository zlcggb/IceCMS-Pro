#!/bin/bash

# IceCMS Pro 日志查看脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 查看 IceCMS Pro 各服务的日志

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
LOG_DIR="$PROJECT_ROOT/logs"

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

# 显示帮助信息
show_help() {
    echo "IceCMS Pro 日志查看工具"
    echo
    echo "用法: $0 [选项] [服务名]"
    echo
    echo "服务名:"
    echo "  backend    - 后端服务日志"
    echo "  admin      - 管理后台日志"
    echo "  frontend   - 用户前台日志"
    echo "  build      - 构建日志"
    echo "  all        - 所有日志 (默认)"
    echo
    echo "选项:"
    echo "  -f, --follow    实时跟踪日志"
    echo "  -n, --lines N   显示最后 N 行 (默认: 50)"
    echo "  -h, --help      显示帮助信息"
    echo
    echo "示例:"
    echo "  $0 backend              # 查看后端日志"
    echo "  $0 -f admin             # 实时跟踪管理后台日志"
    echo "  $0 -n 100 frontend      # 查看用户前台最后100行日志"
}

# 查看单个日志文件
view_log() {
    local service=$1
    local log_file="$LOG_DIR/${service}.log"
    local follow=${2:-false}
    local lines=${3:-50}
    
    if [[ ! -f "$log_file" ]]; then
        log_warning "日志文件不存在: $log_file"
        return 1
    fi
    
    echo -e "${CYAN}==================== $service 日志 ====================${NC}"
    
    if [[ "$follow" == "true" ]]; then
        log_info "实时跟踪 $service 日志 (按 Ctrl+C 退出)..."
        tail -f "$log_file"
    else
        log_info "显示 $service 最后 $lines 行日志..."
        tail -n "$lines" "$log_file"
    fi
    
    echo -e "${CYAN}================================================${NC}"
}

# 查看所有日志
view_all_logs() {
    local follow=${1:-false}
    local lines=${2:-20}
    
    echo -e "${PURPLE}==================== 所有服务日志概览 ====================${NC}"
    
    # 后端日志
    if [[ -f "$LOG_DIR/backend.log" ]]; then
        echo -e "\n${GREEN}>>> 后端服务日志 (最后 $lines 行):${NC}"
        tail -n "$lines" "$LOG_DIR/backend.log" | sed 's/^/  /'
    fi
    
    # 管理后台日志
    if [[ -f "$LOG_DIR/admin.log" ]]; then
        echo -e "\n${GREEN}>>> 管理后台日志 (最后 $lines 行):${NC}"
        tail -n "$lines" "$LOG_DIR/admin.log" | sed 's/^/  /'
    fi
    
    # 用户前台日志
    if [[ -f "$LOG_DIR/frontend.log" ]]; then
        echo -e "\n${GREEN}>>> 用户前台日志 (最后 $lines 行):${NC}"
        tail -n "$lines" "$LOG_DIR/frontend.log" | sed 's/^/  /'
    fi
    
    # 构建日志
    if [[ -f "$LOG_DIR/backend-build.log" ]]; then
        echo -e "\n${GREEN}>>> 后端构建日志 (最后 $lines 行):${NC}"
        tail -n "$lines" "$LOG_DIR/backend-build.log" | sed 's/^/  /'
    fi
    
    echo -e "\n${PURPLE}================================================${NC}"
    
    if [[ "$follow" == "true" ]]; then
        log_info "实时跟踪所有日志 (按 Ctrl+C 退出)..."
        tail -f "$LOG_DIR"/*.log 2>/dev/null
    fi
}

# 清理日志
clean_logs() {
    read -p "确定要清理所有日志文件吗? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$LOG_DIR"/*.log
        log_success "所有日志文件已清理"
    else
        log_info "取消清理操作"
    fi
}

# 显示日志文件信息
show_log_info() {
    echo -e "${CYAN}==================== 日志文件信息 ====================${NC}"
    echo "日志目录: $LOG_DIR"
    echo
    
    if [[ -d "$LOG_DIR" ]]; then
        for log_file in "$LOG_DIR"/*.log; do
            if [[ -f "$log_file" ]]; then
                local filename=$(basename "$log_file")
                local size=$(du -h "$log_file" | cut -f1)
                local lines=$(wc -l < "$log_file")
                local modified=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$log_file" 2>/dev/null || stat -c "%y" "$log_file" 2>/dev/null | cut -d'.' -f1)
                
                echo -e "${GREEN}$filename${NC}"
                echo "  大小: $size"
                echo "  行数: $lines"
                echo "  修改时间: $modified"
                echo
            fi
        done
    else
        log_warning "日志目录不存在"
    fi
    
    echo -e "${CYAN}================================================${NC}"
}

# 主函数
main() {
    # 创建日志目录
    mkdir -p "$LOG_DIR"
    
    # 解析参数
    local follow=false
    local lines=50
    local service=""
    local clean=false
    local info=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--follow)
                follow=true
                shift
                ;;
            -n|--lines)
                lines="$2"
                shift 2
                ;;
            -c|--clean)
                clean=true
                shift
                ;;
            -i|--info)
                info=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            backend|admin|frontend|build|all)
                service="$1"
                shift
                ;;
            *)
                log_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 执行操作
    if [[ "$clean" == "true" ]]; then
        clean_logs
        exit 0
    fi
    
    if [[ "$info" == "true" ]]; then
        show_log_info
        exit 0
    fi
    
    # 默认服务为 all
    if [[ -z "$service" ]]; then
        service="all"
    fi
    
    # 查看日志
    case $service in
        backend)
            view_log "backend" "$follow" "$lines"
            ;;
        admin)
            view_log "admin" "$follow" "$lines"
            ;;
        frontend)
            view_log "frontend" "$follow" "$lines"
            ;;
        build)
            view_log "backend-build" "$follow" "$lines"
            ;;
        all)
            view_all_logs "$follow" "$lines"
            ;;
        *)
            log_error "未知服务: $service"
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
