# 🍓 IceCMS Pro 树莓派部署指南

## 📋 概述

本指南专门针对树莓派设备部署 IceCMS Pro，已在树莓派 5 (ARM64) 上完整测试通过。

## 🔧 支持的设备

| 设备 | 架构 | 支持状态 | 备注 |
|------|------|----------|------|
| 树莓派 5 | ARM64 | ✅ 完全支持 | 推荐配置 |
| 树莓派 4 | ARM64 | ✅ 完全支持 | 性能良好 |
| 树莓派 3 | ARM32 | ⚠️ 轻量化支持 | 性能有限 |

## 🚀 一键部署

```bash
# 1. 克隆项目
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro

# 2. 运行安装脚本（自动检测树莓派）
chmod +x scripts/ubuntu-install.sh
./scripts/ubuntu-install.sh

# 3. 启动服务
./scripts/ubuntu-start.sh
```

## 🔧 自动解决的关键问题

### 1. Maven 下载慢
- **问题**: 国内访问 Maven 中央仓库速度慢
- **解决**: 自动配置阿里云镜像源
- **配置文件**: `~/.m2/settings.xml`

### 2. MariaDB 兼容性
- **问题**: 树莓派默认使用 MariaDB，字符集排序规则不兼容
- **解决**: 自动转换 `utf8mb4_0900_ai_ci` → `utf8mb4_general_ci`
- **影响**: 数据库表创建和数据导入

### 3. ARM64 原生模块
- **问题**: `@oxc-parser` 缺少 ARM64 原生绑定
- **解决**: 自动安装 `@oxc-parser/binding-linux-arm64-gnu`
- **错误信息**: `Cannot find module '@oxc-parser/binding-linux-arm64-gnu'`

### 4. 网络绑定问题
- **问题**: Nuxt3 默认只绑定 localhost，无法外网访问
- **解决**: 自动配置 `--host 0.0.0.0 --port 3000`
- **配置文件**: `package.json` 启动脚本

### 5. npm 下载慢
- **问题**: 国内访问 npm 官方源速度慢
- **解决**: 自动配置淘宝镜像源
- **命令**: `npm config set registry https://registry.npmmirror.com/`

### 6. 数据库初始化
- **问题**: 数据库用户创建失败，表结构缺失
- **解决**: 自动创建数据库用户和导入表结构
- **SQL文件**: 自动选择兼容的 SQL 文件

## 📍 访问地址

部署成功后，可通过以下地址访问：

- **管理后台**: http://树莓派IP:2580 (admin/admin123)
- **用户前台**: http://树莓派IP:3000
- **API文档**: http://树莓派IP:8181/doc.html

## 🛠️ 故障排除

### 前端 503 错误
```bash
# 修复前端依赖
./scripts/fix-frontend-deps.sh

# 检查日志
tail -f logs/frontend.log
```

### 后端启动失败
```bash
# 检查后端日志
tail -f logs/backend.log

# 检查数据库连接
mysql -u icecmspro -p'IceCMS@2024#User' -e "SELECT 1;"
```

### 端口无法访问
```bash
# 检查端口绑定
netstat -tlnp | grep -E ':(8181|2580|3000)'

# 检查防火墙
sudo ufw status
```

## 🔐 安全配置

### 默认密码
- MySQL Root: `IceCMS@2024#Root`
- 数据库用户: `IceCMS@2024#User`
- 管理员: `admin` / `admin123`

### 生产环境建议
1. 修改默认管理员密码
2. 配置防火墙规则
3. 设置 SSL 证书
4. 定期备份数据库

## 📊 性能优化

### 树莓派 5 推荐配置
- **内存**: 8GB 版本推荐
- **存储**: Class 10 SD卡或 SSD
- **散热**: 主动散热风扇

### 系统优化
```bash
# 增加 swap 空间（如需要）
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 添加到启动项
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## 🔄 管理命令

```bash
# 启动所有服务
./scripts/ubuntu-start.sh

# 停止所有服务
./scripts/ubuntu-stop.sh

# 查看服务状态
./scripts/status.sh

# 查看日志
./scripts/logs.sh

# 查看配置信息
./scripts/show-passwords.sh
```

## 📝 技术栈

- **操作系统**: Ubuntu 24.04 LTS
- **Java**: OpenJDK 11
- **数据库**: MariaDB 10.6+
- **缓存**: Redis 6.0+
- **前端**: Nuxt3 + Vue.js
- **后端**: Spring Boot 2.7+
- **构建工具**: Maven 3.8+

## 🆘 获取帮助

如果遇到问题，请：

1. 查看日志文件：`logs/` 目录
2. 运行诊断脚本：`./scripts/status.sh`
3. 查看本文档的故障排除部分
4. 提交 Issue 到 GitHub 仓库

---

**部署成功标志**: 所有服务返回 HTTP 200 状态码，可以正常访问管理后台和用户前台。
