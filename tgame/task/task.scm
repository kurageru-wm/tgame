(define-module tgame.task.task
  (use tui)
  (use tgame.strategy.strategies)
  (export-all)
  )

(select-module tgame.task.task)


;; Task
(define-class <task> ( )
  ((id :init-keyword :id
       :init-value #f
       :accessor id-of)   
   (obj :init-keyword :obj
        :init-value #f
        :accessor obj-of)
   (str :init-keyword :str
        :init-value (make <strategy>)
        :accessor str-of)
   ))

;; Object Info
(define-class <cobject> (<nchar>)
  ((hist :init-value '()
         :accessor hist-of)   
   ))

(define-method update! ((obj <cobject>) xy)
  (cons (cons (x-of obj) (y-of obj))
        (hist-of obj))
  (setch (make <nchar> :x (x-of obj) :y (y-of obj)))
  (set! (x-of obj) (car xy))
  (set! (y-of obj) (cdr xy)))

;; Strategy
(define-method add-strategy ((t <task>) (str <strategy>))
  (set! (str-of t) str))

(define-method command (key (t <task>))
  (receive (d xy a) ((str-of t))    
    (if (not xy) #f
        (begin
          (update! (obj-of t) xy)
          (set! (dates-of (str-of t)) d)
          ))))


;; Draw
(define-method draw (key (t <task>))
  (setch (obj-of t)))



;; Task Manager
(define-class <task-manager> ( )
  ((tasks :init-keyword :tasks
          :init-value (make-hash-table)          
          :accessor tasks-of)
   ))

(define-method add-task ((tm <task-manager>) (t <task>))
  (hash-table-put! (tasks-of tm) (id-of t) t))

(define-method get-task ((tm <task-manager>) id)
  (hash-table-get (tasks-of tm) id))

(define-method remove-task ((tm <task-manager>) id)
  (hash-table-delete! (tasks-of tm) id))

(define-method command ((tm <task-manager>))
  (hash-table-for-each (tasks-of tm) command))

(define-method draw ((tm <task-manager>))
  (hash-table-for-each (tasks-of tm) draw))




;; (define p (make <task>))
;; (print (str-of p))
;; (add-strategy p 'a print)
;; (add-strategy p 'b print)

;; (command p 'b 'a 'b 'c 'd 'e)


(provide "tgame/task/task")