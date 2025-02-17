;Header and description

(define (domain CancerCheck)

;remove requirements that are not needed
(:requirements 
    :strips 
    :fluents 
    :durative-actions 
    :timed-initial-literals 
    :typing 
    :conditional-effects 
    :negative-preconditions 
    :duration-inequalities 
    :equality 
    :action-costs
    :disjunctive-preconditions
)

(:types 
    measurement
    value
)

(:constants 
    perimeter_mean
    symmetry_mean
    radius_mean
    compactness_mean
    texture_mean
    - measurement


    low
    medium
    high
    malignant
    benign
    - value
)

    ; ; Mean measurements (10)
    ; radius_mean texture_mean perimeter_mean area_mean 
    ; smoothness_mean compactness_mean concavity_mean concave_points_mean 
    ; symmetry_mean fractal_dimension_mean
    
    ; ; SE measurements (10)
    ; radius_se texture_se perimeter_se area_se 
    ; smoothness_se compactness_se concavity_se concave_points_se 
    ; symmetry_se fractal_dimension_se
    
    ; ; Worst measurements (10)
    ; radius_worst texture_worst perimeter_worst area_worst 
    ; smoothness_worst compactness_worst concavity_worst concave_points_worst 
    ; symmetry_worst fractal_dimension_worst
    ; - measurement

    ; low medium high malignant benign - value

(:predicates 
    (has-value ?m -measurement ?v -value)
    (test-performed ?m -measurement)
    (diagnosed ?d -value)

    (typeA ?m - measurement)
    (typeB ?m - measurement)

    ; (has-value ?m - measurement ?v - value)
    ; (test-performed ?m - measurement)
    ; (diagnosed ?d - value)
)





(:functions 
    (total-cost)
)

(:action measure
    :parameters ( ?m - measurement ?v - value)
    :precondition (and (not (test-performed ?m)))
    :effect (and

      (test-performed ?m)

      (has-value ?m ?v)

    
      (when (typeA ?m)
        (increase (total-cost) 2))


      (when (typeB ?m)
        (increase (total-cost) 3))
    )
)

  (:action diagnose
    :parameters ()
    :precondition 
      (and (not (diagnosed malignant))
           (not (diagnosed benign)))
    :effect (and
      ;; If we see certain features are high, we say malignant
      (when (or (and (has-value radius_mean high)
                     (has-value texture_mean high))
                (and (has-value perimeter_mean high)
                     (has-value compactness_mean high)))
        (diagnosed malignant))

      ;; If we see certain features are low, we say benign
      (when (or (and (has-value radius_mean low)
                     (has-value texture_mean low))
                (and (has-value perimeter_mean low)
                     (has-value compactness_mean low)))
        (diagnosed benign))
    )
  )

)