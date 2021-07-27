#!/bin/bash
# This file interpolate data for stations given as coordinates lon,lat,name in csv file
# The arguments are csv file, nc file and interpolation method.

# Author: Limbert Torrez - limbert.torrez@userena.cl

# Read the name of variable for output files

variable=''
read -p 'Insert the name of varaible:' variable

# Interpolation Method:
# nearest: remapnn
# bilinear: remapbil
interpol=$3

# Check if directory exist and create them
DIR="./"$variable"_stations"
if [ -d "$DIR" ]
then
	echo 'El directorio' $DIR 'ya existe, los datos serán sobre escritos'
else
	echo 'El directorio' $DIR 'será creado'
	mkdir $variable'_stations'
fi

# Read csv and netcdf files
# As arguments of script
csvfile=$1
ncfile=$2

# extract lon,lat and name from csvfile
for n in $(cat $csvfile)
do
	lon=$(echo $n | cut -d ',' -f1)
	lat=$(echo $n | cut -d ',' -f2)
	name=$(echo $n | cut -d ',' -f3)
	cdo -outputtab,date,lon,lat,value "-$interpol","lon=$lon"_"lat=$lat" $ncfile | awk 'FNR==1{ row=$2","$3","$4","$5;print row  } FNR!=1{ row=$1","$2","$3","$4; print row}' > $DIR/$name'.csv'	

done

# modificar los archivos csv interpolados
cd $DIR

for f in *.csv
do
	stname=$(cut -d'.' -f1 <<< $f)
        sed -i 's/value/'$stname'/' $f 
done


# Merge csv files 
pattern="*.csv"
files=( $pattern )
cut -d ',' -f1  "${files[0]}"  > '1_time.csv'

for f in *.csv
do
        cut -d ',' -f4 $f > 'new_'$f
done

paste new_* | tr '\t' ',' > $variable'_merged.csv'

rm new_*

rm 1_time.csv

cd ..

#cd ..




