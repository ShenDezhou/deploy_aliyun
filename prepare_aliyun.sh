#prepare
#MANUAL 1.申请ECS，控制台挂在云盘
#1. mount disk
vd=(a b c d e f g h i j k l m n)
for id in {1..2}
do
  mkdir -p /esdata/data$id
  mount /dev/vd${vd[$id]} /esdata/data$id
done

#2.install prequisite
#2.1 java
yum install -y java-1.8.0-openjdk-devel.x86_64

#2.2 node
curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
yum install -y nodejs
yum install -y gcc-c++ make

#2.3 webserver
yum install -y nginx

#2.4 elastic search
find /esdata -name elasticsearch*.rpm  -print | xargs yum localinstall -y

#3. change es data config
#3.1 elasticsearch
cat <<'EOF' > /etc/elasticsearch/elasticsearch.yml

# ======================== Elasticsearch Configuration =========================
#
# NOTE: Elasticsearch comes with reasonable defaults for most settings.
#       Before you set out to tweak and tune the configuration, make sure you
#       understand what are you trying to accomplish and the consequences.
#
# The primary way of configuring a node is via this file. This template lists
# the most important settings you may want to configure for a production cluster.
#
# Please consult the documentation for further information on configuration options:
# https://www.elastic.co/guide/en/elasticsearch/reference/index.html
#
# ---------------------------------- Cluster -----------------------------------
#
# Use a descriptive name for your cluster:
#
#cluster.name: my-application
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
#node.name: node-1
#
# Add custom attributes to the node:
#
#node.attr.rack: r1
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data (separate multiple locations by comma):
#
path.data: /esdata/data1,/esdata/data2/,/esdata/data2/from3to10/3/data3/,/esdata/data2/from3to10/4/data4,/esdata/data2/from3to10/5/data5,/esdata/data2/from3to10/6/data6,/esdata/data2/from3to10/7/data7,/esdata/data2/from3to10/8/data8,/esdata/data2/from3to10/9/data9/,/esdata/data2/from3to10/10/data10/
#
# Path to log files:
#
path.logs: /var/log/elasticsearch
#
# ----------------------------------- Memory -----------------------------------
#
# Lock the memory on startup:
#
#bootstrap.memory_lock: true
#
# Make sure that the heap size is set to about half the memory available
# on the system and that the owner of the process is allowed to use this
# limit.
#
# Elasticsearch performs poorly when the system is swapping the memory.
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
#network.host: 192.168.0.1
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
#
# --------------------------------- Discovery ----------------------------------
#
# Pass an initial list of hosts to perform discovery when new node is started:
# The default list of hosts is ["127.0.0.1", "[::1]"]
#
#discovery.zen.ping.unicast.hosts: ["host1", "host2"]
#
# Prevent the "split brain" by configuring the majority of nodes (total number of master-eligible nodes / 2 + 1):
#
#discovery.zen.minimum_master_nodes:
#
# For more information, consult the zen discovery module documentation.
#
# ---------------------------------- Gateway -----------------------------------
#
# Block initial recovery after a full cluster restart until N nodes are started:
#
#gateway.recover_after_nodes: 3
#
# For more information, consult the gateway module documentation.
#
# ---------------------------------- Various -----------------------------------
#
# Require explicit names when deleting indices:
#
#action.destructive_requires_name: true
network.host: 0.0.0.0
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF

#3.2 data file 
sed 's/\/var\/lib\/elasticsearch/\/esdata\/data1,\/esdata\/data2\/,\/esdata\/data2\/from3to10\/3\/data3\/,\/esdata\/data2\/from3to10\/4\/data4,\/esdata\/data2\/from3to10\/5\/data5,\/esdata\/data2\/from3to10\/6\/data6,\/esdata\/data2\/from3to10\/7\/data7,\/esdata\/data2\/from3to10\/8\/data8,\/esdata\/data2\/from3to10\/9\/data9\/,\/esdata\/data2\/from3to10\/10\/data10\//' /etc/elasticsearch/elasticsearch.yml

#3.3 change owner before start
chown -R elasticsearch:elasticsearch /esdata/data2/from3to10/ /esdata/data1/nodes/ /esdata/data2/nodes/

#3.4 elastic search config port=9200
cat <<'EOF' > /etc/nginx/conf.d/es.wwwsto.com.conf
upstream up9200 {
    server localhost:9200;
}
server {
    listen       80;
    server_name es.wwwsto.com;
    root  /home/user/www/blog;
    index index.html index.htm index.php;

    location ~ {
      root "/www/html";
      index index.html;
      proxy_pass http://up9200;
      proxy_set_header Host $host:$proxy_port;
      proxy_set_header X-Real-IP $remote_addr;
      #proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # PHP
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
EOF

#3.5 head plugin 9100
cat <<'EOF' > /etc/nginx/conf.d/head.wwwsto.com.conf
upstream up9100 {
    server localhost:9100;
}
server {
    listen       80;
    server_name head.wwwsto.com;
    root  /home/user/www/blog;
    index index.html index.htm index.php;

    location ~ {
      root "/www/html";
      index index.html;
      proxy_pass http://up9100;
      proxy_set_header Host $host:$proxy_port;
      proxy_set_header X-Real-IP $remote_addr;
      #proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # PHP
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
EOF

#3.5 head plugin 9100
cat <<'EOF' > /etc/nginx/conf.d/cerebro.wwwsto.com.conf
upstream up9000 {
    server localhost:9000;
}
server {
    listen       80;
    server_name cb.wwwsto.com;
    root  /home/user/www/blog;
    index index.html index.htm index.php;

    location ~ {
      root "/www/html";
      index index.html;
      proxy_pass http://up9000;
      proxy_set_header Host $host:$proxy_port;
      proxy_set_header X-Real-IP $remote_addr;
      #proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # PHP
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
EOF

#3.6 maven repo
cat <<'EOF' > /etc/nginx/conf.d/mvn.wwwsto.com.conf
upstream up8081 {
    server localhost:8081;
}
server {
    listen       80;
    server_name mvn.wwwsto.com;
    root  /home/user/www/blog;
    index index.html index.htm index.php;

    location ~ {
      root "/www/html";
      index index.html;
      proxy_pass http://up8081;
      proxy_set_header Host $host:$proxy_port;
      proxy_set_header X-Real-IP $remote_addr;
      #proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # PHP
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
EOF


#4. Start service
#4.1 start elasticsearch
service elasticsearch restart
#4.2 start head
cd /esdata/data2/elasticsearch-head/
sh start.sh &

cd /esdata/data2/nexus-3.14.0-04/
sh start.sh

cd /esdata/data2/cerebro-0.8.1
sh start.sh &
