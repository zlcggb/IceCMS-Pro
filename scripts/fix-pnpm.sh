#!/bin/bash

# pnpm 安装修复脚本
# 解决 npm 权限问题并安装 pnpm

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 方法1: 使用官方安装脚本
install_pnpm_official() {
    log_info "方法1: 使用 pnpm 官方安装脚本..."
    
    if curl -fsSL https://get.pnpm.io/install.sh | sh -; then
        # 添加 pnpm 到 PATH
        export PNPM_HOME="$HOME/.local/share/pnpm"
        export PATH="$PNPM_HOME:$PATH"
        
        # 添加到 shell 配置文件
        add_to_shell_config 'export PNPM_HOME="$HOME/.local/share/pnpm"'
        add_to_shell_config 'export PATH="$PNPM_HOME:$PATH"'
        
        # 重新加载环境变量
        source_shell_config
        
        if command_exists pnpm; then
            log_success "pnpm 通过官方脚本安装成功"
            return 0
        fi
    fi
    
    log_warning "官方脚本安装失败"
    return 1
}

# 方法2: 修复 npm 权限并安装
install_pnpm_npm() {
    log_info "方法2: 修复 npm 权限并安装 pnpm..."
    
    # 检查当前 npm 配置
    local npm_prefix=$(npm config get prefix 2>/dev/null || echo "/usr/local")
    log_info "当前 npm prefix: $npm_prefix"
    
    if [[ "$npm_prefix" == "/usr/local" ]] || [[ "$npm_prefix" == "/usr/local/lib/node_modules" ]]; then
        log_info "检测到权限问题，修复 npm 配置..."
        
        # 创建用户级别的 npm 目录
        mkdir -p "$HOME/.npm-global"
        
        # 设置 npm 全局安装目录
        npm config set prefix "$HOME/.npm-global"
        
        # 添加到 PATH
        export PATH="$HOME/.npm-global/bin:$PATH"
        
        # 添加到 shell 配置文件
        add_to_shell_config 'export PATH="$HOME/.npm-global/bin:$PATH"'
        
        log_success "npm 权限配置已修复"
    fi
    
    # 尝试安装 pnpm
    log_info "安装 pnpm..."
    if npm install -g pnpm@8.6.10; then
        # 重新加载环境变量
        source_shell_config
        
        if command_exists pnpm; then
            log_success "pnpm 通过 npm 安装成功"
            return 0
        fi
    fi
    
    log_warning "npm 安装失败"
    return 1
}

# 方法3: 使用 Homebrew
install_pnpm_brew() {
    log_info "方法3: 使用 Homebrew 安装 pnpm..."
    
    if command_exists brew; then
        if brew install pnpm; then
            if command_exists pnpm; then
                log_success "pnpm 通过 Homebrew 安装成功"
                return 0
            fi
        fi
    else
        log_warning "Homebrew 未安装，跳过此方法"
    fi
    
    log_warning "Homebrew 安装失败"
    return 1
}

# 方法4: 使用 Corepack
install_pnpm_corepack() {
    log_info "方法4: 使用 Corepack 安装 pnpm..."
    
    if command_exists corepack; then
        # 启用 corepack
        corepack enable
        
        # 准备 pnpm
        if corepack prepare pnpm@8.6.10 --activate; then
            if command_exists pnpm; then
                log_success "pnpm 通过 Corepack 安装成功"
                return 0
            fi
        fi
    else
        log_warning "Corepack 不可用，跳过此方法"
    fi
    
    log_warning "Corepack 安装失败"
    return 1
}

# 方法5: 手动下载安装
install_pnpm_manual() {
    log_info "方法5: 手动下载安装 pnpm..."
    
    local pnpm_dir="$HOME/.local/share/pnpm"
    mkdir -p "$pnpm_dir"
    
    # 检测系统架构
    local arch=""
    case $(uname -m) in
        x86_64) arch="x64" ;;
        arm64) arch="arm64" ;;
        *) 
            log_error "不支持的系统架构: $(uname -m)"
            return 1
            ;;
    esac
    
    local download_url="https://github.com/pnpm/pnpm/releases/latest/download/pnpm-macos-${arch}"
    
    log_info "下载 pnpm 二进制文件..."
    if curl -L -o "$pnpm_dir/pnpm" "$download_url"; then
        chmod +x "$pnpm_dir/pnpm"
        
        # 添加到 PATH
        export PATH="$pnpm_dir:$PATH"
        add_to_shell_config "export PATH=\"$pnpm_dir:\$PATH\""
        
        # 重新加载环境变量
        source_shell_config
        
        if command_exists pnpm; then
            log_success "pnpm 手动安装成功"
            return 0
        fi
    fi
    
    log_warning "手动安装失败"
    return 1
}

# 添加配置到 shell 配置文件
add_to_shell_config() {
    local config_line="$1"
    local shell_config=""
    
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_config="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_config="$HOME/.bash_profile"
    fi
    
    if [[ -n "$shell_config" ]]; then
        if ! grep -Fxq "$config_line" "$shell_config" 2>/dev/null; then
            echo "$config_line" >> "$shell_config"
            log_info "已添加配置到 $shell_config"
        fi
    fi
}

# 重新加载 shell 配置
source_shell_config() {
    if [[ "$SHELL" == *"zsh"* ]] && [[ -f "$HOME/.zshrc" ]]; then
        source "$HOME/.zshrc" 2>/dev/null || true
    elif [[ "$SHELL" == *"bash"* ]] && [[ -f "$HOME/.bash_profile" ]]; then
        source "$HOME/.bash_profile" 2>/dev/null || true
    fi
}

# 清理之前失败的安装
cleanup_failed_install() {
    log_info "清理之前失败的安装..."
    
    # 清理 npm 缓存
    npm cache clean --force 2>/dev/null || true
    
    # 清理可能的残留文件
    sudo rm -rf /usr/local/lib/node_modules/pnpm 2>/dev/null || true
    sudo rm -rf /usr/local/bin/pnpm* 2>/dev/null || true
}

# 验证安装
verify_installation() {
    log_info "验证 pnpm 安装..."
    
    if command_exists pnpm; then
        local version=$(pnpm --version 2>/dev/null)
        log_success "pnpm 安装成功，版本: $version"
        
        # 测试 pnpm 功能
        log_info "测试 pnpm 功能..."
        if pnpm --help >/dev/null 2>&1; then
            log_success "pnpm 功能正常"
            return 0
        else
            log_error "pnpm 功能异常"
            return 1
        fi
    else
        log_error "pnpm 安装失败"
        return 1
    fi
}

# 主函数
main() {
    echo "=================================================="
    echo "         pnpm 安装修复脚本"
    echo "=================================================="
    echo
    
    # 检查是否已安装
    if command_exists pnpm; then
        local version=$(pnpm --version 2>/dev/null)
        log_success "pnpm 已安装，版本: $version"
        exit 0
    fi
    
    # 检查 Node.js
    if ! command_exists node; then
        log_error "Node.js 未安装，请先安装 Node.js"
        exit 1
    fi
    
    log_info "Node.js 版本: $(node --version)"
    log_info "npm 版本: $(npm --version)"
    
    # 清理之前失败的安装
    cleanup_failed_install
    
    # 尝试不同的安装方法
    local methods=(
        "install_pnpm_official"
        "install_pnpm_npm" 
        "install_pnpm_brew"
        "install_pnpm_corepack"
        "install_pnpm_manual"
    )
    
    for method in "${methods[@]}"; do
        echo
        if $method; then
            break
        fi
        log_warning "方法失败，尝试下一个..."
    done
    
    echo
    echo "=================================================="
    
    # 验证安装
    if verify_installation; then
        echo
        log_success "pnpm 安装完成！"
        echo
        echo "请重新启动终端或运行以下命令来刷新环境变量："
        echo "source ~/.zshrc  # 如果使用 zsh"
        echo "source ~/.bash_profile  # 如果使用 bash"
        echo
    else
        echo
        log_error "所有安装方法都失败了"
        echo
        echo "请尝试手动安装："
        echo "1. 访问 https://pnpm.io/installation"
        echo "2. 或运行: curl -fsSL https://get.pnpm.io/install.sh | sh -"
        echo "3. 或使用 Homebrew: brew install pnpm"
        echo
        exit 1
    fi
}

# 执行主函数
main "$@"
