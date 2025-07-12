#!/bin/bash

# Lombok 编译问题修复脚本
# 解决 Maven 编译时 Lombok 注解处理问题

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

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

# 修复 Maven 编译器配置
fix_maven_compiler() {
    log_info "修复 Maven 编译器配置..."
    
    # 检查根 pom.xml
    local root_pom="$PROJECT_ROOT/pom.xml"
    if [[ -f "$root_pom" ]]; then
        log_info "更新根 pom.xml 的编译器配置..."
        
        # 备份原文件
        cp "$root_pom" "$root_pom.backup"
        
        # 检查是否已有 maven-compiler-plugin 配置
        if grep -q "maven-compiler-plugin" "$root_pom"; then
            log_info "更新现有的 maven-compiler-plugin 配置..."
            # 使用 sed 更新配置
            sed -i.tmp '/<plugin>/,/<\/plugin>/{
                /<groupId>org.apache.maven.plugins<\/groupId>/,/<\/plugin>/{
                    /<artifactId>maven-compiler-plugin<\/artifactId>/,/<\/plugin>/{
                        /<configuration>/,/<\/configuration>/{
                            s/<source>.*<\/source>/<source>1.8<\/source>/
                            s/<target>.*<\/target>/<target>1.8<\/target>/
                            /<\/target>/a\
                    <annotationProcessorPaths>\
                        <path>\
                            <groupId>org.projectlombok<\/groupId>\
                            <artifactId>lombok<\/artifactId>\
                            <version>1.18.24<\/version>\
                        <\/path>\
                    <\/annotationProcessorPaths>
                        }
                    }
                }
            }' "$root_pom"
            rm -f "$root_pom.tmp"
        fi
    fi
    
    # 修复子模块的 pom.xml
    for module in "IceCMS-ment" "IceCMS-main" "IcePay-ment"; do
        local module_pom="$PROJECT_ROOT/$module/pom.xml"
        if [[ -f "$module_pom" ]]; then
            log_info "修复 $module 的 pom.xml..."
            
            # 备份原文件
            cp "$module_pom" "$module_pom.backup"
            
            # 检查是否需要添加 Lombok 依赖
            if ! grep -q "lombok" "$module_pom"; then
                log_info "为 $module 添加 Lombok 依赖..."
                # 在 dependencies 部分添加 Lombok
                sed -i.tmp '/<\/dependencies>/i\
        <dependency>\
            <groupId>org.projectlombok<\/groupId>\
            <artifactId>lombok<\/artifactId>\
            <version>1.18.24<\/version>\
            <scope>provided<\/scope>\
        <\/dependency>' "$module_pom"
                rm -f "$module_pom.tmp"
            fi
        fi
    done
    
    log_success "Maven 配置修复完成"
}

# 清理 Maven 缓存
clean_maven_cache() {
    log_info "清理 Maven 缓存..."
    
    cd "$PROJECT_ROOT"
    
    # 清理编译输出
    mvn clean > /dev/null 2>&1
    
    # 清理本地仓库中的项目依赖
    rm -rf ~/.m2/repository/com/ttice/
    
    log_success "Maven 缓存清理完成"
}

# 重新编译项目
rebuild_project() {
    log_info "重新编译项目..."
    
    cd "$PROJECT_ROOT"
    
    # 首先编译父项目
    log_info "编译父项目..."
    if mvn clean install -N -DskipTests; then
        log_success "父项目编译成功"
    else
        log_error "父项目编译失败"
        return 1
    fi
    
    # 按顺序编译子模块
    local modules=("IceCMS-ment" "IcePay-ment" "IceCMS-main")
    
    for module in "${modules[@]}"; do
        if [[ -d "$PROJECT_ROOT/$module" ]]; then
            log_info "编译模块: $module..."
            cd "$PROJECT_ROOT/$module"
            
            if mvn clean compile -DskipTests; then
                log_success "模块 $module 编译成功"
            else
                log_error "模块 $module 编译失败"
                return 1
            fi
            
            cd "$PROJECT_ROOT"
        fi
    done
    
    # 最后打包主模块
    log_info "打包主模块..."
    cd "$PROJECT_ROOT/IceCMS-main"
    if mvn package -DskipTests; then
        log_success "主模块打包成功"
    else
        log_error "主模块打包失败"
        return 1
    fi
    
    cd "$PROJECT_ROOT"
    log_success "项目编译完成"
}

# 验证编译结果
verify_build() {
    log_info "验证编译结果..."
    
    local jar_file="$PROJECT_ROOT/IceCMS-main/target/main.jar"
    if [[ -f "$jar_file" ]]; then
        log_success "找到编译后的 JAR 文件: $jar_file"
        
        # 检查 JAR 文件大小
        local size=$(du -h "$jar_file" | cut -f1)
        log_info "JAR 文件大小: $size"
        
        return 0
    else
        log_error "未找到编译后的 JAR 文件"
        return 1
    fi
}

# 主函数
main() {
    echo "=================================================="
    echo "         Lombok 编译问题修复脚本"
    echo "=================================================="
    echo
    
    # 检查是否在正确的目录
    if [[ ! -f "$PROJECT_ROOT/pom.xml" ]]; then
        log_error "未找到项目根目录的 pom.xml 文件"
        exit 1
    fi
    
    # 修复 Maven 配置
    fix_maven_compiler
    
    # 清理缓存
    clean_maven_cache
    
    # 重新编译
    if rebuild_project; then
        # 验证编译结果
        if verify_build; then
            echo
            log_success "Lombok 编译问题修复成功！"
            echo
            echo "现在可以启动应用了："
            echo "cd IceCMS-main && java -jar target/main.jar"
            echo "或者运行: ./scripts/start-all.sh"
        else
            log_error "编译验证失败"
            exit 1
        fi
    else
        log_error "项目编译失败"
        echo
        echo "请检查以下可能的问题："
        echo "1. Java 版本是否正确 (需要 JDK 8+)"
        echo "2. Maven 版本是否兼容"
        echo "3. 网络连接是否正常 (下载依赖)"
        echo "4. 磁盘空间是否充足"
        exit 1
    fi
}

# 执行主函数
main "$@"
