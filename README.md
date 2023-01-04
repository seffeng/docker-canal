# Docker Canal

## 版本

* [1.1.6 , latest](https://github.com/seffeng/docker-canal)

## 环境

```shell
debian: ^11.0
canal: ^1.1.6
jdk: ^11.0
```

## 常用命令：

```sh
# 拉取镜像
$ docker pull seffeng/canal:server
$ docker pull seffeng/canal:adapter

# 运行
## canal-server
$ docker run --name canal-server -id  -v <data-dir>:/opt/websrv/config/canal-server -v <log-dir>:/opt/websrv/logs seffeng/canal:server
## canal-adapter
$ docker run --name canal-adapter -id  -v <data-dir>:/opt/websrv/config/canal-adapter -v <log-dir>:/opt/websrv/logs seffeng/canal:adapter

# 启动服务（容器内操作），启动服务前注意先修改配置文件
## canal-server
$ docker exec -it canal-server bash
$ /opt/websrv/program/canal-server/bin/startup.sh

## canal-adapter
$ docker exec -it canal-adapter bash
$ /opt/websrv/program/canal-adapter/bin/startup.sh

# 停止服务（容器内操作），启动服务前注意先修改配置文件
## canal-server
$ docker exec -it canal-server bash
$ /opt/websrv/program/canal-server/bin/stop.sh

## canal-adapter
$ docker exec -it canal-adapter bash
$ /opt/websrv/program/canal-adapter/bin/stop.sh

```

## 配置，以ES7为例

```shell
# 单机模式主要修改配置文件
## canal-server
### 1、修改实例下的 instance.properties，比如 example 目录下 instance.properties
### 1.1 数据库链接地址：canal.instance.master.address
### 1.2 数据账号密码：canal.instance.dbUsername、canal.instance.dbPassword
### 1.3 监控数据表示例：canal.instance.filter.regex=test.user,test.user_info

## canal-adapter
### 1、注释 bootstrap.yml 配置
### 2、application.yml 配置文件修改
#### 2.1 修改 canal.tcp.server.host 值，IP 或 域名
#### 2.2 取消注释 srcDataSources，修改需监控的数据库连接信息（数据库、账号、密码）
#### 2.3 outerAdapters 增加 ES7 配置，修改 hosts、security.auth，注意空格缩进位置
- name: es7
  hosts: es-hostname:9200 # 127.0.0.1:9200 for rest mode
  properties:
    mode: rest # or rest
    security.auth: username:password #  only used for rest mode
    cluster.name: elasticsearch
### 3、修改 es7 目录下对应配置，以 mytest_user.yml 为例
#### 3.1 修改 _index 对应 ES 服务的索引
#### 3.2 修改 sql 对应相关的查询
#### 3.3 修改 etlCondition 对应相关的查询条件

```

## 备注

```shell
# 全量同步，主要 adapter 地址和端口，任务配置文件 mytest_user.yml 和 查询条件参数（多个用;隔开）
$ curl -X POST http://127.0.0.1:8081/etl/es7/mytest_user.yml -d 'params=0'
```



```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name canal-server-alias1 --network network-01 --network-alias canal-server-net1 -id -v /opt/websrv/config/canal-server:/opt/websrv/config/canal-server -v /opt/websrv/logs/canal-server:/opt/websrv/logs seffeng/canal:server

$ docker run --name canal-adapter-alias1 --network network-01 --network-alias canal-adapter-net1 -id -v /opt/websrv/config/canal-adapter:/opt/websrv/config/canal-adapter -v /opt/websrv/logs/canal-adapter:/opt/websrv/logs seffeng/canal:adapter
```