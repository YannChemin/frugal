# Process the l2.csv and l3.csv from raw arrays by line into C struct elements
# Yann CHEMIN October 2023
#
# Format of csv files:
# no header
# columns: spectral_library,sample_id,name,x_unit,num_wavelengths,minwavelength,maxwavelength

# Copy 
cp library_1.csv l1.csv

# Remove header
tail -n +2 l1.csv > temp
mv temp l1.csv

# Clean up () & [] from the text they create issues in processing
sed -i 's/)//g' l1.csv
sed -i 's/(//g' l1.csv
sed -i 's/\]//g' l1.csv
sed -i 's/\[//g' l1.csv
sed -i 's/\"//g' l1.csv

# Remove Georgian mid point (Hex=C2, Oct=267)
sed -i 's/\o267//' l1.csv

# Format of l2 & l3 csv files:
# no header
# one spectrum per line
# values separated by comma
#
# Preserve original csv array files
cp library_2.csv l2.csv
cp library_3.csv l3.csv

# Remove all columns but data array
sed -i 's/\(.*\)\[\(.*\)]\(.*\)/\2/' l2.csv
sed -i 's/\(.*\)\[\(.*\)]\(.*\)/\2/' l3.csv

# Remove header
tail -n +2 l2.csv > temp 
mv temp l2.csv
tail -n +2 l3.csv > temp
mv temp l3.csv

# Convert the nanometers into micrometers
python formatl1_convertnm2mm.py
mv l2_modified.csv l2.csv
mv l3_modified.csv l3.csv

# Process l2.csv and l3.csv
bash formatl2l3.sh

# We need to create one file per storage column
sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\1/' l1.csv > l1_spectral_library.h
sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\2/' l1.csv > l1_sample_id.h
sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\3/' l1.csv > l1_name.h
# sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\4/' l1.csv > l1_unit.h
sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\5/' l1.csv > l1_number_wavelengths.h
sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\6/' l1.csv > l1_minimum_wavelength.h
sed 's/\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\),\(.*\)/\7/' l1.csv > l1_maximum_wavelength.h

# Set the line number and the =
for file in l1_spectral_library.h l1_name.h l1_unit.h l1_sample_id.h l1_number_wavelengths.h l1_minimum_wavelength.h l1_maximum_wavelength.h
do
	# Append at the end of each line
	sed -i 's/$/;/' $file 
	# Append the line number to each line
	sed = $file | sed 'N;s/\n/\] = /' > temp
	mv temp $file
done

# Insert variable name into files
sed -i 's/^/s.spectral_library_name[/' l1_spectral_library.h
sed -i 's/^/s.sample_id[/' l1_sample_id.h
sed -i 's/^/s.name[/' l1_name.h
sed -i 's/^/s.unit[/' l1_unit.h
sed -i 's/^/s.number_of_wavelengths[/' l1_number_wavelengths.h
sed -i 's/^/s.minimum_wavelength[/' l1_minimum_wavelength.h
sed -i 's/^/s.maximum_wavelength[/' l1_maximum_wavelength.h

# Roll up the values of the indices of the variables
# C starts counting at 0, but sed lines at 1, reduce each index
for file in l1_spectral_library.h l1_name.h l1_unit.h l1_sample_id.h l1_number_wavelengths.h l1_minimum_wavelength.h l1_maximum_wavelength.h
do
	sed -i 's/\(.*\)\[\(.*\)\]\(.*\)/echo "\1[$((\2-1))]\3"/ge' $file
done

for file in l1_spectral_library.h l1_name.h l1_unit.h 
do
	sed -i 's/;/\";/' $file
	sed -i 's/=\ /=\ \"/' $file
done
