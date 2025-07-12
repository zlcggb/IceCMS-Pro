#!/bin/bash

# IceCMS Pro 状态检查脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 检查 IceCMS Pro 各服务的运行状态

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
PID_DIR="$PROJECT_ROOT/scripts/pids"

# 检查端口是否被占用
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # 端口被占用
    else
        return 1  # 端口未被占用
    fi
}

# 检查进程是否运行
check_process() {
    local pid_file="$1"
    if [[ -f "$pid_file" ]]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            echo "$pid"
            return 0
        fi
    fi
    return 1
}

# 检查服务健康状态
check_health() {
    local url="$1"
    local timeout=${2:-5}
    
    if command -v curl >/dev/null 2>&1; then
        if curl -s --max-time "$timeout" "$url" >/dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

# 获取进程信息
get_process_info() {
    local pid="$1"
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
        local cpu_mem=$(ps -p "$pid" -o %cpu,%mem --no-headers 2>/dev/null | tr -s ' ')
        local start_time=$(ps -p "$pid" -o lstart --no-headers 2>/dev/null)
        echo "PID: $pid | CPU/MEM: $cpu_mem | 启动时间: $start_time"
    fi
}

# 检查系统依赖
check_dependencies() {
    echo -e "${PURPLE}==================== 系统依赖检查 ====================${NC}"
    
    # Java
    if command -v java >/dev/null 2>&1; then
        local java_version=$(java -version 2>&1 | head -n1 | cut -d'"' -f2)
        echo -e "${GREEN}✓${NC} Java: $java_version"
    else
        echo -e "${RED}✗${NC} Java: 未安装"
    fi
    
    # Maven
    if command -v mvn >/dev/null 2>&1; then
        local mvn_version=$(mvn -version 2>/dev/null | head -n1 | cut -d' ' -f3)
        echo -e "${GREEN}✓${NC} Maven: $mvn_version"
    else
        echo -e "${RED}✗${NC} Maven: 未安装"
    fi
    
    # Node.js
    if command -v node >/dev/null 2>&1; then
        local node_version=$(node --version)
        echo -e "${GREEN}✓${NC} Node.js: $node_version"
    else
        echo -e "${RED}✗${NC} Node.js: 未安装"
    fi
    
    # pnpm
    if command -v pnpm >/dev/null 2>&1; then
        local pnpm_version=$(pnpm --version)
        echo -e "${GREEN}✓${NC} pnpm: $pnpm_version"
    else
        echo -e "${RED}✗${NC} pnpm: 未安装"
    fi
    
    # MySQL
    if brew services list | grep mysql | grep started >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} MySQL: 服务运行中"
    else
        echo -e "${RED}✗${NC} MySQL: 服务未运行"
    fi
    
    # Redis
    if brew services list | grep redis | grep started >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Redis: 服务运行中"
    else
        echo -e "${YELLOW}!${NC} Redis: 服务未运行 (可选)"
    fi
    
    echo
}

# 检查应用服务
check_services() {
    echo -e "${PURPLE}==================== 应用服务状态 ====================${NC}"
    
    # 后端服务
    echo -e "${CYAN}后端服务 (端口 8181):${NC}"
    if check_port 8181; then
        local pid=$(check_process "$PID_DIR/backend.pid")
        if [[ -n "$pid" ]]; then
            echo -e "  ${GREEN}✓${NC} 运行中"
            echo -e "  $(get_process_info "$pid")"
        else
            echo -e "  ${YELLOW}!${NC} 端口被占用但PID文件不存在"
        fi
        
        # 健康检查
        if check_health "http://localhost:8181/actuator/health" 3; then
            echo -e "  ${GREEN}✓${NC} 健康检查通过"
        else
            echo -e "  ${YELLOW}!${NC} 健康检查失败"
        fi
        
        echo -e "  ${BLUE}→${NC} API文档: http://localhost:8181/doc.html"
    else
        echo -e "  ${RED}✗${NC} 未运行"
    fi
    echo
    
    # 管理后台
    echo -e "${CYAN}管理后台 (端口 5173):${NC}"
    if check_port 5173; then
        local pid=$(check_process "$PID_DIR/admin.pid")
        if [[ -n "$pid" ]]; then
            echo -e "  ${GREEN}✓${NC} 运行中"
            echo -e "  $(get_process_info "$pid")"
        else
            echo -e "  ${YELLOW}!${NC} 端口被占用但PID文件不存在"
        fi
        
        # 健康检查
        if check_health "http://localhost:5173" 3; then
            echo -e "  ${GREEN}✓${NC} 页面可访问"
        else
            echo -e "  ${YELLOW}!${NC} 页面无法访问"
        fi
        
        echo -e "  ${BLUE}→${NC} 访问地址: http://localhost:5173"
        echo -e "  ${BLUE}→${NC} 默认账号: admin / admin123"
    else
        echo -e "  ${RED}✗${NC} 未运行"
    fi
    echo
    
    # 用户前台
    echo -e "${CYAN}用户前台 (端口 3000):${NC}"
    if check_port 3000; then
        local pid=$(check_process "$PID_DIR/frontend.pid")
        if [[ -n "$pid" ]]; then
            echo -e "  ${GREEN}✓${NC} 运行中"
            echo -e "  $(get_process_info "$pid")"
        else
            echo -e "  ${YELLOW}!${NC} 端口被占用但PID文件不存在"
        fi
        
        # 健康检查
        if check_health "http://localhost:3000" 3; then
            echo -e "  ${GREEN}✓${NC} 页面可访问"
        else
            echo -e "  ${YELLOW}!${NC} 页面无法访问"
        fi
        
        echo -e "  ${BLUE}→${NC} 访问地址: http://localhost:3000"
    else
        echo -e "  ${RED}✗${NC} 未运行"
    fi
    echo
}

# 检查数据库连接
check_database() {
    echo -e "${PURPLE}==================== 数据库连接检查 ====================${NC}"
    
    # MySQL 连接检查
    if command -v mysql >/dev/null 2>&1; then
        if mysql -u icecmspro -p123456 -e "SELECT 1;" icecmspro >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} MySQL 数据库连接正常"
            
            # 检查表数量
            local table_count=$(mysql -u icecmspro -p123456 -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='icecmspro';" -s -N 2>/dev/null)
            if [[ -n "$table_count" ]]; then
                echo -e "  ${BLUE}→${NC} 数据表数量: $table_count"
            fi
        else
            echo -e "${RED}✗${NC} MySQL 数据库连接失败"
            echo -e "  ${YELLOW}→${NC} 请检查数据库配置和权限"
        fi
    else
        echo -e "${RED}✗${NC} MySQL 客户端未安装"
    fi
    
    # Redis 连接检查
    if command -v redis-cli >/dev/null 2>&1; then
        if redis-cli ping >/dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} Redis 连接正常"
        else
            echo -e "${YELLOW}!${NC} Redis 连接失败 (可选服务)"
        fi
    else
        echo -e "${YELLOW}!${NC} Redis 客户端未安装 (可选服务)"
    fi
    
    echo
}

# 显示系统资源使用情况
show_system_info() {
    echo -e "${PURPLE}==================== 系统资源使用 ====================${NC}"
    
    # CPU 使用率
    local cpu_usage=$(top -l 1 -s 0 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
    echo -e "${CYAN}CPU 使用率:${NC} ${cpu_usage}%"
    
    # 内存使用情况
    local memory_info=$(vm_stat | grep -E "(free|active|inactive|wired)" | awk '{print $3}' | sed 's/\.//' | grep -E '^[0-9]+$')
    local page_size=4096

    if [[ $(echo "$memory_info" | wc -l) -ge 4 ]]; then
        local free_pages=$(echo "$memory_info" | sed -n '1p')
        local active_pages=$(echo "$memory_info" | sed -n '2p')
        local inactive_pages=$(echo "$memory_info" | sed -n '3p')
        local wired_pages=$(echo "$memory_info" | sed -n '4p')

        # 确保所有值都是数字
        if [[ "$free_pages" =~ ^[0-9]+$ ]] && [[ "$active_pages" =~ ^[0-9]+$ ]] && [[ "$inactive_pages" =~ ^[0-9]+$ ]] && [[ "$wired_pages" =~ ^[0-9]+$ ]]; then
            local total_memory=$(( (free_pages + active_pages + inactive_pages + wired_pages) * page_size / 1024 / 1024 ))
            local used_memory=$(( (active_pages + inactive_pages + wired_pages) * page_size / 1024 / 1024 ))
            local memory_percent=$(( used_memory * 100 / total_memory ))
        else
            local total_memory="N/A"
            local used_memory="N/A"
            local memory_percent="N/A"
        fi
    else
        local total_memory="N/A"
        local used_memory="N/A"
        local memory_percent="N/A"
    fi
    
    echo -e "${CYAN}内存使用:${NC} ${used_memory}MB / ${total_memory}MB (${memory_percent}%)"
    
    # 磁盘使用情况
    local disk_usage=$(df -h . | tail -1 | awk '{print $5}' | sed 's/%//')
    echo -e "${CYAN}磁盘使用:${NC} ${disk_usage}%"
    
    echo
}

# 主函数
main() {
    echo "=================================================="
    echo "         IceCMS Pro 状态检查报告"
    echo "=================================================="
    echo
    
    check_dependencies
    check_services
    check_database
    show_system_info
    
    echo "=================================================="
    echo "检查完成！"
    echo
    echo "常用命令:"
    echo "  启动所有服务: ./scripts/start-all.sh"
    echo "  停止所有服务: ./scripts/stop-all.sh"
    echo "  查看日志: ./scripts/logs.sh"
    echo "=================================================="
}

# 执行主函数
main "$@"
