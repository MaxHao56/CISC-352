import os
import re
import pandas as pd
from sklearn.preprocessing import LabelEncoder

# ------------------------------
# 1. Data Loading and Preprocessing (unchanged)
# ------------------------------

def classify_column(column):
    """
    Classify numeric column values into three quantile-based bins (l, m, h).
    """
    if pd.api.types.is_numeric_dtype(column):
        try:
            numeric_col = column.astype(float)
            return pd.qcut(numeric_col, q=3, labels=['l', 'm', 'h'])
        except Exception as e:
            print(f"Error processing column {column.name}: {e}")
            return column
    else:
        return column

def load_data(csv_file_path):
    """
    Loads and preprocesses the cancer data from a CSV file.
    """
    if not os.path.exists(csv_file_path):
        raise FileNotFoundError(f"CSV file not found at: {csv_file_path}")
    
    df = pd.read_csv(csv_file_path)
    # Drop extraneous columns if they exist
    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    # Encode the diagnosis column
    df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])
    
    # Create a classified copy of the DataFrame
    classified_df = df.copy()
    for col in classified_df.columns[1:]:
        classified_df[col] = classify_column(classified_df[col])
    
    return df, classified_df

# ------------------------------
# 2. PDDL Actions Loader with Enhanced Diagnose Action Parsing
# ------------------------------

def parse_diagnose_precondition(precondition_str):
    """
    Parses the precondition string for diagnose actions that include an (or …) block
    with multiple (and …) clauses. It returns a list of dictionaries with each dictionary
    representing a separate (and …) clause with its tests extracted from the (test-performed ...).
    
    Returns:
        list: Each element is a dict of the form {"tests": [list of tests]}.
    """
    clause_dicts = []
    
    # Look for the content inside the (or ... ) block.
    # This regex captures everything after "(or" up to the "(not" block or the end of the OR block.
    or_pattern = r'\(or\s*(.*?)\s*(?:\(not|\)$)'
    or_match = re.search(or_pattern, precondition_str, re.DOTALL)
    if not or_match:
        # If the (or …) block isn't found, return an empty list.
        return clause_dicts
    
    or_content = or_match.group(1)
    
    # Find each (and ... ) block inside the OR clause.
    and_clauses = re.findall(r'\(and\s*(.*?)\)', or_content, re.DOTALL)
    
    for clause in and_clauses:
        # Extract all tests from each (and …) block that use (test-performed ...).
        tests = re.findall(r'\(test-performed\s+([^)]+)\)', clause)
        clause_dicts.append({"tests": tests})
    
    return clause_dicts

def load_pddl_actions(pddl_file_path):
    """
    Loads PDDL actions from the domain file. This version searches for any
    actions whose name starts with 'diagnose' and extracts features from their
    precondition block. For actions with an (or …) block containing multiple (and …)
    clauses, each clause is processed separately into its own dictionary.

    Returns:
        dict: A dictionary with keys as diagnose action names and values as dictionaries
              containing their extracted features such as parameters, effect, and tests.
    """
    if not os.path.exists(pddl_file_path):
        raise FileNotFoundError(f"PDDL domain file not found: {pddl_file_path}")
    
    actions = {}
    with open(pddl_file_path, 'r') as file:
        content = file.read()
        # Use a regex pattern that dynamically finds any action starting with "diagnose"
        pattern = (
            r'\(:action\s+(diagnose[^\s]+)\s+'           # Matches action name (diagnoseX)
            r':parameters\s*(\([^\)]*\))\s+'               # Matches parameters block
            r':precondition\s*(\(.*?\))\s+'                # Matches precondition block
            r':effect\s*(\(.*?\))'                         # Matches effect block
        )
        matches = re.findall(pattern, content, re.DOTALL)
        if not matches:
            print("No diagnose actions found in the file.")
            return actions
        
        for action_name, parameters, precondition_str, effect_str in matches:
            if "(or" in precondition_str:
                # If there's an OR clause, process each (and …) inside it as separate dictionaries.
                clause_dicts = parse_diagnose_precondition(precondition_str)
                actions[action_name] = {
                    "or_clauses": clause_dicts,
                    "parameters": parameters,
                    "effect": effect_str
                }
            else:
                # For actions without the OR clause, extract all lines with (test-performed ...).
                filtered_lines = [line.strip() for line in precondition_str.splitlines() if 'test-performed' in line]
                tests = [
                    re.sub(r'\(test-performed\s+', '', line).replace(')', '').strip()
                    for line in filtered_lines
                ]
                actions[action_name] = {
                    "tests": tests,
                    "parameters": parameters,
                    "effect": effect_str
                }
    return actions

# ------------------------------
# 3. Planner Runner and Plan Extraction (unchanged)
# ------------------------------

import subprocess

def run_planner(domain_file, problem_file, planner_executable, planner_args=None):
    """
    Runs the planner with the provided domain and problem files.
    
    Returns:
        str: The standard output from the planner.
    """
    if planner_args is None:
        planner_args = []
    
    # Check that all required files exist
    for file in [domain_file, problem_file, planner_executable]:
        if not os.path.exists(file):
            raise FileNotFoundError(f"File not found: {file}")
    
    cmd = [planner_executable, domain_file, problem_file] + planner_args
    print("Running planner command:", cmd)
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print("Planner execution failed:", e)
        return None

def extract_plan(plan_output):
    """
    Extracts plan steps, metric, and makespan values from the planner output.
    
    Returns:
        tuple: (plan, metric, makespan) where plan is a list of (timestamp, action) tuples.
    """
    plan = []
    metric = None
    makespan = None
    capturing_plan = False

    for line in plan_output.splitlines():
        stripped_line = line.strip()
        if stripped_line == "Plan found:":
            capturing_plan = True
            continue
        
        if capturing_plan:
            m = re.match(r'^(\d+\.\d+):\s*\((.+)\)$', stripped_line)
            if m:
                timestamp = float(m.group(1))
                action = m.group(2).strip()
                plan.append((timestamp, action))
                continue
            else:
                capturing_plan = False
        
        if stripped_line.startswith("Metric:"):
            m = re.search(r'Metric:\s*([0-9.]+)', stripped_line)
            if m:
                metric = float(m.group(1))
        elif stripped_line.startswith("Makespan:"):
            m = re.search(r'Makespan:\s*([0-9.]+)', stripped_line)
            if m:
                makespan = float(m.group(1))
    
    return plan, metric, makespan

def update_actions_with_plan_features(actions, plan):
    """
    Merges the extracted plan steps into the actions dictionary.

    For diagnose actions (e.g., diagnoseX), this function updates the entry with
    a new 'timestamp' field (if present in the plan). For other actions (e.g., init-weights),
    new entries are added.
    
    Returns:
        dict: The updated dictionary of actions with merged features.
    """
    updated_actions = {}
    
    # First, update with the loaded diagnose actions.
    for key, details in actions.items():
        updated_actions[key] = {
            "details": details,
            "timestamp": None,
            "manual_required": False
        }
    
    # Now incorporate actions appearing in the plan.
    for timestamp, action in plan:
        action_name = action.strip()
        if action_name.startswith("diagnose"):
            if action_name in updated_actions:
                updated_actions[action_name]["timestamp"] = timestamp
            else:
                updated_actions[action_name] = {
                    "details": {},
                    "timestamp": timestamp,
                    "manual_required": False
                }
        else:
            updated_actions[action_name] = {
                "timestamp": timestamp,
                "manual_required": (action_name == "init-weights")
            }
    return updated_actions

# ------------------------------
# 4. Main Execution (unchanged)
# ------------------------------

def main():
    # ----- Data Preprocessing -----
    csv_file_path = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/datasets/Cancer_Data.csv"
    df, classified_df = load_data(csv_file_path)
    
    print("Classified Data (first 5 rows):")
    print(classified_df.head())
    
    # ----- Load PDDL Actions -----
    domain_file = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_domain.pddl"
    actions = load_pddl_actions(domain_file)
    print("\nLoaded PDDL Actions:")
    print(actions)
    
    # ----- Run the Planner and Extract Plan Output -----
    problem_file = "C:/Users/unabn/Documents/GitHub/CISC-352/Final_Project/BNN_Auto_Planning/CancerCheck_BNN_problem.pddl"
    planner_executable = "C:/path/to/your/planner_executable"  # Update with the actual path to your planner
    
    try:
        plan_output = run_planner(domain_file, problem_file, planner_executable)
        if plan_output is not None:
            print("\nFull Planner Output:")
            print(plan_output)
            
            plan, metric, makespan = extract_plan(plan_output)
            print("\nExtracted Plan Steps:")
            for timestamp, action in plan:
                print(f"{timestamp:.5f}: ({action})")
            print("Metric:", metric)
            print("Makespan:", makespan)
            
            # ----- Merge Plan Features into the Actions Dictionary -----
            updated_actions = update_actions_with_plan_features(actions, plan)
            print("\nUpdated Actions Dictionary with Plan Features:")
            for act, details in updated_actions.items():
                print(f"{act}: {details}")
        else:
            print("No output received from the planner.")
    except Exception as e:
        print("Error running planner:", e)

if __name__ == '__main__':
    main()
