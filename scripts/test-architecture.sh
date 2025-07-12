#!/bin/bash

# IceCMS Pro 架构测试脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 测试不同架构下的安装和运行情况

# 加载配置文件
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/config.sh"

# 测试 Java 安装
test_java() {
    log_step "测试 Java 环境..."
    
    if command_exists java; then
        JAVA_VERSION=$(java -version 2>&1 | head -n1 | awk -F '"' '{print $2}')
        log_success "Java 版本: $JAVA_VERSION"
        
        # 测试 Java 编译
        echo 'public class Test { public static void main(String[] args) { System.out.println("Java OK"); } }' > Test.java
        if javac Test.java && java Test; then
            log_success "Java 编译和运行测试通过"
        else
            log_error "Java 编译或运行测试失败"
        fi
        rm -f Test.java Test.class
    else
        log_error "Java 未安装"
        return 1
    fi
}

# 测试 Node.js 环境
test_nodejs() {
    log_step "测试 Node.js 环境..."
    
    if command_exists node; then
        NODE_VERSION=$(node -v)
        log_success "Node.js 版本: $NODE_VERSION"
        
        # 测试 Node.js 运行
        echo 'console.log("Node.js OK");' > test.js
        if node test.js; then
            log_success "Node.js 运行测试通过"
        else
            log_error "Node.js 运行测试失败"
        fi
        rm -f test.js
        
        # 测试包管理器
        if command_exists pnpm; then
            PNPM_VERSION=$(pnpm -v)
            log_success "pnpm 版本: $PNPM_VERSION"
        elif command_exists npm; then
            NPM_VERSION=$(npm -v)
            log_success "npm 版本: $NPM_VERSION"
        else
            log_warning "未找到包管理器"
        fi
    else
        log_error "Node.js 未安装"
        return 1
    fi
}

# 测试数据库连接
test_database() {
    log_step "测试数据库连接..."
    
    if command_exists mysql; then
        # 测试 MySQL 连接
        if mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1;" 2>/dev/null; then
            log_success "MySQL root 连接测试通过"
        else
            log_warning "MySQL root 连接失败，尝试无密码连接"
            if mysql -u root -e "SELECT 1;" 2>/dev/null; then
                log_success "MySQL 无密码连接成功"
            else
                log_error "MySQL 连接失败"
            fi
        fi
        
        # 测试应用数据库连接
        if mysql -u "$MYSQL_DB_USER" -p"$MYSQL_DB_PASSWORD" "$MYSQL_DB_NAME" -e "SELECT 1;" 2>/dev/null; then
            log_success "应用数据库连接测试通过"
        else
            log_warning "应用数据库连接失败"
        fi
    else
        log_error "MySQL 未安装"
        return 1
    fi
}

# 测试后端编译
test_backend_build() {
    log_step "测试后端编译..."
    
    if [[ -d "$BACKEND_DIR" ]]; then
        cd "$BACKEND_DIR"
        
        # 检查 Maven 配置
        if [[ -f "pom.xml" ]]; then
            log_info "检查 Maven 配置..."
            if mvn validate; then
                log_success "Maven 配置验证通过"
            else
                log_error "Maven 配置验证失败"
                cd "$PROJECT_ROOT"
                return 1
            fi
            
            # 测试编译
            log_info "测试编译（跳过测试）..."
            if mvn clean compile -DskipTests; then
                log_success "后端编译测试通过"
            else
                log_error "后端编译测试失败"
                cd "$PROJECT_ROOT"
                return 1
            fi
        else
            log_error "未找到 pom.xml 文件"
            cd "$PROJECT_ROOT"
            return 1
        fi
        
        cd "$PROJECT_ROOT"
    else
        log_error "后端目录不存在: $BACKEND_DIR"
        return 1
    fi
}

# 测试前端依赖
test_frontend_deps() {
    log_step "测试前端依赖..."
    
    # 测试管理后台
    if [[ -d "$ADMIN_DIR" ]]; then
        cd "$ADMIN_DIR"
        log_info "测试管理后台依赖..."
        
        if [[ -d "node_modules" ]]; then
            log_success "管理后台依赖已安装"
        else
            log_warning "管理后台依赖未安装"
        fi
        cd "$PROJECT_ROOT"
    fi
    
    # 测试用户前台
    if [[ -d "$FRONTEND_DIR" ]]; then
        cd "$FRONTEND_DIR"
        log_info "测试用户前台依赖..."
        
        if [[ -d "node_modules" ]]; then
            log_success "用户前台依赖已安装"
            
            # 测试关键依赖
            if [[ -f "node_modules/nuxt/package.json" ]]; then
                log_success "Nuxt 核心依赖正常"
            else
                log_warning "Nuxt 核心依赖缺失"
            fi
        else
            log_warning "用户前台依赖未安装"
        fi
        cd "$PROJECT_ROOT"
    fi
}

# 测试端口可用性
test_ports() {
    log_step "测试端口可用性..."
    
    local ports=(8181 2580 3000)
    for port in "${ports[@]}"; do
        if ss -tuln | grep ":$port " >/dev/null 2>&1; then
            log_warning "端口 $port 已被占用"
        else
            log_success "端口 $port 可用"
        fi
    done
}

# 测试系统资源
test_system_resources() {
    log_step "测试系统资源..."
    
    # 内存测试
    if [[ -f /proc/meminfo ]]; then
        TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
        AVAIL_MEM=$(grep MemAvailable /proc/meminfo | awk '{print int($2/1024)}')
        
        log_info "总内存: ${TOTAL_MEM}MB"
        log_info "可用内存: ${AVAIL_MEM}MB"
        
        if [[ $AVAIL_MEM -gt 1024 ]]; then
            log_success "内存充足"
        elif [[ $AVAIL_MEM -gt 512 ]]; then
            log_warning "内存适中，建议关闭不必要的服务"
        else
            log_error "内存不足，可能影响运行"
        fi
    fi
    
    # 磁盘空间测试
    DISK_AVAIL=$(df -h / | awk 'NR==2 {print $4}')
    log_info "可用磁盘空间: $DISK_AVAIL"
    
    # CPU 测试
    CPU_CORES=$(nproc)
    log_info "CPU 核心数: $CPU_CORES"
}

# 生成测试报告
generate_report() {
    echo
    echo "=================================================="
    echo "         架构测试报告"
    echo "=================================================="
    echo
    echo "🖥️  系统信息："
    echo "  - 架构: $(uname -m)"
    echo "  - 内核: $(uname -r)"
    echo "  - 发行版: $(lsb_release -d 2>/dev/null | cut -f2 || echo "未知")"
    echo
    echo "📊 测试结果："
    echo "  - Java 环境: $JAVA_TEST_RESULT"
    echo "  - Node.js 环境: $NODEJS_TEST_RESULT"
    echo "  - 数据库连接: $DATABASE_TEST_RESULT"
    echo "  - 后端编译: $BACKEND_TEST_RESULT"
    echo "  - 前端依赖: $FRONTEND_TEST_RESULT"
    echo
    echo "💡 建议："
    if [[ "$JAVA_TEST_RESULT" == "❌" ]]; then
        echo "  - 需要安装或修复 Java 环境"
    fi
    if [[ "$NODEJS_TEST_RESULT" == "❌" ]]; then
        echo "  - 需要安装或修复 Node.js 环境"
    fi
    if [[ "$DATABASE_TEST_RESULT" == "❌" ]]; then
        echo "  - 需要安装或配置数据库"
    fi
    echo "=================================================="
}

# 主函数
main() {
    echo "=================================================="
    echo "         IceCMS Pro 架构兼容性测试"
    echo "=================================================="
    echo
    
    # 初始化测试结果
    JAVA_TEST_RESULT="❌"
    NODEJS_TEST_RESULT="❌"
    DATABASE_TEST_RESULT="❌"
    BACKEND_TEST_RESULT="❌"
    FRONTEND_TEST_RESULT="❌"
    
    # 运行测试
    if test_java; then JAVA_TEST_RESULT="✅"; fi
    if test_nodejs; then NODEJS_TEST_RESULT="✅"; fi
    if test_database; then DATABASE_TEST_RESULT="✅"; fi
    if test_backend_build; then BACKEND_TEST_RESULT="✅"; fi
    if test_frontend_deps; then FRONTEND_TEST_RESULT="✅"; fi
    
    test_ports
    test_system_resources
    
    # 生成报告
    generate_report
}

# 执行主函数
main "$@"
