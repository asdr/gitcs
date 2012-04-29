#| -----------------------------------------------------------------
#| file: git.lisp
#| author: sg
#| created: April 30, 2012
#|
#| provides git apis
---------------------------------------------------- |#|#|#|#|#|#
(in-package :common-lisp-user)

(defpackage :gitcs.git
  (:use #:cl #:gitcs.cmd)
  (:export #:status))

(in-package :gitcs.git)

(defun status (&optional parameters directory)
  (run-git-command "status" parameters directory))

