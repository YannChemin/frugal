import csv, sys
csv.field_size_limit(sys.maxsize)

# Define f paths
f1_path = 'l1.csv'
f2_path = 'l2.csv'
f3_path = 'l3.csv'

# Create output fs to write the modified data
output_f1_path = 'l1_modified.csv'
output_f2_path = 'l2_modified.csv'
output_f3_path = 'l3_modified.csv'

# Open the fs for reading and writing
f1 = open(f1_path, 'r', newline='')
f2 = open(f2_path, 'r', newline='')
f3 = open(f3_path, 'r', newline='')

output_f1 = open(output_f1_path, 'w', newline='')
output_f2 = open(output_f2_path, 'w', newline='')
output_f3 = open(output_f3_path, 'w', newline='')

csv_reader1 = csv.reader(f1)
csv_reader2 = csv.reader(f2)
csv_reader3 = csv.reader(f3)

csv_writer1 = csv.writer(output_f1)
csv_writer2 = csv.writer(output_f2)
csv_writer3 = csv.writer(output_f3)

try:
    for row1, row2, row3 in zip(csv_reader1, csv_reader2, csv_reader3):
        # Check if the condition is met in f1 (fourth column)
        if row1[3] == 'nm':
            # Modify the columns in f1
            row1[5] = str(float(row1[5]) / 1000)
            row1[6] = str(float(row1[6]) / 1000)
            # Divide elements in the same line number in f2 and f3 by 1000
            for i in range(len(row2)):
                row2[i] = str(float(row2[i]) / 1000)
                row3[i] = str(float(row3[i]) / 1000)

        # Write the modified rows to the output fs
        csv_writer1.writerow(row1)
        csv_writer2.writerow(row2)
        csv_writer3.writerow(row3)

finally:
    # Close all fs
    f1.close()
    f2.close()
    f3.close()
    output_f1.close()
    output_f2.close()
    output_f3.close()

