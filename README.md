# IceCMS-Pro

简体中文 | [English](README_en.md)

<p align="center">
  <a href="https://www.icecmspro.com" target="_blank">
    <img alt="logo" style="height: 120px" src="https://res.cloudinary.com/dxl1idlr5/image/upload/v1700470902/logo_s4maqv.svg"/>
  </a>
</p>

<p align="center">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/JDK-11+-orange">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/SpringBoot-2.2.7.RELEASE-brightgreen">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/MyBatis-3.5.5-red">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/Vue-3.0+-brightgreen">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/Nuxt-3.0+-green">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/license-MIT-blue">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/Mac-一键部署-red">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/Ubuntu-一键部署-blue">
</p>

## 📋 目录导航

- [🚀 快速开始](#-快速开始)
- [💻 环境要求](#-环境要求)
- [🔧 部署指南](#-部署指南)
  - [Mac 环境部署](#mac-环境部署)
  - [Ubuntu 环境部署](#ubuntu-环境部署)
  - [Docker 部署](#docker-部署)
- [📁 项目结构](#-项目结构)
- [🌐 访问地址](#-访问地址)
- [📖 详细文档](#-详细文档)
- [❓ 常见问题](#-常见问题)

## 🚀 快速开始

基于 Spring Boot + Vue 前后端分离的内容管理系统，支持 **Mac** 和 **Ubuntu** 环境一键部署。

### ⚡ 超快速部署（推荐）

**Mac 环境：**
```bash
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro
./scripts/start-all.sh  # 一键启动所有服务
```

**Ubuntu 环境：**
```bash
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro
./scripts/check-system.sh    # 检测系统兼容性（推荐）
./scripts/ubuntu-install.sh  # 一键安装依赖（自动适配架构）
./scripts/ubuntu-start.sh    # 一键启动服务
```

### 🏗️ 多架构支持

| 架构 | 设备示例 | 支持状态 |
|------|----------|----------|
| **x86_64** | 服务器、PC | ✅ 完全支持 |
| **ARM64** | 树莓派4/5、Jetson Orin、阿里云ARM | ✅ 自动优化 |
| **ARM32** | 树莓派3 | ⚠️ 轻量化支持 |

#### 🍓 树莓派部署特殊说明

**已解决的关键问题：**
1. ✅ **Maven 下载慢** - 自动配置阿里云镜像
2. ✅ **MariaDB 兼容性** - 自动转换字符集排序规则
3. ✅ **ARM64 原生模块** - 自动安装 `@oxc-parser/binding-linux-arm64-gnu`
4. ✅ **网络绑定问题** - 自动配置 `--host 0.0.0.0`
5. ✅ **npm 下载慢** - 自动配置淘宝镜像
6. ✅ **数据库初始化** - 自动创建用户和导入表结构

**树莓派用户无需额外操作，脚本会自动处理所有兼容性问题！**

**如遇问题，可运行修复脚本：**
```bash
./scripts/fix-frontend-deps.sh  # 修复前端依赖
./scripts/status.sh             # 查看服务状态
./scripts/logs.sh               # 查看详细日志
```

**详细文档：**
- 📖 [树莓派部署指南](docs/RASPBERRY_PI_DEPLOYMENT.md)
- 🔧 [部署问题解决方案](docs/DEPLOYMENT_SOLUTIONS.md)

### 🔐 密码管理

**所有密码都已预配置强密码，无需手动设置：**
```bash
# 查看所有密码和配置信息
./scripts/show-passwords.sh
```

**默认配置：**
- MySQL Root 密码: `IceCMS@2024#Root`
- 数据库用户密码: `IceCMS@2024#User`
- 管理员账号: `admin` / `admin123`

### 🎯 启动后访问地址

- **管理后台**: http://localhost:2580 (账号: `admin` 密码: `admin123`)
- **用户前台**: http://localhost:3000
- **API文档**: http://localhost:8181/doc.html

## 💻 环境要求

### 🔴 重要提示：Java 版本要求

**⚠️ 本项目推荐使用 Java 11 或更高版本，不再推荐 Java 8**

- **推荐**: Java 11+ (LTS 长期支持版本)
- **最低**: Java 8 (需要额外配置，不推荐)

**Java 11+ 的优势：**
- ✅ 更好的性能和内存管理
- ✅ 长期支持版本（LTS）
- ✅ 更好的容器化支持
- ✅ 现代化的垃圾收集器
- ✅ 更好的安全性和稳定性

### 系统要求

| 组件 | Mac 环境 | Ubuntu 环境 | 说明 |
|------|----------|-------------|------|
| **Java** | JDK 11+ | JDK 11+ | 推荐 OpenJDK |
| **Node.js** | 18.18.0+ | 18.18.0+ | 支持 20.x |
| **MySQL** | 5.7+ / 8.0+ | 5.7+ / 8.0+ | 字符集 utf8mb4 |
| **Redis** | 3.0+ | 3.0+ | 可选，用于缓存 |
| **Maven** | 3.6+ | 3.6+ | 构建工具 |
| **pnpm** | 8.6.10+ | 8.6.10+ | 包管理器 |

## 🔧 部署指南

### Mac 环境部署

**方式一：一键启动（推荐）**
```bash
# 克隆项目
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro

# 一键启动（自动安装依赖并启动服务）
./scripts/start-all.sh
```

**方式二：分步安装**
```bash
# 1. 安装依赖
./scripts/install-dependencies.sh

# 2. 启动服务
./scripts/start-all.sh

# 3. 管理服务
./scripts/status.sh      # 查看状态
./scripts/stop-all.sh    # 停止服务
./scripts/logs.sh        # 查看日志
```

### Ubuntu 环境部署

**一键部署流程：**
```bash
# 1. 克隆项目
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro

# 2. 一键安装所有依赖（Java、MySQL、Node.js等）
./scripts/ubuntu-install.sh

# 3. 一键启动所有服务
./scripts/ubuntu-start.sh

# 4. 管理服务
./scripts/ubuntu-stop.sh  # 停止服务
./scripts/status.sh       # 查看状态
```
**详细部署文档：**
- 📖 [Ubuntu 部署指南](docs/Ubuntu-Deployment.md)
- 🐳 [Docker 部署指南](docs/DOCKER_DEPLOYMENT.md)

### 📚 核心文档一览

#### 1. [项目分析与现代化方案](docs/PROJECT_ANALYSIS_AND_MODERNIZATION.md)
- 🔍 深度问题分析
- 🚀 现代化重构方案
- 🛠️ 技术实施细节
- 📊 预期收益分析

#### 2. [快速参考指南](docs/QUICK_REFERENCE_GUIDE.md)
- ⚡ 关键信息速查
- 🎯 实施步骤清单
- 🔧 技术选型建议
- 📈 成功标准定义

#### 3. [AI 助手专用指导](docs/AI_RECONSTRUCTION_GUIDE.md)
- 🤖 AI 决策矩阵
- 🎯 问题诊断流程
- 💡 最佳实践原则
- 📋 常见问题解决方案

### Docker 部署

**快速 Docker 部署：**
```bash
# 克隆项目
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro/IceCMS-Docker

# 一键启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps
```

**详细文档：** 📖 [Docker 部署指南](docs/DOCKER_DEPLOYMENT.md)

## 📁 项目结构

```
IceCMS-Pro/
├── IceCMS-main/              # 后端主服务 (Spring Boot + Java 11)
├── IceCMS-front-admin/       # 管理后台 (Vue 3 + Vite + TypeScript)
├── IceCMS-front-nuxt3/       # 用户前台 (Nuxt 3 + Vue 3)
├── IceCMS-Docker/            # Docker 部署配置
├── IceCMS-uniApp/            # 移动端应用 (uni-app)
├── IceCMS-ment/              # 评论服务模块
├── IcePay-ment/              # 支付服务模块
├── scripts/                  # 🔧 部署和管理脚本
│   ├── start-all.sh          # Mac 一键启动
│   ├── ubuntu-install.sh     # Ubuntu 一键安装
│   ├── ubuntu-start.sh       # Ubuntu 一键启动
│   └── ...                   # 其他管理脚本
├── docs/                     # 📖 文档目录
├── sql/                      # 数据库脚本
└── logs/                     # 日志文件
```

## 🌐 访问地址

| 服务 | 地址 | 说明 |
|------|------|------|
| **管理后台** | http://localhost:2580 | 账号: `admin` 密码: `admin123` |
| **用户前台** | http://localhost:3000 | 网站前台页面 |
| **后端 API** | http://localhost:8181 | RESTful API 服务 |
| **API 文档** | http://localhost:8181/doc.html | Swagger 接口文档 |

## 📖 详细文档

| 文档 | 说明 | 适用环境 |
|------|------|----------|
| 📱 [Mac 部署指南](docs/IceCMS项目技术分析与Mac本地部署指南.md) | 详细的 Mac 环境部署教程 | macOS |
| 🐧 [Ubuntu 部署指南](docs/Ubuntu-Deployment.md) | 完整的 Ubuntu 部署和生产配置 | Ubuntu 18.04+ |
| 🐳 [Docker 部署指南](docs/DOCKER_DEPLOYMENT.md) | 容器化部署方案 | 跨平台 |
| 🍓 [树莓派部署指南](docs/RASPBERRY_PI_DEPLOYMENT.md) | 树莓派专门部署教程 | ARM64/ARM32 |
| 🔧 [部署问题解决方案](docs/DEPLOYMENT_SOLUTIONS.md) | 常见问题及解决方案 | 全平台 |

## ❓ 常见问题

### 🔧 Java 版本问题

**Q: 为什么推荐 Java 11 而不是 Java 8？**

A: Java 11 是 LTS 版本，具有以下优势：
- 更好的性能和内存管理
- 更强的安全性和稳定性
- 更好的容器化支持
- 现代化的垃圾收集器

**Q: 如果必须使用 Java 8 怎么办？**

A: 需要在 `pom.xml` 中添加以下依赖：
```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.0</version>
</dependency>
```

### 🚀 部署问题

**Q: 端口被占用怎么办？**
```bash
# 查看端口占用
lsof -i :8181  # Mac
ss -tulpn | grep :8181  # Ubuntu

# 修改端口配置
# 编辑 IceCMS-main/src/main/resources/application.yml
```

**Q: 数据库连接失败？**
- 确保 MySQL 服务正在运行
- 检查数据库字符集为 `utf8mb4`
- 确认用户权限正确

**Q: 前端依赖安装失败（Ubuntu 环境）？**

Ubuntu 环境可能遇到 `oxc-parser` 原生模块问题：
```bash
# 使用专门的修复脚本
./scripts/fix-frontend-deps.sh

# 或手动修复
cd IceCMS-front-nuxt3
rm -rf node_modules .nuxt
pnpm install --ignore-scripts --no-optional
```

## 🌟 项目简介

基于 Spring Boot + Vue 前后端分离的现代化内容管理系统，支持 **Mac** 和 **Ubuntu** 环境一键部署。

### 🎯 在线演示

- **前台演示**: [www.icecmspro.com](https://www.icecmspro.com/)
- **管理后台**: [admin.icecmspro.com](https://admin.icecmspro.com/) (admin/admin123)
- **API 文档**: [api.icecmspro.com/doc.html](https://api.icecmspro.com/doc.html)

### 📚 官方资源

- **官方网站**: [www.icecms.cn](https://www.icecms.cn)
- **技术文档**: [doc.icecms.cn](https://doc.icecms.cn)
- **源作者GitHub**: [github.com/zlcggb/IceCMS-Pro](https://github.com/zlcggb/IceCMS-Pro)

## ⚠️ 重要提示

### 关于大文件
- 项目中的 JAR 文件（如 `main.jar`）较大，已从仓库中排除
- 首次运行时，脚本会自动构建生成所需的 JAR 文件
- 如需预构建的 JAR 文件，请查看 [Releases 页面](https://github.com/zlcggb/IceCMS-Pro/releases)

### 数据库字符集
- 确保 MySQL 数据库字符集为 `utf8mb4`
- 支持 emoji 表情和特殊字符
- 导入 SQL 文件前请确认字符集配置

内容管理：文章、图片、资源等多种类型的内容管理；

栏目管理：自定义栏目，对栏目进行增删改查等操作；

用户管理：管理后台用户，包括添加、删除、修改、权限分配等功能；

数据统计：对网站访问量、用户行为等进行统计分析；

模板管理：自定义网站模板，方便快速搭建网站；

SEO优化：网站标题、关键词、描述等SEO优化功能。

## PC端
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689828922/63d19ee5a6c55_xu7ex3.png"  width = "50%">
    <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829049/63d19ee456c4b_fhibyf.png"  width = "50%">
</div>
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829099/63d19ee6e070e_meudqj.png"  width = "50%">
    <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829121/63d19ee4b609d_pt54fj.png"  width = "50%">
</div>
## 后台
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1710237058/Screenshot_2024-03-12_at_17.48.51_el9tcs.png"  width = "50%">
    <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1710237057/Screenshot_2024-03-12_at_17.49.02_eioj84.png"  width = "50%">
</div>
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1710237060/Screenshot_2024-03-12_at_17.49.12_x7aotb.png"  width = "50%">
</div>
## UniApp H5、小程序移动端

<img alt="describe" src="https://i0.hdslb.com/bfs/album/354a1caa29bfd8bc9571be67b18db13227bea80f.png" width="280" height="405">

