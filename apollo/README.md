# Apollo 入门指南

## 1、什么是 Apollo

Apollo（阿波罗）是携程框架部门研发的开源配置管理中心，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送
到应用端，并且具备规范的权限、流程治理等特性。 Apollo 支持 4 个维度管理 Key-Value 格式的配置：

-   application(应用)
-   environment(环境)
-   cluster(集群)
-   namespace(命名空间)

Apollo 基于开源模式开发，开源地址：https://github.com/ctripcorp/apollo

## 2、配置基本概念

### 配置是独立于程序的只读变量

配置首先是独立于程序的，同一份程序在不同的配置下会有不同的行为。其次，配置对于程序是只读的，程序通过读取配置来改变自己的
行为，但是程序不应该去改变配置。常见的配置有
：DBConnectionStr、ThreadPoolSize、BufferSize、RequestTimeout、FeatureSwitch、ServerUrls 等。

### 配置伴随应用的整个生命周期

配置贯穿于应用的整个生命周期，应用在启动时通过读取配置来初始化，在运行时根据配置调整行为。

### 配置可以有多种加载方式

配置也有很多种加载方式，常见的有程序内部 hardcode，配置文件，环境变量，启动参数，基于数据库等

### 配置需要治理

#### 权限控制

由于配置能改变程序的行为，不正确的配置甚至能引起灾难，所以对配置的修改必须有比较完善的权限控制

#### 不同环境、集群配置管理

同一份程序在不同的环境（开发，测试，生产）、不同的集群（如不同的数据中心）经常需要有不同的配置，所以需要有完善的环境、集
群配置管理

#### 框架类组件配置管理

还有一类比较特殊的配置-框架类组件配置，比如 CAT 客户端的配置。虽然这类框架类组件是由其他团队开发、维护，但是运行时是在业
务实际应用内的，所以本质上可以认为框架类组件也是应用的一部分。这类组件对应的配置也需要有比较完善的管理方式。

## 3、为什么使用 Apollo

### 统一管理不同环境、不同集群的配置

Apollo 提供了一个统一界面集中式管理不同环境（environment）、不同集群（cluster）、不同命名空间（namespace）的配置。同一份
代码部署在不同的集群，可以有不同的配置，比如 zookeeper 的地址等通过命名空间（namespace）可以很方便地支持多个不同应用共享
同一份配置，同时还允许应用对共享的配置进行覆盖

### 配置修改实时生效（热发布）

用户在 Apollo 修改完配置并发布后，客户端能实时（1 秒）接收到最新的配置，并通知到应用程序

### 版本发布管理

所有的配置发布都有版本概念，从而可以方便地支持配置的回滚

### 灰度发布

支持配置的灰度发布，比如点了发布后，只对部分应用实例生效，等观察一段时间没问题后再推给所有应用实例

### 权限管理、发布审核、操作审计

应用和配置的管理都有完善的权限管理机制，对配置的管理还分为了编辑和发布两个环节，从而减少人为的错误。所有的操作都有审计日
志，可以方便地追踪问题

### 客户端配置信息监控

可以在界面上方便地看到配置在被哪些实例使用

### 提供 Java 和.Net 原生客户端

提供了 Java 和.Net 的原生客户端，方便应用集成支持 SpringPlaceholder,Annotation 和 SpringBoot 的
ConfigurationProperties，方便应用使用（需要 Spring3.1.1+）同时提供了 Http 接口，非 Java 和.Net 应用也可以方便地使用

### 提供开放平台 API

Apollo 自身提供了比较完善的统一配置管理界面，支持多环境、多数据中心配置管理、权限、流程治理等特性。不过 Apollo 出于通用
性考虑，不会对配置的修改做过多限制，只要符合基本的格式就能保存，不会针对不同的配置值进行针对性的校验，如数据库用户名、密
码，Redis 服务地址等对于这类应用配置，Apollo 支持应用方通过开放平台 API 在 Apollo 进行配置的修改和发布，并且具备完善的授
权和权限控制

### 部署简单

配置中心作为基础服务，可用性要求非常高，这就要求 Apollo 对外部依赖尽可能地少目前唯一的外部依赖是 MySQL，所以部署非常简单
，只要安装好 Java 和 MySQL 就可以让 Apollo 跑起来 Apollo 还提供了打包脚本，一键就可以生成所有需要的安装包，并且支持自定
义运行时参数

## Apollo 执行流程

![image-20220916180253646](/Users/yujiale/Library/Application Support/typora-user-images/image-20220916180253646.png)

## 4、Apollo 安装

Apollo 安装依赖于 MySQL 和 JDK ，建议安装 JDK 1.8 版本以上、MySQL 8.0 版本以上，JDK 和 MySQL 安装详情对应的安装文档

### Apollo 下载

[Apollo](https://github.com/ctripcorp/apollo/releases)

需要下载

-   apollo-adminservice-x.x.x-github.zip
-   apollo-configservice-x.x.x-github.zip
-   apollo-portal-x.x.x-github.zip
-   apollo-x.x.x.zip // 源码包

#### 安装包下载

从 [Apollo-github](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fctripcorp%2Fapollo) 下载最新的源码（当前最
新：v1.4.0），通过 git clone 命令将源码下载到本地：

```bash
git clone https://github.com/ctripcorp/apollo
```

#### 创建 Apollo 数据库

Apollo 服务端共需要两个数据库：ApolloPortalDB 和 ApolloConfigDB，数据库、表的创建和样例数据都分别准备了 sql 文件，只需要
导入数据库即可。 注意：如果你本地已经创建过 Apollo 数据库，请注意备份数据。这里准备的 sql 文件会清空 Apollo 相关的表。

需要注意的是 ApolloPortalDB 只需要在环境部署一个即可，而 ApolloConfigDB 需要在每个环境部署一套，如 fat、uat 和 pro 分别
部署 3 套 ApolloConfigDB

(https://github.com/nobodyiam/apollo-build-scripts/tree/master/sql )

-   创建 ApolloPortalDB

```bash
source /your_local_path/sql/apolloportaldb.sql
```

-   创建 ApolloConfigDB

```bash
source /your_local_path/sql/apolloconfigdb.sql
```

Apollo 服务配置数据库连接

> 注意：填入的用户需要具备对 ApolloPortalDB 和 ApolloConfigDB 数据的读写权限且用户名和密码后面不要有空格!

```properties
#apollo config db info
apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
apollo_config_db_username=用户名
apollo_config_db_password=密码（如果没有密码，留空即可）

# apollo portal db info
apollo_portal_db_url="jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
apollo_portal_db_username=用户名
apollo_portal_db_password=密码（如果没有密码，留空即可）
```

#### 修改 apollo-configservice 服务地址

> 分别是不同环境下的服务地址，这里只配置了（开发-dev）环境下的地址

```bash
vim apollo-portal/config/apollo-env.properties

local.meta=http://192.168.137.5:8080
dev.meta=http://192.168.137.5:8080
fat.meta=http://fill-in-fat-meta-server:8080
uat.meta=http://fill-in-uat-meta-server:8080
lpt.meta=${lpt_meta}
pro.meta=http://fill-in-pro-meta-server:8080
```

ApolloPortalDB 必要配置说明

配置项统一存储在 ApolloPortalDB.ServerConfig 表中，也可以通过[管理员工具] – [系统参数]页面进行配置，无特殊说明则修改完一
分钟实时生效

Key

描述

value

备注

apollo.portal.envs

可支持的环境列表

DEV,FAT,UAT,PRO

默认值是 dev，如果 portal 需要管理多个环境的话，以逗号分隔即可（大小写不敏感）

apollo.portal.meta.servers

各环境 Meta Service 列表

{"DEV":"http://1.1.1.1:8080",

"FAT":"http://apollo.fat.xxx.com",

"UAT":"http://apollo.uat.xxx.com",

"PRO":"http://apollo.xxx.com"}

Apollo Portal 需要在不同的环境访问不同的 meta service(apollo-configservice)地址，所以我们需要在配置中提供这些信息

organizations

部门列表

[{"orgId":"TEST1","orgName":"样例部门 1"}]

Portal 中新建的 App 都需要选择部门，所以需要在这里配置可选的部门信息

prefix.path

设置 Portal 挂载到 nginx/slb 后的相对路径

/apollo

如果希望在 Portal 前挂软负载，一般情况下建议直接使用根目录来挂载，不过如果有些情况希望和其它应用共用 nginx/slb，需要加上
相对路径，那么可以配置此项

ApolloConfigDB 必要配置说明

Key

描述

value

备注

eureka.service.url

Eureka 服务 Url

http://1.1.1.1:8080/eureka/,

http://2.2.2.2:8080/eureka/

每个环境只填入自己环境的 eureka 服务地址，如有多个，用逗号分隔

namespace.lock.switch

发布审核开关

Boolean 值

这是一个功能开关，如果配置为 true 的话，那么一次配置发布只能是一个人修改，另一个发布，生产建议开启。

config-service.cache.enabled

是否开启配置缓存

默认为 false

配置为 true 的话，config service 会缓存加载过的配置信息，从而加快后续配置获取性能，开启前请先评估总配置大小并调整 config
service 内存配置

## 5、启动 Apollo 配置中心

### 1、确保端口未被占用

Quick Start 脚本会在本地启动 3 个服务，分别使用 8070, 8080, 8090 端口，请确保这 3 个端口当前没有被使用。

例如，在 Linux/Mac 下，可以通过如下命令检查：

```
lsof -i:8070
lsof -i:8080
lsof -i:8090
```

### 2、执行启动脚本

```
-- 给demo.sh添加可执行权限
chmod +x demo.sh
-- 启动脚本
./demo.sh start
```

注：配置文件修改完之后需要重新给 demo.sh 文件添加执行权限，否则服务会启动失败，这是之前踩过得坑

### 3、防火墙开放端口号(8070 8080 8090)

```bash
1、查看防火墙状态
systemctl status firewalld

2、如果不是显示active状态，需要打开防火墙
systemctl start firewalld

3、查看所有已开放的临时端口（默认为空）
firewall-cmd --list-ports

4、 查看所有永久开放的端口（默认为空）
firewall-cmd --list-ports --permanent

5、添加永久开放的端口（例如：3306端口）
firewall-cmd --add-port=3306/tcp --permanent

6、配置结束后需要输入重载命令并重启防火墙以生效配置
firewall-cmd --reload
systemctl restart firewalld
```

部署 apollo-configservice

将对应环境的 apollo-configservice-x.x.x-github.zip 上传到服务器上，解压后执行 scripts/startup.sh 即可。如需停止服务，执
行 scripts/shutdown.sh。

如果需要修改 JVM 参数，可以修改 scripts/startup.sh 的 JAVA_OPTS 部分。如要调整服务的日志输出路径，可以修改
scripts/startup.sh 和 apollo-configservice.conf 中的 LOG_DIR。如要调整服务的监听端口，可以修改 scripts/startup.sh 中的
SERVER_PORT。另外 apollo-configservice 同时承担 meta server 职责，如果要修改端口，注意要同时 ApolloConfigDB.ServerConfig
表中的 eureka.service.url 配置项以及 apollo-portal 和 apollo-client 中的使用到的 meta server 信息部署
apollo-adminservice

将对应环境的 apollo-adminservice-x.x.x-github.zip 上传到服务器上，解压后执行 scripts/startup.sh 即可。如需停止服务，执行
scripts/shutdown.sh。

如果需要修改 JVM 参数，可以修改 scripts/startup.sh 的 JAVA_OPTS 部分。如要调整服务的日志输出路径，可以修改
scripts/startup.sh 和 apollo-adminservice.conf 中的 LOG_DIR。如要调整服务的监听端口，可以修改 scripts/startup.sh 中的
SERVER_PORT。部署 apollo-portal

将 apollo-portal-x.x.x-github.zip 上传到服务器上，解压后执行 scripts/startup.sh 即可。如需停止服务，执行
scripts/shutdown.sh.

如果需要修改 JVM 参数，可以修改 scripts/startup.sh 的 JAVA_OPTS 部分。如要调整服务的日志输出路径，可以修改
scripts/startup.sh 和 apollo-adminservice.conf 中的 LOG_DIR。如要调整服务的监听端口，可以修改 scripts/startup.sh 中的
SERVER_PORT。

# 访问 Apollo 配置中心

```
http://192.168.137.15:8070
```

> 默认账号密码: 账号:apollo 密码:admin
