# IceCMS Pro 项目技术分析与Mac本地部署指南

## 项目概述

IceCMS Pro 是一个基于 Spring Boot + Vue 前后端分离的内容管理系统，支持多端应用（Web端、移动端、小程序）。

## 技术栈分析

### 后端技术栈
- **核心框架**: Spring Boot 2.3.5.RELEASE
- **安全框架**: Spring Security
- **Token认证**: JWT (jjwt)
- **持久层框架**: MyBatis Plus 3.4.2
- **数据库**: MySQL 8.0+
- **缓存**: Redis
- **Java版本**: **JDK 11+** (推荐) 或 JDK 1.8+ (最低要求)
- **构建工具**: Maven
- **API文档**: Swagger2 + Knife4j
- **其他依赖**:
  - FastJSON 2.0.51 (JSON处理)
  - Spring Boot Mail (邮件服务)
  - Lombok (代码简化)

### ⚠️ Java 版本重要说明

**强烈推荐使用 Java 11 或更高版本：**
- ✅ **性能优势**: 更好的 JVM 性能和内存管理
- ✅ **长期支持**: Java 11 是 LTS 版本，获得长期支持
- ✅ **安全性**: 更强的安全特性和漏洞修复
- ✅ **容器化**: 更好的 Docker 和 Kubernetes 支持
- ✅ **现代化**: 支持现代化的垃圾收集器（如 G1GC、ZGC）

**如果必须使用 Java 8，需要额外配置：**
```xml
<!-- 在 pom.xml 中添加以下依赖 -->
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.0</version>
</dependency>
```

### 前端技术栈

#### 管理后台 (IceCMS-front-admin)
- **框架**: Vue 3.4.14 + TypeScript
- **构建工具**: Vite 5.0.12
- **包管理器**: pnpm 8.6.10
- **UI框架**: Element Plus 2.5.3
- **状态管理**: Pinia 2.1.7
- **路由**: Vue Router 4.2.5
- **样式**: TailwindCSS 3.4.1 + Sass
- **图表**: ECharts 5.4.3
- **富文本编辑器**: @wangeditor/editor 5.1.23
- **其他特性**:
  - 国际化支持 (vue-i18n)
  - 响应式设计
  - 代码规范 (ESLint + Prettier)

#### 用户前台 (IceCMS-front-nuxt3)
- **框架**: Nuxt 3.15.2 + Vue 3
- **UI框架**: Element Plus 2.9.3
- **状态管理**: Pinia
- **Markdown编辑器**: @kangc/v-md-editor 2.3.18
- **代码高亮**: PrismJS 1.29.0
- **时间处理**: DayJS 1.11.13

#### 移动端 (IceCMS-uniApp)
- **框架**: uni-app
- **支持平台**: H5、小程序、App

### 数据库设计
- **数据库**: MySQL 8.0+
- **字符集**: utf8mb4 (支持emoji表情)
- **主要表结构**:
  - 用户管理 (用户、角色、权限)
  - 内容管理 (文章、栏目、标签)
  - 系统管理 (配置、日志、公告)

## 系统架构

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   管理后台      │    │   用户前台      │    │   移动端        │
│  (Vue3+Vite)   │    │  (Nuxt3)       │    │  (uni-app)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   API Gateway   │
                    │  (Spring Boot)  │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   业务服务层    │
                    │  - 用户管理     │
                    │  - 内容管理     │
                    │  - 系统管理     │
                    │  - 支付模块     │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   数据访问层    │
                    │  (MyBatis Plus) │
                    └─────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│     MySQL       │    │     Redis       │    │   文件存储      │
│   (主数据库)    │    │    (缓存)       │    │  (本地/云存储)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Mac本地部署指南

### 环境要求

#### 必需软件
1. **Java Development Kit (JDK) 11+** (推荐) 或 JDK 1.8+ (最低)
2. **MySQL 8.0+** (或 MySQL 5.7+)
3. **Maven 3.6+**
4. **Node.js 18.18.0+ 或 20.9.0+ 或 21.1.0+**
5. **pnpm 8.6.10+**

#### ⚠️ Java 版本选择建议
- **生产环境**: 强烈推荐 Java 11 或 Java 17 (LTS 版本)
- **开发环境**: 推荐 Java 11+
- **兼容性**: 最低支持 Java 8 (需要额外配置)

#### 可选软件
1. **Redis** (用于缓存，可选)
2. **Docker** (用于容器化部署)

### 安装依赖

#### 1. 安装 Homebrew (如果未安装)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 2. 安装 Java (推荐 Java 11)
```bash
# 推荐：安装 OpenJDK 11 (LTS 版本)
brew install openjdk@11

# 设置环境变量 (添加到 ~/.zshrc 或 ~/.bash_profile)
export JAVA_HOME=/opt/homebrew/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# 验证安装
java -version
```

**可选：如果需要 Java 8**
```bash
# 安装 OpenJDK 8 (不推荐，仅兼容性考虑)
brew install openjdk@8

# 设置环境变量
export JAVA_HOME=/opt/homebrew/opt/openjdk@8/libexec/openjdk.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH
```

#### 3. 安装 MySQL
```bash
# 安装 MySQL
brew install mysql

# 启动 MySQL 服务
brew services start mysql

# 设置 root 密码
mysql_secure_installation
```

#### 4. 安装 Maven
```bash
brew install maven
```

#### 5. 安装 Node.js 和 pnpm
```bash
# 安装 Node.js (推荐使用 nvm)
brew install nvm
nvm install 20
nvm use 20

# 安装 pnpm
npm install -g pnpm@8.6.10
```

#### 6. 安装 Redis (可选)
```bash
brew install redis
brew services start redis
```

### 数据库配置

#### 1. 创建数据库
```sql
-- 登录 MySQL
mysql -u root -p

-- 创建数据库
CREATE DATABASE icecmspro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户
CREATE USER 'icecmspro'@'localhost' IDENTIFIED BY '123456';

-- 授权
GRANT ALL PRIVILEGES ON icecmspro.* TO 'icecmspro'@'localhost';
FLUSH PRIVILEGES;
```

#### 2. 导入数据
```bash
# 导入数据库结构和数据
mysql -u icecmspro -p icecmspro < sql/icecms8.0.sql
```

### 后端部署

#### 1. 配置数据库连接
编辑 `IceCMS-main/src/main/resources/application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/icecmspro?useUnicode=true&useJDBCCompliantTimezoneShift=true&serverTimezone=UTC
    username: icecmspro
    password: 123456
    driver-class-name: com.mysql.cj.jdbc.Driver
  redis:
    host: localhost
    port: 6379
    # password: # 如果Redis设置了密码
```

#### 2. 编译和启动后端
```bash
# 进入项目根目录
cd /path/to/IceCMS-Pro

# 编译项目
mvn clean install

# 启动后端服务
cd IceCMS-main
mvn spring-boot:run

# 或者使用jar包启动
java -jar target/main.jar
```

后端服务将在 `http://localhost:8181` 启动

### 前端部署

#### 1. 管理后台部署
```bash
# 进入管理后台目录
cd IceCMS-front-admin

# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev
```

管理后台将在 `http://localhost:5173` 启动

#### 2. 用户前台部署
```bash
# 进入用户前台目录
cd IceCMS-front-nuxt3

# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev
```

用户前台将在 `http://localhost:3000` 启动

### 访问地址

- **后端API**: http://localhost:8181
- **API文档**: http://localhost:8181/doc.html
- **管理后台**: http://localhost:5173
- **用户前台**: http://localhost:3000

### 默认账号

- **管理员账号**: admin
- **管理员密码**: admin123

### Docker部署 (推荐用于生产环境)

#### 1. 安装 Docker
```bash
brew install docker
```

#### 2. 使用 Docker Compose 一键部署
```bash
cd IceCMS-Docker
docker-compose up -d
```

这将启动：
- MySQL 数据库 (端口: 随机)
- Spring Boot 后端 (端口: 8181)
- Vue 前端 (端口: 3000)

## 常见问题解决

### 1. MySQL 连接问题
- 确保 MySQL 服务正在运行
- 检查数据库用户权限
- 确认数据库字符集为 utf8mb4

### 2. 端口冲突
- 修改 `application.yml` 中的 `server.port`
- 修改前端项目的端口配置

### 3. 依赖安装失败
```bash
# 清理 Maven 缓存
mvn clean

# 清理 pnpm 缓存
pnpm store prune
rm -rf node_modules
pnpm install
```

### 4. 权限问题
```bash
# 给脚本执行权限
chmod +x bin/*.sh
```

## 开发建议

1. **代码规范**: 项目已配置 ESLint 和 Prettier，建议开启编辑器的自动格式化
2. **API测试**: 使用 Swagger UI 进行 API 测试
3. **数据库管理**: 推荐使用 Navicat 或 MySQL Workbench
4. **版本控制**: 建议使用 Git 进行版本管理
5. **环境隔离**: 开发、测试、生产环境使用不同的配置文件

## 🚀 一键部署方案

我已经为您创建了完整的自动化脚本，让部署变得非常简单：

### 方案一：交互式一键部署（推荐）
```bash
# 1. 设置脚本权限并启动交互式菜单
chmod +x scripts/setup.sh
./scripts/setup.sh

# 2. 在菜单中选择：
#    - 选择 "1" 安装依赖
#    - 选择 "2" 启动所有服务
#    - 选择 "7" 打开浏览器访问
```

### 方案二：命令行一键部署
```bash
# 1. 安装所有依赖（包括Java、MySQL、Node.js等）
./scripts/install-dependencies.sh

# 2. 一键启动所有服务
./scripts/start-all.sh

# 3. 查看服务状态
./scripts/status.sh
```

### 可用的管理命令
```bash
# 启动服务
./scripts/start-all.sh

# 停止服务
./scripts/stop-all.sh

# 查看状态
./scripts/status.sh

# 查看日志
./scripts/logs.sh

# 交互式管理
./scripts/setup.sh
```

### 🎯 部署后访问地址
- **管理后台**: http://localhost:5173 (admin/admin123)
- **用户前台**: http://localhost:3000
- **API文档**: http://localhost:8181/doc.html

## 生产部署注意事项

1. **安全配置**:
   - 修改默认密码
   - 配置 HTTPS
   - 设置防火墙规则

2. **性能优化**:
   - 配置 Redis 缓存
   - 数据库索引优化
   - 静态资源 CDN

3. **监控和日志**:
   - 配置应用监控
   - 设置日志收集
   - 定期备份数据

## 技术支持

- **官方文档**: https://doc.icecms.cn
- **QQ交流群**: 951286996
- **GitHub**: https://github.com/Thecosy/IceCMS
