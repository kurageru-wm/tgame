(define-module tgame.strategy.strategies
  (use tui)
  (export-all)
  )

(select-module tgame.strategy.strategies)


(define-class <strategy> ()
  ((proc :init-keyword :proc
         :init-value (lambda args (values '() #f '(0 . 0))) ;dates cordinate angle
         :accessor proc-of)
   (dates :init-keyword :dates
          :init-value #()
          :accessor dates-of)   
   ))

(define-method next ((str <strategy>))
  ((proc-of str) (dates-of str)))

(define-method object-apply ((str <strategy>))
  (next str))


;; Return: (values dates Cordinate Angle ...)
(define (pattern dates)
  (let1 i (vector-ref dates 1)    
    (if (= (- (vector-length (vector-ref dates 0)) 1) i)
        (set! (vector-ref dates 1) 0)
        (inc! (vector-ref dates 1)))
    (values dates (vector-ref (vector-ref dates 0) i) '(0 . 0))))


(provide "tgame/strategy/strategies")
