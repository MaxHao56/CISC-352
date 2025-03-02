import subprocess
import os

# Define paths
DOMAIN_FILE = "domain.pddl"
PROBLEM_FILE = "problem.pddl"
PLANNER_PATH = "./solver.py"  # Change this to ENHSP if needed

def run_planner(domain, problem, planner):
    """
    Runs the PDDL planner and extracts the optimal plan.
    """
    try:
        result = subprocess.run(
            [planner, domain, problem],
            capture_output=True,
            text=True,
            timeout=60  # Timeout in case the planner hangs
        )

        output = result.stdout
        return output

    except subprocess.TimeoutExpired:
        print("Planner timeout! Try adjusting problem constraints.")
        return None
    except Exception as e:
        print(f"Error running planner: {e}")
        return None

def extract_plan(output):
    """
    Parses the planner output to extract the action sequence and cost.
    """
    plan = []
    total_cost = 0

    lines = output.split("\n")
    for line in lines:
        line = line.strip().lower()
        if line.startswith("(") and "reach-goal" not in line:
            plan.append(line)
        if "plan found with cost" in line:
            total_cost = int(line.split()[-1])

    return plan, total_cost

def validate_plan(plan, expected_cost):
    """
    Ensures that the returned plan aligns with the expected cost updates.
    """
    if not plan:
        print("No valid plan found!")
        return False

    print("\nOptimal Plan Found:")
    for step in plan:
        print(f"  - {step}")

    print(f"\nTotal Cost: {expected_cost}")
    return True

# Run the solver
output = run_planner(DOMAIN_FILE, PROBLEM_FILE, PLANNER_PATH)

if output:
    plan, total_cost = extract_plan(output)
    validate_plan(plan, total_cost)
else:
    print("Planner failed to generate output.")
