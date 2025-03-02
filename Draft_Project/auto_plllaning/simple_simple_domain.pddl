(define (domain CancerCheck_BNN_2)
  (:requirements
    :strips
    :typing
    :negative-preconditions
    :equality
    :action-costs
  )

  (:types 
    measurement
    value
  )

  (:constants
    ;; Measurements

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

  ;; --- Radius Actions ---
  ;; radius_1: cost 6, quality: radius_mean high, radius_se medium, radius_worst low
  (:action radius_1
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
              (increase (total-cost) 6))
  )

  ;; radius_2: cost 6, quality: radius_mean high, radius_se high, radius_worst low
  (:action radius_2
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
              (increase (total-cost) 6))
  )

  ;; --- Area Actions ---
  ;; area_1: cost 6, quality: area_mean high, area_se medium, area_worst low
  (:action area_1
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
              (increase (total-cost) 6))
  )

  ;; area_2: cost 6, quality: area_mean high, area_se high, area_worst low
  (:action area_2
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
              (increase (total-cost) 6))
  )

  ;; --- Perimeter Actions (All 27 combinations) ---
  ;; Each perimeter action requires that none of the three perimeter tests have been performed,
  ;; and that the measurement values match a specific combination.
  ;; The action effect marks the tests as performed and increases the total cost by 3.

  ;; Combination: (perimeter_mean high, perimeter_se high, perimeter_worst high)
  (:action perimeter_hhh
    :parameters ()
    :precondition (and (weights-initialized)
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
              (increase (total-cost) 1))
  )

  ;; --- Diagnosis Action ---
  (:action diagnose
    :parameters ()
    :precondition (and
      (test-performed radius_mean) 
      (test-performed radius_se) 
      (test-performed radius_worst)
      (test-performed area_mean) 
      (test-performed area_se) 
      (test-performed area_worst)
      ; Optionally, if you want perimeter tests to be required:
      (test-performed perimeter_mean) 
      (test-performed perimeter_se) 
      (test-performed perimeter_worst)
      (not (diagnosed)))
    :effect (diagnosed)
  )
)
