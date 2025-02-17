; (define (problem CancerCheck-Instance)
;   (:domain CancerCheck)


;   ;; Initial state
;   (:init
;     ;; Measurements are untested initially
;     (not (test-performed perimeter_mean))
;     (not (test-performed texture_mean))
;     (not (test-performed radius_mean))
;     (not (test-performed compactness_mean))
;     (not (test-performed symmetry_mean))
    
;     ;; Assign measurement types
;     (typeA radius_mean)
;     (typeA texture_mean)
;     (typeB perimeter_mean)
;     (typeB compactness_mean)
;     (typeB symmetry_mean)
    
;     ;; Initial cost
;     (= (total-cost) 0)
;   )

;   ;; Goal: A diagnosis must be made
;   (:goal (or (diagnosed malignant) (diagnosed benign)))

;   ;; Metric: Minimize the cost of tests
;   (:metric minimize (total-cost))
; )


(define (problem CancerCheck-RandomAssignment)
  (:domain CancerCheck)

  ;;------------------------------------------------------------------
  ;; We do NOT need to re-declare the constants here; they're declared
  ;; in the domain. We just use them. We also do NOT define objects for
  ;; the measurements, since they're domain-level constants.
  ;; 
  ;; Instead, we place all initial facts in the :init section.
  ;;------------------------------------------------------------------

  (:init

    ;; ---------------------------
    ;; 1) Set total-cost to 0
    ;; ---------------------------
    (= (total-cost) 0)

    ;; -----------------------------------------------------------
    ;; 2) Randomly assign each measurement to a value: low/med/high
    ;; -----------------------------------------------------------

    ;;   For radius_*
    (has-value radius_mean high)
    (has-value radius_se medium)
    (has-value radius_worst low)

    ;;   For area_*
    (has-value area_mean medium)
    (has-value area_se high)
    (has-value area_worst low)

    ;;   For perimeter_*
    (has-value preimeter_mean low)
    (has-value preimeter_se high)
    (has-value preimeter_worst medium)

    ;;   For compactness_*
    (has-value compactness_mean medium)
    (has-value compactness_se low)
    (has-value compactness_worst high)

    ;;   For fractal_dimension_*
    (has-value fractal_dimension_mean high)
    (has-value fractal_dimension_se medium)
    (has-value fractal_dimension_worst low)

    ;;   For concavity_*
    (has-value concavity_mean high)
    (has-value concavity_se medium)
    (has-value concavity_worst low)

    ;;   For concave_points_*
    (has-value concave_points_mean low)
    (has-value concave_points_se medium)
    (has-value concave_points_worst high)

    ;;   For texture_*
    (has-value texture_mean high)
    (has-value texture_se low)
    (has-value texture_worst medium)

    ;;   For symmetry_*
    (has-value symmetry_mean medium)
    (has-value symmetry_se low)
    (has-value symmetry_worst high)

    ;;   For smoothness_*
    (has-value smoothness_mean medium)
    (has-value smoothness_se high)
    (has-value smoothness_worst low)

    ;; ------------------------------------------------
    ;; 3) Randomly mark each measurement as typeA/typeB
    ;;    (affects the cost of the "measure" action)
    ;; ------------------------------------------------

    ;; For illustration, about half are typeA and half typeB

    (typeA radius_mean)
    (typeA radius_se)
    (typeB radius_worst)

    (typeB area_mean)
    (typeA area_se)
    (typeB area_worst)

    (typeA preimeter_mean)
    (typeB preimeter_se)
    (typeA preimeter_worst)

    (typeB compactness_mean)
    (typeA compactness_se)
    (typeA compactness_worst)

    (typeB fractal_dimension_mean)
    (typeB fractal_dimension_se)
    (typeA fractal_dimension_worst)

    (typeB concavity_mean)
    (typeA concavity_se)
    (typeA concavity_worst)

    (typeA concave_points_mean)
    (typeB concave_points_se)
    (typeB concave_points_worst)

    (typeA texture_mean)
    (typeB texture_se)
    (typeA texture_worst)

    (typeB symmetry_mean)
    (typeB symmetry_se)
    (typeA symmetry_worst)

    (typeA smoothness_mean)
    (typeB smoothness_se)
    (typeB smoothness_worst)

    ;; ------------------------------------------------------------
    ;; 4) By default, no measurements have yet been performed, and
    ;;    no diagnosis is declared. So we omit (test-performed ...)
    ;;    and (diagnosed ...) from the initial state.
    ;; ------------------------------------------------------------
  )

  ;;------------------------------------------------------------------
  ;; 5) Goal: we want to end up diagnosing the cancer
  ;;    as either malignant or benign.
  ;;------------------------------------------------------------------
  (:goal
    (or (diagnosed malignant)
        (diagnosed benign))
  )
)
