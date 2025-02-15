(define (domain breast-cancer-diagnosis)
  (:requirements :strips :typing :negative-preconditions :numeric-fluents :probabilistic-effects)
  (:types 
    measurement value
  )
  
  (:predicates
    (has-value ?m - measurement ?v - value)
  )
  
  (:functions
    (total-cost)
  )
  
  ;; Each measurement action checks that the given test has not yet been performed
  ;; and nondeterministically assigns it one of the values low, medium, or high.
  ;; The cost of the test is added via (increase (total-cost) cost).
  
  (:action measure_radius_mean
    :precondition (has-value radius_mean unknown)
    :effect (oneof
             (and (not (has-value radius_mean unknown))
                  (has-value radius_mean low)
                  (increase (total-cost) 2))
             (and (not (has-value radius_mean unknown))
                  (has-value radius_mean medium)
                  (increase (total-cost) 2))
             (and (not (has-value radius_mean unknown))
                  (has-value radius_mean high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_texture_mean
    :precondition (has-value texture_mean unknown)
    :effect (oneof
             (and (not (has-value texture_mean unknown))
                  (has-value texture_mean low)
                  (increase (total-cost) 2))
             (and (not (has-value texture_mean unknown))
                  (has-value texture_mean medium)
                  (increase (total-cost) 2))
             (and (not (has-value texture_mean unknown))
                  (has-value texture_mean high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_perimeter_mean
    :precondition (has-value perimeter_mean unknown)
    :effect (oneof
             (and (not (has-value perimeter_mean unknown))
                  (has-value perimeter_mean low)
                  (increase (total-cost) 3))
             (and (not (has-value perimeter_mean unknown))
                  (has-value perimeter_mean medium)
                  (increase (total-cost) 3))
             (and (not (has-value perimeter_mean unknown))
                  (has-value perimeter_mean high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_area_mean
    :precondition (has-value area_mean unknown)
    :effect (oneof
             (and (not (has-value area_mean unknown))
                  (has-value area_mean low)
                  (increase (total-cost) 3))
             (and (not (has-value area_mean unknown))
                  (has-value area_mean medium)
                  (increase (total-cost) 3))
             (and (not (has-value area_mean unknown))
                  (has-value area_mean high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_smoothness_mean
    :precondition (has-value smoothness_mean unknown)
    :effect (oneof
             (and (not (has-value smoothness_mean unknown))
                  (has-value smoothness_mean low)
                  (increase (total-cost) 2))
             (and (not (has-value smoothness_mean unknown))
                  (has-value smoothness_mean medium)
                  (increase (total-cost) 2))
             (and (not (has-value smoothness_mean unknown))
                  (has-value smoothness_mean high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_compactness_mean
    :precondition (has-value compactness_mean unknown)
    :effect (oneof
             (and (not (has-value compactness_mean unknown))
                  (has-value compactness_mean low)
                  (increase (total-cost) 3))
             (and (not (has-value compactness_mean unknown))
                  (has-value compactness_mean medium)
                  (increase (total-cost) 3))
             (and (not (has-value compactness_mean unknown))
                  (has-value compactness_mean high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_concavity_mean
    :precondition (has-value concavity_mean unknown)
    :effect (oneof
             (and (not (has-value concavity_mean unknown))
                  (has-value concavity_mean low)
                  (increase (total-cost) 3))
             (and (not (has-value concavity_mean unknown))
                  (has-value concavity_mean medium)
                  (increase (total-cost) 3))
             (and (not (has-value concavity_mean unknown))
                  (has-value concavity_mean high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_concave_points_mean
    :precondition (has-value concave_points_mean unknown)
    :effect (oneof
             (and (not (has-value concave_points_mean unknown))
                  (has-value concave_points_mean low)
                  (increase (total-cost) 3))
             (and (not (has-value concave_points_mean unknown))
                  (has-value concave_points_mean medium)
                  (increase (total-cost) 3))
             (and (not (has-value concave_points_mean unknown))
                  (has-value concave_points_mean high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_symmetry_mean
    :precondition (has-value symmetry_mean unknown)
    :effect (oneof
             (and (not (has-value symmetry_mean unknown))
                  (has-value symmetry_mean low)
                  (increase (total-cost) 2))
             (and (not (has-value symmetry_mean unknown))
                  (has-value symmetry_mean medium)
                  (increase (total-cost) 2))
             (and (not (has-value symmetry_mean unknown))
                  (has-value symmetry_mean high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_fractal_dimension_mean
    :precondition (has-value fractal_dimension_mean unknown)
    :effect (oneof
             (and (not (has-value fractal_dimension_mean unknown))
                  (has-value fractal_dimension_mean low)
                  (increase (total-cost) 2))
             (and (not (has-value fractal_dimension_mean unknown))
                  (has-value fractal_dimension_mean medium)
                  (increase (total-cost) 2))
             (and (not (has-value fractal_dimension_mean unknown))
                  (has-value fractal_dimension_mean high)
                  (increase (total-cost) 2))
            )
  )
  
  ;; -- Second Set: Standard Error (se) Measurements --
  
  (:action measure_radius_se
    :precondition (has-value radius_se unknown)
    :effect (oneof
             (and (not (has-value radius_se unknown))
                  (has-value radius_se low)
                  (increase (total-cost) 2))
             (and (not (has-value radius_se unknown))
                  (has-value radius_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value radius_se unknown))
                  (has-value radius_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_texture_se
    :precondition (has-value texture_se unknown)
    :effect (oneof
             (and (not (has-value texture_se unknown))
                  (has-value texture_se low)
                  (increase (total-cost) 2))
             (and (not (has-value texture_se unknown))
                  (has-value texture_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value texture_se unknown))
                  (has-value texture_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_perimeter_se
    :precondition (has-value perimeter_se unknown)
    :effect (oneof
             (and (not (has-value perimeter_se unknown))
                  (has-value perimeter_se low)
                  (increase (total-cost) 3))
             (and (not (has-value perimeter_se unknown))
                  (has-value perimeter_se medium)
                  (increase (total-cost) 3))
             (and (not (has-value perimeter_se unknown))
                  (has-value perimeter_se high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_area_se
    :precondition (has-value area_se unknown)
    :effect (oneof
             (and (not (has-value area_se unknown))
                  (has-value area_se low)
                  (increase (total-cost) 3))
             (and (not (has-value area_se unknown))
                  (has-value area_se medium)
                  (increase (total-cost) 3))
             (and (not (has-value area_se unknown))
                  (has-value area_se high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_smoothness_se
    :precondition (has-value smoothness_se unknown)
    :effect (oneof
             (and (not (has-value smoothness_se unknown))
                  (has-value smoothness_se low)
                  (increase (total-cost) 2))
             (and (not (has-value smoothness_se unknown))
                  (has-value smoothness_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value smoothness_se unknown))
                  (has-value smoothness_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_compactness_se
    :precondition (has-value compactness_se unknown)
    :effect (oneof
             (and (not (has-value compactness_se unknown))
                  (has-value compactness_se low)
                  (increase (total-cost) 2))
             (and (not (has-value compactness_se unknown))
                  (has-value compactness_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value compactness_se unknown))
                  (has-value compactness_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_concavity_se
    :precondition (has-value concavity_se unknown)
    :effect (oneof
             (and (not (has-value concavity_se unknown))
                  (has-value concavity_se low)
                  (increase (total-cost) 2))
             (and (not (has-value concavity_se unknown))
                  (has-value concavity_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value concavity_se unknown))
                  (has-value concavity_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_concave_points_se
    :precondition (has-value concave_points_se unknown)
    :effect (oneof
             (and (not (has-value concave_points_se unknown))
                  (has-value concave_points_se low)
                  (increase (total-cost) 2))
             (and (not (has-value concave_points_se unknown))
                  (has-value concave_points_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value concave_points_se unknown))
                  (has-value concave_points_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_symmetry_se
    :precondition (has-value symmetry_se unknown)
    :effect (oneof
             (and (not (has-value symmetry_se unknown))
                  (has-value symmetry_se low)
                  (increase (total-cost) 2))
             (and (not (has-value symmetry_se unknown))
                  (has-value symmetry_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value symmetry_se unknown))
                  (has-value symmetry_se high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_fractal_dimension_se
    :precondition (has-value fractal_dimension_se unknown)
    :effect (oneof
             (and (not (has-value fractal_dimension_se unknown))
                  (has-value fractal_dimension_se low)
                  (increase (total-cost) 2))
             (and (not (has-value fractal_dimension_se unknown))
                  (has-value fractal_dimension_se medium)
                  (increase (total-cost) 2))
             (and (not (has-value fractal_dimension_se unknown))
                  (has-value fractal_dimension_se high)
                  (increase (total-cost) 2))
            )
  )
  
  ;; -- Third Set: Worst Measurements --
  
  (:action measure_radius_worst
    :precondition (has-value radius_worst unknown)
    :effect (oneof
             (and (not (has-value radius_worst unknown))
                  (has-value radius_worst low)
                  (increase (total-cost) 2))
             (and (not (has-value radius_worst unknown))
                  (has-value radius_worst medium)
                  (increase (total-cost) 2))
             (and (not (has-value radius_worst unknown))
                  (has-value radius_worst high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_texture_worst
    :precondition (has-value texture_worst unknown)
    :effect (oneof
             (and (not (has-value texture_worst unknown))
                  (has-value texture_worst low)
                  (increase (total-cost) 2))
             (and (not (has-value texture_worst unknown))
                  (has-value texture_worst medium)
                  (increase (total-cost) 2))
             (and (not (has-value texture_worst unknown))
                  (has-value texture_worst high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_perimeter_worst
    :precondition (has-value perimeter_worst unknown)
    :effect (oneof
             (and (not (has-value perimeter_worst unknown))
                  (has-value perimeter_worst low)
                  (increase (total-cost) 3))
             (and (not (has-value perimeter_worst unknown))
                  (has-value perimeter_worst medium)
                  (increase (total-cost) 3))
             (and (not (has-value perimeter_worst unknown))
                  (has-value perimeter_worst high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_area_worst
    :precondition (has-value area_worst unknown)
    :effect (oneof
             (and (not (has-value area_worst unknown))
                  (has-value area_worst low)
                  (increase (total-cost) 3))
             (and (not (has-value area_worst unknown))
                  (has-value area_worst medium)
                  (increase (total-cost) 3))
             (and (not (has-value area_worst unknown))
                  (has-value area_worst high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_smoothness_worst
    :precondition (has-value smoothness_worst unknown)
    :effect (oneof
             (and (not (has-value smoothness_worst unknown))
                  (has-value smoothness_worst low)
                  (increase (total-cost) 2))
             (and (not (has-value smoothness_worst unknown))
                  (has-value smoothness_worst medium)
                  (increase (total-cost) 2))
             (and (not (has-value smoothness_worst unknown))
                  (has-value smoothness_worst high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_compactness_worst
    :precondition (has-value compactness_worst unknown)
    :effect (oneof
             (and (not (has-value compactness_worst unknown))
                  (has-value compactness_worst low)
                  (increase (total-cost) 3))
             (and (not (has-value compactness_worst unknown))
                  (has-value compactness_worst medium)
                  (increase (total-cost) 3))
             (and (not (has-value compactness_worst unknown))
                  (has-value compactness_worst high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_concavity_worst
    :precondition (has-value concavity_worst unknown)
    :effect (oneof
             (and (not (has-value concavity_worst unknown))
                  (has-value concavity_worst low)
                  (increase (total-cost) 3))
             (and (not (has-value concavity_worst unknown))
                  (has-value concavity_worst medium)
                  (increase (total-cost) 3))
             (and (not (has-value concavity_worst unknown))
                  (has-value concavity_worst high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_concave_points_worst
    :precondition (has-value concave_points_worst unknown)
    :effect (oneof
             (and (not (has-value concave_points_worst unknown))
                  (has-value concave_points_worst low)
                  (increase (total-cost) 3))
             (and (not (has-value concave_points_worst unknown))
                  (has-value concave_points_worst medium)
                  (increase (total-cost) 3))
             (and (not (has-value concave_points_worst unknown))
                  (has-value concave_points_worst high)
                  (increase (total-cost) 3))
            )
  )
  
  (:action measure_symmetry_worst
    :precondition (has-value symmetry_worst unknown)
    :effect (oneof
             (and (not (has-value symmetry_worst unknown))
                  (has-value symmetry_worst low)
                  (increase (total-cost) 2))
             (and (not (has-value symmetry_worst unknown))
                  (has-value symmetry_worst medium)
                  (increase (total-cost) 2))
             (and (not (has-value symmetry_worst unknown))
                  (has-value symmetry_worst high)
                  (increase (total-cost) 2))
            )
  )
  
  (:action measure_fractal_dimension_worst
    :precondition (has-value fractal_dimension_worst unknown)
    :effect (oneof
             (and (not (has-value fractal_dimension_worst unknown))
                  (has-value fractal_dimension_worst low)
                  (increase (total-cost) 2))
             (and (not (has-value fractal_dimension_worst unknown))
                  (has-value fractal_dimension_worst medium)
                  (increase (total-cost) 2))
             (and (not (has-value fractal_dimension_worst unknown))
                  (has-value fractal_dimension_worst high)
                  (increase (total-cost) 2))
            )
  )
  
  ;; -- Diagnosis Actions --
  ;; When enough information has been gathered, a diagnosis action can be applied.
  ;; Each action’s preconditions mirror one of the probabilistic rules.
  
  (:action diagnose_malignant
    :precondition (and (has-value diagnosis unknown)
                       (or (and (has-value radius_mean high) (has-value texture_mean high))
                           (and (has-value perimeter_mean high) (has-value compactness_mean high))
                           (and (has-value concavity_mean high) (has-value concave_points_mean high))))
    :effect (and (not (has-value diagnosis unknown))
                 (has-value diagnosis malignant))
  )
  
  (:action diagnose_benign
    :precondition (and (has-value diagnosis unknown)
                       (or (and (has-value radius_mean low) (has-value texture_mean low))
                           (and (has-value symmetry_mean low) (has-value fractal_dimension_mean low))))
    :effect (and (not (has-value diagnosis unknown))
                 (has-value diagnosis benign))
  )
)
