(define (problem breast-cancer-diagnosis-problem)
  (:domain breast-cancer-diagnosis)
  
  (:objects 
    ;; Measurements for tumor characteristics (mean, se, worst)
    radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
    compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean
    radius_se texture_se perimeter_se area_se smoothness_se compactness_se concavity_se concave_points_se symmetry_se fractal_dimension_se
    radius_worst texture_worst perimeter_worst area_worst smoothness_worst compactness_worst 
    concavity_worst concave_points_worst symmetry_worst fractal_dimension_worst
    ;; The diagnosis is treated as a measurement
    diagnosis - measurement
    
    ;; Values: note that for diagnosis, malignant and benign are the conclusive values.
    low medium high unknown malignant benign - value
  )
  
  (:init
    ;; All tumor feature measurements are initially unknown.
    (has-value radius_mean unknown)
    (has-value texture_mean unknown)
    (has-value perimeter_mean unknown)
    (has-value area_mean unknown)
    (has-value smoothness_mean unknown)
    (has-value compactness_mean unknown)
    (has-value concavity_mean unknown)
    (has-value concave_points_mean unknown)
    (has-value symmetry_mean unknown)
    (has-value fractal_dimension_mean unknown)
    
    (has-value radius_se unknown)
    (has-value texture_se unknown)
    (has-value perimeter_se unknown)
    (has-value area_se unknown)
    (has-value smoothness_se unknown)
    (has-value compactness_se unknown)
    (has-value concavity_se unknown)
    (has-value concave_points_se unknown)
    (has-value symmetry_se unknown)
    (has-value fractal_dimension_se unknown)
    
    (has-value radius_worst unknown)
    (has-value texture_worst unknown)
    (has-value perimeter_worst unknown)
    (has-value area_worst unknown)
    (has-value smoothness_worst unknown)
    (has-value compactness_worst unknown)
    (has-value concavity_worst unknown)
    (has-value concave_points_worst unknown)
    (has-value symmetry_worst unknown)
    (has-value fractal_dimension_worst unknown)
    
    ;; The diagnosis starts as unknown.
    (has-value diagnosis unknown)
    
    ;; Initialize total cost to 0.
    (= (total-cost) 0)
  )
  
  (:goal (or (has-value diagnosis malignant)
             (has-value diagnosis benign)))
  
  (:metric minimize (total-cost))
)
