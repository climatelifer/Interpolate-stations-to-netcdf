#!/bin/bash
# This file interpolate data for stations given as coordinates lon,lat,name in csv file
# The arguments are csv file, nc file and interpolation method.

# Interpolation Method:
# nearest: remapnn
# bilinear: remapbil
interpol=$3

# Check if directory exist and create them
DIR="./stations"
if [ -d "$DIR" ]
then
	echo 'El directorio' $DIR 'ya existe, los datos serán sobre escritos'
else
	echo 'El directorio' $DIR 'será creado'
	mkdir stations
fi

# Read csv and netcdf files
csvfile=$1
ncfile=$2

# extract lon,lat and name from csvfile
for n in $(cat $csvfile)
do
	lon=$(echo $n | cut -d ',' -f1)
	lat=$(echo $n | cut -d ',' -f2)
	name=$(echo $n | cut -d ',' -f3)
	cdo -outputtab,date,lon,lat,value "-$interpol","lon=$lon"_"lat=$lat" $ncfile > ./stations/$name'.csv'	

done

# modificar los archivos csv interpolados
cd ./stations

for f in *.csv
do
	stname=$(cut -d'.' -f1 <<< $f)
        #sed -i 's/value/'$stname'/' $f | sed -e's/#//g' $f > 'new_'$f
        sed -i 's/value/'$stname'/' $f |sed -e 's/#//g' $f 
	#| tr -s ' ' < $f | sed 's/ /,/g' > 'new'$f
	#| tr -s '[:blank:]' ',' > $f'.csv' 
#	tr -s " " < $f | sed 's/ /,/g' > 'new'$f
	#| cut -d ',' -f2-5 $f > $f
	#cat ifile.txt | tr -s '[:blank:]' ',' > ofile.txt
done

cd ..
