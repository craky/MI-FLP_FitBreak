; author: krakovoj@fit.cvut.cz
; Bellman - Ford algorithm for solution FitBreak problem
(defconstant n_max 100); maximum number of nodes
(defconstant n_min 2)  ; minimum number of nodes
(defconstant m_max 100); maximum of streets
(defconstant m_min 0)  ; minimum of streets
(defconstant err  -999); error value
(defconstant ok  0)	  ; "no problem" value
(defparameter *n* NIL) ; number of nodes
(defparameter *m* NIL) ; number of streets
(setf *adjacency_matrix* (make-array (list n_max n_max):initial-element 0))

(defun load_stdin () 
	(setf *n* (read))
	(let ((s (read)))
		(print s)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; assert
;; is using to compare two parameters if they are same, if not prints error
;; Input: parameter A and parameter B
;; Output: t or nil
(defun assert_ (A B str)
	(if (eq A B)
		t
		(progn 	(print str)
					nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load the number of node
;; Input: none
;; Output: the number of node or err if the number is not in the interval
;;			  <2;100>
(defun load_num_of_node()
	(setf *n* (read))
	(if (or (< *n* n_min) (> *n* n_max))
		(progn (print "Bad input!")
				 err)
		*n*))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load the number of streets
;; Input: none
;; Output: the number of streets or err if the number is not in the interval
;;			  <0;100>. The upper part is optional.
;; TODO: The variable *m* should not be global. Local variable is enough
(defun load_num_of_streets()
	(setf *m* (read))
	(if (or (< *m* m_min) (> *m* m_max))
		(progn 	(print "Bad streets input!")
			    	err)
		*m*))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load streets
;; Loads all streets: start_node end_node length.
;; Input: remaining number of streets
;; output: ok or err
(defun load_streets (remain_str)
	(if (= remain_str 0)
		ok
		;; n is source node, m is destination node
		(let (n m)	(progn	(setf n (read))
									(setf m (read))					
									(setf (aref *adjacency_matrix* n m) (read))
									(load_streets (- remain_str 1))))))

(print (assert_ (load_streets (load_num_of_streets)) ok "Test: Number of streets is not same!"))
(print (assert_ (aref *adjacency_matrix* 0 0) 5 "Test: Adjacency matrix on [0:0] is not 5"))
;(print (load_num_of_node))
;(print (load_num_of_streets))

