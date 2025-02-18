(define (problem cancer-diagnosis)
  (:domain CancerCheck_B)

;   (:objects
;     radius_mean radius_se radius_worst
;     area_mean area_se area_worst
;     perimeter_mean perimeter_se perimeter_worst
;     - measurement

;     low medium high
;     malignant benign uncertain
;     - value
;   )

  (:init
    (has-value radius_mean high)
    (has-value radius_se medium)
    (has-value radius_worst low)

    (has-value area_mean low)
    (has-value area_se high)
    (has-value area_worst medium)

    (has-value perimeter_mean low)
    (has-value perimeter_se medium)
    (has-value perimeter_worst high)

    (= (total-cost) 0)
  )

  (:goal
  (exists (?d - value) (diagnosed ?d))
)

  (:metric minimize (total-cost))
)
