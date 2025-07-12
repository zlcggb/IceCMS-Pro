# IceCMS Pro Ubuntu 部署指南

本文档介绍如何在 Ubuntu 系统上部署 IceCMS Pro 项目。

## 系统要求

- **操作系统**: Ubuntu 18.04 或更高版本
- **内存**: 至少 4GB RAM
- **存储**: 至少 10GB 可用空间
- **网络**: 能够访问互联网（用于下载依赖）

## 快速部署

### 1. 下载项目

```bash
# 克隆项目
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro
```

### 2. 一键安装依赖

```bash
# 运行安装脚本（自动配置强密码）
./scripts/ubuntu-install.sh
```

安装脚本会自动安装以下组件：
- Java 11 (OpenJDK)
- Maven
- Node.js 18.x
- pnpm
- MySQL（自动配置强密码）
- Redis

### 🔐 自动密码配置

安装脚本会自动配置以下强密码：
- **MySQL Root 密码**: `IceCMS@2024#Root`
- **数据库名**: `icecmspro`
- **数据库用户**: `icecmspro`
- **数据库密码**: `IceCMS@2024#User`

```bash
# 查看所有密码和配置信息
./scripts/show-passwords.sh
```

### 3. 启动服务（数据库已自动配置）

```bash
# 一键启动所有服务
./scripts/ubuntu-start.sh
```

## 服务管理

### 启动服务
```bash
./scripts/ubuntu-start.sh
```

### 停止服务
```bash
./scripts/ubuntu-stop.sh
```

### 查看状态
```bash
./scripts/status.sh
```

### 查看日志
```bash
./scripts/logs.sh
```

## 访问地址

启动成功后，可以通过以下地址访问：

- **后端 API**: http://localhost:8181
- **API 文档**: http://localhost:8181/doc.html
- **管理后台**: http://localhost:2580
- **用户前台**: http://localhost:3000

默认管理员账号：
- 用户名: `admin`
- 密码: `admin123`

## 防火墙配置

如果需要外部访问，需要开放相应端口：

```bash
# 开放端口
sudo ufw allow 8181  # 后端 API
sudo ufw allow 2580  # 管理后台
sudo ufw allow 3000  # 用户前台

# 启用防火墙
sudo ufw enable
```

## 生产环境配置

### 1. 使用 Nginx 反向代理

安装 Nginx：
```bash
sudo apt install nginx
```

配置 Nginx：
```bash
sudo nano /etc/nginx/sites-available/icecms-pro
```

添加配置：
```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 管理后台
    location /admin {
        proxy_pass http://localhost:2580;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # 用户前台
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # API 接口
    location /api {
        proxy_pass http://localhost:8181;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

启用配置：
```bash
sudo ln -s /etc/nginx/sites-available/icecms-pro /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 2. 配置 SSL 证书

使用 Let's Encrypt：
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

### 3. 设置开机自启

创建 systemd 服务文件：

```bash
# 后端服务
sudo nano /etc/systemd/system/icecms-backend.service
```

```ini
[Unit]
Description=IceCMS Pro Backend
After=network.target mysql.service redis-server.service

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/IceCMS-Pro/IceCMS-main
ExecStart=/usr/bin/java -jar target/main.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

启用服务：
```bash
sudo systemctl enable icecms-backend
sudo systemctl start icecms-backend
```

## 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   # 查看端口占用
   sudo ss -tulpn | grep :8181
   
   # 杀死进程
   sudo kill -9 <PID>
   ```

2. **Java 版本问题**
   ```bash
   # 检查 Java 版本
   java -version
   
   # 切换 Java 版本
   sudo update-alternatives --config java
   ```

3. **数据库连接失败**
   ```bash
   # 检查 MySQL 状态
   sudo systemctl status mysql
   
   # 重启 MySQL
   sudo systemctl restart mysql
   ```

4. **前端依赖安装失败**
   ```bash
   # 清理缓存
   pnpm store prune
   
   # 重新安装
   pnpm install
   ```

### 日志位置

- 后端日志: `logs/backend.log`
- 管理后台日志: `logs/admin.log`
- 用户前台日志: `logs/frontend.log`
- 构建日志: `logs/backend-build.log`

## 性能优化

### 1. JVM 参数优化

编辑启动脚本，添加 JVM 参数：
```bash
java -Xms2g -Xmx4g -XX:+UseG1GC -jar target/main.jar
```

### 2. 数据库优化

编辑 MySQL 配置：
```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

添加优化参数：
```ini
[mysqld]
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
max_connections = 200
```

### 3. Redis 优化

编辑 Redis 配置：
```bash
sudo nano /etc/redis/redis.conf
```

优化参数：
```
maxmemory 512mb
maxmemory-policy allkeys-lru
```

## 备份策略

### 数据库备份

```bash
# 创建备份脚本
nano backup-db.sh
```

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -u icecms -p icecms_pro > backup_${DATE}.sql
```

### 自动备份

添加到 crontab：
```bash
crontab -e
```

```
# 每天凌晨 2 点备份
0 2 * * * /path/to/backup-db.sh
```

## 监控

### 系统监控

安装 htop：
```bash
sudo apt install htop
```

### 应用监控

使用 PM2 管理 Node.js 应用：
```bash
npm install -g pm2
pm2 start ecosystem.config.js
pm2 monit
```

## 更新升级

### 更新代码

```bash
git pull origin main
./scripts/ubuntu-stop.sh
./scripts/ubuntu-start.sh
```

### 更新依赖

```bash
# 后端依赖
cd IceCMS-main
mvn clean package -DskipTests

# 前端依赖
cd ../IceCMS-front-admin
pnpm update

cd ../IceCMS-front-nuxt3
pnpm update
```

## 技术支持

如果遇到问题，请：

1. 查看日志文件
2. 检查系统资源使用情况
3. 确认网络连接正常
4. 提交 Issue 到 GitHub 仓库

---

**注意**: 本部署指南适用于开发和测试环境。生产环境部署请根据实际需求进行安全加固和性能优化。
