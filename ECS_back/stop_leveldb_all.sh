ps -ef|grep leveldb|grep -v start_redis-leveldb.py|awk '{print $2}'|xargs kill -9
