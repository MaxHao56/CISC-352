(define (problem cancer-test-instance)
  (:domain CancerCheck_BNN)


  (:init
    (not (weights-initialized))
    (= (total-cost) 0)
    (has-value radius_mean high)
    (has-value radius_se medium)
    (has-value radius_worst low)
    (has-value area_mean low)
    (has-value area_se high)
    (has-value area_worst medium)
    (has-value perimeter_mean high)
    (has-value perimeter_se low)
    (has-value perimeter_worst high)
  )

  (:goal (or (diagnosed malignant) (diagnosed benign) (diagnosed uncertain)))
  (:metric minimize (total-cost))
)
