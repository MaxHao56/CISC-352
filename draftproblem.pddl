(define (problem breast-cancer-problem)
  (:domain breast-cancer-diagnosis)
  
  (:init
    ;; Set the initial total cost to 0.
    (= (total-cost) 0)
    ;; By the closed-world assumption, none of the test predicates (e.g., (test-performed radius_mean))
    ;; or diagnosis predicates are true initially.
  )
  
  (:goal 
    (or (diagnosed malignant) (diagnosed benign))
  )
)
