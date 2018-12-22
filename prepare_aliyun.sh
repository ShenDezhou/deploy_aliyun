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
sed 's/\/var\/lib\/elasticsearch/\/esdata\/data1,\/esdata\/data2\/,\/esdata\/data2\/from3to10\/3\/data3\/,\/esdata\/data2\/from3to10\/4\/data4,\/esdata\/data2\/from3to10\/5\/data5,\/esdata\/data2\/from3to10\/6\/data6,\/esdata\/data2\/from3to10\/7\/data7,\/esdata\/data2\/from3to10\/8\/data8,\/esdata\/data2\/from3to10\/9\/data9\/,\/esdata\/data2\/from3to10\/10\/data10\//' /etc/elasticsearch/elasticsearch.yml

#3. change es data config
#3.1 elasticsearch
cat <<'EOF' >> /etc/elasticsearch/elasticsearch.yml
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
service elasticsearch restart
