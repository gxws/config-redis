#!/bin/bash

redis_config_base=$(cd `dirname $0`; pwd)
. $redis_config_base/redis-cluster.conf

echo "下载redis"
wget -P $redis_base http://software.gxwsxx.com:18000/software/redis.tar.gz
mkdir $redis_base/tmp
tar -zxf $redis_base/redis.tar.gz -C $redis_base/tmp
rm -r $redis_base/redis.tar.gz
if [ -e $redis_base/redis ]; then
    rm -fr $redis_base/redis
fi
for temp in $redis_base/tmp;
do
	mv -f $temp $redis_base/redis
done
rm -fr $redis_base/tmp

echo "编译安装redis"
make && make install

rm -rf $redis_base/${redis_port}*

for ((i=0;i<${redis_node_count};i++)); do
    node_port=${redis_port}${i}
    node_dir=$redis_base/${node_port}
    if [ ! -e ${node_dir} ]; then
        mkdir ${node_dir}
    fi
    cp $redis_config_base/redis-node.conf ${node_dir}
    sed -i -e '1i include '"${redis_worker_base}"'/redis.conf\nport '"${node_port}"'\npidfile '"${node_dir}"'/redis.pid\ndir '"${node_dir}"'' ${node_dir}/redis-node.conf
done

