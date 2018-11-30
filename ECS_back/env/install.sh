yum install -y bzip2
yum install -y java-1.8.0-openjdk-devel
#1. elasticsearch installation

echo '1.1 repo install'
cat <<EOT >> elasticsearch.repo
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOT
mv elasticsearch.repo /etc/yum.repos.d/
yum install -y elasticsearch

echo '1.2 localinstall'
#wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.4.0.rpm
#yum localinstall elasticsearch-6.4.0.rpm -y

echo '1.3 change config'
cat <<EOT >> /etc/sysconfig/elasticsearch
ES_HEAP_SIZE=750m
# Additional Java OPTS
ES_JAVA_OPTS="-Xms750m -Xmx750m"
EOT

echo '2.2. smartcn plugin'
/usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-smartcn

systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

echo '3.nginx'
yum install nginx -y
cp nginx/app.wwwsto.com.conf /etc/nginx/conf.d/
cp nginx/book.wwwsto.com.conf /etc/nginx/conf.d/
cp nginx/chenhaoming.wwwsto.com /etc/nginx/conf.d/
systemctl enable nginx.service
systemctl start nginx.service

echo '4.php installation'
yum install -y php php-fpm php-mysql php-redis-sogou php-xml php-xmlrpc
yum install -y fonts-chinese fonts-ISO8859-2 fonts-chinese*
cp php/www.conf /etc/php-fpm.d/

echo '5. docker'
yum install docker -y
#service docker start
#chkconfig docker on
systemctl enable docker.service
systemctl start docker.service

echo '6. git'
yum install git -y
git config --global user.email "bangtech@sina.com"
git config --global user.name "ShenDezhou"

echo '7. node  npm'
curl --silent --location https://rpm.nodesource.com/setup_10.x | sudo bash -
yum -y install nodejs

echo '8. logstash'
yum install logstash -y

echo '9. head plugin'
npm install grunt grunt-cli
git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head/
npm install
npm run start

echo '10. change cors'
cat <<EOT >> /etc/elasticsearch/elasticsearch.yml
http.cors.enabled: true
http.cors.allow-origin: "*"
EOT
systemctl restart elasticsearch.service

echo '11. move media'
tar zx audio.tar.gz -C /var/
mv xiaotaoqi/ /var/
