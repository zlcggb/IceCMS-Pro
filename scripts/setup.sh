#!/bin/bash

# IceCMS Pro 快速设置脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 设置脚本权限并提供快速操作菜单

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
SCRIPTS_DIR="$PROJECT_ROOT/scripts"

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

# 设置脚本权限
setup_permissions() {
    log_info "设置脚本执行权限..."
    
    # 设置所有 .sh 文件的执行权限
    find "$SCRIPTS_DIR" -name "*.sh" -exec chmod +x {} \;
    
    log_success "脚本权限设置完成"
}

# 显示项目信息
show_project_info() {
    echo -e "${PURPLE}==================== IceCMS Pro 项目信息 ====================${NC}"
    echo -e "${CYAN}项目名称:${NC} IceCMS Pro"
    echo -e "${CYAN}项目类型:${NC} 内容管理系统 (CMS)"
    echo -e "${CYAN}架构:${NC} 前后端分离"
    echo -e "${CYAN}后端技术:${NC} Spring Boot + MyBatis Plus + MySQL"
    echo -e "${CYAN}前端技术:${NC} Vue 3 + Nuxt 3 + Element Plus"
    echo -e "${CYAN}项目目录:${NC} $PROJECT_ROOT"
    echo
}

# 显示可用脚本
show_available_scripts() {
    echo -e "${PURPLE}==================== 可用脚本 ====================${NC}"
    echo -e "${GREEN}1.${NC} install-dependencies.sh - 一键安装所有依赖"
    echo -e "${GREEN}2.${NC} start-all.sh           - 一键启动所有服务"
    echo -e "${GREEN}3.${NC} stop-all.sh            - 停止所有服务"
    echo -e "${GREEN}4.${NC} status.sh              - 检查服务状态"
    echo -e "${GREEN}5.${NC} logs.sh                - 查看服务日志"
    echo
}

# 显示快速操作菜单
show_menu() {
    echo -e "${PURPLE}==================== 快速操作菜单 ====================${NC}"
    echo -e "${GREEN}1.${NC} 安装依赖"
    echo -e "${GREEN}2.${NC} 启动所有服务"
    echo -e "${GREEN}3.${NC} 停止所有服务"
    echo -e "${GREEN}4.${NC} 查看服务状态"
    echo -e "${GREEN}5.${NC} 查看日志"
    echo -e "${GREEN}6.${NC} 重启所有服务"
    echo -e "${GREEN}7.${NC} 打开浏览器访问服务"
    echo -e "${GREEN}8.${NC} 显示帮助信息"
    echo -e "${GREEN}0.${NC} 退出"
    echo
}

# 安装依赖
install_dependencies() {
    log_info "开始安装依赖..."
    "$SCRIPTS_DIR/install-dependencies.sh"
}

# 启动所有服务
start_services() {
    log_info "启动所有服务..."
    "$SCRIPTS_DIR/start-all.sh"
}

# 停止所有服务
stop_services() {
    log_info "停止所有服务..."
    "$SCRIPTS_DIR/stop-all.sh"
}

# 查看服务状态
check_status() {
    "$SCRIPTS_DIR/status.sh"
}

# 查看日志
view_logs() {
    echo "选择要查看的日志:"
    echo "1. 后端日志"
    echo "2. 管理后台日志"
    echo "3. 用户前台日志"
    echo "4. 所有日志"
    echo "5. 实时跟踪所有日志"
    read -p "请选择 (1-5): " log_choice
    
    case $log_choice in
        1) "$SCRIPTS_DIR/logs.sh" backend ;;
        2) "$SCRIPTS_DIR/logs.sh" admin ;;
        3) "$SCRIPTS_DIR/logs.sh" frontend ;;
        4) "$SCRIPTS_DIR/logs.sh" all ;;
        5) "$SCRIPTS_DIR/logs.sh" -f all ;;
        *) log_error "无效选择" ;;
    esac
}

# 重启所有服务
restart_services() {
    log_info "重启所有服务..."
    "$SCRIPTS_DIR/stop-all.sh"
    sleep 3
    "$SCRIPTS_DIR/start-all.sh"
}

# 打开浏览器
open_browser() {
    echo "选择要打开的服务:"
    echo "1. 后端 API 文档 (http://localhost:8181/doc.html)"
    echo "2. 管理后台 (http://localhost:5173)"
    echo "3. 用户前台 (http://localhost:3000)"
    echo "4. 打开所有"
    read -p "请选择 (1-4): " browser_choice
    
    case $browser_choice in
        1) 
            log_info "打开 API 文档..."
            open "http://localhost:8181/doc.html" 2>/dev/null || log_warning "请手动访问: http://localhost:8181/doc.html"
            ;;
        2) 
            log_info "打开管理后台..."
            open "http://localhost:5173" 2>/dev/null || log_warning "请手动访问: http://localhost:5173"
            ;;
        3) 
            log_info "打开用户前台..."
            open "http://localhost:3000" 2>/dev/null || log_warning "请手动访问: http://localhost:3000"
            ;;
        4)
            log_info "打开所有服务..."
            open "http://localhost:8181/doc.html" 2>/dev/null &
            open "http://localhost:5173" 2>/dev/null &
            open "http://localhost:3000" 2>/dev/null &
            ;;
        *) log_error "无效选择" ;;
    esac
}

# 显示帮助信息
show_help() {
    echo -e "${PURPLE}==================== 帮助信息 ====================${NC}"
    echo
    echo -e "${CYAN}快速开始:${NC}"
    echo "1. 首次使用请先运行: 安装依赖"
    echo "2. 然后运行: 启动所有服务"
    echo "3. 访问管理后台: http://localhost:5173 (admin/admin123)"
    echo "4. 访问用户前台: http://localhost:3000"
    echo "5. 查看 API 文档: http://localhost:8181/doc.html"
    echo
    echo -e "${CYAN}常见问题:${NC}"
    echo "• 如果端口被占用，请先停止相关服务"
    echo "• 如果启动失败，请查看日志文件排查问题"
    echo "• 确保 MySQL 和 Redis 服务正在运行"
    echo "• 数据库默认配置: icecmspro/123456"
    echo
    echo -e "${CYAN}目录结构:${NC}"
    echo "• IceCMS-main/          - 后端服务"
    echo "• IceCMS-front-admin/   - 管理后台"
    echo "• IceCMS-front-nuxt3/   - 用户前台"
    echo "• scripts/              - 脚本文件"
    echo "• logs/                 - 日志文件"
    echo
    echo -e "${CYAN}技术支持:${NC}"
    echo "• 官方文档: https://doc.icecms.cn"
    echo "• QQ交流群: 951286996"
    echo "• GitHub: https://github.com/Thecosy/IceCMS"
    echo
}

# 主函数
main() {
    # 设置脚本权限
    setup_permissions
    
    # 显示项目信息
    show_project_info
    
    # 如果有参数，直接执行对应操作
    if [[ $# -gt 0 ]]; then
        case $1 in
            install) install_dependencies ;;
            start) start_services ;;
            stop) stop_services ;;
            status) check_status ;;
            logs) view_logs ;;
            restart) restart_services ;;
            help) show_help ;;
            *) 
                log_error "未知参数: $1"
                show_help
                ;;
        esac
        return
    fi
    
    # 显示可用脚本
    show_available_scripts
    
    # 交互式菜单
    while true; do
        show_menu
        read -p "请选择操作 (0-8): " choice
        
        case $choice in
            1) install_dependencies ;;
            2) start_services ;;
            3) stop_services ;;
            4) check_status ;;
            5) view_logs ;;
            6) restart_services ;;
            7) open_browser ;;
            8) show_help ;;
            0) 
                log_info "退出程序"
                exit 0
                ;;
            *) 
                log_error "无效选择，请重新输入"
                ;;
        esac
        
        echo
        read -p "按回车键继续..." -r
        echo
    done
}

# 显示欢迎信息
echo "=================================================="
echo "         IceCMS Pro 快速设置脚本"
echo "=================================================="
echo

# 执行主函数
main "$@"
