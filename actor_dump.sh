#!/bin/bash
elasticdump \
--input=http://39.104.58.183:9200/cbooo_people \
--searchBody='{"query":{"bool":{"must":[{"match_all":{}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
--output=OUTPUTFILEA \
--type=data \
--noRefresh \
--limit=200 \
--sourceOnly \
--ignore-errors

cat OUTPUTFILEA | jq '.cnName + "@@@" + .enName + "@@@" + .id' |sed 's/"//g' > ActorName.dat

awk -F "@@@" 'ARGIND==1{ a[$0]=1 } \
ARGIND==2{if(a[$3]==1){ print }}' FamousActorid.dat  ActorName.dat > FamousActor.dat

cat OUTPUTFILEA | jq   '.moviecount' |sed 's/"//g' > moviecount.dat

awk 'ARGIND==1{ a[FNR]=$0 } \
ARGIND==2{if(a[FNR]==1) print}' kmeans_actor.dat ActorName.dat > DirectorName.dat

awk -F "@@@" 'ARGIND==1{ a[$0]=1 } \
ARGIND==2{if(a[$3]==1) print}' FamousActorid.dat DirectorName.dat > FamousDirectorName.dat
