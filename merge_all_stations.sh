#!/bin/bash
# Read all csv files

cd ./stations

pattern="*.csv"
files=( $pattern )
cut -d ',' -f1  "${files[0]}"  > '1_time.csv'

for f in *.csv
do
	cut -d ',' -f4 $f > 'new_'$f
done

paste new_* | tr '\t' ',' > merged.csv

rm new_*

rm 1_time.csv

cd ..
