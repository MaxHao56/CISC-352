DOMAIN BreastCancerDiagnosis

### STATE SPACE ###
FEATURES:
    # Tumor characteristics (observed or unknown)
    radius_mean: {low, medium, high, unknown}
    texture_mean: {low, medium, high, unknown}
    perimeter_mean: {low, medium, high, unknown}
    area_mean: {low, medium, high, unknown}
    smoothness_mean: {low, medium, high, unknown}
    compactness_mean: {low, medium, high, unknown}
    concavity_mean: {low, medium, high, unknown}
    concave_points_mean: {low, medium, high, unknown}
    symmetry_mean: {low, medium, high, unknown}
    fractal_dimension_mean: {low, medium, high, unknown}

    radius_se: {low, medium, high, unknown}
    texture_se: {low, medium, high, unknown}
    perimeter_se: {low, medium, high, unknown}
    area_se: {low, medium, high, unknown}
    smoothness_se: {low, medium, high, unknown}
    compactness_se: {low, medium, high, unknown}
    concavity_se: {low, medium, high, unknown}
    concave_points_se: {low, medium, high, unknown}
    symmetry_se: {low, medium, high, unknown}
    fractal_dimension_se: {low, medium, high, unknown}

    radius_worst: {low, medium, high, unknown}
    texture_worst: {low, medium, high, unknown}
    perimeter_worst: {low, medium, high, unknown}
    area_worst: {low, medium, high, unknown}
    smoothness_worst: {low, medium, high, unknown}
    compactness_worst: {low, medium, high, unknown}
    concavity_worst: {low, medium, high, unknown}
    concave_points_worst: {low, medium, high, unknown}
    symmetry_worst: {low, medium, high, unknown}
    fractal_dimension_worst: {low, medium, high, unknown}

    # Diagnosis Hypothesis
    diagnosis: {malignant, benign, unknown}

### INITIAL STATE ###
INITIAL_STATE:
    radius_mean = unknown
    texture_mean = unknown
    perimeter_mean = unknown
    area_mean = unknown
    smoothness_mean = unknown
    compactness_mean = unknown
    concavity_mean = unknown
    concave_points_mean = unknown
    symmetry_mean = unknown
    fractal_dimension_mean = unknown
    radius_se = unknown
    texture_se = unknown
    perimeter_se = unknown
    area_se = unknown
    smoothness_se = unknown
    compactness_se = unknown
    concavity_se = unknown
    concave_points_se = unknown
    symmetry_se = unknown
    fractal_dimension_se = unknown
    radius_worst = unknown
    texture_worst = unknown
    perimeter_worst = unknown
    area_worst = unknown
    smoothness_worst = unknown
    compactness_worst = unknown
    concavity_worst = unknown
    concave_points_worst = unknown
    symmetry_worst = unknown
    fractal_dimension_worst = unknown

    diagnosis = unknown

### PROBABILISTIC RULES ###
PROBABILISTIC_RULES:
    P(diagnosis = malignant | radius_mean = high, texture_mean = high) = 0.87
    P(diagnosis = benign | radius_mean = low, texture_mean = low) = 0.92
    P(diagnosis = malignant | perimeter_mean = high, compactness_mean = high) = 0.95
    P(diagnosis = malignant | concavity_mean = high, concave_points_mean = high) = 0.90
    P(diagnosis = benign | symmetry_mean = low, fractal_dimension_mean = low) = 0.89

### ACTIONS (Medical Tests) ###
ACTIONS:
    measure_radius_mean:
        PRECONDITION: (radius_mean = unknown)
        EFFECT: radius_mean = {low, medium, high}
        COST: 2
        REWARD: 5
        PROBABILITY_UPDATE: P(diagnosis | radius_mean)

    measure_texture_mean:
        PRECONDITION: (texture_mean = unknown)
        EFFECT: texture_mean = {low, medium, high}
        COST: 2
        REWARD: 5
        PROBABILITY_UPDATE: P(diagnosis | texture_mean)

    measure_perimeter_mean:
        PRECONDITION: (perimeter_mean = unknown)
        EFFECT: perimeter_mean = {low, medium, high}
        COST: 3
        REWARD: 4
        PROBABILITY_UPDATE: P(diagnosis | perimeter_mean)

    measure_area_mean:
        PRECONDITION: (area_mean = unknown)
        EFFECT: area_mean = {low, medium, high}
        COST: 3
        REWARD: 4
        PROBABILITY_UPDATE: P(diagnosis | area_mean)

    measure_smoothness_mean:
        PRECONDITION: (smoothness_mean = unknown)
        EFFECT: smoothness_mean = {low, medium, high}
        COST: 2
        REWARD: 3
        PROBABILITY_UPDATE: P(diagnosis | smoothness_mean)

    measure_compactness_mean:
        PRECONDITION: (compactness_mean = unknown)
        EFFECT: compactness_mean = {low, medium, high}
        COST: 3
        REWARD: 4
        PROBABILITY_UPDATE: P(diagnosis | compactness_mean)

    measure_concavity_mean:
        PRECONDITION: (concavity_mean = unknown)
        EFFECT: concavity_mean = {low, medium, high}
        COST: 3
        REWARD: 5
        PROBABILITY_UPDATE: P(diagnosis | concavity_mean)

    measure_concave_points_mean:
        PRECONDITION: (concave_points_mean = unknown)
        EFFECT: concave_points_mean = {low, medium, high}
        COST: 3
        REWARD: 5
        PROBABILITY_UPDATE: P(diagnosis | concave_points_mean)

    measure_symmetry_mean:
        PRECONDITION: (symmetry_mean = unknown)
        EFFECT: symmetry_mean = {low, medium, high}
        COST: 2
        REWARD: 3
        PROBABILITY_UPDATE: P(diagnosis | symmetry_mean)

    measure_fractal_dimension_mean:
        PRECONDITION: (fractal_dimension_mean = unknown)
        EFFECT: fractal_dimension_mean = {low, medium, high}
        COST: 2
        REWARD: 3
        PROBABILITY_UPDATE: P(diagnosis | fractal_dimension_mean)

### PLANNING ALGORITHM ###
PLANNING_ALGORITHM:
    forward_chain_A_star:
        heuristic = "Expected Information Gain"
        cost_function = "Minimize Total Cost"
        goal = "maximize P(diagnosis = malignant) OR P(diagnosis = benign) > 0.95"

### EXECUTION PIPELINE ###
EXECUTION_PIPELINE:
    - Classical planner generates optimal action sequence.
    - Executioner performs tests in sequence.
    - PL-DNN observer updates probabilities after each test.
    - If probability threshold reached, conclude diagnosis.
    - Otherwise, re-plan and continue testing.

### GOAL STATE ###
GOAL_STATE:
    diagnosis = malignant OR diagnosis = benign
