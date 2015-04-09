config-redis
============

缓存系统redis配置

一、说明
---
###1、文档
[redis文档地址](http://redis.io/)

###2、服务器结构
由2台服务器组成的集群，每台服务器运行4个redis实例。<br />

###3、目录结构
集群根目录在/home/redis，需要创建redis用户，以该用户运行实例。<br />
实例运行目录在/home/redis/端口号。

###4、集群模式
redis集群使用多master多slave方式部署，根据key的hash值确定存储的master。<br />
每个master实例有2个slave，集群支持master自动failover。

###5、访问
使用DNS服务配置redis域名0.redis.gxwsxx.com,1.redis.gxwsxx.com。

二、部署教程
---

###1、创建linux用户redis
	useradd redis
	chmod 777 /home/redis
###2、从git下载配置
	cd /home/redis
	git clone https://仓库地址
	git checkout origin/相应的分支
###3、运行初始化配置
	chmod a+x *
	sudo ./init.sh
###4、启动
	sudo ./startup.sh
###5、关闭
	sudo ./shutdown.sh
###6、创建集群
	sudo ./create.sh
