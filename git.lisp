#| -----------------------------------------------------------------
#| file: git.lisp
#| author: sg
#| created: April 30, 2012
#|
#| provides git apis
---------------------------------------------------- |#|#|#|#|#|#
(in-package :common-lisp-user)

(defpackage :gitcs.git
  (:use #:gitcs #:gitcs.cmd)
  (:export #:status
	   #:add 
	   #:commit
	   #:reset
	   #:checkout
	   #:pull
	   #:push
	   #:revert
	   #:bisect
	   #:diff
	   #:log
	   #:reflog
	   #:config
	   #:init
	   #:clone
	   #:rm
	   #:branch
	   #:merge
	   #:stash
	   #:tag
	   #:fetch
	   #:remote
	   #:show
	   #:ls-tree))

(in-package :gitcs.git)


		     
      

(cl:defun status (cl:&optional parameters cl:&key directory)
  (run-git-command "status" parameters directory))

(cl:defun add (cl:&optional parameters cl:&key directory)
  (run-git-command "add" parameters directory))

(cl:defun commit (cl:&optional parameters cl:&key directory)
  (run-git-command "commit" parameters directory))

(cl:defun reset (cl:&optional parameters cl:&key directory)
  (run-git-command "reset" parameters directory))

(cl:defun checkout (cl:&optional parameters cl:&key directory)
  (run-git-command "checkout" parameters directory))

(cl:defun pull (cl:&optional parameters cl:&key directory)
  (run-git-command "pull" parameters directory))

(cl:defun push (cl:&optional parameters cl:&key directory)
  (run-git-command "push" parameters directory))

(cl:defun revert (cl:&optional parameters cl:&key directory)
  (run-git-command "revert" parameters directory))

(cl:defun bisect (cl:&optional parameters cl:&key directory)
  (run-git-command "bisect" parameters directory))

(cl:defun diff (cl:&optional parameters cl:&key directory)
  (run-git-command "diff" parameters directory))

(cl:defun log (cl:&optional parameters cl:&key directory)
  (run-git-command "log" parameters directory))

(cl:defun reflog (cl:&optional parameters cl:&key directory)
  (run-git-command "reflog" parameters directory))

(cl:defun config (cl:&optional parameters cl:&key directory)
  (run-git-command "config" parameters directory))

(cl:defun init (cl:&optional parameters cl:&key directory)
  (run-git-command "init" parameters directory))

(cl:defun clone (cl:&optional parameters cl:&key directory)
  (run-git-command "clone" parameters directory))

(cl:defun rm (cl:&optional parameters cl:&key directory)
  (run-git-command "rm" parameters directory))

(cl:defun branch (cl:&optional parameters cl:&key directory)
  (run-git-command "branch" parameters directory))

(cl:defun merge (cl:&optional parameters cl:&key directory)
  (run-git-command "merge" parameters directory))

(cl:defun stash (cl:&optional parameters cl:&key directory)
  (run-git-command "stash" parameters directory))

(cl:defun tag (cl:&optional parameters cl:&key directory)
  (run-git-command "tag" parameters directory))

(cl:defun fetch (cl:&optional parameters cl:&key directory)
  (run-git-command "fetch" parameters directory))

(cl:defun remote (cl:&optional parameters cl:&key directory)
  (run-git-command "remote" parameters directory))

(cl:defun show (cl:&optional parameters cl:&key directory)
  (run-git-command "show" parameters directory))

(cl:defun ls-tree (cl:&optional parameters cl:&key directory)
  (run-git-command "ls-tree" parameters directory))

(cl:defun gc (cl:&optional parameters cl:&key directory)
  (run-git-command "gc" parameters directory))
