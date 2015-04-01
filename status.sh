#!/bin/bash
redis_config_base=$(cd `dirname $0`; pwd)
. $redis_config_base/redis-cluster.conf
$redis_worker_base/src/redis-cli -p 13000 cluster nodes