(define (domain CancerCheck_BNN_2)
  (:requirements
    :strips
    :typing
    :negative-preconditions
    :equality
    :action-costs
    :disjunctive-preconditions
    :conditional-effects
  )

  (:types 
    measurement
    value
  )

  (:constants
    ;; Measurements
    smoothness_mean smoothness_se smoothness_worst
    symmetry_mean symmetry_se symmetry_worst
    compactness_mean compactness_se compactness_worst


    radius_mean radius_se radius_worst 
    area_mean area_se area_worst 
    perimeter_mean perimeter_se perimeter_worst - measurement

    ;; Measurement quality values
    low medium high malignant benign uncertain - value
  )

  (:predicates
    (has-value ?m - measurement ?v - value)
    (test-performed ?m - measurement)
    (diagnosed)
    (weights-initialized)
  )

  (:functions
    (total-cost)
  )

;; --- INITIAL WEIGHT GENERATION ---
  (:action init-weights
    :parameters ()
    :precondition (not (weights-initialized))
    :effect (weights-initialized)
  )



;; --- Perimeter Actions (All 27 combinations) ---
  ;; Each perimeter action requires that none of the three perimeter tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (perimeter_mean high, perimeter_se high, perimeter_worst high)
  (:action perimeter_hhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, medium)
  (:action perimeter_hhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, low)
  (:action perimeter_hhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, high)
  (:action perimeter_hmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, medium)
  (:action perimeter_hmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, low)
  (:action perimeter_hml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, high)
  (:action perimeter_hlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, medium)
  (:action perimeter_hlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, low)
  (:action perimeter_hll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean high)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = medium combinations ---
  ;; (medium, high, high)
  (:action perimeter_mhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, medium)
  (:action perimeter_mhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, low)
  (:action perimeter_mhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, high)
  (:action perimeter_mmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, medium)
  (:action perimeter_mmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, low)
  (:action perimeter_mml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, high)
  (:action perimeter_mlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, medium)
  (:action perimeter_mlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, low)
  (:action perimeter_mll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean medium)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = low combinations ---
  ;; (low, high, high)
  (:action perimeter_lhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, medium)
  (:action perimeter_lhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, low)
  (:action perimeter_lhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se high)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, high)
  (:action perimeter_lmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, medium)
  (:action perimeter_lmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, low)
  (:action perimeter_lml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se medium)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, high)
  (:action perimeter_llh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst high))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, medium)
  (:action perimeter_llm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst medium))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, low)
  (:action perimeter_lll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed perimeter_mean))
                       (not (test-performed perimeter_se))
                       (not (test-performed perimeter_worst))
                       (has-value perimeter_mean low)
                       (has-value perimeter_se low)
                       (has-value perimeter_worst low))
    :effect (and
              (test-performed perimeter_mean)
              (test-performed perimeter_se)
              (test-performed perimeter_worst)
              (increase (total-cost) 3))
  )






;; --- smoothness Actions (All 27 combinations) ---
  ;; Each smoothness action requires that none of the three smoothness tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (smoothness_mean high, smoothness_se high, smoothness_worst high)
  (:action smoothness_hhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, medium)
  (:action smoothness_hhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, low)
  (:action smoothness_hhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, high)
  (:action smoothness_hmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, medium)
  (:action smoothness_hmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, low)
  (:action smoothness_hml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, high)
  (:action smoothness_hlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, medium)
  (:action smoothness_hlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, low)
  (:action smoothness_hll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean high)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = medium combinations ---
  ;; (medium, high, high)
  (:action smoothness_mhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, medium)
  (:action smoothness_mhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, low)
  (:action smoothness_mhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, high)
  (:action smoothness_mmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, medium)
  (:action smoothness_mmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, low)
  (:action smoothness_mml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, high)
  (:action smoothness_mlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, medium)
  (:action smoothness_mlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, low)
  (:action smoothness_mll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean medium)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = low combinations ---
  ;; (low, high, high)
  (:action smoothness_lhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, medium)
  (:action smoothness_lhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, low)
  (:action smoothness_lhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se high)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, high)
  (:action smoothness_lmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, medium)
  (:action smoothness_lmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, low)
  (:action smoothness_lml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se medium)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, high)
  (:action smoothness_llh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst high))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, medium)
  (:action smoothness_llm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst medium))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, low)
  (:action smoothness_lll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed smoothness_mean))
                       (not (test-performed smoothness_se))
                       (not (test-performed smoothness_worst))
                       (has-value smoothness_mean low)
                       (has-value smoothness_se low)
                       (has-value smoothness_worst low))
    :effect (and
              (test-performed smoothness_mean)
              (test-performed smoothness_se)
              (test-performed smoothness_worst)
              (increase (total-cost) 3))
  )











;; --- symmetry Actions (All 27 combinations) ---
  ;; Each symmetry action requires that none of the three symmetry tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (symmetry_mean high, symmetry_se high, symmetry_worst high)
  (:action symmetry_hhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, medium)
  (:action symmetry_hhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, low)
  (:action symmetry_hhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, high)
  (:action symmetry_hmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, medium)
  (:action symmetry_hmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, low)
  (:action symmetry_hml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, high)
  (:action symmetry_hlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, medium)
  (:action symmetry_hlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, low)
  (:action symmetry_hll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean high)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = medium combinations ---
  ;; (medium, high, high)
  (:action symmetry_mhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, medium)
  (:action symmetry_mhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, low)
  (:action symmetry_mhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, high)
  (:action symmetry_mmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, medium)
  (:action symmetry_mmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, low)
  (:action symmetry_mml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, high)
  (:action symmetry_mlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, medium)
  (:action symmetry_mlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, low)
  (:action symmetry_mll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean medium)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = low combinations ---
  ;; (low, high, high)
  (:action symmetry_lhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, medium)
  (:action symmetry_lhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, low)
  (:action symmetry_lhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se high)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, high)
  (:action symmetry_lmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, medium)
  (:action symmetry_lmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, low)
  (:action symmetry_lml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se medium)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, high)
  (:action symmetry_llh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst high))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, medium)
  (:action symmetry_llm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst medium))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, low)
  (:action symmetry_lll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed symmetry_mean))
                       (not (test-performed symmetry_se))
                       (not (test-performed symmetry_worst))
                       (has-value symmetry_mean low)
                       (has-value symmetry_se low)
                       (has-value symmetry_worst low))
    :effect (and
              (test-performed symmetry_mean)
              (test-performed symmetry_se)
              (test-performed symmetry_worst)
              (increase (total-cost) 3))
  )





























;; --- radius Actions (All 27 combinations) ---
  ;; Each radius action requires that none of the three radius tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (radius_mean high, radius_se high, radius_worst high)
  (:action radius_hhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se high)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, medium)
  (:action radius_hhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se high)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, low)
  (:action radius_hhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se high)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, high)
  (:action radius_hmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se medium)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, medium)
  (:action radius_hmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se medium)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, low)
  (:action radius_hml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se medium)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, high)
  (:action radius_hlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se low)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, medium)
  (:action radius_hlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se low)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, low)
  (:action radius_hll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean high)
                       (has-value radius_se low)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = medium combinations ---
  ;; (medium, high, high)
  (:action radius_mhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se high)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, medium)
  (:action radius_mhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se high)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, low)
  (:action radius_mhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se high)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, high)
  (:action radius_mmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se medium)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, medium)
  (:action radius_mmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se medium)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, low)
  (:action radius_mml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se medium)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, high)
  (:action radius_mlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se low)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, medium)
  (:action radius_mlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se low)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, low)
  (:action radius_mll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean medium)
                       (has-value radius_se low)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = low combinations ---
  ;; (low, high, high)
  (:action radius_lhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se high)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, medium)
  (:action radius_lhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se high)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, low)
  (:action radius_lhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se high)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, high)
  (:action radius_lmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se medium)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, medium)
  (:action radius_lmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se medium)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, low)
  (:action radius_lml
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se medium)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, high)
  (:action radius_llh
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se low)
                       (has-value radius_worst high))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, medium)
  (:action radius_llm
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se low)
                       (has-value radius_worst medium))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, low)
  (:action radius_lll
    :parameters ()
    :precondition (and (weights-initialized)
                       (not (test-performed radius_mean))
                       (not (test-performed radius_se))
                       (not (test-performed radius_worst))
                       (has-value radius_mean low)
                       (has-value radius_se low)
                       (has-value radius_worst low))
    :effect (and
              (test-performed radius_mean)
              (test-performed radius_se)
              (test-performed radius_worst)
              (increase (total-cost) 3))
  )







































;; --- area Actions (All 27 combinations) ---
  ;; Each area action requires that none of the three area tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (area_mean high, area_se high, area_worst high)
  (:action area_hhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se high)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, medium)
  (:action area_hhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se high)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, low)
  (:action area_hhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se high)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, high)
  (:action area_hmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se medium)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, medium)
  (:action area_hmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se medium)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, low)
  (:action area_hml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se medium)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, high)
  (:action area_hlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se low)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, medium)
  (:action area_hlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se low)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, low)
  (:action area_hll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean high)
                       (has-value area_se low)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = medium combinations ---
  ;; (medium, high, high)
  (:action area_mhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se high)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, medium)
  (:action area_mhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se high)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, low)
  (:action area_mhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se high)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, high)
  (:action area_mmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se medium)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, medium)
  (:action area_mmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se medium)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, low)
  (:action area_mml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se medium)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, high)
  (:action area_mlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se low)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, medium)
  (:action area_mlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se low)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, low)
  (:action area_mll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean medium)
                       (has-value area_se low)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = low combinations ---
  ;; (low, high, high)
  (:action area_lhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se high)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, medium)
  (:action area_lhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se high)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, low)
  (:action area_lhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se high)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, high)
  (:action area_lmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se medium)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, medium)
  (:action area_lmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se medium)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, low)
  (:action area_lml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se medium)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, high)
  (:action area_llh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se low)
                       (has-value area_worst high))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, medium)
  (:action area_llm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se low)
                       (has-value area_worst medium))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, low)
  (:action area_lll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed radius_mean)
                       (test-performed radius_se)
                       (test-performed radius_worst)
                       (not (test-performed area_mean))
                       (not (test-performed area_se))
                       (not (test-performed area_worst))
                       (has-value area_mean low)
                       (has-value area_se low)
                       (has-value area_worst low))
    :effect (and
              (test-performed area_mean)
              (test-performed area_se)
              (test-performed area_worst)
              (increase (total-cost) 3))
  )



















































;; --- compactness Actions (All 27 combinations) ---
  ;; Each compactness action requires that none of the three compactness tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (compactness_mean high, compactness_se high, compactness_worst high)
  (:action compactness_hhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se high)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, medium)
  (:action compactness_hhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se high)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, high, low)
  (:action compactness_hhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se high)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, high)
  (:action compactness_hmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se medium)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, medium)
  (:action compactness_hmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se medium)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, medium, low)
  (:action compactness_hml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se medium)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, high)
  (:action compactness_hlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se low)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, medium)
  (:action compactness_hlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se low)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (high, low, low)
  (:action compactness_hll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean high)
                       (has-value compactness_se low)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = medium combinations ---
  ;; (medium, high, high)
  (:action compactness_mhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se high)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, medium)
  (:action compactness_mhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se high)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, high, low)
  (:action compactness_mhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se high)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, high)
  (:action compactness_mmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se medium)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, medium)
  (:action compactness_mmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se medium)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, medium, low)
  (:action compactness_mml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se medium)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, high)
  (:action compactness_mlh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se low)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, medium)
  (:action compactness_mlm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se low)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (medium, low, low)
  (:action compactness_mll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean medium)
                       (has-value compactness_se low)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; --- Mean = low combinations ---
  ;; (low, high, high)
  (:action compactness_lhh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se high)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, medium)
  (:action compactness_lhm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se high)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, high, low)
  (:action compactness_lhl
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se high)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, high)
  (:action compactness_lmh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se medium)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, medium)
  (:action compactness_lmm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se medium)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, medium, low)
  (:action compactness_lml
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se medium)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, high)
  (:action compactness_llh
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se low)
                       (has-value compactness_worst high))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, medium)
  (:action compactness_llm
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se low)
                       (has-value compactness_worst medium))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )

  ;; (low, low, low)
  (:action compactness_lll
    :parameters ()
    :precondition (and (weights-initialized)
                       (test-performed area_mean)
                       (test-performed area_se)
                       (test-performed area_worst)
                       (test-performed perimeter_mean)
                       (test-performed perimeter_se)
                       (test-performed perimeter_worst)
                       (not (test-performed compactness_mean))
                       (not (test-performed compactness_se))
                       (not (test-performed compactness_worst))
                       (has-value compactness_mean low)
                       (has-value compactness_se low)
                       (has-value compactness_worst low))
    :effect (and
              (test-performed compactness_mean)
              (test-performed compactness_se)
              (test-performed compactness_worst)
              (increase (total-cost) 3))
  )






;; --- Diagnosis Action ---
  (:action diagnose
    :parameters ()
    :precondition ( and (or
      (and
        (test-performed perimeter_mean)
        (test-performed perimeter_se)
        (test-performed perimeter_worst)

        (test-performed area_mean)
        (test-performed area_se)
        (test-performed area_worst)
        
        (test-performed compactness_mean)
        (test-performed compactness_mean)
        (test-performed compactness_mean)
      )
    )
      (not (diagnosed)))
    :effect (diagnosed)
  )



  (:action diagnose_2
    :parameters ()
    :precondition ( and (or
      (and
        (test-performed compactness_mean)
        (test-performed compactness_se)
        (test-performed compactness_worst)
      )


    )
      (not (diagnosed)))
    :effect (diagnosed)
  )












)





