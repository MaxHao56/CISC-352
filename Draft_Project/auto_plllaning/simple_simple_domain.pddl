(define (domain CancerCheck_B)

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
    - measurement

    low
    medium
    high
    malignant
    benign
    uncertain
    - value
  )

  (:predicates
    (has-value ?m - measurement ?v - value)
    (test-performed ?m - measurement)
    (diagnosed ?d - value)
  )

  (:functions
    (total-cost)
  )

  ;; RADIUS TEST ACTION
  (:action radius
    :parameters ()
    :precondition (and
      (not (test-performed radius_mean))
      (not (test-performed radius_se))
      (not (test-performed radius_worst))
    )
    :effect (and
      (test-performed radius_mean)
      (test-performed radius_se)
      (test-performed radius_worst)

      (when (has-value radius_mean high)   (increase (total-cost) 3))
      (when (has-value radius_mean medium) (increase (total-cost) 2))
      (when (has-value radius_mean low)    (increase (total-cost) 1))

      (when (has-value radius_se high)   (increase (total-cost) 3))
      (when (has-value radius_se medium) (increase (total-cost) 2))
      (when (has-value radius_se low)    (increase (total-cost) 1))

      (when (has-value radius_worst high)   (increase (total-cost) 3))
      (when (has-value radius_worst medium) (increase (total-cost) 2))
      (when (has-value radius_worst low)    (increase (total-cost) 1))
    )
  )

  ;; AREA TEST ACTION
  (:action area
    :parameters ()
    :precondition (and
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

      (when (has-value area_mean high)   (increase (total-cost) 3))
      (when (has-value area_mean medium) (increase (total-cost) 2))
      (when (has-value area_mean low)    (increase (total-cost) 1))

      (when (has-value area_se high)   (increase (total-cost) 3))
      (when (has-value area_se medium) (increase (total-cost) 2))
      (when (has-value area_se low)    (increase (total-cost) 1))

      (when (has-value area_worst high)   (increase (total-cost) 3))
      (when (has-value area_worst medium) (increase (total-cost) 2))
      (when (has-value area_worst low)    (increase (total-cost) 1))
    )
  )

  ;; PERIMETER TEST ACTION
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

      (when (has-value perimeter_mean high)   (increase (total-cost) 3))
      (when (has-value perimeter_mean medium) (increase (total-cost) 2))
      (when (has-value perimeter_mean low)    (increase (total-cost) 1))

      (when (has-value perimeter_se high)   (increase (total-cost) 3))
      (when (has-value perimeter_se medium) (increase (total-cost) 2))
      (when (has-value perimeter_se low)    (increase (total-cost) 1))

      (when (has-value perimeter_worst high)   (increase (total-cost) 3))
      (when (has-value perimeter_worst medium) (increase (total-cost) 2))
      (when (has-value perimeter_worst low)    (increase (total-cost) 1))
    )
  )

  ;; DIAGNOSIS ACTION
  (:action diagnose
    :parameters ()
    :precondition (and
      (test-performed radius_mean)
      (test-performed radius_se)
      (test-performed radius_worst)
      (test-performed area_mean)
      (test-performed area_se)
      (test-performed area_worst)
      (test-performed perimeter_mean)
      (test-performed perimeter_se)
      (test-performed perimeter_worst)
      (not (diagnosed malignant))
      (not (diagnosed benign))
      (not (diagnosed uncertain))
    )
    :effect (and
      (when (or 
        (and (has-value radius_mean high) (has-value radius_se medium))
        (and (has-value perimeter_mean low) (has-value perimeter_worst high))
        (>= (total-cost) 21))
        (diagnosed malignant))

      (when (or 
        (and (has-value radius_mean low) (has-value radius_se high))
        (and (has-value perimeter_mean low) (has-value perimeter_worst low))
        (<= (total-cost) 15))
        (diagnosed benign))

      (when (and (> (total-cost) 15) (< (total-cost) 21))
        (diagnosed uncertain))

      ;; Ensure at least one diagnosis is made
      (when (and (not (diagnosed malignant)) (not (diagnosed benign)) (not (diagnosed uncertain)))
        (diagnosed uncertain))
    )
  )
)