(use tui)
(use tgame)
(use AI)
(use srfi-42)
(use srfi-11)

;; Task Manager
(define *tm* (make <task-manager>))

;; Key Event
(define *key-events* (make <events> 'eqv?))

;; Map
(define *map*
  (list-ec (: i 30) (make-string 130 #\.))
  )

;; Pattern
(define p (make <pattern>))
(build-path-segment! p 5 5 10 10)
(build-path-segment! p 10 10 14 9)
(build-path-segment! p 14 9 20 3)
(build-path-segment! p 20 3 5 5)

;; Key Move
(define (update-pre ch y x)
  (let-values (((wy wx) (getwinyx))
               ((cy cx) (getchyx ch)))
    (if (and (< 0 (+ cy y) (- wy 1))
             (< 0 (+ cx x) (- wx 1)))
        (begin
          (set! (x-of ch) (+ (x-of ch) x))
          (set! (y-of ch) (+ (y-of ch) y)))        
        #f)    
    ))

;; Pattern Strategy
(define pat
  (make <strategy>
    :proc pattern
    :dates (vector (list->vector (pattern-of p)) 0)))

(define (main args)
  ;; Initialize
  (init-tui)

  ;; Load Map
  (load-map *map*)

  ;; Create Color
  (init_pair 1 COLOR_CYAN COLOR_BLACK)
  (init_pair 2 COLOR_RED COLOR_BLACK)

  ;; Add Tasks
  (add-task *tm*
            (make <task>
              :id 0
              :obj (make <cobject> :ch #\@ :x 10 :y 10 :attr `(,A_BOLD ,(COLOR_PAIR 1)))
              ))
  (add-task *tm*
            (make <task>
              :id 1
              :obj (make <cobject> :ch #\E :x 20 :y 20 :attr `(,A_BOLD ,(COLOR_PAIR 2)))
              ))
  

  ;; Add Key Event
  (let1 proc
        (lambda () (string-ref
                    (list-ref *map* (y-of (obj-of (get-task *tm* 0))))
                    (x-of (obj-of (get-task *tm* 0)))))
        (add-event *key-events* (x->number #\j)
                   (lambda (args) (update-pre (obj-of (get-task *tm* 0)) 1 0)))
        (add-event *key-events* (x->number #\k)
                   (lambda (args) (update-pre (obj-of (get-task *tm* 0)) -1 0)))
        (add-event *key-events* (x->number #\l)
                   (lambda (args) (update-pre (obj-of (get-task *tm* 0)) 0 1)))
        (add-event *key-events* (x->number #\h)
                   (lambda (args) (update-pre (obj-of (get-task *tm* 0)) 0 -1)))
        )

  (add-strategy (get-task *tm* 1) pat)
  (let loop ((c (getch)))
    (*key-events* c)

    (command *tm*)
    
    (draw-box)
    (draw *tm*)    
    
    ;; (mvprintw 0 0 "%3d:%3d" (x-of (obj-of (get-task *tm* 0))) (y-of pey))
    (mvprintw 0 20 "%3d:%3d"
              (x-of (obj-of (get-task *tm* 1)))
              (y-of (obj-of (get-task *tm* 1))))

    (unless (= (x->number #\q) c)
            (loop (getch))
            )
    )  

  (getch)
  (endwin)
  )


  