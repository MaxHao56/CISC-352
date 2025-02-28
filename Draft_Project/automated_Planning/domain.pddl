(define (domain CancerCheck_BNN)
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
    reaction
  )

  (:constants
    ;; Measurements
    radius_mean radius_se radius_worst 
    area_mean area_se area_worst 
    perimeter_mean perimeter_se perimeter_worst - measurement

    ;; Measurement quality values
    low medium high malignant benign uncertain - value

    ;; Simulated BNN feedback reactions
    correct incorrect - reaction
  )

  (:predicates
    (has-value ?m - measurement ?v - value)
    (test-performed ?m - measurement)
    (diagnosed ?d - value)
    (weights-initialized)
    (feedback-received)
    (diagnosis-correct)
  )

  (:functions
    (total-cost)
    (weight ?m - measurement)
  )

  ;; --- INITIAL WEIGHT GENERATION ---
  (:action init-weights
    :parameters ()
    :precondition (not (weights-initialized))
    :effect (and
      (weights-initialized)
      (assign (weight radius_mean) 1)
      (assign (weight radius_se) 1)
      (assign (weight radius_worst) 1)
      (assign (weight area_mean) 1)
      (assign (weight area_se) 1)
      (assign (weight area_worst) 1)
      (assign (weight perimeter_mean) 1)
      (assign (weight perimeter_se) 1)
      (assign (weight perimeter_worst) 1)
    )
  )

  ;; --- RADIUS TEST ACTION (Cost now multiplied by the weight) ---
  (:action radius
    :parameters ()
    :precondition (and
      (weights-initialized)
      (not (test-performed radius_mean))
      (not (test-performed radius_se))
      (not (test-performed radius_worst))
    )
    :effect (and
      (test-performed radius_mean)
      (test-performed radius_se)
      (test-performed radius_worst)
      (when (has-value radius_mean high)   (increase (total-cost) (* 3 (weight radius_mean))))
      (when (has-value radius_mean medium) (increase (total-cost) (* 2 (weight radius_mean))))
      (when (has-value radius_mean low)    (increase (total-cost) (* 1 (weight radius_mean))))

      (when (has-value radius_se high)   (increase (total-cost) (* 3 (weight radius_se))))
      (when (has-value radius_se medium) (increase (total-cost) (* 2 (weight radius_se))))
      (when (has-value radius_se low)    (increase (total-cost) (* 1 (weight radius_se))))

      (when (has-value radius_worst high)   (increase (total-cost) (* 3 (weight radius_worst))))
      (when (has-value radius_worst medium) (increase (total-cost) (* 2 (weight radius_worst))))
      (when (has-value radius_worst low)    (increase (total-cost) (* 1 (weight radius_worst))))
    )
  )

  ;; --- AREA TEST ACTION (Using weight) ---
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
      (when (has-value area_mean high)   (increase (total-cost) (* 3 (weight area_mean))))
      (when (has-value area_mean medium) (increase (total-cost) (* 2 (weight area_mean))))
      (when (has-value area_mean low)    (increase (total-cost) (* 1 (weight area_mean))))

      (when (has-value area_se high)   (increase (total-cost) (* 3 (weight area_se))))
      (when (has-value area_se medium) (increase (total-cost) (* 2 (weight area_se))))
      (when (has-value area_se low)    (increase (total-cost) (* 1 (weight area_se))))

      (when (has-value area_worst high)   (increase (total-cost) (* 3 (weight area_worst))))
      (when (has-value area_worst medium) (increase (total-cost) (* 2 (weight area_worst))))
      (when (has-value area_worst low)    (increase (total-cost) (* 1 (weight area_worst))))
    )
  )

  ;; --- PERIMETER TEST ACTION (Using weight) ---
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
      (when (has-value perimeter_mean high)   (increase (total-cost) (* 3 (weight perimeter_mean))))
      (when (has-value perimeter_mean medium) (increase (total-cost) (* 2 (weight perimeter_mean))))
      (when (has-value perimeter_mean low)    (increase (total-cost) (* 1 (weight perimeter_mean))))

      (when (has-value perimeter_se high)   (increase (total-cost) (* 3 (weight perimeter_se))))
      (when (has-value perimeter_se medium) (increase (total-cost) (* 2 (weight perimeter_se))))
      (when (has-value perimeter_se low)    (increase (total-cost) (* 1 (weight perimeter_se))))

      (when (has-value perimeter_worst high)   (increase (total-cost) (* 3 (weight perimeter_worst))))
      (when (has-value perimeter_worst medium) (increase (total-cost) (* 2 (weight perimeter_worst))))
      (when (has-value perimeter_worst low)    (increase (total-cost) (* 1 (weight perimeter_worst))))
    )
  )

  ;; --- DIAGNOSIS ACTION ---
  (:action diagnose
    :parameters ()
    :precondition (and
      (test-performed radius_mean) (test-performed radius_se) (test-performed radius_worst)
      (test-performed area_mean) (test-performed area_se) (test-performed area_worst)
      (test-performed perimeter_mean) (test-performed perimeter_se) (test-performed perimeter_worst)
      (not (diagnosed malignant)) (not (diagnosed benign)) (not (diagnosed uncertain))
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
      (when (and (not (diagnosed malignant)) (not (diagnosed benign)) (not (diagnosed uncertain)))
            (diagnosed uncertain))
    )
  )

  ;; --- GET FEEDBACK FROM THE BNN MODEL ---
  (:action get-feedback
    :parameters ()
    :precondition (or (diagnosed malignant) (diagnosed benign) (diagnosed uncertain))
    :effect (feedback-received)
  )

  ;; --- UPDATE WEIGHTS BASED ON BNN FEEDBACK ---
  (:action update-weights
    :parameters (?m - measurement ?delta - number)
    :precondition (feedback-received)
    :effect (increase (weight ?m) ?delta)
  )

  ;; --- CHECK IF THE DIAGNOSIS IS CORRECT (Simulated BNN check) ---
  (:action check-diagnosis
    :parameters ()
    :precondition (feedback-received)
    :effect (when (>= (total-cost) 20) (diagnosis-correct))
  )
)
