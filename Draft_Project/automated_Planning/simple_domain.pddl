;Header and description

(define (domain CancerCheck)

;remove requirements that are not needed
(:requirements 
    :strips 
    :fluents 
    :durative-actions 
    :timed-initial-literals 
    :typing 
    :conditional-effects 
    :negative-preconditions 
    :duration-inequalities 
    :equality 
    :action-costs
    :disjunctive-preconditions
)

(:types 
    measurement
    value
)



(:constants 

    radius_mean
    radius_se
    radius_worst

    area_mean
    area_se
    area_worst

    preimeter_mean
    preimeter_se
    preimeter_worst

    compactness_mean
    compactness_se
    compactness_worst

    fractal_dimension_mean
    fractal_dimension_se
    fractal_dimension_worst

    concavity_mean
    concavity_se
    concavity_worst


    concave_points_mean
    concave_points_se
    concave_points_worst

    texture_mean
    texture_se
    texture_worst


    symmetry_mean
    symmetry_se
    symmetry_worst

    smoothness_mean
    smoothness_se
    smoothness_worst


    - measurement


    low
    medium
    high
    malignant
    benign
    - value
)


(:predicates 
    (has-value ?m -measurement ?v -value)
    (test-performed ?m -measurement)
    (diagnosed ?d -value)

    (typeA ?m - measurement)
    (typeB ?m - measurement)

    ; (has-value ?m - measurement ?v - value)
    ; (test-performed ?m - measurement)
    ; (diagnosed ?d - value)
)



(:functions 
    (total-cost)
)


; (:action adjust-radius-cost
;     :parameters ()
;     :precondition (and 
;         (test-performed radius_mean)
;         (test-performed radius_se)
;         (test-performed radius_worst)
;     )
;     :effect (and
;         ;; Increase cost if radius_worst is high (potential outliers)
;         (when (has-value radius_worst high)
;             (increase (total-cost) 2))

;         ;; Increase cost if radius_se is high (unstable mean)
;         (when (has-value radius_se high)
;             (increase (total-cost) 5))

;         ;; Reduce cost slightly if radius_mean is stable (low or medium SE)
;         (when (or (has-value radius_se low) (has-value radius_se medium))
;             (increase (total-cost) -2))
;     )
; )



(:action radius
    :parameters ()
    :precondition (and 
        (not (test-performed radius_mean))
        (not (test-performed radius_se))
        (not (test-performed radius_worst))
    )
    :effect (and 

        (test-performed radius_mean)
        (test-performed radius_se)
        (test-performed radius_worst)

        ; (has-value radius_mean high)
        ; (has-value radius_se medium)
        ; (has-value radius_worst low)

        (increase (total-cost) 5) 
    )
)

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

    ; (has-value area_mean medium)
    ; (has-value area_se high)
    ; (has-value area_worst low)

    (increase (total-cost) 5)
  
    )
)

(:action preimeter
    :parameters ()
    :precondition (and 

    (test-performed radius_mean)
    (test-performed radius_se)
    (test-performed radius_worst)
    
    (not (test-performed preimeter_mean))
    (not (test-performed preimeter_se))
    (not (test-performed preimeter_worst))
    
    )
    :effect (and 

    (test-performed preimeter_mean)
    (test-performed preimeter_se)
    (test-performed preimeter_worst)


    ; (has-value preimeter_mean low)
    ; (has-value preimeter_se high)
    ; (has-value preimeter_worst medium)

    (increase (total-cost) 5)
    
    )
)

(:action compacntness
    :parameters ()
    :precondition (and 


    (test-performed area_mean)
    (test-performed area_se)
    (test-performed area_worst)
    
    (test-performed preimeter_mean)
    (test-performed preimeter_se)
    (test-performed preimeter_worst)


    (not (test-performed compactness_mean))
    (not (test-performed compactness_se))
    (not (test-performed compactness_worst))
    )
    :effect (and 
    
    (test-performed compactness_mean)
    (test-performed compactness_se)
    (test-performed compactness_worst)

    ; (has-value compactness_mean medium)
    ; (has-value compactness_se low)
    ; (has-value compactness_worst high)

    (increase (total-cost) 5)
  
    )
)

(:action fractal_dimension 
    :parameters ()
    :precondition (and 

    (test-performed compactness_mean)
    (test-performed compactness_se)
    (test-performed compactness_worst)



    (test-performed concavity_mean)
    (test-performed concavity_se)
    (test-performed concavity_worst)

    (not (test-performed fractal_dimension_mean))
    (not (test-performed fractal_dimension_se))
    (not (test-performed fractal_dimension_worst))
    )
    :effect (and 
    
    (test-performed fractal_dimension_mean)
    (test-performed fractal_dimension_se)
    (test-performed fractal_dimension_worst)


    ; (has-value fractal_dimension_mean high)
    ; (has-value fractal_dimension_se medium)
    ; (has-value fractal_dimension_worst low)

    (increase (total-cost) 5)
  
    )
)

(:action concavity
    :parameters ()
    :precondition (and 

    (test-performed concave_points_mean)
    (test-performed concave_points_se)
    (test-performed concave_points_worst)

    (not (test-performed concavity_mean))
    (not (test-performed concavity_se))
    (not (test-performed concavity_worst))
    )
    :effect (and 
    
    (test-performed concavity_mean)
    (test-performed concavity_se)
    (test-performed concavity_worst)


    ; (has-value concavity_mean high)
    ; (has-value concavity_se medium)
    ; (has-value concavity_worst low)


    (increase (total-cost) 5)
  
    )
)

(:action concave_points
    :parameters ()
    :precondition (and 
    (not (test-performed concave_points_mean))
    (not (test-performed concave_points_se))
    (not (test-performed concave_points_worst))
    )

    :effect (and 
  
    (test-performed concave_points_mean)
    (test-performed concave_points_se)
    (test-performed concave_points_worst)

    ; (has-value concave_points_mean low)
    ; (has-value concave_points_se medium)
    ; (has-value concave_points_worst high)


    (increase (total-cost) 5)
  
    )
)

(:action texture
    :parameters ()
    :precondition (and 

    (not (test-performed texture_mean))
    (not (test-performed texture_se))
    (not (test-performed texture_worst))
    )
    
    :effect (and 
    (test-performed texture_mean)
    (test-performed texture_se)
    (test-performed texture_worst)


    ; (has-value texture_mean high)
    ; (has-value texture_se low)
    ; (has-value texture_worst medium)

    (increase (total-cost) 5)
  
    )
)

(:action symmetry
    :parameters ()
    :precondition (and 
    (not (test-performed symmetry_mean))
    (not (test-performed symmetry_se))
    (not (test-performed symmetry_worst))
    )
    :effect (and 
    
    (test-performed symmetry_mean)
    (test-performed symmetry_se)
    (test-performed symmetry_worst)

    ; (has-value symmetry_mean medium)
    ; (has-value symmetry_se low)
    ; (has-value symmetry_worst high)

    (increase (total-cost) 5)
  
    )
) 

(:action smoothness
    :parameters ()
    :precondition (and 
    (not (test-performed smoothness_mean))
    (not (test-performed smoothness_se))
    (not (test-performed smoothness_worst))
    )
    :effect (and 
    
    (test-performed smoothness_mean)
    (test-performed smoothness_se)
    (test-performed smoothness_worst)

    ; (has-value smoothness_mean medium)
    ; (has-value smoothness_se high)
    ; (has-value smoothness_worst low)

    (increase (total-cost) 5)
  
    )
)



(:action measure
    :parameters ( ?m - measurement ?v - value)
    :precondition (and (not (test-performed ?m)))
    :effect (and

      (test-performed ?m)

      (has-value ?m ?v)

    
      (when (typeA ?m)
        (increase (total-cost) 2))


      (when (typeB ?m)
        (increase (total-cost) 3))
    )
)

  (:action diagnose
    :parameters ()
    :precondition 
      (and (not (diagnosed malignant))
           (not (diagnosed benign)))
    :effect (and
      ;; If we see certain features are high, we say malignant
      (when (or (and (has-value radius_mean high)
                     (has-value texture_mean high))
                (and (has-value preimeter_mean high)
                     (has-value compactness_mean high)))
        (diagnosed malignant))

      ;; If we see certain features are low, we say benign
      (when (or (and (has-value radius_mean low)
                     (has-value texture_mean low))
                (and (has-value preimeter_mean low)
                     (has-value compactness_mean low)))
        (diagnosed benign))
    )
  )

)