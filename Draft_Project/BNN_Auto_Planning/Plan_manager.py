from flask import Flask, request, jsonify

app = Flask(__name__)

PDDL_FILE_PATH = "problem.pddl"  # Path to your PDDL file
SECTION_TO_COMMENT = "; START COMMENT SECTION"  # Marker to find section


def modify_pddl_file(input_value):
    """Modifies the PDDL file by commenting out a section if input is 1."""
    with open(PDDL_FILE_PATH, "r") as file:
        lines = file.readlines()
    
    modified_lines = []
    comment_mode = False

    for line in lines:
        if SECTION_TO_COMMENT in line:
            comment_mode = not comment_mode  # Toggle comment mode
            if input_value == 1:
                modified_lines.append("; " + line)  # Comment out section marker
                continue
        
        if comment_mode and input_value == 1:
            modified_lines.append("; " + line)  # Comment out the entire section
        else:
            modified_lines.append(line)
    
    with open(PDDL_FILE_PATH, "w") as file:
        file.writelines(modified_lines)


@app.route("/modify_pddl", methods=["POST"])
def modify_pddl():
    """API endpoint to modify the PDDL file based on input."""
    data = request.get_json()
    input_value = data.get("input")
    
    if input_value not in [0, 1]:
        return jsonify({"error": "Invalid input. Use 0 or 1."}), 400
    
    modify_pddl_file(input_value)
    return jsonify({"message": "PDDL file modified successfully."})


if __name__ == "__main__":
    app.run(debug=True)