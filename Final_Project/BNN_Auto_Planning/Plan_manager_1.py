import pandas as pd
from sklearn.preprocessing import LabelEncoder
import re

file_path = "/Users/kanicekanice/Desktop/Queensu/plan_manager/Cancer_Data.csv"

df = pd.read_csv(file_path)

###### Preprocessing data
df.drop(columns=['id'], inplace=True, errors='ignore')
df.drop(columns=['Unnamed: 32'], inplace=True, errors='ignore')
df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])


# Function to classify into low, medium, and high using quantiles
def classify_column(column):
    if pd.api.types.is_numeric_dtype(column):
        return pd.qcut(column, q=3, labels=['l', 'm', 'h'])
    else:
        return column

# Copy the original DataFrame
classified_df = df.copy()

# Apply classification from the second column onwards (index 1 and beyond)
classified_df.iloc[:, 1:] = df.iloc[:, 1:].apply(classify_column)

# Show result
print(classified_df.head())

# Load PDDL actions

actions = {}
def load_pddl_actions(CancerCheck_BNN_domain_pddl):
    with open(CancerCheck_BNN_domain_pddl, 'r') as file:
        content = file.read()
        
        # Updated regex pattern to match PDDL actions
        for i in (range(1, 6)):
            
            a=str(i)
            pattern = r'\(:action diagnose'+a+'\s+:parameters\s*(\([^\)]*\))\s*:precondition\s*(\(.*?\))\s*:effect\s*(\(.*?\))'
            matches = re.findall(pattern, content, re.DOTALL)
            tuple_data = matches[0]
            str_list = [str(item) for item in tuple_data]
            
            # Get the precondition string (2nd item) and split it on literal '\n'
            split_str = [j.split('\n') for j in str_list] 
            
            grand_list=[]
            for sublist in split_str:
                grand_list.extend(sublist)

            # Assuming `lines` contains your split and stripped lines
            filtered_lines = [line.strip() for line in grand_list if 'test-performed' in line]

            cleaned = [cond.replace('(test-performed ', '').replace(')', '') for cond in filtered_lines]
            actions[i]=cleaned
        

    return actions

df_patients = df.head(25)

accuracy = 0.0
prediction = 999
for x,y in actions.items(): 
    if (accuracy < 0.9):
        print("send the x/y pair to BNN")
    else:
        break

print(load_pddl_actions('CancerCheck_BNN_domain.pddl'))

