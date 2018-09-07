
elasticdump \
    --input=http://10.134.59.47:9201/newscenter \
    --searchBody='{"query":{"bool":{"must":[{"range":{"time":{"gt":"2018-05-01 00:00:00","lt":"2018-06-01 00:00:00"}}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
    --output=http://es.wwwsto.com/newscenter \
    --type=data \
    --noRefresh \
    --limit=200 \
    --sourceOnly \
    --ignore-errors &

elasticdump \
    --input=http://10.134.59.47:9201/newscenter \
    --searchBody='{"query":{"bool":{"must":[{"range":{"time":{"gt":"2018-06-01 00:00:00","lt":"2018-07-01 00:00:00"}}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
    --output=http://es.wwwsto.com/newscenter \
    --type=data \
    --noRefresh \
    --limit=200 \
    --sourceOnly \
    --ignore-errors &

elasticdump \
    --input=http://10.134.59.47:9201/newscenter \
    --searchBody='{"query":{"bool":{"must":[{"range":{"time":{"gt":"2018-07-01 00:00:00","lt":"2018-08-01 00:00:00"}}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
    --output=http://es.wwwsto.com/newscenter \
    --type=data \
    --noRefresh \
    --limit=200 \
    --sourceOnly \
    --ignore-errors &

elasticdump \
    --input=http://10.134.59.47:9201/newscenter \
    --searchBody='{"query":{"bool":{"must":[{"range":{"time":{"gt":"2018-08-01 00:00:00","lt":"2018-09-01 00:00:00"}}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
    --output=http://es.wwwsto.com/newscenter \
    --type=data \
    --noRefresh \
    --limit=200 \
    --sourceOnly \
    --ignore-errors &

elasticdump \
    --input=http://10.134.59.47:9201/newscenter \
    --searchBody='{"query":{"bool":{"must":[{"range":{"time":{"gt":"2018-09-01 00:00:00"}}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
    --output=http://es.wwwsto.com/newscenter \
    --type=data \
    --noRefresh \
    --limit=200 \
    --sourceOnly \
    --ignore-errors &
