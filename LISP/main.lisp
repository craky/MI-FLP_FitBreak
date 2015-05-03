; author: krakovoj@fit.cvut.cz
; Bellman - Ford algorithm for solution FitBreak problem
(defconstant n_max 100); maximum number of nodes
(defconstant n_min 2)  ; minimum number of nodes
(defconstant m_max 100); maximum of streets
(defconstant m_min 0)  ; minimum of streets
(defconstant err  -999); error value
(defconstant ok  0)	  ; "no problem" value
(defconstant inf 9999) ; infinity (distance)
(defconstant no_pre -2); no predecessor
(defparameter *n* NIL) ; number of nodes
(defparameter *m* NIL) ; number of streets
(setf *adjacency_matrix* (make-array (list n_max n_max):initial-element 0))
(setf *distance* (make-array (list n_max):initial-element inf))
(setf *predecessor* (make-array (list n_max):initial-element no_pre)) 

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
;; loads streets and theirs distances
;; Loads all streets: start_node end_node length.
;; Input: remaining number of streets
;; output: ok or err
(defun load_streets (remain_str)
	(if (= remain_str 0)
		ok
		;; n is source node, m is destination node, d is distance
		(let (n m d)	(progn	(setf n (read))
										(setf m (read))
										(setf d (read))
										(setf (aref *adjacency_matrix* n m) d)
										(setf (aref *adjacency_matrix* m n) d)
										(load_streets (- remain_str 1))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Check the distance
;; If shorter distance was found, set it.
(defun check_distance (y k)
	(if (< (+ (aref *distance* y) (aref *adjacency_matrix* y k)) (aref *distance* k))
		(progn (setf (aref *distance* k) (+ (aref *distance* y) (aref *adjacency_matrix* y k)))
				 (setf (aref *predecessor* k) y))
		ok))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; k nodes
;; It is simulation of third loop in three nested loops
(defun k_nodes (y k)
	(if (> (aref *adjacency_matrix* y k) 0)
		(check_distance y k)
		ok))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; j nodes
;; It is simulation of second loop in three nested loops
(defun j_nodes (y)
	(if (eq y 0)
		ok
		(progn (k_nodes y *n*)
			    (j_nodes (- y 1)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; through all nodes
;; will do cycle through all nodes
;; It is simulation of first loop in three nested loops
(defun through_all_nodes (x)
	(if (eq x 0)
		ok
		(progn (j_nodes *n*)
				 (through_all_nodes (- x 1)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Bellman - Ford algorithm
(defun bellman-ford()
	;; set distance of first node 0
	(setf (aref *distance* 0) 0)
	(through_all_nodes *n*)
	ok
	)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; distance
;; Computes distance of two nodes
(defun dist (dest source distance)
	(if (eq dest 0)
		distance
		(dist source (aref *predecessor* dest) (+ (aref *adjacency_matrix* dest source) distance))))

(setf *n* 10)
(print (assert_ (load_streets (load_num_of_streets)) ok "Test: Number of streets is not same!"))
(print (assert_ (aref *adjacency_matrix* 3 2) 5 "Test: Adjacency matrix on [3:2] is not 5."))
(print (assert_ (through_all_nodes *n*) ok "Test: through_all_nodes does not return ok."))
(print (assert_ (j_nodes *n*) ok "Test: j_nodes does not return ok."))
(print (assert_ (bellman-ford) ok "Test: bellman-ford does not return ok."))

(setf *n* 3)
(print (assert_ *n* 3 "Test: *n* is not 3."))
(setf (aref *predecessor* 0) no_pre)
(setf (aref *predecessor* 1) no_pre)
(setf (aref *predecessor* 2) 0)
(setf (aref *adjacency_matrix* 0 0) 0)
(setf (aref *adjacency_matrix* 0 1) 2)
(setf (aref *adjacency_matrix* 0 2) 4)
(setf (aref *adjacency_matrix* 1 0) 2)
(setf (aref *adjacency_matrix* 1 1) 0)
(setf (aref *adjacency_matrix* 1 2) 6)
(setf (aref *adjacency_matrix* 2 0) 4)
(setf (aref *adjacency_matrix* 2 1) 6)
(setf (aref *adjacency_matrix* 2 2) 0)
(print (assert_ (dist 2 0 0) 4 "Test: Example distance 2 and 0 is not 4"))
;(print (load_num_of_node))
;(print (load_num_of_streets))

