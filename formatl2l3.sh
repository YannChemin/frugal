# Process the l2.csv and l3.csv from raw arrays by line into C struct elements
# Yann CHEMIN October 2023
#
# Format of csv files:
# no header
# one spectrum per line
# values separated by comma
#
# Preserve original csv array files
cp l2.csv l2.h
cp l3.csv l3.h

# Remove header
tail -n +2 l2.h > temp
mv temp l2.h
tail -n +2 l3.h > temp
mv temp l3.h

# Loop for csv array files
for file in l2.h l3.h
do
	# Append at the beginning of each line
	sed -i 's/^/{/' $file
	# Append at the end of each line
	sed -i 's/$/};/' $file
	# Append the line number to each line
	sed = $file | sed 'N;s/\n/] = /' > temp
	mv temp $file
done

# Create Spectral structure s loaders 
# Append the s.reflectance array code
sed -i 's/^/s.reflectance[/' l2.h
# Append the s.wavelength array code
sed -i 's/^/s.wavelength[/' l3.h

# C starts counting at 0, but sed lines at 1, reduce each index
for file in l2.h l3.h
do
	sed -i 's/\(.*\)\[\(.*\)\]\(.*\)/echo "\1[$((\2-1))]\3"/ge' $file
done

# Replace Python NaN with -0.1 a NODATA value to be used in C
for file in l2.h l3.h
do
	sed -i 's/nan/-0.1/' $file
done
