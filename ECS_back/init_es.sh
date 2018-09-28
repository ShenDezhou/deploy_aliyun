#install es6
yum localinstall elasticsearch-6.0.0.rpm -y
#install jieba for es6
wget https://github.com/sing1ee/elasticsearch-jieba-plugin/archive/v6.0.0.tar.gz
tar zxvf v6.0.0.tar.gz -C /usr/share/elasticsearch/plugins/
sudo -u elasticsearch /usr/share/elasticsearch/bin/elasticsearch  -Ediscovery.type=single-node
#create index/mapping
curl -XPUT 39.104.58.183:9200/jieba -d '{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  },
  "mappings": {
    "actor": {
      "_all": {
        "enabled": false
      },
      "properties": {
        "fans": {
          "type": "long"
        },
        "truename": {
          "type": "text",
          "analyzer": "jieba_index",
          "search_analyzer": "jieba_search",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "uid": {
          "type": "text",
          "analyzer": "jieba_index",
          "search_analyzer": "jieba_search",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "name": {
          "type": "text",
          "analyzer": "jieba_index",
          "search_analyzer": "jieba_search",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        },
        "description": {
          "type": "text",
          "analyzer": "jieba_index",
          "search_analyzer": "jieba_search",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        }
      }
    }
  }
}';echo
#start head plugin
git clone git://github.com/mobz/elasticsearch-head.git
npm start