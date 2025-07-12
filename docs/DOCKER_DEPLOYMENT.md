# 🐳 IceCMS Pro Docker 部署指南

## 📋 概述

本指南介绍如何使用 Docker 和 Docker Compose 快速部署 IceCMS Pro 系统。Docker 部署方式具有环境一致性、快速部署、易于管理等优势。

## 🔧 环境要求

### 系统要求
- **操作系统**: Linux、macOS、Windows
- **Docker**: 20.10.0+
- **Docker Compose**: 2.0.0+
- **内存**: 最低 2GB，推荐 4GB+
- **磁盘**: 最低 10GB 可用空间

### 架构支持
- ✅ **x86_64** (Intel/AMD 64位)
- ✅ **ARM64** (Apple M1/M2, 树莓派4/5)
- ⚠️ **ARM32** (树莓派3，性能有限)

## 🚀 快速开始

### 1. 克隆项目
```bash
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro/IceCMS-Docker
```

### 2. 一键启动
```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

### 3. 访问服务
- **管理后台**: http://localhost:2580 (admin/admin123)
- **用户前台**: http://localhost:3000
- **API文档**: http://localhost:8181/doc.html

## 📁 Docker 项目结构

```
IceCMS-Docker/
├── docker-compose.yml       # 主要编排文件
├── Makefile                 # 便捷管理命令
├── build.sh                 # 构建脚本
├── icecms-api/              # 后端服务
│   ├── Dockerfile           # 后端镜像构建
│   └── main.jar             # 后端应用包
├── icecms-sql/              # 数据库初始化
│   ├── Dockerfile           # 数据库镜像
│   ├── IceCMS.sql           # 数据库结构
│   ├── privileges.sql       # 权限配置
│   └── setup.sh             # 初始化脚本
└── icecms-vue/              # 前端服务
    ├── Dockerfile           # 前端镜像构建
    ├── default.conf         # Nginx 配置
    └── dist/                # 前端构建产物
```

## 🔧 服务配置详解

### Docker Compose 服务
```yaml
services:
  # MySQL 数据库
  icecms-mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: IceCMS@2024#Root
      MYSQL_DATABASE: icecms
      MYSQL_USER: icecms
      MYSQL_PASSWORD: IceCMS@2024#User

  # Redis 缓存
  icecms-redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  # 后端 API 服务
  icecms-api:
    build: ./icecms-api
    ports:
      - "8181:8181"
    depends_on:
      - icecms-mysql
      - icecms-redis

  # 前端服务
  icecms-vue:
    build: ./icecms-vue
    ports:
      - "3000:80"
    depends_on:
      - icecms-api
```

### 环境变量配置
```bash
# 数据库配置
MYSQL_ROOT_PASSWORD=IceCMS@2024#Root
MYSQL_DATABASE=icecms
MYSQL_USER=icecms
MYSQL_PASSWORD=IceCMS@2024#User

# 应用配置
SPRING_PROFILES_ACTIVE=docker
SERVER_PORT=8181
REDIS_HOST=icecms-redis
REDIS_PORT=6379
```

## 🛠️ 管理命令

### 使用 Docker Compose
```bash
# 启动所有服务
docker-compose up -d

# 停止所有服务
docker-compose down

# 重启服务
docker-compose restart

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f [service_name]

# 进入容器
docker-compose exec icecms-api bash
docker-compose exec icecms-mysql mysql -u root -p
```

### 使用 Makefile (推荐)
```bash
# 构建镜像
make build

# 启动服务
make up

# 停止服务
make down

# 重启服务
make restart

# 查看状态
make status

# 查看日志
make logs

# 清理数据
make clean
```

## 🔍 故障排除

### 常见问题

#### 1. 端口冲突
```bash
# 检查端口占用
netstat -tlnp | grep -E ':(3306|6379|8181|3000)'

# 修改端口映射
# 编辑 docker-compose.yml 中的 ports 配置
```

#### 2. 数据库连接失败
```bash
# 检查数据库容器状态
docker-compose logs icecms-mysql

# 进入数据库容器检查
docker-compose exec icecms-mysql mysql -u root -p

# 检查网络连接
docker-compose exec icecms-api ping icecms-mysql
```

#### 3. 前端页面无法访问
```bash
# 检查前端容器状态
docker-compose logs icecms-vue

# 检查 Nginx 配置
docker-compose exec icecms-vue cat /etc/nginx/conf.d/default.conf

# 重新构建前端镜像
docker-compose build icecms-vue
```

#### 4. 内存不足
```bash
# 检查容器资源使用
docker stats

# 增加 Docker 内存限制
# 在 docker-compose.yml 中添加:
# deploy:
#   resources:
#     limits:
#       memory: 1G
```

### 日志查看
```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f icecms-api
docker-compose logs -f icecms-mysql
docker-compose logs -f icecms-vue

# 查看最近的日志
docker-compose logs --tail=100 icecms-api
```

## 🔧 自定义配置

### 修改数据库配置
```yaml
# docker-compose.yml
icecms-mysql:
  environment:
    MYSQL_ROOT_PASSWORD: your_root_password
    MYSQL_DATABASE: your_database_name
    MYSQL_USER: your_username
    MYSQL_PASSWORD: your_password
  volumes:
    - mysql_data:/var/lib/mysql
    - ./custom.cnf:/etc/mysql/conf.d/custom.cnf
```

### 修改应用配置
```yaml
# docker-compose.yml
icecms-api:
  environment:
    SPRING_PROFILES_ACTIVE: production
    SPRING_DATASOURCE_URL: jdbc:mysql://icecms-mysql:3306/icecms
    SPRING_DATASOURCE_USERNAME: icecms
    SPRING_DATASOURCE_PASSWORD: your_password
    SPRING_REDIS_HOST: icecms-redis
    SPRING_REDIS_PORT: 6379
```

### 添加 SSL 证书
```yaml
# docker-compose.yml
icecms-vue:
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./ssl:/etc/nginx/ssl
    - ./nginx-ssl.conf:/etc/nginx/conf.d/default.conf
```

## 📊 性能优化

### 生产环境配置
```yaml
# docker-compose.prod.yml
version: '3.8'
services:
  icecms-api:
    deploy:
      replicas: 2
      resources:
        limits:
          memory: 1G
          cpus: '0.5'
        reservations:
          memory: 512M
          cpus: '0.25'
    environment:
      JAVA_OPTS: "-Xmx768m -Xms512m"

  icecms-mysql:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
    volumes:
      - mysql_data:/var/lib/mysql
      - ./mysql-prod.cnf:/etc/mysql/conf.d/mysql.cnf
```

### 监控配置
```yaml
# 添加监控服务
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin123
```

## 🚀 部署到生产环境

### 1. 环境准备
```bash
# 安装 Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# 安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### 2. 安全配置
```bash
# 修改默认密码
# 编辑 docker-compose.yml 中的密码配置

# 配置防火墙
sudo ufw allow 80
sudo ufw allow 443
sudo ufw deny 3306  # 不对外暴露数据库端口
sudo ufw deny 6379  # 不对外暴露 Redis 端口
```

### 3. 数据备份
```bash
# 数据库备份
docker-compose exec icecms-mysql mysqldump -u root -p icecms > backup.sql

# 数据卷备份
docker run --rm -v icecms-docker_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz /data
```

## 📋 检查清单

### 部署前检查
- [ ] Docker 和 Docker Compose 已安装
- [ ] 端口 80、443、3000、8181 未被占用
- [ ] 至少 4GB 可用内存
- [ ] 至少 10GB 可用磁盘空间

### 部署后验证
- [ ] 所有容器正常运行 (`docker-compose ps`)
- [ ] 数据库连接正常
- [ ] 管理后台可以登录
- [ ] 用户前台正常显示
- [ ] API 文档可以访问

### 生产环境检查
- [ ] 修改了默认密码
- [ ] 配置了 SSL 证书
- [ ] 设置了数据备份
- [ ] 配置了监控告警
- [ ] 防火墙规则正确

---

**注意**: Docker 部署方式适合快速体验和开发环境。生产环境建议使用 Kubernetes 或其他容器编排平台以获得更好的可扩展性和可靠性。
