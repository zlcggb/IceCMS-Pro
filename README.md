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
### 创建的核心文档
# 1. docs/PROJECT_ANALYSIS_AND_MODERNIZATION.md - 主要分析报告
🔍 深度问题分析
🚀 现代化重构方案
🛠️ 技术实施细节
📊 预期收益分析
# 2.docs/QUICK_REFERENCE_GUIDE.md - 快速参考指南
⚡ 关键信息速查
🎯 实施步骤清单
🔧 技术选型建议
📈 成功标准定义
# 3.docs/AI_RECONSTRUCTION_GUIDE.md - AI 助手专用指导
🤖 AI 决策矩阵
🎯 问题诊断流程
💡 最佳实践原则
📋 常见问题解决方案


**详细部署文档：** 📖 [Ubuntu 部署指南](docs/Ubuntu-Deployment.md)

### Docker 部署

```bash
# 快速 Docker 部署
cd IceCMS-Docker
docker-compose up -d
```

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
| 📱 [Mac 部署指南](IceCMS项目技术分析与Mac本地部署指南.md) | 详细的 Mac 环境部署教程 | macOS |
| 🐧 [Ubuntu 部署指南](docs/Ubuntu-Deployment.md) | 完整的 Ubuntu 部署和生产配置 | Ubuntu 18.04+ |
| 🐳 [Docker 部署](IceCMS-Docker/) | 容器化部署方案 | 跨平台 |

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
- **GitHub**: [github.com/zlcggb/IceCMS-Pro](https://github.com/zlcggb/IceCMS-Pro)

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

## 预览地址：

前台：[www.icecmspro.com](https://www.icecmspro.com)

uniapp移动端：[uni.icecmspro.com](https://m.www.icecmspro.com)

后台：[admin.icecmspro.com](https://admin.icecmspro.com) 账号`admin`密码`admin123`

API文档：[api.icecmspro.com/doc.html](https://api.icecmspro.com/doc.html)

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


## 后端

1. 核心框架：[Spring Boot](https://github.com/spring-projects/spring-boot)
2. 安全框架：[Spring Security](https://github.com/spring-projects/spring-security)
3. Token 认证：[jjwt](https://github.com/jwtk/jjwt)
4. 持久层框架：[MyBatis](https://github.com/mybatis/spring-boot-starter)
5. 分页插件：[PageHelper](https://github.com/pagehelper/Mybatis-PageHelper)
6. NoSQL缓存：[Redis](https://github.com/redis/redis)
7. Markdown 转 HTML：[commonmark-java](https://github.com/commonmark/commonmark-java)
8. 离线 IP 地址库：[ip2region](https://github.com/lionsoul2014/ip2region)

**重要提示：推荐使用 JDK 11 或以上版本以获得更好的兼容性和性能。**

JDK 11+ 的优势：
- 更好的性能和内存管理
- 长期支持版本（LTS）
- 更好的容器化支持
- 现代化的垃圾收集器

如果使用 JDK 8，需要添加以下依赖：

```xml
<dependency>
    <groupId>javax.xml.bind</groupId>
    <artifactId>jaxb-api</artifactId>
    <version>2.3.0</version>
</dependency>
```

## 前端

核心框架：Vue2.x、Vue Router、Vuex

Vue 项目基于 @vue/cli4.x 构建

JS 依赖及参考的 css：[axios](https://github.com/axios/axios)、[moment](https://github.com/moment/moment)、[nprogress](https://github.com/rstacruz/nprogress)、[v-viewer](https://github.com/fengyuanchen/viewerjs)、[prismjs](https://github.com/PrismJS/prism)、[APlayer](https://github.com/DIYgod/APlayer)、[MetingJS](https://github.com/metowolf/MetingJS)、[lodash](https://github.com/lodash/lodash)、[mavonEditor](https://github.com/hinesboy/mavonEditor)、[echarts](https://github.com/apache/echarts)、[tocbot](https://github.com/tscanlin/tocbot)、[iCSS](https://github.com/chokcoco/iCSS)

### 后台 UI

后台 CMS 部分基于 [vue-admin-template](https://github.com/PanJiaChen/vue-admin-template)

UI 框架为 [Element UI](https://github.com/ElemeFE/element)


### 前台 UI

[Element UI](https://github.com/ElemeFE/element)：部分使用，一些小组件，更改了ui样式，便于快速实现效果


## 最近更新

增加标签功能

完善部分ui

docker 前端部署方式

docker compose 一键部署


# 快速开始
Docker部署方式(推荐,可用于快速上线或测试)

    # 未安装docker的请先安装docker，已经安装的跳过此步
    yum install docker-ce -y
    #启动docker
    systemctl start docker
    # 配置国内源
    # 创建docker目录
    sudo mkdir -p /etc/docker
    # 创建配置文件
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
    "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
    }
    EOF
    # 加载新的配置文件
    sudo systemctl daemon-reload
    # 重启docker服务
    sudo systemctl restart docker
    
    main-命令执行
    Ps:按顺序执行

    1.运行Mysql容器
    docker run -d -p 0:3389 \
    --name ice-sql \
    --restart always \
    thecosy/icemysql:v2.2.0
    
    2.运行Spring容器
    docker run -d -p 8181:8181 \
    --name ice-api \
    --restart always \
    --link ice-sql:db \
    thecosy/icecms:v2.2.0
    
    3.运行Vue容器
    docker run -d -p 3000:80 \
    --name ice-vue \
    --restart always \
    --link  ice-api:iceApi \
    thecosy/icevue:v2.2.0
    
    #访问前端地址http://ip:3000

## 目录结构
    iceCMS/
    ├── HELP.md
    ├── IceCMS-java.iml
    ├── IceCMS-main             --java主程序启动入口
    │   ├── IceCMS-main.iml
    │   ├── main.iml
    │   ├── pom.xml
    │   ├── src
    │   └── target
    ├── IcePay-ment             --java支付模块
    │   ├── IcePay-ment.iml
    │   ├── pom.xml
    │   ├── src
    │   └── target
    ├── IceWk-ment              --java前端api模块
    │   ├── IceWk-ment.iml
    │   ├── pom.xml
    │   ├── src
    │   └── target
    ├── IceWk-uniApp            --h5Uniapp模块
    │   ├── App.vue
    │   ├── LICENSE
    │   ├── components
    │   ├── main.js
    │   ├── manifest.json
    │   ├── nPro
    │   ├── package-lock.json
    │   ├── package.json
    │   ├── pages
    │   ├── pages.json
    │   ├── static
    │   ├── store
    │   ├── subPage
    │   ├── template.h5.html
    │   ├── theme
    │   ├── uni.scss
    │   ├── uni_modules
    │   ├── utils
    │   └── vue.config.js
    ├── IceWk-vues                --前端vue模块
    │   ├── LICENSE
    │   ├── README.md
    │   ├── babel.config.js
    │   ├── build
    │   ├── dist
    │   ├── jest.config.js
    │   ├── jsconfig.json
    │   ├── node_modules
    │   ├── package-lock.json
    │   ├── package.json
    │   ├── postcss.config.js
    │   ├── public
    │   ├── serverless.yml
    │   ├── src
    │   ├── vue.config.js
    │   └── yarn.lock
    ├── README.md
    ├── bin
    │   ├── clean.bat
    │   ├── package.bat
    │   └── run.bat
    ├── doc
    │   └── IceCMS环境使用手册.docx
    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    └── sql                        --项目sql文件
    ├── icecms5.6.sql
    └── icecms8.0.sql

## 🛠️ 环境要求

### 必需环境

- **Java**: JDK 11+ （推荐）或 JDK 1.8+
- **Node.js**: 16.0+
- **MySQL**: 5.7+ 或 8.0+
- **Redis**: 3.0+ （可选，用于缓存）
- **Maven**: 3.6+
- **Git**: 2.0+
- **Git LFS**: 用于大文件管理

### 开发工具（可选）

- IntelliJ IDEA 或 Eclipse
- VS Code
- 微信开发者工具（用于uni-app开发）

### <strong>后端部署</strong>

2.创建 MySQL 数据库`IceCMS`，并执行`/sql/IceCMS.sql`初始化表数据

3.启动iceCMS-main管理后台的后端服务

3.1.修改配置信息`IceCMS-main/src/main/resources/application.yml`配置数据库连接

3.2.安装 Redis 并启动(不用的话不影响)

3.3.打开命令行，输入以下命令

    cd iceCMS
    mvn install
    mvn clean package
    java -Dfile.encoding=UTF-8 -jar iceCMS/iceCMS-main/target/iceCMS.jar
    #在iceCMS.jar目录输入 java -jar iceCMS.jar

### <strong>前端部署</strong>

4.进入iceCMS-vues目录

打开命令行，输入以下命令

```bash
# 克隆项目
git clone https://github.com/PanJiaChen/vue-admin-template.git

# 进入项目目录
cd IceWk-VUE

# 安装依赖
npm install

# 建议不要直接使用 cnpm 安装以来，会有各种诡异的 bug。可以通过如下操作解决 npm 下载速度慢的问题
npm install --legacy-peer-deps --registry=https://registry.npm.taobao.org
# 启动服务
npm run dev
```
### 发布

```bash
# 构建测试环境
npm run build:stage

# 构建生产环境
npm run build:prod
```

5.启动前端

浏览器打开，访问 [http://localhost:9528](http://localhost:9528)
, 此时进入前端页面。

启动前端后台（后台地址http://localhost:9528/admin）

6.启动uniapp移动端

下载HBuilderX

进入（[https://ext.dcloud.net.cn/plugin?id=9261](https://ext.dcloud.net.cn/plugin?id=9261)）uniapp移动端插件目录，点击导入，然后即可导入到本地。

也可在本地打开IceCMS-uniapp项目

打开`IceWK-uniApp`目录,进行编译打包

## 注意事项

一些常见问题：

- MySQL 确保数据库字符集为`utf8mb4`的情况下通常没有问题（”站点设置“及”文章详情“等许多表字段需要`utf8mb4`格式字符集来支持 emoji 表情，否则在导入 sql 文件时，即使成功导入，也会有部分字段内容不完整，导致前端页面渲染数据时报错）
- 确保 Maven 能够成功导入现版本依赖，请勿升级或降低依赖版本
- 数据库中默认用户名密码为`root`，`123123`，因为是个人项目，没打算做修改密码的页面，可在`top.naccl.util.HashUtils`下的`main`方法手动生成密码存入数据库
- 注意修改IceCMS-main目录下的`application-dev.properties`的配置信息
  - Redis 若没有密码，留空即可
  - 注意修改`token.secretKey`，否则无法保证 token 安全性

[//]: # (  - `spring.mail.host`及`spring.mail.port`的默认配置为阿里云邮箱，其它邮箱服务商参考关键字`spring mail 服务器`（邮箱配置用于接收评论提醒）)



[//]: # (## 隐藏功能)

[//]: # ()
[//]: # (- 在前台访问`/login`路径登录后，可以以博主身份（带有博主标识）回复评论，且不需要填写昵称和邮箱即可提交)

[//]: # (- 在 Markdown 中加入`<meting-js server="netease" type="song" id="歌曲id" theme="#25CCF7"></meting-js>` （注意以正文形式添加，而不是代码片段）可以在文章中添加 [APlayer]&#40;https://github.com/DIYgod/APlayer&#41; 音乐播放器，`netease`为网易云音乐，其它配置及具体用法参考 [MetingJS]&#40;https://github.com/metowolf/MetingJS&#41;)

[//]: # (- 提供了两种隐藏文字效果：在 Markdown 中使用`@@`包住文字，文字会被渲染成“黑幕”效果，鼠标悬浮在上面时才会显示；使用`%%`包住文字，文字会被“蓝色覆盖层”遮盖，只有鼠标选中状态才会反色显示。例如：`@@隐藏文字@@`，`%%隐藏文字%%`)

[//]: # (- 大部分个性化配置可以在后台“站点设置”中修改，小部分由于考虑到首屏加载速度（如首页大图）需要修改前端源码)


## QQ交流群

QQ交流群：（[951286996](https://qm.qq.com/cgi-bin/qm/qr?k=XLX0hSw6GGuOgNbC53r-Pc7Lrubwcm4q&authKey=AaNuGPfAWTSyaN6MR5yGYFQ0+4AKsZQq7kI0uRASo+v5ttyrc6xvh7gfNEMQ7UDR&noverify=0)）

Tg群组：[https://t.me/+1rau4SBwFyE1OTA1](https://t.me/+1rau4SBwFyE1OTA1）

该群是一个学习交流群，如果是程序相关问题，请直接提交issues

## 软著

<div class = "half">
  <img alt="describe" style="width:420px" src = "https://res.cloudinary.com/dxl1idlr5/image/upload/v1689829207/%E7%99%BB%E8%AE%B0%E8%AF%81%E4%B9%A6_2023R11L0135975__mosaic_wgmw6p.jpg"  width = "50%">
</div>

## 开源协议
GPL-3.0 license © pipipi-pikachu

## 商业用途
* 如果你希望将本项目商用盈利，我希望你能严格遵循 GPL-3.0 协议；
* 如果你真的需要闭源商用，无法执行 GPL-3.0 协议，可以选择：
* 成为项目的贡献者，大致包括：
* 你的代码被本项目作为依赖引用；
* 你提交的 PR 被本项目合并（仅限有价值的，不包括简单的错别字或拼写错误修改等）；
* 你参与过本项目的设计、实现（也包括对各种功能/模块的实现或Bug的修复提供了有价值的思路）；
* 联系作者付费商用


## Thanks

感谢 [JetBrains](https://www.jetbrains.com/) 提供的非商业开源软件 License


## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=Thecosy/IceCMS&type=Date)](https://star-history.com/#Thecosy/IceCMS&Date)
