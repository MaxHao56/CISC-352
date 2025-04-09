import os
import subprocess
import re
import pandas as pd
from sklearn.preprocessing import LabelEncoder

# ------------------------------
# 1. Data Loading and Preprocessing
# ------------------------------

def classify_column(column):
    """
    Classify numeric column values into three quantile-based bins (low, medium, high).
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
    # Drop extraneous columns
    df.drop(columns=['id', 'Unnamed: 32'], inplace=True, errors='ignore')
    # Encode the diagnosis column
    df['diagnosis'] = LabelEncoder().fit_transform(df['diagnosis'])
    
    # Create a classified copy of the DataFrame
    classified_df = df.copy()
    for col in classified_df.columns[1:]:
        classified_df[col] = classify_column(classified_df[col])
    
    return df, classified_df

# ------------------------------
# 2. PDDL Actions Loader
# ------------------------------

def load_pddl_actions(pddl_file_path):
    """
    Loads PDDL actions from the domain file.

    It extracts actions diagnose1 to diagnose5 and cleans the precondition strings
    where a 'test-performed' is mentioned.
    """
    if not os.path.exists(pddl_file_path):
        raise FileNotFoundError(f"PDDL domain file not found: {pddl_file_path}")
    
    actions = {}
    with open(pddl_file_path, 'r') as file:
        content = file.read()
        # Iterate over diagnose1 to diagnose5
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
            
            # Get the first match (parameters, precondition, effect)
            tuple_data = matches[0]
            # Extract the precondition part (assumed to be the second element)
            precondition_str = str(tuple_data[1])
            # Split the precondition into lines and filter for 'test-performed'
            filtered_lines = [line.strip() for line in precondition_str.split('\n') if 'test-performed' in line]
            # Clean the lines by removing the surrounding PDDL syntax
            cleaned = [line.replace('(test-performed ', '').replace(')', '') for line in filtered_lines]
            actions[i] = cleaned
    return actions

# ------------------------------
# 3. Planner Runner and Plan Extraction
# ------------------------------

def run_planner(domain_file, problem_file, planner_executable, planner_args=None):
    """
    Runs the planner with the provided domain and problem files.

    Returns:
        str: The standard output from the planner.
    """
    if planner_args is None:
        planner_args = []
    
    # Check that all files exist
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
    
    It looks for a block that follows the header "Plan found:" and only captures
    the first contiguous block of plan-step lines.
    
    Returns:
        tuple: (plan, metric, makespan) where:
            - plan is a list of (timestamp, action) tuples.
            - metric is a float representing the metric value.
            - makespan is a float representing the makespan.
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
        
        # While capturing, try to match a plan-step pattern; expecting lines like "0.00000: (action-name)"
        if capturing_plan:
            m = re.match(r'^(\d+\.\d+):\s*\((.+)\)$', stripped_line)
            if m:
                timestamp = float(m.group(1))
                action = m.group(2).strip()
                plan.append((timestamp, action))
                continue
            else:
                # Once a non-matching line is encountered, stop capturing the first block
                capturing_plan = False
        
        # Outside the plan block, capture metric and makespan if available
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

    For diagnose actions (e.g., diagnose1), we update the corresponding entry with
    a new 'timestamp' field. For actions not present in the original actions dictionary
    (e.g., init-weights, radius_hhl, etc.), new entries are added.
    
    A flag 'manual_required' is set to True for actions (for instance "init-weights")
    that require manual execution.

    Returns:
        dict: The updated dictionary of actions with merged features.
    """
    updated_actions = {}
    
    # First, add the loaded diagnose actions from the domain file.
    # Keys will be like "diagnose1", "diagnose2", etc.
    for key, preconditions in actions.items():
        updated_actions[f"diagnose{key}"] = {
            "preconditions": preconditions,
            "timestamp": None,
            "manual_required": False
        }
    
    # Now update with the actions appearing in the plan
    for timestamp, action in plan:
        action_name = action.strip()
        if action_name.startswith("diagnose"):
            # If it exists, update its timestamp (if multiple occur, the last one will be kept)
            if action_name in updated_actions:
                updated_actions[action_name]["timestamp"] = timestamp
            else:
                # If not (an unusual case), add it.
                updated_actions[action_name] = {
                    "preconditions": [],
                    "timestamp": timestamp,
                    "manual_required": False
                }
        else:
            # For other actions, add an entry; here we mark "init-weights" as requiring manual execution,
            # but you can customize the conditions as needed.
            updated_actions[action_name] = {
                "timestamp": timestamp,
                "manual_required": (action_name == "init-weights")
            }
    return updated_actions

# ------------------------------
# 4. Main Execution
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
    # Set the paths for the problem file and the planner executable.
    # Ensure these files exist and update the paths as necessary.
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
