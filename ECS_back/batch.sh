for filename in `ls $1`
do
	igawk -F'\t' -f merge.awk $1/$filename > $2/$filename
done
