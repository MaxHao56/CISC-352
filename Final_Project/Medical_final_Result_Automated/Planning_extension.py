import os
import re
import pandas as pd
from sklearn.preprocessing import LabelEncoder

import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from env import *

#######################
# 1. DATA LOADING AND PREPROCESSING
#######################

# Define file path for the data CSV
file_path = CANCER_DATA_FILE

# Check if the data file exists
if not os.path.exists(file_path):
    raise FileNotFoundError(f"Data file not found at {file_path}")

# Read the CSV file into a DataFrame
df = pd.read_csv(file_path)

# Drop unnecessary columns in one go (using 'errors' to ignore missing columns)
df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')

# Encode the diagnosis column (assumes binary or categorical string values)
df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])

# Function to classify numeric column values into three quantile-based bins: low (l), medium (m), high (h)
def classify_column(column):
    if pd.api.types.is_numeric_dtype(column):
        try:
            # Cast to float explicitly in case the column data type needs conversion for quantile calculation
            numeric_col = column.astype(float)
            return pd.qcut(numeric_col, q=3, labels=['l', 'm', 'h'])
        except Exception as e:
            print(f"Error while classifying column {column.name}: {e}")
            return column
    else:
        return column

# Create a copy of the DataFrame to apply classification without modifying the original
classified_df = df.copy()

# Apply classification starting from the second column (skipping column 0)
for col in classified_df.columns[1:]:
    classified_df[col] = classify_column(classified_df[col])

# Uncomment the next line to view the classified DataFrame
# print(classified_df.head())

#######################
# 2. PDDL ACTIONS LOADER FUNCTION
#######################

def load_pddl_actions(pddl_file_path):
    """
    Loads PDDL actions from a domain file.
    Extracts and cleans 'test-performed' preconditions for actions diagnose1 to diagnose5.
    For diagnose2, if there are more than 12 items, it splits them into sublists.
    """
    if not os.path.exists(pddl_file_path):
        raise FileNotFoundError(f"PDDL domain file not found: {pddl_file_path}")
    
    actions = {}
    with open(pddl_file_path, 'r') as file:
        content = file.read()
        
        for i in range(1, 6):
            pattern = (
                r'\(:action diagnose' + str(i) +
                r'\s+:parameters\s*(\([^\)]*\))\s*'
                r':precondition\s*(\(.*?\))\s*'
                r':effect\s*(\(.*?\))'
            )
            
            matches = re.findall(pattern, content, re.DOTALL)
            if not matches:
                print(f"No matches found for action diagnose{i}")
                continue
            
            tuple_data = matches[0]
            str_list = [str(item) for item in tuple_data]
            precondition_str = str_list[1]
            split_lines = precondition_str.split('\n')
            filtered_lines = [line.strip() for line in split_lines if 'test-performed' in line]
            cleaned = [line.replace('(test-performed ', '').replace(')', '') for line in filtered_lines]
            
            if i == 2:
                chunk_size = 12
                chunked = [
                    cleaned[j:j + chunk_size]
                    for j in range(0, len(cleaned), chunk_size)
                    if len(cleaned[j:j + chunk_size]) == chunk_size
                ]
                actions[i] = chunked
            else:
                actions[i] = cleaned

    return actions


#######################
# 3. EXAMPLE USEAGES
#######################

# Taking the first 25 rows of the data for further processing (if needed)
df_patients = df.head(25)

accuracy = 0.0
prediction = 999

# Define the domain file path for the PDDL file
domain_file = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_domain.pddl" ## Change this path or you local path on your computer 

# Load the actions from the PDDL domain file into a dictionary
actions = load_pddl_actions(domain_file)
print("Loaded PDDL actions:")
print(actions)

