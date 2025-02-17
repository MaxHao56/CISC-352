(define (problem CancerCheck-Instance)
  (:domain CancerCheck)


  ;; Initial state
  (:init
    ;; Measurements are untested initially
    (not (test-performed perimeter_mean))
    (not (test-performed texture_mean))
    (not (test-performed radius_mean))
    (not (test-performed compactness_mean))
    (not (test-performed symmetry_mean))
    
    ;; Assign measurement types
    (typeA radius_mean)
    (typeA texture_mean)
    (typeB perimeter_mean)
    (typeB compactness_mean)
    (typeB symmetry_mean)
    
    ;; Initial cost
    (= (total-cost) 0)
  )

  ;; Goal: A diagnosis must be made
  (:goal (or (diagnosed malignant) (diagnosed benign)))

  ;; Metric: Minimize the cost of tests
  (:metric minimize (total-cost))
)