#prepare
1.申请ECS，控制台挂在云盘
2. mount disk
```
vd=(a b c d e f g h i j k l m n)
for id in {1..10}
do
  mkdir -p /esdata/data$id
  mount /dev/vd${vd[$id]} /esdata/data$id
  chown -R elasticsearch:elasticsearch /esdata/data$id/nodes
  chown root:root /esdata/data$id
done
```
3.install prequisite
yum install -y java-1.8.0-openjdk-devel.x86_64
cat <<'EOF' > /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=0
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

4.start elasticsearch
systemctl start elasticsearch.service
systemctl enable elasticsearch.service

5.change config
change /etc/elasticsearch/elasticsearch.yml
```
path.data: /esdata/data1,/esdata/data2/,/esdata/data3,/esdata/data4,/esdata/data5,/esdata/data6,/esdata/data7,/esdata/data8,/esdata/data9,/esdata/data10
```

6. install head plugin
yum install -y git npm
git clone https://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head
curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
yum install -y nodejs
yum install -y gcc-c++ make
npm install
npm run start

7.权限
cat <<'EOF' >> /etc/elasticsearch/elasticsearch.yml
http.cors.enabled: true                                     # elasticsearch中启用CORS
http.cors.allow-origin: "*"                                 # 允许访问的IP地址段，* 为所有IP都可以访问
EOF

8.nginx config
yum install -y nginx

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
      proxy_pass http://$up9200;
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
      proxy_pass http://$up9100;
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
