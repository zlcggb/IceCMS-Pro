#!/bin/bash

# IceCMS Pro 系统检测脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 检测系统架构、设备类型和兼容性

# 加载配置文件
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/config.sh"

# 检测系统架构
detect_architecture() {
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            SYSTEM_ARCH="x64"
            ARCH_DESC="Intel/AMD 64位"
            COMPATIBILITY="优秀"
            ;;
        aarch64|arm64)
            SYSTEM_ARCH="arm64"
            ARCH_DESC="ARM 64位"
            COMPATIBILITY="良好"
            ;;
        armv7l|armhf)
            SYSTEM_ARCH="arm32"
            ARCH_DESC="ARM 32位"
            COMPATIBILITY="基本"
            ;;
        *)
            SYSTEM_ARCH="unknown"
            ARCH_DESC="未知架构"
            COMPATIBILITY="未知"
            ;;
    esac
}

# 检测设备类型
detect_device() {
    DEVICE_TYPE="generic"
    DEVICE_DESC="通用设备"
    
    # 检测树莓派
    if [[ -f /proc/device-tree/model ]]; then
        MODEL=$(cat /proc/device-tree/model 2>/dev/null)
        if [[ "$MODEL" == *"Raspberry Pi"* ]]; then
            DEVICE_TYPE="raspberry_pi"
            DEVICE_DESC="树莓派 ($MODEL)"
            
            # 检测树莓派版本
            if [[ "$MODEL" == *"Pi 5"* ]]; then
                PI_VERSION="5"
                PERFORMANCE="高"
            elif [[ "$MODEL" == *"Pi 4"* ]]; then
                PI_VERSION="4"
                PERFORMANCE="中高"
            elif [[ "$MODEL" == *"Pi 3"* ]]; then
                PI_VERSION="3"
                PERFORMANCE="中等"
            else
                PI_VERSION="其他"
                PERFORMANCE="基本"
            fi
        fi
    fi
    
    # 检测 Jetson 设备
    if [[ -f /etc/nv_tegra_release ]] || [[ -f /proc/device-tree/model ]] && grep -q "NVIDIA" /proc/device-tree/model 2>/dev/null; then
        DEVICE_TYPE="jetson"
        if [[ -f /proc/device-tree/model ]]; then
            MODEL=$(cat /proc/device-tree/model 2>/dev/null)
            DEVICE_DESC="NVIDIA Jetson ($MODEL)"
        else
            DEVICE_DESC="NVIDIA Jetson"
        fi
        PERFORMANCE="高"
    fi
    
    # 检测云服务商
    if [[ -f /sys/class/dmi/id/sys_vendor ]]; then
        VENDOR=$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)
        case "$VENDOR" in
            *"Alibaba"*)
                DEVICE_TYPE="aliyun"
                DEVICE_DESC="阿里云服务器"
                PERFORMANCE="高"
                ;;
            *"Amazon"*|*"AWS"*)
                DEVICE_TYPE="aws"
                DEVICE_DESC="AWS EC2"
                PERFORMANCE="高"
                ;;
            *"Microsoft"*)
                DEVICE_TYPE="azure"
                DEVICE_DESC="Azure 虚拟机"
                PERFORMANCE="高"
                ;;
            *"Google"*)
                DEVICE_TYPE="gcp"
                DEVICE_DESC="Google Cloud"
                PERFORMANCE="高"
                ;;
            *"Tencent"*)
                DEVICE_TYPE="tencent"
                DEVICE_DESC="腾讯云"
                PERFORMANCE="高"
                ;;
        esac
    fi
    
    # 如果还是通用设备，尝试其他检测方式
    if [[ "$DEVICE_TYPE" == "generic" ]]; then
        # 检测虚拟化
        if [[ -f /proc/cpuinfo ]]; then
            if grep -q "hypervisor" /proc/cpuinfo; then
                DEVICE_DESC="虚拟机"
                PERFORMANCE="中高"
            fi
        fi
    fi
}

# 检测系统资源
detect_resources() {
    # 内存
    if [[ -f /proc/meminfo ]]; then
        TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
        if [[ $TOTAL_MEM -gt 4096 ]]; then
            MEM_STATUS="充足 (${TOTAL_MEM}MB)"
        elif [[ $TOTAL_MEM -gt 2048 ]]; then
            MEM_STATUS="适中 (${TOTAL_MEM}MB)"
        else
            MEM_STATUS="有限 (${TOTAL_MEM}MB)"
        fi
    else
        MEM_STATUS="未知"
    fi
    
    # CPU 核心数
    CPU_CORES=$(nproc)
    if [[ $CPU_CORES -gt 4 ]]; then
        CPU_STATUS="多核 (${CPU_CORES}核)"
    elif [[ $CPU_CORES -gt 2 ]]; then
        CPU_STATUS="四核 (${CPU_CORES}核)"
    else
        CPU_STATUS="双核 (${CPU_CORES}核)"
    fi
    
    # 存储空间
    DISK_SPACE=$(df -h / | awk 'NR==2 {print $4}')
    DISK_STATUS="可用 $DISK_SPACE"
}

# 检测软件兼容性
check_compatibility() {
    JAVA_COMPAT="未知"
    NODE_COMPAT="未知"
    MYSQL_COMPAT="未知"
    
    # Java 兼容性
    if command_exists java; then
        JAVA_VERSION=$(java -version 2>&1 | head -n1 | awk -F '"' '{print $2}')
        if [[ "$JAVA_VERSION" =~ ^11\. ]] || [[ "$JAVA_VERSION" =~ ^17\. ]]; then
            JAVA_COMPAT="✅ 兼容 ($JAVA_VERSION)"
        elif [[ "$JAVA_VERSION" =~ ^1\.8\. ]]; then
            JAVA_COMPAT="⚠️ 可用 ($JAVA_VERSION)"
        else
            JAVA_COMPAT="❌ 不兼容 ($JAVA_VERSION)"
        fi
    else
        JAVA_COMPAT="❌ 未安装"
    fi
    
    # Node.js 兼容性
    if command_exists node; then
        NODE_VERSION=$(node -v | sed 's/v//')
        if [[ "${NODE_VERSION%%.*}" -ge 18 ]]; then
            NODE_COMPAT="✅ 兼容 (v$NODE_VERSION)"
        elif [[ "${NODE_VERSION%%.*}" -ge 16 ]]; then
            NODE_COMPAT="⚠️ 可用 (v$NODE_VERSION)"
        else
            NODE_COMPAT="❌ 版本过低 (v$NODE_VERSION)"
        fi
    else
        NODE_COMPAT="❌ 未安装"
    fi
    
    # MySQL 兼容性
    if command_exists mysql; then
        MYSQL_COMPAT="✅ 已安装"
    else
        MYSQL_COMPAT="❌ 未安装"
    fi
}

# 生成建议
generate_recommendations() {
    RECOMMENDATIONS=()
    
    case $SYSTEM_ARCH in
        "arm32")
            RECOMMENDATIONS+=("• 建议增加 swap 空间至少 1GB")
            RECOMMENDATIONS+=("• 使用轻量化配置启动服务")
            RECOMMENDATIONS+=("• 考虑关闭不必要的系统服务")
            ;;
        "arm64")
            if [[ "$DEVICE_TYPE" == "raspberry_pi" ]]; then
                RECOMMENDATIONS+=("• 使用高速 SD 卡 (Class 10+)")
                RECOMMENDATIONS+=("• 确保充足的电源供应")
            fi
            ;;
        "x64")
            if [[ $TOTAL_MEM -lt 2048 ]]; then
                RECOMMENDATIONS+=("• 建议增加内存至少 2GB")
            fi
            ;;
    esac
    
    if [[ "$JAVA_COMPAT" == *"未安装"* ]]; then
        RECOMMENDATIONS+=("• 需要安装 Java 11+")
    fi
    
    if [[ "$NODE_COMPAT" == *"未安装"* ]]; then
        RECOMMENDATIONS+=("• 需要安装 Node.js 18+")
    fi
    
    if [[ "$DEVICE_TYPE" == *"cloud"* ]] || [[ "$DEVICE_TYPE" == "aliyun" ]] || [[ "$DEVICE_TYPE" == "aws" ]]; then
        RECOMMENDATIONS+=("• 配置防火墙开放端口 2580, 3000, 8181")
        RECOMMENDATIONS+=("• 建议使用 HTTPS 和域名")
    fi
}

# 主函数
main() {
    echo "=================================================="
    echo "         IceCMS Pro 系统兼容性检测"
    echo "=================================================="
    echo
    
    detect_architecture
    detect_device
    detect_resources
    check_compatibility
    generate_recommendations
    
    echo "🖥️  系统信息："
    echo "  ├─ 操作系统: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Ubuntu")"
    echo "  ├─ 系统架构: $SYSTEM_ARCH ($ARCH_DESC)"
    echo "  ├─ 设备类型: $DEVICE_DESC"
    echo "  └─ 兼容性评级: $COMPATIBILITY"
    echo
    
    echo "💾 硬件资源："
    echo "  ├─ 内存: $MEM_STATUS"
    echo "  ├─ CPU: $CPU_STATUS"
    echo "  └─ 存储: $DISK_STATUS"
    echo
    
    echo "🔧 软件兼容性："
    echo "  ├─ Java: $JAVA_COMPAT"
    echo "  ├─ Node.js: $NODE_COMPAT"
    echo "  └─ MySQL: $MYSQL_COMPAT"
    echo
    
    if [[ ${#RECOMMENDATIONS[@]} -gt 0 ]]; then
        echo "💡 优化建议："
        for rec in "${RECOMMENDATIONS[@]}"; do
            echo "  $rec"
        done
        echo
    fi
    
    echo "🚀 推荐安装方式："
    case $SYSTEM_ARCH in
        "x64")
            echo "  标准安装: ./scripts/ubuntu-install.sh"
            ;;
        "arm64")
            if [[ "$DEVICE_TYPE" == "raspberry_pi" ]]; then
                echo "  树莓派优化: ./scripts/ubuntu-install.sh"
                echo "  (已自动适配 ARM64 架构)"
            else
                echo "  ARM64 服务器: ./scripts/ubuntu-install.sh"
            fi
            ;;
        "arm32")
            echo "  轻量化安装: ./scripts/ubuntu-install.sh"
            echo "  (将使用最小化配置)"
            ;;
        *)
            echo "  通用安装: ./scripts/ubuntu-install.sh"
            echo "  (可能需要手动调整)"
            ;;
    esac
    
    echo
    echo "=================================================="
    echo "         检测完成"
    echo "=================================================="
}

# 执行主函数
main "$@"
