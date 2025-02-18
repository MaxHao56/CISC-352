(define (domain CancerCheck)

  (:requirements
    :strips
    :fluents
    :conditional-effects
    :negative-preconditions
    :typing
    :equality
    :action-costs
    :disjunctive-preconditions
  )

  (:types 
    measurement
    value
  )

  ;; --------------------------------------------------
  ;; Declare measurement constants & possible value types
  ;; --------------------------------------------------
  (:constants
    radius_mean
    radius_se
    radius_worst

    area_mean
    area_se
    area_worst

    perimeter_mean
    perimeter_se
    perimeter_worst

    compactness_mean
    compactness_se
    compactness_worst

    fractal_dimension_mean
    fractal_dimension_se
    fractal_dimension_worst

    concavity_mean
    concavity_se
    concavity_worst

    concave_points_mean
    concave_points_se
    concave_points_worst

    texture_mean
    texture_se
    texture_worst

    symmetry_mean
    symmetry_se
    symmetry_worst

    smoothness_mean
    smoothness_se
    smoothness_worst

    - measurement

    low
    medium
    high
    malignant
    benign
    - value
  )

  ;; --------------------------------------------------
  ;; Predicates & function
  ;; --------------------------------------------------
  (:predicates
    (has-value ?m - measurement ?v - value)
    (test-performed ?m - measurement)
    (diagnosed ?d - value)
  )

  (:functions
    (total-cost)
  )

  ;; ==================================================
  ;; BATCH ACTIONS
  ;; Each action "performs tests" on a group of measurements
  ;; and applies a cost based on (has-value ?m ?v).
  ;; ==================================================

  ;;----------------------------
  ;; 1) RADIUS
  ;;----------------------------
  (:action radius
    :parameters ()
    :precondition (and
      (not (test-performed radius_mean))
      (not (test-performed radius_se))
      (not (test-performed radius_worst))
    )
    :effect (and
      ;; Mark them as tested
      (test-performed radius_mean)
      (test-performed radius_se)
      (test-performed radius_worst)

      ;; Conditional cost for radius_mean
      (when (has-value radius_mean high)   (increase (total-cost) 3))
      (when (has-value radius_mean medium) (increase (total-cost) 2))
      (when (has-value radius_mean low)    (increase (total-cost) 1))

      ;; Conditional cost for radius_se
      (when (has-value radius_se high)   (increase (total-cost) 3))
      (when (has-value radius_se medium) (increase (total-cost) 2))
      (when (has-value radius_se low)    (increase (total-cost) 1))

      ;; Conditional cost for radius_worst
      (when (has-value radius_worst high)   (increase (total-cost) 3))
      (when (has-value radius_worst medium) (increase (total-cost) 2))
      (when (has-value radius_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 2) AREA (depends on RADIUS)
  ;;----------------------------
  (:action area
    :parameters ()
    :precondition (and
      ;; We require that radius tests have been performed
      (test-performed radius_mean)
      (test-performed radius_se)
      (test-performed radius_worst)

      (not (test-performed area_mean))
      (not (test-performed area_se))
      (not (test-performed area_worst))
    )
    :effect (and
      (test-performed area_mean)
      (test-performed area_se)
      (test-performed area_worst)

      ;; area_mean
      (when (has-value area_mean high)   (increase (total-cost) 3))
      (when (has-value area_mean medium) (increase (total-cost) 2))
      (when (has-value area_mean low)    (increase (total-cost) 1))

      ;; area_se
      (when (has-value area_se high)   (increase (total-cost) 3))
      (when (has-value area_se medium) (increase (total-cost) 2))
      (when (has-value area_se low)    (increase (total-cost) 1))

      ;; area_worst
      (when (has-value area_worst high)   (increase (total-cost) 3))
      (when (has-value area_worst medium) (increase (total-cost) 2))
      (when (has-value area_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 3) PERIMETER (depends on RADIUS)
  ;;----------------------------
  (:action perimeter
    :parameters ()
    :precondition (and
      (test-performed radius_mean)
      (test-performed radius_se)
      (test-performed radius_worst)

      (not (test-performed perimeter_mean))
      (not (test-performed perimeter_se))
      (not (test-performed perimeter_worst))
    )
    :effect (and
      (test-performed perimeter_mean)
      (test-performed perimeter_se)
      (test-performed perimeter_worst)

      ;; perimeter_mean
      (when (has-value perimeter_mean high)   (increase (total-cost) 3))
      (when (has-value perimeter_mean medium) (increase (total-cost) 2))
      (when (has-value perimeter_mean low)    (increase (total-cost) 1))

      ;; perimeter_se
      (when (has-value perimeter_se high)   (increase (total-cost) 3))
      (when (has-value perimeter_se medium) (increase (total-cost) 2))
      (when (has-value perimeter_se low)    (increase (total-cost) 1))

      ;; perimeter_worst
      (when (has-value perimeter_worst high)   (increase (total-cost) 3))
      (when (has-value perimeter_worst medium) (increase (total-cost) 2))
      (when (has-value perimeter_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 4) COMPACTNESS (depends on AREA + PERIMETER)
  ;;----------------------------
  (:action compactness
    :parameters ()
    :precondition (and
      (test-performed area_mean)
      (test-performed area_se)
      (test-performed area_worst)

      (test-performed perimeter_mean)
      (test-performed perimeter_se)
      (test-performed perimeter_worst)

      (not (test-performed compactness_mean))
      (not (test-performed compactness_se))
      (not (test-performed compactness_worst))
    )
    :effect (and
      (test-performed compactness_mean)
      (test-performed compactness_se)
      (test-performed compactness_worst)

      ;; compactness_mean
      (when (has-value compactness_mean high)   (increase (total-cost) 3))
      (when (has-value compactness_mean medium) (increase (total-cost) 2))
      (when (has-value compactness_mean low)    (increase (total-cost) 1))

      ;; compactness_se
      (when (has-value compactness_se high)   (increase (total-cost) 3))
      (when (has-value compactness_se medium) (increase (total-cost) 2))
      (when (has-value compactness_se low)    (increase (total-cost) 1))

      ;; compactness_worst
      (when (has-value compactness_worst high)   (increase (total-cost) 3))
      (when (has-value compactness_worst medium) (increase (total-cost) 2))
      (when (has-value compactness_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 5) CONCAVE_POINTS (no explicit pre-req in DAG)
  ;;----------------------------
  (:action concave_points
    :parameters ()
    :precondition (and
      (not (test-performed concave_points_mean))
      (not (test-performed concave_points_se))
      (not (test-performed concave_points_worst))
    )
    :effect (and
      (test-performed concave_points_mean)
      (test-performed concave_points_se)
      (test-performed concave_points_worst)

      ;; concave_points_mean
      (when (has-value concave_points_mean high)   (increase (total-cost) 3))
      (when (has-value concave_points_mean medium) (increase (total-cost) 2))
      (when (has-value concave_points_mean low)    (increase (total-cost) 1))

      ;; concave_points_se
      (when (has-value concave_points_se high)   (increase (total-cost) 3))
      (when (has-value concave_points_se medium) (increase (total-cost) 2))
      (when (has-value concave_points_se low)    (increase (total-cost) 1))

      ;; concave_points_worst
      (when (has-value concave_points_worst high)   (increase (total-cost) 3))
      (when (has-value concave_points_worst medium) (increase (total-cost) 2))
      (when (has-value concave_points_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 6) CONCAVITY (depends on CONCAVE_POINTS)
  ;;----------------------------
  (:action concavity
    :parameters ()
    :precondition (and
      (test-performed concave_points_mean)
      (test-performed concave_points_se)
      (test-performed concave_points_worst)

      (not (test-performed concavity_mean))
      (not (test-performed concavity_se))
      (not (test-performed concavity_worst))
    )
    :effect (and
      (test-performed concavity_mean)
      (test-performed concavity_se)
      (test-performed concavity_worst)

      ;; concavity_mean
      (when (has-value concavity_mean high)   (increase (total-cost) 3))
      (when (has-value concavity_mean medium) (increase (total-cost) 2))
      (when (has-value concavity_mean low)    (increase (total-cost) 1))

      ;; concavity_se
      (when (has-value concavity_se high)   (increase (total-cost) 3))
      (when (has-value concavity_se medium) (increase (total-cost) 2))
      (when (has-value concavity_se low)    (increase (total-cost) 1))

      ;; concavity_worst
      (when (has-value concavity_worst high)   (increase (total-cost) 3))
      (when (has-value concavity_worst medium) (increase (total-cost) 2))
      (when (has-value concavity_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 7) FRACTAL_DIMENSION (depends on COMPACTNESS + CONCAVITY)
  ;;----------------------------
  (:action fractal_dimension
    :parameters ()
    :precondition (and
      (test-performed compactness_mean)
      (test-performed compactness_se)
      (test-performed compactness_worst)

      (test-performed concavity_mean)
      (test-performed concavity_se)
      (test-performed concavity_worst)

      (not (test-performed fractal_dimension_mean))
      (not (test-performed fractal_dimension_se))
      (not (test-performed fractal_dimension_worst))
    )
    :effect (and
      (test-performed fractal_dimension_mean)
      (test-performed fractal_dimension_se)
      (test-performed fractal_dimension_worst)

      ;; fractal_dimension_mean
      (when (has-value fractal_dimension_mean high)   (increase (total-cost) 3))
      (when (has-value fractal_dimension_mean medium) (increase (total-cost) 2))
      (when (has-value fractal_dimension_mean low)    (increase (total-cost) 1))

      ;; fractal_dimension_se
      (when (has-value fractal_dimension_se high)   (increase (total-cost) 3))
      (when (has-value fractal_dimension_se medium) (increase (total-cost) 2))
      (when (has-value fractal_dimension_se low)    (increase (total-cost) 1))

      ;; fractal_dimension_worst
      (when (has-value fractal_dimension_worst high)   (increase (total-cost) 3))
      (when (has-value fractal_dimension_worst medium) (increase (total-cost) 2))
      (when (has-value fractal_dimension_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 8) TEXTURE (no explicit pre-req in DAG)
  ;;----------------------------
  (:action texture
    :parameters ()
    :precondition (and
      (not (test-performed texture_mean))
      (not (test-performed texture_se))
      (not (test-performed texture_worst))
    )
    :effect (and
      (test-performed texture_mean)
      (test-performed texture_se)
      (test-performed texture_worst)

      ;; texture_mean
      (when (has-value texture_mean high)   (increase (total-cost) 3))
      (when (has-value texture_mean medium) (increase (total-cost) 2))
      (when (has-value texture_mean low)    (increase (total-cost) 1))

      ;; texture_se
      (when (has-value texture_se high)   (increase (total-cost) 3))
      (when (has-value texture_se medium) (increase (total-cost) 2))
      (when (has-value texture_se low)    (increase (total-cost) 1))

      ;; texture_worst
      (when (has-value texture_worst high)   (increase (total-cost) 3))
      (when (has-value texture_worst medium) (increase (total-cost) 2))
      (when (has-value texture_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 9) SYMMETRY (no explicit pre-req in DAG)
  ;;----------------------------
  (:action symmetry
    :parameters ()
    :precondition (and
      (not (test-performed symmetry_mean))
      (not (test-performed symmetry_se))
      (not (test-performed symmetry_worst))
    )
    :effect (and
      (test-performed symmetry_mean)
      (test-performed symmetry_se)
      (test-performed symmetry_worst)

      ;; symmetry_mean
      (when (has-value symmetry_mean high)   (increase (total-cost) 3))
      (when (has-value symmetry_mean medium) (increase (total-cost) 2))
      (when (has-value symmetry_mean low)    (increase (total-cost) 1))

      ;; symmetry_se
      (when (has-value symmetry_se high)   (increase (total-cost) 3))
      (when (has-value symmetry_se medium) (increase (total-cost) 2))
      (when (has-value symmetry_se low)    (increase (total-cost) 1))

      ;; symmetry_worst
      (when (has-value symmetry_worst high)   (increase (total-cost) 3))
      (when (has-value symmetry_worst medium) (increase (total-cost) 2))
      (when (has-value symmetry_worst low)    (increase (total-cost) 1))
    )
  )

  ;;----------------------------
  ;; 10) SMOOTHNESS (no explicit pre-req in DAG)
  ;;----------------------------
  (:action smoothness
    :parameters ()
    :precondition (and
      (not (test-performed smoothness_mean))
      (not (test-performed smoothness_se))
      (not (test-performed smoothness_worst))
    )
    :effect (and
      (test-performed smoothness_mean)
      (test-performed smoothness_se)
      (test-performed smoothness_worst)

      ;; smoothness_mean
      (when (has-value smoothness_mean high)   (increase (total-cost) 3))
      (when (has-value smoothness_mean medium) (increase (total-cost) 2))
      (when (has-value smoothness_mean low)    (increase (total-cost) 1))

      ;; smoothness_se
      (when (has-value smoothness_se high)   (increase (total-cost) 3))
      (when (has-value smoothness_se medium) (increase (total-cost) 2))
      (when (has-value smoothness_se low)    (increase (total-cost) 1))

      ;; smoothness_worst
      (when (has-value smoothness_worst high)   (increase (total-cost) 3))
      (when (has-value smoothness_worst medium) (increase (total-cost) 2))
      (when (has-value smoothness_worst low)    (increase (total-cost) 1))
    )
  )


  ;; ==================================================
  ;; FINAL DIAGNOSIS ACTION
  ;; Based on certain "has-value" combos,
  ;; we label the tumor malignant or benign.
  ;; ==================================================
  (:action diagnose
    :parameters ()
    :precondition (and
      (not (diagnosed malignant))
      (not (diagnosed benign))
    )
    :effect (and
      ;; If certain features are high => malignant
      (when (or (and (has-value radius_mean high)
                     (has-value texture_mean high))
                (and (has-value perimeter_mean high)
                     (has-value compactness_mean high)))
        (diagnosed malignant))

      ;; If certain features are low => benign
      (when (or (and (has-value radius_mean low)
                     (has-value texture_mean low))
                (and (has-value perimeter_mean low)
                     (has-value compactness_mean low)))
        (diagnosed benign))
    )
  )
)
