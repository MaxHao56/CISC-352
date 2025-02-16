(define (domain breast-cancer-diagnosis)
  (:requirements :strips :typing :negative-preconditions :disjunctive-preconditions :numeric-fluents :action-costs)
  ;; If your planner does not support disjunction (i.e. (or ...)) in preconditions,
  ;; you can remove :disjunctive-preconditions and split the diagnose actions.

  (:types 
    measurement
    value
  )

  (:constants
    ;; Measurements (30 features)
    radius_mean
    texture_mean
    perimeter_mean
    area_mean
    smoothness_mean
    compactness_mean
    concavity_mean
    concave_points_mean
    symmetry_mean
    fractal_dimension_mean

    radius_se
    texture_se
    perimeter_se
    area_se
    smoothness_se
    compactness_se
    concavity_se
    concave_points_se
    symmetry_se
    fractal_dimension_se

    radius_worst
    texture_worst
    perimeter_worst
    area_worst
    smoothness_worst
    compactness_worst
    concavity_worst
    concave_points_worst
    symmetry_worst
    fractal_dimension_worst

    ;; Possible values
    low
    medium
    high

    malignant
    benign
    - value
  )

  (:predicates
    ;; Whether measurement ?m has been assigned value ?v
    (has-value ?m - measurement ?v - value)
    ;; Whether measurement ?m was already performed
    (test-performed ?m - measurement)
    ;; Diagnosis label (we treat malignant or benign as "values" for convenience)
    (diagnosed ?d - value)
  )

  (:functions
    (total-cost)
  )

  ;; ------------------------------------------------
  ;; MEASUREMENT ACTIONS: Each measurement has 3 actions
  ;; ------------------------------------------------

  ;; =============== radius_mean ===============
  (:action measure_radius_mean_low
    :parameters ()
    :precondition (not (test-performed radius_mean))
    :effect (and
      (test-performed radius_mean)
      (increase (total-cost) 2)
      (has-value radius_mean low))
  )

  (:action measure_radius_mean_medium
    :parameters ()
    :precondition (not (test-performed radius_mean))
    :effect (and
      (test-performed radius_mean)
      (increase (total-cost) 2)
      (has-value radius_mean medium))
  )

  (:action measure_radius_mean_high
    :parameters ()
    :precondition (not (test-performed radius_mean))
    :effect (and
      (test-performed radius_mean)
      (increase (total-cost) 2)
      (has-value radius_mean high))
  )

  ;; =============== texture_mean ===============
  (:action measure_texture_mean_low
    :parameters ()
    :precondition (not (test-performed texture_mean))
    :effect (and
      (test-performed texture_mean)
      (increase (total-cost) 2)
      (has-value texture_mean low))
  )

  (:action measure_texture_mean_medium
    :parameters ()
    :precondition (not (test-performed texture_mean))
    :effect (and
      (test-performed texture_mean)
      (increase (total-cost) 2)
      (has-value texture_mean medium))
  )

  (:action measure_texture_mean_high
    :parameters ()
    :precondition (not (test-performed texture_mean))
    :effect (and
      (test-performed texture_mean)
      (increase (total-cost) 2)
      (has-value texture_mean high))
  )

  ;; =============== perimeter_mean ===============
  (:action measure_perimeter_mean_low
    :parameters ()
    :precondition (not (test-performed perimeter_mean))
    :effect (and
      (test-performed perimeter_mean)
      (increase (total-cost) 3)
      (has-value perimeter_mean low))
  )

  (:action measure_perimeter_mean_medium
    :parameters ()
    :precondition (not (test-performed perimeter_mean))
    :effect (and
      (test-performed perimeter_mean)
      (increase (total-cost) 3)
      (has-value perimeter_mean medium))
  )

  (:action measure_perimeter_mean_high
    :parameters ()
    :precondition (not (test-performed perimeter_mean))
    :effect (and
      (test-performed perimeter_mean)
      (increase (total-cost) 3)
      (has-value perimeter_mean high))
  )

  ;; =============== area_mean ===============
  (:action measure_area_mean_low
    :parameters ()
    :precondition (not (test-performed area_mean))
    :effect (and
      (test-performed area_mean)
      (increase (total-cost) 3)
      (has-value area_mean low))
  )

  (:action measure_area_mean_medium
    :parameters ()
    :precondition (not (test-performed area_mean))
    :effect (and
      (test-performed area_mean)
      (increase (total-cost) 3)
      (has-value area_mean medium))
  )

  (:action measure_area_mean_high
    :parameters ()
    :precondition (not (test-performed area_mean))
    :effect (and
      (test-performed area_mean)
      (increase (total-cost) 3)
      (has-value area_mean high))
  )

  ;; =============== smoothness_mean ===============
  (:action measure_smoothness_mean_low
    :parameters ()
    :precondition (not (test-performed smoothness_mean))
    :effect (and
      (test-performed smoothness_mean)
      (increase (total-cost) 2)
      (has-value smoothness_mean low))
  )

  (:action measure_smoothness_mean_medium
    :parameters ()
    :precondition (not (test-performed smoothness_mean))
    :effect (and
      (test-performed smoothness_mean)
      (increase (total-cost) 2)
      (has-value smoothness_mean medium))
  )

  (:action measure_smoothness_mean_high
    :parameters ()
    :precondition (not (test-performed smoothness_mean))
    :effect (and
      (test-performed smoothness_mean)
      (increase (total-cost) 2)
      (has-value smoothness_mean high))
  )

  ;; =============== compactness_mean ===============
  (:action measure_compactness_mean_low
    :parameters ()
    :precondition (not (test-performed compactness_mean))
    :effect (and
      (test-performed compactness_mean)
      (increase (total-cost) 3)
      (has-value compactness_mean low))
  )

  (:action measure_compactness_mean_medium
    :parameters ()
    :precondition (not (test-performed compactness_mean))
    :effect (and
      (test-performed compactness_mean)
      (increase (total-cost) 3)
      (has-value compactness_mean medium))
  )

  (:action measure_compactness_mean_high
    :parameters ()
    :precondition (not (test-performed compactness_mean))
    :effect (and
      (test-performed compactness_mean)
      (increase (total-cost) 3)
      (has-value compactness_mean high))
  )

  ;; =============== concavity_mean ===============
  (:action measure_concavity_mean_low
    :parameters ()
    :precondition (not (test-performed concavity_mean))
    :effect (and
      (test-performed concavity_mean)
      (increase (total-cost) 3)
      (has-value concavity_mean low))
  )

  (:action measure_concavity_mean_medium
    :parameters ()
    :precondition (not (test-performed concavity_mean))
    :effect (and
      (test-performed concavity_mean)
      (increase (total-cost) 3)
      (has-value concavity_mean medium))
  )

  (:action measure_concavity_mean_high
    :parameters ()
    :precondition (not (test-performed concavity_mean))
    :effect (and
      (test-performed concavity_mean)
      (increase (total-cost) 3)
      (has-value concavity_mean high))
  )

  ;; =============== concave_points_mean ===============
  (:action measure_concave_points_mean_low
    :parameters ()
    :precondition (not (test-performed concave_points_mean))
    :effect (and
      (test-performed concave_points_mean)
      (increase (total-cost) 3)
      (has-value concave_points_mean low))
  )

  (:action measure_concave_points_mean_medium
    :parameters ()
    :precondition (not (test-performed concave_points_mean))
    :effect (and
      (test-performed concave_points_mean)
      (increase (total-cost) 3)
      (has-value concave_points_mean medium))
  )

  (:action measure_concave_points_mean_high
    :parameters ()
    :precondition (not (test-performed concave_points_mean))
    :effect (and
      (test-performed concave_points_mean)
      (increase (total-cost) 3)
      (has-value concave_points_mean high))
  )

  ;; =============== symmetry_mean ===============
  (:action measure_symmetry_mean_low
    :parameters ()
    :precondition (not (test-performed symmetry_mean))
    :effect (and
      (test-performed symmetry_mean)
      (increase (total-cost) 2)
      (has-value symmetry_mean low))
  )

  (:action measure_symmetry_mean_medium
    :parameters ()
    :precondition (not (test-performed symmetry_mean))
    :effect (and
      (test-performed symmetry_mean)
      (increase (total-cost) 2)
      (has-value symmetry_mean medium))
  )

  (:action measure_symmetry_mean_high
    :parameters ()
    :precondition (not (test-performed symmetry_mean))
    :effect (and
      (test-performed symmetry_mean)
      (increase (total-cost) 2)
      (has-value symmetry_mean high))
  )

  ;; =============== fractal_dimension_mean ===============
  (:action measure_fractal_dimension_mean_low
    :parameters ()
    :precondition (not (test-performed fractal_dimension_mean))
    :effect (and
      (test-performed fractal_dimension_mean)
      (increase (total-cost) 2)
      (has-value fractal_dimension_mean low))
  )

  (:action measure_fractal_dimension_mean_medium
    :parameters ()
    :precondition (not (test-performed fractal_dimension_mean))
    :effect (and
      (test-performed fractal_dimension_mean)
      (increase (total-cost) 2)
      (has-value fractal_dimension_mean medium))
  )

  (:action measure_fractal_dimension_mean_high
    :parameters ()
    :precondition (not (test-performed fractal_dimension_mean))
    :effect (and
      (test-performed fractal_dimension_mean)
      (increase (total-cost) 2)
      (has-value fractal_dimension_mean high))
  )

  ;; =============== radius_se ===============
  (:action measure_radius_se_low
    :parameters ()
    :precondition (not (test-performed radius_se))
    :effect (and
      (test-performed radius_se)
      (increase (total-cost) 2)
      (has-value radius_se low))
  )

  (:action measure_radius_se_medium
    :parameters ()
    :precondition (not (test-performed radius_se))
    :effect (and
      (test-performed radius_se)
      (increase (total-cost) 2)
      (has-value radius_se medium))
  )

  (:action measure_radius_se_high
    :parameters ()
    :precondition (not (test-performed radius_se))
    :effect (and
      (test-performed radius_se)
      (increase (total-cost) 2)
      (has-value radius_se high))
  )

  ;; =============== texture_se ===============
  (:action measure_texture_se_low
    :parameters ()
    :precondition (not (test-performed texture_se))
    :effect (and
      (test-performed texture_se)
      (increase (total-cost) 2)
      (has-value texture_se low))
  )

  (:action measure_texture_se_medium
    :parameters ()
    :precondition (not (test-performed texture_se))
    :effect (and
      (test-performed texture_se)
      (increase (total-cost) 2)
      (has-value texture_se medium))
  )

  (:action measure_texture_se_high
    :parameters ()
    :precondition (not (test-performed texture_se))
    :effect (and
      (test-performed texture_se)
      (increase (total-cost) 2)
      (has-value texture_se high))
  )

  ;; =============== perimeter_se ===============
  (:action measure_perimeter_se_low
    :parameters ()
    :precondition (not (test-performed perimeter_se))
    :effect (and
      (test-performed perimeter_se)
      (increase (total-cost) 3)
      (has-value perimeter_se low))
  )

  (:action measure_perimeter_se_medium
    :parameters ()
    :precondition (not (test-performed perimeter_se))
    :effect (and
      (test-performed perimeter_se)
      (increase (total-cost) 3)
      (has-value perimeter_se medium))
  )

  (:action measure_perimeter_se_high
    :parameters ()
    :precondition (not (test-performed perimeter_se))
    :effect (and
      (test-performed perimeter_se)
      (increase (total-cost) 3)
      (has-value perimeter_se high))
  )

  ;; =============== area_se ===============
  (:action measure_area_se_low
    :parameters ()
    :precondition (not (test-performed area_se))
    :effect (and
      (test-performed area_se)
      (increase (total-cost) 3)
      (has-value area_se low))
  )

  (:action measure_area_se_medium
    :parameters ()
    :precondition (not (test-performed area_se))
    :effect (and
      (test-performed area_se)
      (increase (total-cost) 3)
      (has-value area_se medium))
  )

  (:action measure_area_se_high
    :parameters ()
    :precondition (not (test-performed area_se))
    :effect (and
      (test-performed area_se)
      (increase (total-cost) 3)
      (has-value area_se high))
  )

  ;; =============== smoothness_se ===============
  (:action measure_smoothness_se_low
    :parameters ()
    :precondition (not (test-performed smoothness_se))
    :effect (and
      (test-performed smoothness_se)
      (increase (total-cost) 2)
      (has-value smoothness_se low))
  )

  (:action measure_smoothness_se_medium
    :parameters ()
    :precondition (not (test-performed smoothness_se))
    :effect (and
      (test-performed smoothness_se)
      (increase (total-cost) 2)
      (has-value smoothness_se medium))
  )

  (:action measure_smoothness_se_high
    :parameters ()
    :precondition (not (test-performed smoothness_se))
    :effect (and
      (test-performed smoothness_se)
      (increase (total-cost) 2)
      (has-value smoothness_se high))
  )

  ;; =============== compactness_se ===============
  (:action measure_compactness_se_low
    :parameters ()
    :precondition (not (test-performed compactness_se))
    :effect (and
      (test-performed compactness_se)
      (increase (total-cost) 3)
      (has-value compactness_se low))
  )

  (:action measure_compactness_se_medium
    :parameters ()
    :precondition (not (test-performed compactness_se))
    :effect (and
      (test-performed compactness_se)
      (increase (total-cost) 3)
      (has-value compactness_se medium))
  )

  (:action measure_compactness_se_high
    :parameters ()
    :precondition (not (test-performed compactness_se))
    :effect (and
      (test-performed compactness_se)
      (increase (total-cost) 3)
      (has-value compactness_se high))
  )

  ;; =============== concavity_se ===============
  (:action measure_concavity_se_low
    :parameters ()
    :precondition (not (test-performed concavity_se))
    :effect (and
      (test-performed concavity_se)
      (increase (total-cost) 3)
      (has-value concavity_se low))
  )

  (:action measure_concavity_se_medium
    :parameters ()
    :precondition (not (test-performed concavity_se))
    :effect (and
      (test-performed concavity_se)
      (increase (total-cost) 3)
      (has-value concavity_se medium))
  )

  (:action measure_concavity_se_high
    :parameters ()
    :precondition (not (test-performed concavity_se))
    :effect (and
      (test-performed concavity_se)
      (increase (total-cost) 3)
      (has-value concavity_se high))
  )

  ;; =============== concave_points_se ===============
  (:action measure_concave_points_se_low
    :parameters ()
    :precondition (not (test-performed concave_points_se))
    :effect (and
      (test-performed concave_points_se)
      (increase (total-cost) 3)
      (has-value concave_points_se low))
  )

  (:action measure_concave_points_se_medium
    :parameters ()
    :precondition (not (test-performed concave_points_se))
    :effect (and
      (test-performed concave_points_se)
      (increase (total-cost) 3)
      (has-value concave_points_se medium))
  )

  (:action measure_concave_points_se_high
    :parameters ()
    :precondition (not (test-performed concave_points_se))
    :effect (and
      (test-performed concave_points_se)
      (increase (total-cost) 3)
      (has-value concave_points_se high))
  )

  ;; =============== symmetry_se ===============
  (:action measure_symmetry_se_low
    :parameters ()
    :precondition (not (test-performed symmetry_se))
    :effect (and
      (test-performed symmetry_se)
      (increase (total-cost) 2)
      (has-value symmetry_se low))
  )

  (:action measure_symmetry_se_medium
    :parameters ()
    :precondition (not (test-performed symmetry_se))
    :effect (and
      (test-performed symmetry_se)
      (increase (total-cost) 2)
      (has-value symmetry_se medium))
  )

  (:action measure_symmetry_se_high
    :parameters ()
    :precondition (not (test-performed symmetry_se))
    :effect (and
      (test-performed symmetry_se)
      (increase (total-cost) 2)
      (has-value symmetry_se high))
  )

  ;; =============== fractal_dimension_se ===============
  (:action measure_fractal_dimension_se_low
    :parameters ()
    :precondition (not (test-performed fractal_dimension_se))
    :effect (and
      (test-performed fractal_dimension_se)
      (increase (total-cost) 2)
      (has-value fractal_dimension_se low))
  )

  (:action measure_fractal_dimension_se_medium
    :parameters ()
    :precondition (not (test-performed fractal_dimension_se))
    :effect (and
      (test-performed fractal_dimension_se)
      (increase (total-cost) 2)
      (has-value fractal_dimension_se medium))
  )

  (:action measure_fractal_dimension_se_high
    :parameters ()
    :precondition (not (test-performed fractal_dimension_se))
    :effect (and
      (test-performed fractal_dimension_se)
      (increase (total-cost) 2)
      (has-value fractal_dimension_se high))
  )

  ;; =============== radius_worst ===============
  (:action measure_radius_worst_low
    :parameters ()
    :precondition (not (test-performed radius_worst))
    :effect (and
      (test-performed radius_worst)
      (increase (total-cost) 2)
      (has-value radius_worst low))
  )

  (:action measure_radius_worst_medium
    :parameters ()
    :precondition (not (test-performed radius_worst))
    :effect (and
      (test-performed radius_worst)
      (increase (total-cost) 2)
      (has-value radius_worst medium))
  )

  (:action measure_radius_worst_high
    :parameters ()
    :precondition (not (test-performed radius_worst))
    :effect (and
      (test-performed radius_worst)
      (increase (total-cost) 2)
      (has-value radius_worst high))
  )

  ;; =============== texture_worst ===============
  (:action measure_texture_worst_low
    :parameters ()
    :precondition (not (test-performed texture_worst))
    :effect (and
      (test-performed texture_worst)
      (increase (total-cost) 2)
      (has-value texture_worst low))
  )

  (:action measure_texture_worst_medium
    :parameters ()
    :precondition (not (test-performed texture_worst))
    :effect (and
      (test-performed texture_worst)
      (increase (total-cost) 2)
      (has-value texture_worst medium))
  )

  (:action measure_texture_worst_high
    :parameters ()
    :precondition (not (test-performed texture_worst))
    :effect (and
      (test-performed texture_worst)
      (increase (total-cost) 2)
      (has-value texture_worst high))
  )

  ;; =============== perimeter_worst ===============
  (:action measure_perimeter_worst_low
    :parameters ()
    :precondition (not (test-performed perimeter_worst))
    :effect (and
      (test-performed perimeter_worst)
      (increase (total-cost) 3)
      (has-value perimeter_worst low))
  )

  (:action measure_perimeter_worst_medium
    :parameters ()
    :precondition (not (test-performed perimeter_worst))
    :effect (and
      (test-performed perimeter_worst)
      (increase (total-cost) 3)
      (has-value perimeter_worst medium))
  )

  (:action measure_perimeter_worst_high
    :parameters ()
    :precondition (not (test-performed perimeter_worst))
    :effect (and
      (test-performed perimeter_worst)
      (increase (total-cost) 3)
      (has-value perimeter_worst high))
  )

  ;; =============== area_worst ===============
  (:action measure_area_worst_low
    :parameters ()
    :precondition (not (test-performed area_worst))
    :effect (and
      (test-performed area_worst)
      (increase (total-cost) 3)
      (has-value area_worst low))
  )

  (:action measure_area_worst_medium
    :parameters ()
    :precondition (not (test-performed area_worst))
    :effect (and
      (test-performed area_worst)
      (increase (total-cost) 3)
      (has-value area_worst medium))
  )

  (:action measure_area_worst_high
    :parameters ()
    :precondition (not (test-performed area_worst))
    :effect (and
      (test-performed area_worst)
      (increase (total-cost) 3)
      (has-value area_worst high))
  )

  ;; =============== smoothness_worst ===============
  (:action measure_smoothness_worst_low
    :parameters ()
    :precondition (not (test-performed smoothness_worst))
    :effect (and
      (test-performed smoothness_worst)
      (increase (total-cost) 2)
      (has-value smoothness_worst low))
  )

  (:action measure_smoothness_worst_medium
    :parameters ()
    :precondition (not (test-performed smoothness_worst))
    :effect (and
      (test-performed smoothness_worst)
      (increase (total-cost) 2)
      (has-value smoothness_worst medium))
  )

  (:action measure_smoothness_worst_high
    :parameters ()
    :precondition (not (test-performed smoothness_worst))
    :effect (and
      (test-performed smoothness_worst)
      (increase (total-cost) 2)
      (has-value smoothness_worst high))
  )

  ;; =============== compactness_worst ===============
  (:action measure_compactness_worst_low
    :parameters ()
    :precondition (not (test-performed compactness_worst))
    :effect (and
      (test-performed compactness_worst)
      (increase (total-cost) 3)
      (has-value compactness_worst low))
  )

  (:action measure_compactness_worst_medium
    :parameters ()
    :precondition (not (test-performed compactness_worst))
    :effect (and
      (test-performed compactness_worst)
      (increase (total-cost) 3)
      (has-value compactness_worst medium))
  )

  (:action measure_compactness_worst_high
    :parameters ()
    :precondition (not (test-performed compactness_worst))
    :effect (and
      (test-performed compactness_worst)
      (increase (total-cost) 3)
      (has-value compactness_worst high))
  )

  ;; =============== concavity_worst ===============
  (:action measure_concavity_worst_low
    :parameters ()
    :precondition (not (test-performed concavity_worst))
    :effect (and
      (test-performed concavity_worst)
      (increase (total-cost) 3)
      (has-value concavity_worst low))
  )

  (:action measure_concavity_worst_medium
    :parameters ()
    :precondition (not (test-performed concavity_worst))
    :effect (and
      (test-performed concavity_worst)
      (increase (total-cost) 3)
      (has-value concavity_worst medium))
  )

  (:action measure_concavity_worst_high
    :parameters ()
    :precondition (not (test-performed concavity_worst))
    :effect (and
      (test-performed concavity_worst)
      (increase (total-cost) 3)
      (has-value concavity_worst high))
  )

  ;; =============== concave_points_worst ===============
  (:action measure_concave_points_worst_low
    :parameters ()
    :precondition (not (test-performed concave_points_worst))
    :effect (and
      (test-performed concave_points_worst)
      (increase (total-cost) 3)
      (has-value concave_points_worst low))
  )

  (:action measure_concave_points_worst_medium
    :parameters ()
    :precondition (not (test-performed concave_points_worst))
    :effect (and
      (test-performed concave_points_worst)
      (increase (total-cost) 3)
      (has-value concave_points_worst medium))
  )

  (:action measure_concave_points_worst_high
    :parameters ()
    :precondition (not (test-performed concave_points_worst))
    :effect (and
      (test-performed concave_points_worst)
      (increase (total-cost) 3)
      (has-value concave_points_worst high))
  )

  ;; =============== symmetry_worst ===============
  (:action measure_symmetry_worst_low
    :parameters ()
    :precondition (not (test-performed symmetry_worst))
    :effect (and
      (test-performed symmetry_worst)
      (increase (total-cost) 2)
      (has-value symmetry_worst low))
  )

  (:action measure_symmetry_worst_medium
    :parameters ()
    :precondition (not (test-performed symmetry_worst))
    :effect (and
      (test-performed symmetry_worst)
      (increase (total-cost) 2)
      (has-value symmetry_worst medium))
  )

  (:action measure_symmetry_worst_high
    :parameters ()
    :precondition (not (test-performed symmetry_worst))
    :effect (and
      (test-performed symmetry_worst)
      (increase (total-cost) 2)
      (has-value symmetry_worst high))
  )

  ;; =============== fractal_dimension_worst ===============
  (:action measure_fractal_dimension_worst_low
    :parameters ()
    :precondition (not (test-performed fractal_dimension_worst))
    :effect (and
      (test-performed fractal_dimension_worst)
      (increase (total-cost) 2)
      (has-value fractal_dimension_worst low))
  )

  (:action measure_fractal_dimension_worst_medium
    :parameters ()
    :precondition (not (test-performed fractal_dimension_worst))
    :effect (and
      (test-performed fractal_dimension_worst)
      (increase (total-cost) 2)
      (has-value fractal_dimension_worst medium))
  )

  (:action measure_fractal_dimension_worst_high
    :parameters ()
    :precondition (not (test-performed fractal_dimension_worst))
    :effect (and
      (test-performed fractal_dimension_worst)
      (increase (total-cost) 2)
      (has-value fractal_dimension_worst high))
  )

  ;; ------------------------------------------------
  ;; DIAGNOSIS ACTIONS (SIMPLE EXAMPLE)
  ;; ------------------------------------------------

  (:action diagnose_malignant
    :parameters ()
    :precondition (and
      (not (diagnosed malignant))
      (or (and (has-value radius_mean high)
               (has-value texture_mean high))
          (and (has-value perimeter_mean high)
               (has-value compactness_mean high))
          (and (has-value concavity_mean high)
               (has-value concave_points_mean high))))
    :effect (diagnosed malignant)
  )

  (:action diagnose_benign
    :parameters ()
    :precondition (and
      (not (diagnosed benign))
      (or (and (has-value radius_mean low)
               (has-value texture_mean low))
          (and (has-value symmetry_mean low)
               (has-value fractal_dimension_mean low))))
    :effect (diagnosed benign)
  )
)
