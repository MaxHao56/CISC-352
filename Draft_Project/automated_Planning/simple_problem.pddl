(define (problem CancerCheck-Instance)
  (:domain CancerCheck)

  ;; Objects in the problem
  ; (:objects
  ;   perimeter_mean texture_mean radius_mean compactness_mean - measurement
  ;   low medium high - value
  ; )

  ;; Initial state
  (:init
    ;; Measurements are untested initially
    (not (test-performed perimeter_mean))
    (not (test-performed texture_mean))
    (not (test-performed radius_mean))
    (not (test-performed compactness_mean))
    
    ;; Assign measurement types
    (typeA radius_mean)
    (typeA texture_mean)
    (typeB perimeter_mean)
    (typeB compactness_mean)
    
    ;; Initial cost
    (= (total-cost) 0)
  )

  ;; Goal: A diagnosis must be made
  (:goal (or (diagnosed malignant) (diagnosed benign)))

  ;; Metric: Minimize the cost of tests
  (:metric minimize (total-cost))
)