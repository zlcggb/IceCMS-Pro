# IceCMS-Pro

[简体中文](README.md) | English

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
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/Mac-One--Click--Deploy-red">
	<img style="padding: 4px;" alt="Label" src="https://img.shields.io/badge/Ubuntu-One--Click--Deploy-blue">
</p>

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [💻 Requirements](#-requirements)
- [🔧 Deployment Guide](#-deployment-guide)
- [📁 Project Structure](#-project-structure)
- [🌐 Access URLs](#-access-urls)
- [📖 Documentation](#-documentation)
- [❓ FAQ](#-faq)

## 🚀 Quick Start

A modern Content Management System based on Spring Boot + Vue with frontend-backend separation, supporting **Mac** and **Ubuntu** one-click deployment.

### ⚡ Super Quick Deployment (Recommended)

**Mac Environment:**
```bash
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro
./scripts/start-all.sh  # One-click start all services
```

**Ubuntu Environment:**
```bash
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro
./scripts/check-system.sh    # Check system compatibility (recommended)
./scripts/ubuntu-install.sh  # One-click install dependencies (auto-adapt architecture)
./scripts/ubuntu-start.sh    # One-click start services
```

### 🏗️ Multi-Architecture Support

| Architecture | Device Examples | Support Status |
|--------------|-----------------|----------------|
| **x86_64** | Servers, PCs | ✅ Full Support |
| **ARM64** | Raspberry Pi 4/5, Jetson Orin, Alibaba Cloud ARM | ✅ Auto-Optimized |
| **ARM32** | Raspberry Pi 3 | ⚠️ Lightweight Support |

#### 🍓 Raspberry Pi Deployment Notes

**Key Issues Resolved:**
1. ✅ **Slow Maven Downloads** - Auto-configure Alibaba Cloud mirrors
2. ✅ **MariaDB Compatibility** - Auto-convert charset collation rules
3. ✅ **ARM64 Native Modules** - Auto-install `@oxc-parser/binding-linux-arm64-gnu`
4. ✅ **Network Binding Issues** - Auto-configure `--host 0.0.0.0`
5. ✅ **Slow npm Downloads** - Auto-configure Taobao mirrors
6. ✅ **Database Initialization** - Auto-create users and import table structures

**Raspberry Pi users need no extra operations - scripts handle all compatibility issues automatically!**

**If you encounter issues, run repair scripts:**
```bash
./scripts/fix-frontend-deps.sh  # Fix frontend dependencies
./scripts/status.sh             # Check service status
./scripts/logs.sh               # View detailed logs
```

**Detailed Documentation:**
- 📖 [Raspberry Pi Deployment Guide](docs/RASPBERRY_PI_DEPLOYMENT.md)
- 🔧 [Deployment Solutions](docs/DEPLOYMENT_SOLUTIONS.md)

### 🔐 Password Management

**All passwords are pre-configured with strong passwords, no manual setup required:**
```bash
# View all passwords and configuration info
./scripts/show-passwords.sh
```

**Default Configuration:**
- MySQL Root Password: `IceCMS@2024#Root`
- Database User Password: `IceCMS@2024#User`
- Admin Account: `admin` / `admin123`

### 🎯 Access URLs After Startup

- **Admin Panel**: http://localhost:2580 (Username: `admin` Password: `admin123`)
- **User Frontend**: http://localhost:3000
- **API Documentation**: http://localhost:8181/doc.html

## 💻 Requirements

### 🔴 Important: Java Version Requirements

**⚠️ This project recommends Java 11 or higher, Java 8 is no longer recommended**

- **Recommended**: Java 11+ (LTS Long Term Support)
- **Minimum**: Java 8 (requires additional configuration, not recommended)

**Advantages of Java 11+:**
- ✅ Better performance and memory management
- ✅ Long Term Support (LTS) version
- ✅ Better containerization support
- ✅ Modern garbage collectors
- ✅ Enhanced security and stability

### System Requirements

| Component | Mac Environment | Ubuntu Environment | Notes |
|-----------|-----------------|-------------------|-------|
| **Java** | JDK 11+ | JDK 11+ | Recommend OpenJDK |
| **Node.js** | 18.18.0+ | 18.18.0+ | Support 20.x |
| **MySQL** | 5.7+ / 8.0+ | 5.7+ / 8.0+ | Charset utf8mb4 |
| **Redis** | 3.0+ | 3.0+ | Optional, for caching |
| **Maven** | 3.6+ | 3.6+ | Build tool |
| **pnpm** | 8.6.10+ | 8.6.10+ | Package manager |

## 🔧 Deployment Guide

### Mac Deployment

**Method 1: One-Click Start (Recommended)**
```bash
# Clone project
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro

# One-click start (auto-install dependencies and start services)
./scripts/start-all.sh
```

**Method 2: Step-by-Step Installation**
```bash
# 1. Install dependencies
./scripts/install-dependencies.sh

# 2. Start services
./scripts/start-all.sh

# 3. Manage services
./scripts/status.sh      # Check status
./scripts/stop-all.sh    # Stop services
./scripts/logs.sh        # View logs
```

### Ubuntu Deployment

**One-Click Deployment Process:**
```bash
# 1. Clone project
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro

# 2. One-click install all dependencies (Java, MySQL, Node.js, etc.)
./scripts/ubuntu-install.sh

# 3. One-click start all services
./scripts/ubuntu-start.sh

# 4. Manage services
./scripts/ubuntu-stop.sh  # Stop services
./scripts/status.sh       # Check status
```

### Docker Deployment

**Quick Docker Deployment:**
```bash
# Clone project
git clone https://github.com/zlcggb/IceCMS-Pro.git
cd IceCMS-Pro/IceCMS-Docker

# One-click start all services
docker-compose up -d

# Check service status
docker-compose ps
```

**Detailed Documentation:** 📖 [Docker Deployment Guide](docs/DOCKER_DEPLOYMENT.md)

### 📚 Core Documentation Overview

#### 1. [Project Analysis & Modernization](docs/PROJECT_ANALYSIS_AND_MODERNIZATION.md)
- 🔍 In-depth problem analysis
- 🚀 Modernization refactoring solutions
- 🛠️ Technical implementation details
- 📊 Expected benefits analysis

#### 2. [Quick Reference Guide](docs/QUICK_REFERENCE_GUIDE.md)
- ⚡ Key information quick lookup
- 🎯 Implementation step checklist
- 🔧 Technology selection recommendations
- 📈 Success criteria definition

#### 3. [AI Assistant Guide](docs/AI_RECONSTRUCTION_GUIDE.md)
- 🤖 AI decision matrix
- 🎯 Problem diagnosis process
- 💡 Best practice principles
- 📋 Common problem solutions

## 📁 Project Structure

```
IceCMS-Pro/
├── IceCMS-main/              # Backend main service (Spring Boot + Java 11)
├── IceCMS-front-admin/       # Admin panel (Vue 3 + Vite + TypeScript)
├── IceCMS-front-nuxt3/       # User frontend (Nuxt 3 + Vue 3)
├── IceCMS-Docker/            # Docker deployment configuration
├── IceCMS-uniApp/            # Mobile app (uni-app)
├── IceCMS-ment/              # Comment service module
├── IcePay-ment/              # Payment service module
├── scripts/                  # 🔧 Deployment and management scripts
│   ├── start-all.sh          # Mac one-click start
│   ├── ubuntu-install.sh     # Ubuntu one-click install
│   ├── ubuntu-start.sh       # Ubuntu one-click start
│   └── ...                   # Other management scripts
├── docs/                     # 📖 Documentation directory
├── sql/                      # Database scripts
└── logs/                     # Log files
```

## 🌐 Access URLs

| Service | URL | Description |
|---------|-----|-------------|
| **Admin Panel** | http://localhost:2580 | Username: `admin` Password: `admin123` |
| **User Frontend** | http://localhost:3000 | Website frontend pages |
| **Backend API** | http://localhost:8181 | RESTful API service |
| **API Documentation** | http://localhost:8181/doc.html | Swagger interface documentation |

## 📖 Documentation

| Document | Description | Applicable Environment |
|----------|-------------|----------------------|
| 📱 [Mac Deployment Guide](docs/IceCMS项目技术分析与Mac本地部署指南.md) | Detailed Mac environment deployment tutorial | macOS |
| 🐧 [Ubuntu Deployment Guide](docs/Ubuntu-Deployment.md) | Complete Ubuntu deployment and production configuration | Ubuntu 18.04+ |
| 🐳 [Docker Deployment Guide](docs/DOCKER_DEPLOYMENT.md) | Containerized deployment solution | Cross-platform |
| 🍓 [Raspberry Pi Deployment Guide](docs/RASPBERRY_PI_DEPLOYMENT.md) | Specialized Raspberry Pi deployment tutorial | ARM64/ARM32 |
| 🔧 [Deployment Solutions](docs/DEPLOYMENT_SOLUTIONS.md) | Common issues and solutions | All platforms |

## ❓ FAQ

### 🔧 Java Version Issues

**Q: Why recommend Java 11 instead of Java 8?**

A: Java 11 is an LTS version with the following advantages:
- Better performance and memory management
- Enhanced security and stability
- Better containerization support
- Modern garbage collectors

**Q: What if I must use Java 8?**

A: You need to add the following dependency in `pom.xml`:
```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.0</version>
</dependency>
```

### 🚀 Deployment Issues

**Q: What if ports are occupied?**
```bash
# Check port usage
lsof -i :8181  # Mac
ss -tulpn | grep :8181  # Ubuntu

# Modify port configuration
# Edit IceCMS-main/src/main/resources/application.yml
```

**Q: Database connection failed?**
- Ensure MySQL service is running
- Check database charset is `utf8mb4`
- Confirm user permissions are correct

**Q: Frontend dependency installation failed (Ubuntu environment)?**

Ubuntu environment may encounter `oxc-parser` native module issues:
```bash
# Use specialized repair script
./scripts/fix-frontend-deps.sh

# Or manual repair
cd IceCMS-front-nuxt3
rm -rf node_modules .nuxt
pnpm install --ignore-scripts --no-optional
```

## 🌟 Project Introduction

A modern Content Management System based on Spring Boot + Vue with frontend-backend separation, supporting **Mac** and **Ubuntu** one-click deployment.

### 🎯 Online Demo

- **Frontend Demo**: [www.icecmspro.com](https://www.icecmspro.com/)
- **Admin Panel**: [admin.icecmspro.com](https://admin.icecmspro.com/) (admin/admin123)
- **API Documentation**: [api.icecmspro.com/doc.html](https://api.icecmspro.com/doc.html)

### 📚 Official Resources

- **Official Website**: [www.icecms.cn](https://www.icecms.cn)
- **Technical Documentation**: [doc.icecms.cn](https://doc.icecms.cn)
- **Original Author GitHub**: [github.com/zlcggb/IceCMS-Pro](https://github.com/zlcggb/IceCMS-Pro)

## ⚠️ Important Notes

### About Large Files
- JAR files in the project (such as `main.jar`) are large and excluded from the repository
- On first run, scripts will automatically build and generate required JAR files
- For pre-built JAR files, please check the [Releases page](https://github.com/zlcggb/IceCMS-Pro/releases)

### Database Charset
- Ensure MySQL database charset is `utf8mb4`
- Support emoji expressions and special characters
- Confirm charset configuration before importing SQL files

## 🎯 Features

**Content Management**: Articles, images, resources and other types of content management;

**Category Management**: Custom categories, CRUD operations on categories;

**User Management**: Backend user management, including add, delete, modify, permission assignment functions;

**Data Statistics**: Statistical analysis of website traffic, user behavior, etc.;

**Template Management**: Custom website templates for quick website building;

**SEO Optimization**: Website title, keywords, description and other SEO optimization functions.

## PC Screenshots
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689828922/63d19ee5a6c55_xu7ex3.png"  width = "50%">
    <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829049/63d19ee456c4b_fhibyf.png"  width = "50%">
</div>
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829099/63d19ee6e070e_meudqj.png"  width = "50%">
    <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829121/63d19ee4b609d_pt54fj.png"  width = "50%">
</div>

## Admin Panel
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1710237058/Screenshot_2024-03-12_at_17.48.51_el9tcs.png"  width = "50%">
    <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1710237057/Screenshot_2024-03-12_at_17.49.02_eioj84.png"  width = "50%">
</div>
<div class = "half">
  <img alt="describe" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1710237060/Screenshot_2024-03-12_at_17.49.12_x7aotb.png"  width = "50%">
</div>

## UniApp H5, Mini Program Mobile
<img alt="describe" src="https://i0.hdslb.com/bfs/album/354a1caa29bfd8bc9571be67b18db13227bea80f.png" width="280" height="405">
