from flask import Flask, request, jsonify
import heapq, re, requests
from flask_cors import CORS  # Import CORS for Flasks
app = Flask(__name__)
CORS(app)  # Allow CORS for all routes
import logging
app.run(debug=True)

logging.basicConfig(level=logging.DEBUG)
app.logger.info("Received a request at /least_cost_plan")

# Define Action class with g_cost and h_cost only
class Action:
    def __init__(self, name, g_cost, h_cost, preconditions, effects):
        self.name = name
        self.g_cost = g_cost  # Cost to reach this action from the start
        self.h_cost = h_cost  # Estimated cost to reach the goal
        self.preconditions = preconditions
        self.effects = effects

# Load PDDL actions
def load_pddl_actions(CancerCheck_BNN_domain_pddl):
    actions = {}
    with open(CancerCheck_BNN_domain_pddl, 'r') as file:
        content = file.read()
        
        # Updated regex pattern to match PDDL actions
        pattern = r'\(:action\s+(\w+)\s*:parameters\s*(\([^\)]*\))\s*:precondition\s*(\(.*?\))\s*:effect\s*(\(.*?\))'
        matches = re.findall(pattern, content, re.DOTALL)

        for match in matches:
            action_name = match[0]
            parameters = match[1].strip()
            preconditions = match[2].strip()
            effects = match[3].strip()
            
            actions[action_name] = {
                'parameters': parameters,
                'preconditions': preconditions,
                'effects': effects
            }

    return actions

# Enhance actions with costs
def enhance_actions_with_costs(pddl_actions, g_costs, h_costs):
    actions = []
    for name, details in pddl_actions.items():
        g_cost = g_costs.get(name, 0)
        h_cost = h_costs.get(name, 0)
        action = Action(
            name=name,
            g_cost=g_cost,
            h_cost=h_cost,
            preconditions=details["preconditions"],
            effects=details["effects"]
        )
        actions.append(action)
    return actions

# Define g(n) and h(n) costs
g_costs = {
    action: 1 for action in [
    "perimeter_hhh", "perimeter_hhm", "perimeter_hhl",
    "perimeter_hmh", "perimeter_hmm", "perimeter_hml",
    "perimeter_hlh", "perimeter_hlm", "perimeter_hll",
    "perimeter_mhh", "perimeter_mhm", "perimeter_mhl",
    "perimeter_mmh", "perimeter_mmm", "perimeter_mml",
    "perimeter_mlh", "perimeter_mlm", "perimeter_mll",
    "perimeter_lhh", "perimeter_lhm", "perimeter_lhl",
    "perimeter_lmh", "perimeter_lmm", "perimeter_lml",
    "perimeter_llh", "perimeter_llm", "perimeter_lll"
    ]
} | {  # <-- Merge two dictionaries using `|` (Python 3.9+)
    action: 2 for action in [
    "smoothness_hhh", "smoothness_hhm", "smoothness_hhl",
    "smoothness_hmh", "smoothness_hmm", "smoothness_hml",
    "smoothness_hlh", "smoothness_hlm", "smoothness_hll",
    "smoothness_mhh", "smoothness_mhm", "smoothness_mhl",
    "smoothness_mmh", "smoothness_mmm", "smoothness_mml",
    "smoothness_mlh", "smoothness_mlm", "smoothness_mll",
    "smoothness_lhh", "smoothness_lhm", "smoothness_lhl",
    "smoothness_lmh", "smoothness_lmm", "smoothness_lml",
    "smoothness_llh", "smoothness_llm", "smoothness_lll"
    ]
} | {
    action: 2 for action in [
    "symmetry_hhh", "symmetry_hhm", "symmetry_hhl",
    "symmetry_hmh", "symmetry_hmm", "symmetry_hml",
    "symmetry_hlh", "symmetry_hlm", "symmetry_hll",
    "symmetry_mhh", "symmetry_mhm", "symmetry_mhl",
    "symmetry_mmh", "symmetry_mmm", "symmetry_mml",
    "symmetry_mlh", "symmetry_mlm", "symmetry_mll",
    "symmetry_lhh", "symmetry_lhm", "symmetry_lhl",
    "symmetry_lmh", "symmetry_lmm", "symmetry_lml",
    "symmetry_llh", "symmetry_llm", "symmetry_lll"
    ]
} | {
    action: 1 for action in [
    "radius_hhh", "radius_hhm", "radius_hhl",
    "radius_hmh", "radius_hmm", "radius_hml",
    "radius_hlh", "radius_hlm", "radius_hll",
    "radius_mhh", "radius_mhm", "radius_mhl",
    "radius_mmh", "radius_mmm", "radius_mml",
    "radius_mlh", "radius_mlm", "radius_mll",
    "radius_lhh", "radius_lhm", "radius_lhl",
    "radius_lmh", "radius_lmm", "radius_lml",
    "radius_llh", "radius_llm", "radius_lll"
    ]
} | {
    action: 1 for action in [
    "area_hhh", "area_hhm", "area_hhl",
    "area_hmh", "area_hmm", "area_hml",
    "area_hlh", "area_hlm", "area_hll",
    "area_mhh", "area_mhm", "area_mhl",
    "area_mmh", "area_mmm", "area_mml",
    "area_mlh", "area_mlm", "area_mll",
    "area_lhh", "area_lhm", "area_lhl",
    "area_lmh", "area_lmm", "area_lml",
    "area_llh", "area_llm", "area_lll"
    ]
 } | {   
    action: 1 for action in [
    "compactness_hhh", "compactness_hhm", "compactness_hhl",
    "compactness_hmh", "compactness_hmm", "compactness_hml",
    "compactness_hlh", "compactness_hlm", "compactness_hll",
    "compactness_mhh", "compactness_mhm", "compactness_mhl",
    "compactness_mmh", "compactness_mmm", "compactness_mml",
    "compactness_mlh", "compactness_mlm", "compactness_mll",
    "compactness_lhh", "compactness_lhm", "compactness_lhl",
    "compactness_lmh", "compactness_lmm", "compactness_lml",
    "compactness_llh", "compactness_llm", "compactness_lll"
    ]
} | {
    action: 4 for action in [
    "concavepoints_hhh", "concavepoints_hhm", "concavepoints_hhl",
    "concavepoints_hmh", "concavepoints_hmm", "concavepoints_hml",
    "concavepoints_hlh", "concavepoints_hlm", "concavepoints_hll",
    "concavepoints_mhh", "concavepoints_mhm", "concavepoints_mhl",
    "concavepoints_mmh", "concavepoints_mmm", "concavepoints_mml",
    "concavepoints_mlh", "concavepoints_mlm", "concavepoints_mll",
    "concavepoints_lhh", "concavepoints_lhm", "concavepoints_lhl",
    "concavepoints_lmh", "concavepoints_lmm", "concavepoints_lml",
    "concavepoints_llh", "concavepoints_llm", "concavepoints_lll"
    ]
} | {
    action: 4 for action in [
    "concavity_hhh", "concavity_hhm", "concavity_hhl",
    "concavity_hmh", "concavity_hmm", "concavity_hml",
    "concavity_hlh", "concavity_hlm", "concavity_hll",
    "concavity_mhh", "concavity_mhm", "concavity_mhl",
    "concavity_mmh", "concavity_mmm", "concavity_mml",
    "concavity_mlh", "concavity_mlm", "concavity_mll",
    "concavity_lhh", "concavity_lhm", "concavity_lhl", 
    "concavity_lmh", "concavity_lmm", "concavity_lml",
    "concavity_llh", "concavity_llm", "concavity_lll"
    ]
} | {
    action: 5 for action in [
    "fractaldimension_hhh", "fractaldimension_hhm", "fractaldimension_hhl",
    "fractaldimension_hmh", "fractaldimension_hmm", "fractaldimension_hml",
    "fractaldimension_hlh", "fractaldimension_hlm", "fractaldimension_hll",
    "fractaldimension_mhh", "fractaldimension_mhm", "fractaldimension_mhl",
    "fractaldimension_mmh", "fractaldimension_mmm", "fractaldimension_mml",
    "fractaldimension_mlh", "fractaldimension_mlm", "fractaldimension_mll",
    "fractaldimension_lhh", "fractaldimension_lhm", "fractaldimension_lhl",
    "fractaldimension_lmh", "fractaldimension_lmm", "fractaldimension_lml",
    "fractaldimension_llh", "fractaldimension_llm", "fractaldimension_lll"
    ]
} | {
    action: 3 for action in [
    "texture_hhh", "texture_hhm", "texture_hhl",
    "texture_hmh", "texture_hmm", "texture_hml",
    "texture_hlh", "texture_hlm", "texture_hll",
    "texture_mhh", "texture_mhm", "texture_mhl",
    "texture_mmh", "texture_mmm", "texture_mml",
    "texture_mlh", "texture_mlm", "texture_mll",
    "texture_lhh", "texture_lhm", "texture_lhl",
    "texture_lmh", "texture_lmm", "texture_lml",
    "texture_llh", "texture_llm", "texture_lll"
    ]
}

h_costs = {
    action: 1 for action in [
    "perimeter_hhh", "perimeter_hhm", "perimeter_hhl",
    "perimeter_hmh", "perimeter_hmm", "perimeter_hml",
    "perimeter_hlh", "perimeter_hlm", "perimeter_hll",
    "perimeter_mhh", "perimeter_mhm", "perimeter_mhl",
    "perimeter_mmh", "perimeter_mmm", "perimeter_mml",
    "perimeter_mlh", "perimeter_mlm", "perimeter_mll",
    "perimeter_lhh", "perimeter_lhm", "perimeter_lhl",
    "perimeter_lmh", "perimeter_lmm", "perimeter_lml",
    "perimeter_llh", "perimeter_llm", "perimeter_lll"
    ]
} | {  # <-- Merge two dictionaries using `|` (Python 3.9+)
    action: 2 for action in [
    "smoothness_hhh", "smoothness_hhm", "smoothness_hhl",
    "smoothness_hmh", "smoothness_hmm", "smoothness_hml",
    "smoothness_hlh", "smoothness_hlm", "smoothness_hll",
    "smoothness_mhh", "smoothness_mhm", "smoothness_mhl",
    "smoothness_mmh", "smoothness_mmm", "smoothness_mml",
    "smoothness_mlh", "smoothness_mlm", "smoothness_mll",
    "smoothness_lhh", "smoothness_lhm", "smoothness_lhl",
    "smoothness_lmh", "smoothness_lmm", "smoothness_lml",
    "smoothness_llh", "smoothness_llm", "smoothness_lll"
    ]
} | {
    action: 2 for action in [
    "symmetry_hhh", "symmetry_hhm", "symmetry_hhl",
    "symmetry_hmh", "symmetry_hmm", "symmetry_hml",
    "symmetry_hlh", "symmetry_hlm", "symmetry_hll",
    "symmetry_mhh", "symmetry_mhm", "symmetry_mhl",
    "symmetry_mmh", "symmetry_mmm", "symmetry_mml",
    "symmetry_mlh", "symmetry_mlm", "symmetry_mll",
    "symmetry_lhh", "symmetry_lhm", "symmetry_lhl",
    "symmetry_lmh", "symmetry_lmm", "symmetry_lml",
    "symmetry_llh", "symmetry_llm", "symmetry_lll"
    ]
} | {
    action: 1 for action in [
    "radius_hhh", "radius_hhm", "radius_hhl",
    "radius_hmh", "radius_hmm", "radius_hml",
    "radius_hlh", "radius_hlm", "radius_hll",
    "radius_mhh", "radius_mhm", "radius_mhl",
    "radius_mmh", "radius_mmm", "radius_mml",
    "radius_mlh", "radius_mlm", "radius_mll",
    "radius_lhh", "radius_lhm", "radius_lhl",
    "radius_lmh", "radius_lmm", "radius_lml",
    "radius_llh", "radius_llm", "radius_lll"
    ]
} | {
    action: 1 for action in [
    "area_hhh", "area_hhm", "area_hhl",
    "area_hmh", "area_hmm", "area_hml",
    "area_hlh", "area_hlm", "area_hll",
    "area_mhh", "area_mhm", "area_mhl",
    "area_mmh", "area_mmm", "area_mml",
    "area_mlh", "area_mlm", "area_mll",
    "area_lhh", "area_lhm", "area_lhl",
    "area_lmh", "area_lmm", "area_lml",
    "area_llh", "area_llm", "area_lll"
    ]
 } | {   
    action: 1 for action in [
    "compactness_hhh", "compactness_hhm", "compactness_hhl",
    "compactness_hmh", "compactness_hmm", "compactness_hml",
    "compactness_hlh", "compactness_hlm", "compactness_hll",
    "compactness_mhh", "compactness_mhm", "compactness_mhl",
    "compactness_mmh", "compactness_mmm", "compactness_mml",
    "compactness_mlh", "compactness_mlm", "compactness_mll",
    "compactness_lhh", "compactness_lhm", "compactness_lhl",
    "compactness_lmh", "compactness_lmm", "compactness_lml",
    "compactness_llh", "compactness_llm", "compactness_lll"
    ]
} | {
    action: 4 for action in [
    "concavepoints_hhh", "concavepoints_hhm", "concavepoints_hhl",
    "concavepoints_hmh", "concavepoints_hmm", "concavepoints_hml",
    "concavepoints_hlh", "concavepoints_hlm", "concavepoints_hll",
    "concavepoints_mhh", "concavepoints_mhm", "concavepoints_mhl",
    "concavepoints_mmh", "concavepoints_mmm", "concavepoints_mml",
    "concavepoints_mlh", "concavepoints_mlm", "concavepoints_mll",
    "concavepoints_lhh", "concavepoints_lhm", "concavepoints_lhl",
    "concavepoints_lmh", "concavepoints_lmm", "concavepoints_lml",
    "concavepoints_llh", "concavepoints_llm", "concavepoints_lll"
    ]
} | {
    action: 3 for action in [
    "concavity_hhh", "concavity_hhm", "concavity_hhl",
    "concavity_hmh", "concavity_hmm", "concavity_hml",
    "concavity_hlh", "concavity_hlm", "concavity_hll",
    "concavity_mhh", "concavity_mhm", "concavity_mhl",
    "concavity_mmh", "concavity_mmm", "concavity_mml",
    "concavity_mlh", "concavity_mlm", "concavity_mll",
    "concavity_lhh", "concavity_lhm", "concavity_lhl", 
    "concavity_lmh", "concavity_lmm", "concavity_lml",
    "concavity_llh", "concavity_llm", "concavity_lll"
    ]
} | {
    action: 4 for action in [
    "fractaldimension_hhh", "fractaldimension_hhm", "fractaldimension_hhl",
    "fractaldimension_hmh", "fractaldimension_hmm", "fractaldimension_hml",
    "fractaldimension_hlh", "fractaldimension_hlm", "fractaldimension_hll",
    "fractaldimension_mhh", "fractaldimension_mhm", "fractaldimension_mhl",
    "fractaldimension_mmh", "fractaldimension_mmm", "fractaldimension_mml",
    "fractaldimension_mlh", "fractaldimension_mlm", "fractaldimension_mll",
    "fractaldimension_lhh", "fractaldimension_lhm", "fractaldimension_lhl",
    "fractaldimension_lmh", "fractaldimension_lmm", "fractaldimension_lml",
    "fractaldimension_llh", "fractaldimension_llm", "fractaldimension_lll"
    ]
} | {
    action: 3 for action in [
    "texture_hhh", "texture_hhm", "texture_hhl",
    "texture_hmh", "texture_hmm", "texture_hml",
    "texture_hlh", "texture_hlm", "texture_hll",
    "texture_mhh", "texture_mhm", "texture_mhl",
    "texture_mmh", "texture_mmm", "texture_mml",
    "texture_mlh", "texture_mlm", "texture_mll",
    "texture_lhh", "texture_lhm", "texture_lhl",
    "texture_lmh", "texture_lmm", "texture_lml",
    "texture_llh", "texture_llm", "texture_lll"
    ]
}

# Goal states
goal_states = {"diagnose1", "diagnose2", "diagnose3"}

def interact_with_bnn(least_cost_path):
    """
    Interacts with the BNN to get accuracy and diagnosis result.
    
    Parameters:
    - least_cost_path: List of actions that represent the least cost path to diagnose.

    Returns:
    - accuracy: A float representing the accuracy of the diagnosis (0 to 1).
    - prediction: An integer representing the diagnosis result (1 for malignant, 0 for benign).
    """
    # Define the URL for the BNN API
    # bnn_api_url = 'http://your-bnn-api-url/diagnose'

    # Prepare the payload with the least cost path
    payload = {
        'actions': least_cost_path
    }

    # Send a POST request to the BNN API
    # try:
    #     response = requests.post(bnn_api_url, json=payload)
    #     response.raise_for_status()  # Raise an error for bad responses

    #     # Extract accuracy and prediction from the response
    #     data = response.json()
    #     accuracy = data.get('accuracy')
    #     prediction = data.get('prediction')

    #     return accuracy, prediction

    # except requests.exceptions.RequestException as e:
    #     print(f"Error communicating with BNN: {e}")
    #     return None, None  # Return None if there's an error
    
    #example
    accuracy = 0.75  # example accuracy
    prediction = 1   # example prediction (1 for malignant, 0 for benign)
    return accuracy, prediction

def modify_pddl_file(action_to_remove):
    """Modifies the PDDL file to comment out the specified action."""
    PDDL_FILE_PATH = '/Users/kanicekanice/Desktop/Queensu/plan_manager/CancerCheck_BNN_domain.pddl'  # Path to your PDDL file
    
    with open(PDDL_FILE_PATH, 'r') as file:
        lines = file.readlines()
    
    modified_lines = []
    action_pattern = f'(:action {action_to_remove}\n'  # Pattern to find the action block
    in_action_block = False

    for line in lines:
        if action_pattern in line:
            in_action_block = True
            modified_lines.append('; ' + line)  # Comment out the action line
            continue
        if in_action_block and line.startswith(')'):
            in_action_block = False
            modified_lines.append('; ' + line)  # Comment out the closing parenthesis of the action
            continue
        if in_action_block:
            modified_lines.append('; ' + line)  # Comment out all lines in the action block
        else:
            modified_lines.append(line)

    with open(PDDL_FILE_PATH, 'w') as file:
        file.writelines(modified_lines)

# Define State class

class State:
    def __init__(self, performed_actions, cost):
        self.performed_actions = set(performed_actions)  # Actions taken so far
        self.cost = cost  # g(n) cost so far

    def __lt__(self, other):
        return self.cost < other.cost  # Needed for priority queue

    # def is_goal(self):
    #     return self.attributes.get("diagnosed", False)

    # def apply_action(self, action):
    #     # Check preconditions
    #     if all(self.attributes.get(pre, False) for pre in action.preconditions):
    #         # Apply effects
    #         new_attributes = self.attributes.copy()
    #         for eff in action.effects:
    #             new_attributes[eff] = True  # Apply effect
    #         return State(new_attributes), action.g_cost  # Return g_cost for the action
    #     return None, float('inf')  # Invalid action

# Define PlanManager class
class PlanManager:
    # A* Search Implementation
    def find_least_cost_path(actions):
        start_state = State(performed_actions=set(), cost=0)
        priority_queue = [(0, start_state)]  # (f(n), state)
        visited = set()

        while priority_queue:
            _, current_state = heapq.heappop(priority_queue)

            # Check if we reached any goal state
            if any(goal in current_state.performed_actions for goal in goal_states):
                return list(current_state.performed_actions), current_state.cost

            if frozenset(current_state.performed_actions) in visited:
                continue
            visited.add(frozenset(current_state.performed_actions))

            for action_name, action_data in actions.items():
                if action_name in current_state.performed_actions:
                    continue  # Skip if already done

                new_actions = current_state.performed_actions | {action_name}
                new_cost = current_state.cost + g_costs.get(action_name, 1)  # Default cost=1 if missing

                # A* heuristic: f(n) = g(n) + h(n)
                heuristic = h_costs.get(action_name, 1)
                f_cost = new_cost + heuristic

                new_state = State(new_actions, new_cost)
                heapq.heappush(priority_queue, (f_cost, new_state))

        return None, float("inf")  # No valid path found
    
# Load actions from the PDDL file
pddl_actions = load_pddl_actions('/Users/kanicekanice/Desktop/Queensu/plan_manager/CancerCheck_BNN_domain.pddl')

# Enhance actions with costs
actions = enhance_actions_with_costs(pddl_actions, g_costs, h_costs)

plan_manager = PlanManager(actions)

@app.route('/least_cost_plan', methods=['POST'])

def least_cost_plan():
    # data = request.get_json()
    # return jsonify({"message": "Received", "data": data}), 200
    least_cost_path, total_cost = plan_manager.find_least_cost_path()
    
    # Interact with BNN
    accuracy, prediction = interact_with_bnn(least_cost_path)
    
    # Check accuracy and adjust costs if needed
    if accuracy < 0.8:  # Threshold for low accuracy
        for action in least_cost_path:
            h_costs[action] += 1  # Increase cost for this action
            modify_pddl_file(action)  # Comment out the action in the PDDL file
    return jsonify({"plan": least_cost_path, "total_cost": total_cost, "accuracy": accuracy, "prediction": prediction})

# PDDL_FILE_PATH = "problem.pddl"  
# SECTION_TO_COMMENT = "; commenting input "


# def modify_pddl_file(input_value):
#     """Modifies the PDDL file by commenting out a section if input is 1."""
#     with open(PDDL_FILE_PATH, "r") as file:
#         lines = file.readlines()
    
#     modified_lines = []
#     comment_mode = False

#     for line in lines:
#         if SECTION_TO_COMMENT in line:
#             comment_mode = not comment_mode  # Toggle comment mode
#             if input_value == 1:
#                 modified_lines.append("; " + line)  # Comment out section marker
#                 continue
        
#         if comment_mode and input_value == 1:
#             modified_lines.append("; " + line)  # Comment out the entire section
#         else:
#             modified_lines.append(line)
    
#     with open(PDDL_FILE_PATH, "w") as file:
#         file.writelines(modified_lines)


# @app.route("/modify_pddl", methods=["POST"])
# def modify_pddl():
#     """API endpoint to modify the PDDL file based on input."""
#     data = request.get_json()
#     input_value = data.get("input")
    
#     if input_value not in [0, 1]:
#         return jsonify({"error": "Invalid input. Use 0 or 1."}), 400
    
#     modify_pddl_file(input_value)
#     return jsonify({"message": "PDDL file modified successfully."})


if __name__ == "__main__":
    app.run(debug=True)