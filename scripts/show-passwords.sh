#!/bin/bash

# IceCMS Pro 密码和配置信息显示脚本
# 作者: AI Assistant
# 版本: 1.0
# 描述: 显示所有重要的密码和配置信息

# 加载配置文件
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/config.sh"

# 主函数
main() {
    echo "=================================================="
    echo "         IceCMS Pro 配置和密码信息"
    echo "=================================================="
    echo
    
    echo "🔐 数据库配置信息："
    echo "  ┌─ MySQL Root 密码: $MYSQL_ROOT_PASSWORD"
    echo "  ├─ 数据库名称: $MYSQL_DB_NAME"
    echo "  ├─ 数据库用户: $MYSQL_DB_USER"
    echo "  └─ 数据库密码: $MYSQL_DB_PASSWORD"
    echo
    
    echo "🌐 服务访问地址："
    echo "  ┌─ 后端 API: http://localhost:$BACKEND_PORT"
    echo "  ├─ API 文档: http://localhost:$BACKEND_PORT/doc.html"
    echo "  ├─ 管理后台: http://localhost:$ADMIN_PORT"
    echo "  └─ 用户前台: http://localhost:$FRONTEND_PORT"
    echo
    
    echo "👤 默认管理员账号："
    echo "  ┌─ 用户名: $ADMIN_USERNAME"
    echo "  └─ 密码: $ADMIN_PASSWORD"
    echo
    
    echo "📁 重要目录路径："
    echo "  ┌─ 项目根目录: $PROJECT_ROOT"
    echo "  ├─ 后端目录: $BACKEND_DIR"
    echo "  ├─ 管理后台目录: $ADMIN_DIR"
    echo "  ├─ 用户前台目录: $FRONTEND_DIR"
    echo "  ├─ 日志目录: $LOG_DIR"
    echo "  └─ PID 目录: $PID_DIR"
    echo
    
    echo "🔧 常用管理命令："
    echo "  ┌─ 启动所有服务: ./scripts/start-all.sh"
    echo "  ├─ 停止所有服务: ./scripts/stop-all.sh"
    echo "  ├─ 查看服务状态: ./scripts/status.sh"
    echo "  ├─ 查看日志: ./scripts/logs.sh"
    echo "  ├─ Ubuntu 安装: ./scripts/ubuntu-install.sh"
    echo "  ├─ Ubuntu 启动: ./scripts/ubuntu-start.sh"
    echo "  └─ 显示配置: ./scripts/show-passwords.sh"
    echo
    
    echo "⚠️  安全提示："
    echo "  ┌─ 请妥善保存上述密码信息"
    echo "  ├─ 生产环境请修改默认密码"
    echo "  ├─ 定期备份数据库数据"
    echo "  └─ 不要将密码提交到版本控制系统"
    echo
    
    echo "📋 快速连接数据库："
    echo "  mysql -u $MYSQL_DB_USER -p'$MYSQL_DB_PASSWORD' $MYSQL_DB_NAME"
    echo
    
    echo "=================================================="
    echo "         配置信息显示完成"
    echo "=================================================="
}

# 执行主函数
main "$@"
