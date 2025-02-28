(define (problem cancer-bnn-test)
  (:domain CancerCheck_BNN)
  (:objects
    radius_mean radius_se radius_worst 
    area_mean area_se area_worst 
    perimeter_mean perimeter_se perimeter_worst - measurement
    low medium high malignant benign uncertain - value
    correct incorrect - reaction
  )
  (:init
    ;; Initialize overall cost
    (= (total-cost) 0)
    
    ;; Assign measurement quality values (these could be updated based on external data)
    (has-value radius_mean high)
    (has-value radius_se medium)
    (has-value radius_worst low)
    
    (has-value area_mean medium)
    (has-value area_se high)
    (has-value area_worst low)
    
    (has-value perimeter_mean low)
    (has-value perimeter_se low)
    (has-value perimeter_worst high)
  )
  (:goal
    (and
      (diagnosis-correct)
      (feedback-received)
    )
  )
  (:metric minimize (total-cost))
)
