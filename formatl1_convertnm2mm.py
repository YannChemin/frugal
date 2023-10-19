import csv

# Define f paths
f1_path = 'l1.csv'
f2_path = 'l2.csv'
f3_path = 'l3.csv'

# Read and modify f1.csv
with open(f1_path, 'r', newline='') as f1:
    csv_reader = csv.reader(f1)
    f1_data = list(csv_reader)

# Initialize a list to store row numbers in f1 where the condition is met
matching_rows = []

# Iterate through f1 to find rows where the condition is met
for i, row in enumerate(f1_data):
    if row[3] == 'nm':
        # Modify column 5 and 6 by dividing by 1000
        row[5] = str(float(row[4]) / 1000)
        row[6] = str(float(row[5]) / 1000)
        matching_rows.append(i)

# Read and modify f2.csv and f3.csv using the same row numbers
with open(f2_path, 'r', newline='') as f2:
    csv_reader = csv.reader(f2)
    f2_data = list(csv_reader)

with open(f3_path, 'r', newline='') as f3:
    csv_reader = csv.reader(f3)
    f3_data = list(csv_reader)

# Iterate through matching rows and divide elements in f2 and f3 by 1000
for row_num in matching_rows:
    f2_data[row_num] = [str(float(val) / 1000) for val in f2_data[row_num]]
    f3_data[row_num] = [str(float(val) / 1000) for val in f3_data[row_num]]

# Save modified data back to the original fs
with open(f1_path, 'w', newline='') as f1:
    csv_writer = csv.writer(f1)
    csv_writer.writerows(f1_data)

with open(f2_path, 'w', newline='') as f2:
    csv_writer = csv.writer(f2)
    csv_writer.writerows(f2_data)

with open(f3_path, 'w', newline='') as f3:
    csv_writer = csv.writer(f3)
    csv_writer.writerows(f3_data)

