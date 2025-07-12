# IceCMS Pro 自动化脚本

这个目录包含了 IceCMS Pro 项目的自动化部署和管理脚本，让您能够在 Mac 上快速部署和管理整个系统。

## 🚀 快速开始

### 1. 一键设置和启动
```bash
# 设置脚本权限并打开交互式菜单
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 2. 分步执行
```bash
# 1. 安装所有依赖
./scripts/install-dependencies.sh

# 2. 启动所有服务
./scripts/start-all.sh

# 3. 查看服务状态
./scripts/status.sh
```

## 📋 脚本说明

### 🔧 setup.sh - 快速设置脚本
- **功能**: 设置脚本权限，提供交互式操作菜单
- **用法**: `./scripts/setup.sh [命令]`
- **命令参数**:
  - `install` - 安装依赖
  - `start` - 启动服务
  - `stop` - 停止服务
  - `status` - 查看状态
  - `restart` - 重启服务
  - `help` - 显示帮助

### 📦 install-dependencies.sh - 依赖安装脚本
- **功能**: 自动安装所有系统依赖和项目依赖
- **包含**:
  - Homebrew
  - Java (OpenJDK 8)
  - Maven
  - MySQL 8.0
  - Redis
  - Node.js 20
  - pnpm
  - Docker (可选)
- **数据库配置**: 自动创建数据库和用户，导入初始数据

### 🚀 start-all.sh - 一键启动脚本
- **功能**: 启动所有服务
- **服务**:
  - 后端服务 (端口 8181)
  - 管理后台 (端口 5173)
  - 用户前台 (端口 3000)
- **特性**:
  - 自动检查端口占用
  - 等待服务启动完成
  - 显示访问地址

### 🛑 stop-all.sh - 停止服务脚本
- **功能**: 停止所有运行中的服务
- **特性**:
  - 优雅停止进程
  - 强制杀死无响应进程
  - 清理 PID 文件

### 📊 status.sh - 状态检查脚本
- **功能**: 全面检查系统和服务状态
- **检查项目**:
  - 系统依赖安装状态
  - 服务运行状态
  - 数据库连接状态
  - 系统资源使用情况

### 📝 logs.sh - 日志查看脚本
- **功能**: 查看和管理服务日志
- **用法**: `./scripts/logs.sh [选项] [服务名]`
- **选项**:
  - `-f, --follow` - 实时跟踪日志
  - `-n, --lines N` - 显示最后 N 行
  - `-c, --clean` - 清理日志文件
  - `-i, --info` - 显示日志文件信息
- **服务名**: `backend`, `admin`, `frontend`, `build`, `all`

## 🌐 访问地址

启动成功后，您可以访问以下地址：

- **后端 API**: http://localhost:8181
- **API 文档**: http://localhost:8181/doc.html
- **管理后台**: http://localhost:5173
  - 默认账号: `admin`
  - 默认密码: `admin123`
- **用户前台**: http://localhost:3000

## 📁 目录结构

```
scripts/
├── setup.sh                 # 快速设置脚本 (推荐入口)
├── install-dependencies.sh  # 依赖安装脚本
├── start-all.sh             # 一键启动脚本
├── stop-all.sh              # 停止服务脚本
├── status.sh                # 状态检查脚本
├── logs.sh                  # 日志查看脚本
├── pids/                    # PID 文件目录
└── README.md                # 本文件

logs/                        # 日志文件目录
├── backend.log              # 后端服务日志
├── backend-build.log        # 后端构建日志
├── admin.log                # 管理后台日志
└── frontend.log             # 用户前台日志
```

## 🔧 常用操作

### 启动服务
```bash
# 启动所有服务
./scripts/start-all.sh

# 或使用交互式菜单
./scripts/setup.sh
```

### 停止服务
```bash
# 停止所有服务
./scripts/stop-all.sh

# 或按 Ctrl+C 中断启动脚本
```

### 查看日志
```bash
# 查看所有日志
./scripts/logs.sh

# 查看特定服务日志
./scripts/logs.sh backend
./scripts/logs.sh admin
./scripts/logs.sh frontend

# 实时跟踪日志
./scripts/logs.sh -f backend
```

### 检查状态
```bash
# 全面状态检查
./scripts/status.sh
```

### 重启服务
```bash
# 停止后重新启动
./scripts/stop-all.sh
./scripts/start-all.sh

# 或使用交互式菜单
./scripts/setup.sh
# 选择 "6. 重启所有服务"
```

## ⚠️ 注意事项

1. **首次运行**: 请先执行 `./scripts/install-dependencies.sh` 安装依赖
2. **权限问题**: 如果脚本无法执行，请运行 `chmod +x scripts/*.sh`
3. **端口冲突**: 如果端口被占用，请先停止相关服务
4. **数据库配置**: 默认数据库配置为 `icecmspro/123456`
5. **日志文件**: 日志文件位于 `logs/` 目录，可以定期清理

## 🐛 故障排除

### 服务启动失败
1. 检查依赖是否正确安装: `./scripts/status.sh`
2. 查看详细日志: `./scripts/logs.sh [服务名]`
3. 检查端口是否被占用: `lsof -i :端口号`

### 数据库连接失败
1. 确保 MySQL 服务运行: `brew services list | grep mysql`
2. 检查数据库配置: `IceCMS-main/src/main/resources/application.yml`
3. 测试数据库连接: `mysql -u icecmspro -p123456 icecmspro`

### 前端编译失败
1. 清理依赖缓存: `rm -rf node_modules && pnpm install`
2. 检查 Node.js 版本: `node --version` (需要 18+)
3. 查看构建日志: `./scripts/logs.sh build`

## 📞 技术支持

- **官方文档**: https://doc.icecms.cn
- **QQ交流群**: 951286996
- **GitHub**: https://github.com/Thecosy/IceCMS
- **问题反馈**: 请在 GitHub 提交 Issue

## 📄 许可证

本项目遵循 GPL-3.0 开源协议。
