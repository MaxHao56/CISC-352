import pandas as pd
from sklearn.preprocessing import KBinsDiscretizer
import os
import re
import shutil

def categorize_patient_data(patient_csv_file, bins=3, strategy='quantile', patient_index=0):
    """
    Load patient data from a CSV, discretize each feature into bins (default low/medium/high),
    and return a list of PDDL predicate strings of the form:
      (has-value <feature> <bin_label>)
    
    Args:
        patient_csv_file (str): Path to the patient CSV file.
        bins (int): Number of bins (default is 3).
        strategy (str): Binning strategy (e.g., 'quantile').
        patient_index (int): Index of the patient row to process.
    
    Returns:
        list[str]: List of predicate strings.
    """
    df = pd.read_csv(patient_csv_file)
    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    
    # Remove diagnosis column if present; we only need features.
    if 'diagnosis' in df.columns:
        df.drop(columns=['diagnosis'], inplace=True)
    
    features = df.columns.tolist()
    
    # Discretize features: output is ordinal (0,1,2) corresponding to low, medium, high.
    discretizer = KBinsDiscretizer(n_bins=bins, encode='ordinal', strategy=strategy)
    binned_data = discretizer.fit_transform(df[features])
    bin_labels = ['low', 'medium', 'high'] if bins == 3 else [f"bin{i+1}" for i in range(bins)]
    
    patient_values = binned_data[patient_index]
    new_block_lines = []
    
    # For each feature, create a new predicate line.
    for i, feature in enumerate(features):
        label = bin_labels[int(patient_values[i])]
        new_block_lines.append(f"(has-value {feature} {label})")
    
    return new_block_lines

def update_pddl_file(input_file_path, output_file_path, new_block_lines):
    """
    Reads the PDDL file, removes all lines that contain "has-value", then finds the last line 
    containing "test-performed" and inserts the new block (new_block_lines) immediately afterward.
    The updated content is written to the output file.
    
    Args:
        input_file_path (str): Path to the original PDDL file.
        output_file_path (str): Path where the updated file will be written.
        new_block_lines (list[str]): New lines (predicates) to insert.
    """
    if not os.path.exists(input_file_path):
        raise FileNotFoundError(f"PDDL file not found: {input_file_path}")
    
    with open(input_file_path, 'r') as f:
        lines = f.readlines()
    
    # Filter out lines that contain "has-value"
    filtered_lines = [line for line in lines if "has-value" not in line]
    
    # Find the index of the last occurrence of a line containing "test-performed"
    last_test_index = -1
    for i, line in enumerate(filtered_lines):
        if "test-performed" in line:
            last_test_index = i
    if last_test_index == -1:
        raise ValueError("No line containing 'test-performed' found in the file.")
    
    # Build the new block text as a single string (with newline at the end)
    new_block_text = "\n".join(new_block_lines) + "\n"
    
    # Insert the new block immediately after the last "test-performed" line.
    updated_lines = (
        filtered_lines[:last_test_index+1]
        + [new_block_text]
        + filtered_lines[last_test_index+1:]
    )
    
    # Write updated content to the new file.
    with open(output_file_path, 'w') as f:
        f.writelines(updated_lines)
    
    print(f" Updated file written to: {output_file_path}")

if __name__ == "__main__":
    # File paths (adjust these paths as needed)
    data_csv_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
    template_pddl_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_Problem.pddl"
    output_pddl_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_Problem1.pddl" # the format is little weired but it works
    
    # Optionally, er make a copy of the template file to the output file before modifying
    shutil.copy(template_pddl_path, output_pddl_path)
    
    # Generate the new block of "has-value" predicates from the chosen patient's data
    new_predicates = categorize_patient_data(data_csv_path, patient_index=2)
    
    # Update the PDDL file: remove all old "has-value" lines and insert the new block after "test-performed" lines.
    update_pddl_file(output_pddl_path, output_pddl_path, new_predicates)
