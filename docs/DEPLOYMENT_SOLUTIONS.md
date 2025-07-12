# 🔧 IceCMS Pro 部署问题解决方案

## 📋 概述

本文档汇总了 IceCMS Pro 在不同环境下部署时遇到的常见问题及其解决方案，特别是针对树莓派 ARM64 架构的特殊处理。

## 🚨 关键问题及解决方案

### 1. Maven 下载速度慢

**问题描述**:
- 国内服务器访问 Maven 中央仓库速度极慢
- 下载依赖包时速度只有几 KB/s
- 编译过程经常超时失败

**解决方案**:
```bash
# 创建 Maven 配置目录
mkdir -p ~/.m2

# 配置阿里云镜像源
cat > ~/.m2/settings.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 
          http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>https://maven.aliyun.com/repository/public</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
</settings>
EOF
```

**自动化**: 已集成到 `ubuntu-install.sh` 脚本中

### 2. YAML 配置文件格式错误

**问题描述**:
- Spring Boot 启动时报 YAML 解析错误
- 配置文件中 URL 字段重复出现
- 错误信息: `could not determine a constructor for the tag`

**错误示例**:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/icecmspro?useUnicode=trueurl: jdbc:mysql://127.0.0.1:3306/icecmspro?useUnicode=true&useJDBCCompliantTimezoneShift=true&serverTimezone=UTCcharacterEncoding=utf8
```

**解决方案**:
```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/icecmspro?useUnicode=true&useJDBCCompliantTimezoneShift=true&serverTimezone=Asia/Shanghai&characterEncoding=utf8
    username: icecmspro
    password: IceCMS@2024#User
    driver-class-name: com.mysql.cj.jdbc.Driver
server:
  address: 0.0.0.0
  port: 8181
```

**自动化**: 脚本会自动检测并修复配置文件格式

### 3. MariaDB 字符集兼容性

**问题描述**:
- 树莓派默认使用 MariaDB 而非 MySQL
- SQL 文件中的 `utf8mb4_0900_ai_ci` 排序规则不被支持
- 错误信息: `Unknown collation: 'utf8mb4_0900_ai_ci'`

**解决方案**:
```bash
# 转换排序规则
sed 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' sql/icecms8.0.sql > sql/icecms_mariadb.sql

# 导入转换后的 SQL
mysql -u icecmspro -p'IceCMS@2024#User' icecmspro < sql/icecms_mariadb.sql
```

**自动化**: 脚本会自动检测数据库类型并处理兼容性

### 4. 数据库用户创建失败

**问题描述**:
- 数据库连接被拒绝
- 用户 `icecmspro` 不存在
- 错误信息: `Access denied for user 'icecmspro'@'localhost'`

**解决方案**:
```sql
-- 手动创建数据库和用户
CREATE DATABASE IF NOT EXISTS icecmspro;
CREATE USER IF NOT EXISTS 'icecmspro'@'localhost' IDENTIFIED BY 'IceCMS@2024#User';
GRANT ALL PRIVILEGES ON icecmspro.* TO 'icecmspro'@'localhost';
FLUSH PRIVILEGES;
```

**自动化**: 脚本会检测用户是否存在并自动创建

### 5. ARM64 原生绑定缺失

**问题描述**:
- Nuxt3 前端启动失败
- 缺少 ARM64 架构的原生模块
- 错误信息: `Cannot find module '@oxc-parser/binding-linux-arm64-gnu'`

**解决方案**:
```bash
# 进入前端目录
cd IceCMS-front-nuxt3

# 安装 ARM64 原生绑定
pnpm add @oxc-parser/binding-linux-arm64-gnu
```

**架构检测**:
```bash
ARCH=$(uname -m)
case $ARCH in
    aarch64|arm64)
        pnpm add @oxc-parser/binding-linux-arm64-gnu
        ;;
    x86_64)
        pnpm add @oxc-parser/binding-linux-x64-gnu
        ;;
esac
```

**自动化**: 脚本会自动检测架构并安装对应绑定

### 6. 前端网络绑定问题

**问题描述**:
- 前端服务只能本地访问
- 外网访问返回连接拒绝
- 端口绑定在 `127.0.0.1` 或 `::1`

**解决方案**:
```bash
# 修改 package.json 启动脚本
npm pkg set scripts.dev="nuxt dev --host 0.0.0.0 --port 3000 --dotenv .env.development"
npm pkg set scripts.serve="nuxt dev --host 0.0.0.0 --port 3000 --dotenv .env.development"
```

**Nuxt3 配置**:
```typescript
// nuxt.config.ts
export default defineNuxtConfig({
  devServer: {
    host: '0.0.0.0',
    port: 3000
  }
})
```

**自动化**: 脚本会自动配置网络绑定参数

### 7. npm 下载速度慢

**问题描述**:
- 国内访问 npm 官方源速度慢
- 前端依赖安装经常超时
- 特别影响 ARM 设备的安装过程

**解决方案**:
```bash
# 配置 npm 淘宝镜像
npm config set registry https://registry.npmmirror.com/

# 配置 pnpm 淘宝镜像
pnpm config set registry https://registry.npmmirror.com/
```

**自动化**: 脚本会自动配置镜像源

### 8. 数据库表结构缺失

**问题描述**:
- 后端启动时报表不存在错误
- 数据库连接成功但缺少表结构
- 错误信息: `Table 'icecmspro.user' doesn't exist`

**解决方案**:
```bash
# 检查并导入表结构
if [[ -f "sql/icecms8.0.sql" ]]; then
    # 检测数据库类型
    DB_VERSION=$(mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SELECT VERSION();" 2>/dev/null | tail -n 1)
    
    if [[ "$DB_VERSION" == *"MariaDB"* ]]; then
        # MariaDB 兼容处理
        sed 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' sql/icecms8.0.sql > sql/icecms_mariadb.sql
        mysql -u icecmspro -p'IceCMS@2024#User' icecmspro < sql/icecms_mariadb.sql
    else
        # 标准 MySQL
        mysql -u icecmspro -p'IceCMS@2024#User' icecmspro < sql/icecms8.0.sql
    fi
fi
```

**自动化**: 脚本会自动检测数据库类型并导入表结构

## 🔍 诊断命令

### 检查服务状态
```bash
# 检查端口绑定
netstat -tlnp | grep -E ':(8181|2580|3000)'

# 检查进程状态
ps aux | grep -E 'java|node'

# 检查服务响应
curl -I http://localhost:8181/doc.html
curl -I http://localhost:2580
curl -I http://localhost:3000
```

### 检查日志
```bash
# 后端日志
tail -f logs/backend.log

# 前端日志
tail -f logs/frontend.log

# 管理后台日志
tail -f logs/admin.log
```

### 检查数据库
```bash
# 测试数据库连接
mysql -u icecmspro -p'IceCMS@2024#User' -e "SELECT 1;"

# 检查表结构
mysql -u icecmspro -p'IceCMS@2024#User' icecmspro -e "SHOW TABLES;"
```

## 🛠️ 修复脚本

项目提供了多个修复脚本：

```bash
# 修复前端依赖问题
./scripts/fix-frontend-deps.sh

# 查看服务状态
./scripts/status.sh

# 查看详细日志
./scripts/logs.sh

# 查看配置信息
./scripts/show-passwords.sh
```

## 📋 部署检查清单

- [ ] Maven 镜像源配置
- [ ] YAML 配置文件格式正确
- [ ] 数据库用户创建成功
- [ ] 数据库表结构导入完成
- [ ] ARM64 原生绑定安装（如适用）
- [ ] 前端网络绑定配置
- [ ] npm 镜像源配置
- [ ] 所有服务端口正确绑定
- [ ] 外网访问测试通过

## 🎯 成功标志

部署成功的标志：
1. 所有服务返回 HTTP 200 状态码
2. 管理后台可以正常登录
3. 用户前台页面正常显示
4. API 文档可以正常访问

---

**注意**: 这些解决方案已经集成到自动化脚本中，大多数问题会被自动处理。如果仍有问题，请参考具体的错误信息和对应的解决方案。
