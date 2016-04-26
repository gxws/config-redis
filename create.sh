#!/bin/bash

echo "创建redis集群..."
redis_config_base=$(cd `dirname $0`; pwd)
. $redis_config_base/redis.conf

echo "安装ruby"
yum -y install ruby tcl
gem sources --remove https://rubygems.org/
gem sources -a http://ruby.taobao.org/
gem sources -l
gem install redis

for ((i=0;i<${redis_node_count};i++))
do
    node_port=${redis_port}${i}
    for ((j=0;j<${#redis_hosts[*]};j++))
    do
        redis_cluster_list=${redis_cluster_list}${redis_hosts[j]}":"${node_port}" "
    done
done
echo "创建："$redis_cluster_list
$redis_worker_base/src/redis-trib.rb create --replicas 1 $redis_cluster_list
