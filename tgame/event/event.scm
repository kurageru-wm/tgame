(define-module tgame.event.event
  (export-all)
  )
(select-module tgame.event.event)



(define-class <events> ( )
  ((event-table :accessor table-of)
   ))
(define-method initialize ((self <events>) initargs)
  (let-optionals* initargs ((type 'eq?))                  
                  (set! (table-of self) (make-hash-table type))))

(define-method add-event ((events <events>) key proc)  
  (hash-table-put! (table-of events) key proc))

(define-method call ((events <events>) key . args)
  ((hash-table-get (table-of events) key (lambda (x))) args))

(define-method object-apply ((events <events>) key . args)
  (apply call events key args))


(provide "tgame/event/event")