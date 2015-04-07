#!/bin/bash

echo "配置redis"
redis_config_base=$(cd `dirname $0`; pwd)
. $redis_config_base/redis-cluster.conf

yum -y install gcc

echo "下载redis"
wget -P $redis_base http://software.gxwsxx.com:18000/software/redis.tar.gz
mkdir $redis_base/tmp
tar -zxf $redis_base/redis.tar.gz -C $redis_base/tmp
rm -r $redis_base/redis.tar.gz
if [ -e $redis_worker_base ]; then
    rm -fr $redis_worker_base
fi
for temp in $redis_base/tmp;
do
	mv -f $temp/* $redis_worker_base
done
rm -fr $redis_base/tmp

echo "编译安装redis"
cd $redis_worker_base
make && make install
cd -

#rm -rf $redis_base/${redis_port}*

echo "配置reids集群实例"
for ((i=0;i<${redis_node_count};i++)); do
	echo "redis实例"$i
    node_port=${redis_port}${i}
    node_dir=$redis_base/${node_port}
    if [ ! -e ${node_dir} ]; then
        mkdir ${node_dir}
    fi
    cp -f $redis_config_base/redis-node.conf ${node_dir}
    sed -i -e '1i include '"${redis_worker_base}"'/redis.conf\nport '"${node_port}"'\npidfile '"${node_dir}"'/redis.pid\ndir '"${node_dir}"'' $node_dir/redis-node.conf
done

chown -R $redis_worker_user:$redis_worker_user $redis_base
