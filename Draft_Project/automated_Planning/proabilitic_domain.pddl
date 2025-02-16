(define (domain breast-cancer-diagnosis)
  (:requirements :strips :typing :negative-preconditions :numeric-fluents :conditional-effects :action-costs)
  
  (:types 
    measurement value
  )
  
  (:predicates
    (has-value ?m - measurement ?v - value)
    (test-performed ?m - measurement)
    (diagnosed ?d - value)
  )
  
  (:functions
    (total-cost)
  )
  
  ;; ==========================
  ;; MEDICAL TESTS (ACTIONS)
  ;; ==========================
  
;   (:action measure_radius_mean
;     :precondition (not (test-performed radius_mean))
;     :effect (and 
;       (test-performed radius_mean)
;       (increase (total-cost) 2)
;       (oneof (has-value radius_mean low)
;              (has-value radius_mean medium)
;              (has-value radius_mean high))
;     ;   (has-value radius_mean low) (has-value radius_mean medium) (has-value radius_mean high)
;     ; the conversion happens since this doesn't suppport more than one value to it so that I could only have one option instead
;     )
;   )
(:action measure_radius_mean_low
  :precondition (and (not (test-performed radius_mean)))
  :effect (and 
    (test-performed radius_mean)
    (increase (total-cost) 2)
    (has-value radius_mean low)
  )
)

(:action measure_radius_mean_medium
  :precondition (not (test-performed radius_mean))
  :effect (and 
    (test-performed radius_mean)
    (increase (total-cost) 2)
    (has-value radius_mean medium)
  )
)

(:action measure_radius_mean_high
  :precondition (not (test-performed radius_mean))
  :effect (and 
    (test-performed radius_mean)
    (increase (total-cost) 2)
    (has-value radius_mean high)
  )
)

  (:action measure_texture_mean
    :precondition (not (test-performed texture_mean))
    :effect (and 
      (test-performed texture_mean)
      (increase (total-cost) 2)
    ;   (has-value texture_mean low) (has-value texture_mean medium) (has-value texture_mean high)
    (oneof (has-value radius_mean low)
             (has-value radius_mean medium)
             (has-value radius_mean high))
    )
  )

  (:action measure_perimeter_mean
    :precondition (not (test-performed perimeter_mean))
    :effect (and 
      (test-performed perimeter_mean)
      (increase (total-cost) 3)
    ;   (has-value perimeter_mean low) (has-value perimeter_mean medium) (has-value perimeter_mean high)
    (oneof (has-value perimeter_mean low)
             (has-value perimeter_mean medium)
             (has-value perimeter_mean high))
    )
  )

  (:action measure_area_mean
    :precondition (not (test-performed area_mean))
    :effect (and 
      (test-performed area_mean)
      (increase (total-cost) 3)
    ;   (has-value area_mean low) (has-value area_mean medium) (has-value area_mean high)
    (oneof (has-value area_mean low)
             (has-value area_mean medium)
             (has-value area_mean high))
    )
  )

  (:action measure_smoothness_mean
    :precondition (not (test-performed smoothness_mean))
    :effect (and 
      (test-performed smoothness_mean)
      (increase (total-cost) 2)
    ;   (has-value smoothness_mean low) (has-value smoothness_mean medium) (has-value smoothness_mean high)
    (oneof (has-value smoothness_mean low)
             (has-value smoothness_mean medium)
             (has-value smoothness_mean high))
    )
  )

  (:action measure_compactness_mean
    :precondition (not (test-performed compactness_mean))
    :effect (and 
      (test-performed compactness_mean)
      (increase (total-cost) 3)
    ;   (has-value compactness_mean low) (has-value compactness_mean medium) (has-value compactness_mean high)
    (oneof (has-value compactness_mean low)
             (has-value compactness_mean medium)
             (has-value compactness_mean high))
    )
  )

  (:action measure_concavity_mean
    :precondition (not (test-performed concavity_mean))
    :effect (and 
      (test-performed concavity_mean)
      (increase (total-cost) 3)
    ;   (has-value concavity_mean low) (has-value concavity_mean medium) (has-value concavity_mean high)
    (oneof (has-value concavity_mean low)
             (has-value concavity_mean medium)
             (has-value concavity_mean high))
    )
  )

  (:action measure_concave_points_mean
    :precondition (not (test-performed concave_points_mean))
    :effect (and 
      (test-performed concave_points_mean)
      (increase (total-cost) 3)
      (oneof (has-value concave_points_mean low)
             (has-value concave_points_mean medium)
             (has-value concave_points_mean high))
    ;   (has-value concave_points_mean low) (has-value concave_points_mean medium) (has-value concave_points_mean high)
    )
  )

  (:action measure_symmetry_mean
    :precondition (not (test-performed symmetry_mean))
    :effect (and 
      (test-performed symmetry_mean)
      (increase (total-cost) 2)
      (oneof (has-value symmetry_mean low)
             (has-value symmetry_mean medium)
             (has-value symmetry_mean high))
    ;   (has-value symmetry_mean low) (has-value symmetry_mean medium) (has-value symmetry_mean high)
    )
  )

  (:action measure_fractal_dimension_mean
    :precondition (not (test-performed fractal_dimension_mean))
    :effect (and 
      (test-performed fractal_dimension_mean)
      (increase (total-cost) 2)
      (oneof (has-value fractal_dimension_mean low)
             (has-value fractal_dimension_mean medium)
             (has-value fractal_dimension_mean high))
    ;   (has-value fractal_dimension_mean low) (has-value fractal_dimension_mean medium) (has-value fractal_dimension_mean high)
    )
  )

  ;; ==========================
  ;; DIAGNOSIS DETERMINATION
  ;; ==========================
  
  (:action diagnose_malignant
    :precondition (and (not (diagnosed malignant))
                       (or (and (has-value radius_mean high) (has-value texture_mean high))
                           (and (has-value perimeter_mean high) (has-value compactness_mean high))
                           (and (has-value concavity_mean high) (has-value concave_points_mean high))))
    :effect (and (diagnosed malignant))
  )

  (:action diagnose_benign
    :precondition (and (not (diagnosed benign))
                       (or (and (has-value radius_mean low) (has-value texture_mean low))
                           (and (has-value symmetry_mean low) (has-value fractal_dimension_mean low))))
    :effect (and (diagnosed benign))
  )

)
