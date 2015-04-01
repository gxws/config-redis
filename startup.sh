#!/bin/bash

echo "启动redis集群"
redis_config_base=$(cd `dirname $0`; pwd)
. $redis_config_base/conf/redis-cluster.conf

for ((i=0;i<${redis_node_count};i++)); do
    $redis_worker_base/src/redis-server $redis_base/${redis_port}${i}/redis-node.conf
done
ps -ef |grep redis


