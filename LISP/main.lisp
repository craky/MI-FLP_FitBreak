; author: krakovoj@fit.cvut.c
; Bellman - Ford algorithm for solution FitBreak problem
(defconstant n_max 100); maximum number of nodes
(defparameter *n* NIL) ; number of nodes 

(defun load_stdin () 
	(setf *n* (read))
	(let ((s (read)))
		(print s)))

(load_stdin)
(print *n*)

