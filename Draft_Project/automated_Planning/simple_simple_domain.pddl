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
