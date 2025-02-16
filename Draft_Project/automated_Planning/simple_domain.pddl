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

(:predicates 
    (has-value ?m -measurement ?v -value)
    (test-performed ?m -measurement)
    (diagnosed ?d -value)

    (typeA ?m - measurement)
    (typeB ?m - measurement)
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