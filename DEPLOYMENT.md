# IceCMS-Pro 部署指南

## 🚀 Mac一键部署（推荐）

### 前置要求

1. **克隆项目**
   ```bash
   git clone https://github.com/zlcggb/IceCMS-Pro.git
   cd IceCMS-Pro
   ```

2. **一键启动**
   ```bash
   ./scripts/start-all.sh
   ```

   > 注意：首次运行会自动下载依赖和构建项目，可能需要较长时间。

### 脚本功能说明

- `start-all.sh` - 一键启动所有服务
- `stop-all.sh` - 停止所有服务
- `status.sh` - 查看服务状态
- `logs.sh` - 查看服务日志
- `smart-start.sh` - 智能启动（跳过已运行的服务）

## 🛠️ 手动部署

### 环境准备

#### Java环境
```bash
# 推荐使用Java 11
brew install openjdk@11

# 设置JAVA_HOME
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@11' >> ~/.zshrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# 验证安装
java -version
```

#### Node.js环境
```bash
# 安装Node.js 16+
brew install node@16

# 安装pnpm
npm install -g pnpm

# 验证安装
node -v
pnpm -v
```

#### 数据库环境
```bash
# 安装MySQL
brew install mysql
brew services start mysql

# 安装Redis（可选）
brew install redis
brew services start redis
```

### 数据库配置

1. **创建数据库**
   ```sql
   CREATE DATABASE icecms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```

2. **导入数据**
   ```bash
   mysql -u root -p icecms < sql/icecms8.0.sql
   ```

3. **配置数据库连接**
   编辑 `IceCMS-main/src/main/resources/application.yml`：
   ```yaml
   spring:
     datasource:
       url: jdbc:mysql://localhost:3306/icecms?useUnicode=true&characterEncoding=utf8&serverTimezone=GMT%2B8
       username: root
       password: your_password
   ```

### 后端部署

1. **编译项目**
   ```bash
   cd IceCMS-main
   mvn clean package -DskipTests
   ```

2. **启动服务**
   ```bash
   java -jar target/main.jar
   ```

   或者使用开发模式：
   ```bash
   mvn spring-boot:run
   ```

### 前端部署

#### 管理后台
```bash
cd IceCMS-front-admin
pnpm install
pnpm dev
```

#### 用户前端
```bash
cd IceCMS-front-nuxt3
pnpm install
pnpm dev
```

## 🐳 Docker部署

### 使用Docker Compose
```bash
cd IceCMS-Docker
docker-compose up -d
```

### 单独构建
```bash
# 构建后端镜像
cd IceCMS-Docker
docker build -t icecms-api ./icecms-api

# 构建前端镜像
docker build -t icecms-vue ./icecms-vue
```

## 🔧 配置说明

### 后端配置文件
- `application.yml` - 主配置文件
- `application-dev.yml` - 开发环境配置
- `application-prod.yml` - 生产环境配置

### 前端配置文件
- `IceCMS-front-admin/vite.config.ts` - 管理后台配置
- `IceCMS-front-nuxt3/nuxt.config.ts` - 用户前端配置

### 重要配置项

#### 数据库配置
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/icecms
    username: root
    password: password
```

#### Redis配置
```yaml
spring:
  redis:
    host: localhost
    port: 6379
    password: 
```

#### 文件上传配置
```yaml
file:
  upload:
    path: /uploads/
    max-size: 10MB
```

## 🚨 常见问题

### Java版本问题
- **推荐使用Java 11+**，避免兼容性问题
- 如果使用Java 8，需要添加JAXB依赖

### 端口冲突
- 后端默认端口：8080
- 管理后台：3001
- 用户前端：3000
- 可在配置文件中修改

### 内存不足
```bash
# 增加JVM内存
java -Xmx2g -Xms1g -jar target/main.jar
```

### 数据库连接问题
- 检查MySQL服务是否启动
- 确认数据库用户权限
- 检查防火墙设置

## 📝 生产环境部署

### 性能优化
1. **JVM参数调优**
   ```bash
   java -Xmx4g -Xms2g -XX:+UseG1GC -jar target/main.jar
   ```

2. **数据库优化**
   - 配置连接池
   - 启用查询缓存
   - 优化索引

3. **前端优化**
   ```bash
   # 生产构建
   pnpm build
   
   # 使用nginx部署
   nginx -s reload
   ```

### 安全配置
- 修改默认密码
- 配置HTTPS
- 设置防火墙规则
- 定期备份数据

### 监控和日志
- 配置日志级别
- 设置日志轮转
- 监控系统资源
- 配置告警机制

## 📞 技术支持

如果遇到部署问题，请：
1. 查看日志文件：`logs/`目录
2. 检查服务状态：`./scripts/status.sh`
3. 提交Issue到GitHub仓库
4. 参考官方文档：[doc.icecms.cn](https://doc.icecms.cn)
