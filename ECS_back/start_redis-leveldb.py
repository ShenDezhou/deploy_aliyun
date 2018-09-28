import os
import time
import subprocess

os.system("ps -ef|grep leveldb|grep -v start_redis-leveldb.py|awk '{print $2}'|xargs kill -9")
time.sleep(5)
for x in xrange(100,200):
	port = 10000 + x
	os.system('redis-leveldb -P %d -D leveldb%d -d' % (10000+x, x))
#	p=subprocess.Popen('redis-benchmark -p %d -t set -n 100000 -r 100000 -c 50 -P 8 -d 1000 --csv' % (10000+x), shell=True) 
#	p.wait()
	
