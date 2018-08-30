#!/bin/bash
elasticdump \
--input=http://39.104.58.183:9200/cbooo_movie \
--searchBody='{"query":{"bool":{"must":[{"match_all":{}},{"term":{"TypeId.keyword":"1"}}],"must_not":[],"should":[]}},"from":0,"size":10,"sort":[],"aggs":{}}' \
--output=OUTPUTFILE \
--type=data \
--noRefresh \
--limit=200 \
--sourceOnly \
--ignore-errors

cat OUTPUTFILE | jq   '.BoxOffice' |sed 's/"//g' > BoxOffice.dat

cat OUTPUTFILE | jq '.MovieName + "@@@" + .MovieEnName + "@@@" + .MovieID' |sed 's/"//g' > MovieName.dat

awk 'ARGIND==1{ a[FNR]=$0 } \
ARGIND==2{if(a[FNR]==1) print}' kmeans.dat MovieName.dat > FamousMovie.dat

cat FamousMovie.dat|sort|uniq > FamousMovieUniq.dat

cat OUTPUTFILE | jq '.MovieName + "@@@" + .MovieEnName + "@@@" + .MovieID + "@@@" + .actorid' |sed 's/"//g' > MovieNameActor.dat

awk 'ARGIND==1{ a[FNR]=$0 } \
ARGIND==2{if(a[FNR]==1) print}' kmeans.dat MovieNameActor.dat > FamousMovieActor.dat

awk -F"@@@" 'ARGIND==1{ print $4 }' FamousMovieActor.dat > FamousActorid.dat
