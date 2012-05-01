#| -----------------------------------------------------------------
#| file: cmd.lisp
#| author: sg
#| created: April 29, 2012
#|
#| purpose of code is running system executables from common lisp.
#| Note: works well only with sbcl
---------------------------------------------------- |#|#|#|#|#|#|#
(in-package :common-lisp-user)

(defpackage :gitcs.cmd
  (:use #:cl #:gitcs)
  (:export #:with-command-run
	   #:with-in-directory
	   #:cwd
	   #:run-git-command
	   #:run-multiple-git-commands))

(in-package :gitcs.cmd)

;; ChangeWorkingDirectory
;; author: Kevin M. Rosenberg
;; taken from: http://files.b9.com/lboot/utils.lisp
(defun cwd (&optional dir)
  "Change directory and set default pathname"
  (cond
    ((not (null dir))
     (when (and (typep dir 'logical-pathname)
		(translate-logical-pathname dir))
       (setq dir (translate-logical-pathname dir)))
     (when (stringp dir)
       (setq dir (parse-namestring dir)))
     (sb-posix:chdir dir)
     (setq cl:*default-pathname-defaults* dir))
    (t
     (let ((dir
	     (sb-unix:posix-getcwd)))
       (when (stringp dir)
	 (setq dir (parse-namestring dir)))
       dir))))
    
(defmacro with-command-run ((stream &key program args directory) &body body)
  (let ((gprocess (gensym))
	(gprog (gensym))
	(gargs (gensym)))
    (if (not (null directory))
	(let ((gwd (gensym)))
	  `(let ((,gwd ,directory))
	     (with-in-directory (,gwd)
	       (let ((,gprog ,program)
		     (,gargs ,args))
		 (let ((,gprocess 
			 (sb-ext:run-program ,gprog ,gargs
				       :output :stream 
				       :error :output
				       :wait t)))
		   (let ((,stream (sb-ext:process-output ,gprocess)))
		     ,@body)	 
		   (sb-ext:process-close ,gprocess)
		   (sb-ext:process-exit-code ,gprocess))))))
	`(let ((,gprog ,program)
	       (,gargs ,args))
	   (let ((,gprocess 
		   (sb-ext:run-program ,gprog ,gargs
				       :output :stream 
				       :error :output
				       :wait t)))
	     (let ((,stream (sb-ext:process-output ,gprocess)))
	       ,@body)	 
	     (sb-ext:process-close ,gprocess)
	     (sb-ext:process-exit-code ,gprocess))))))
	     
  
(defmacro with-in-directory ((&optional directory) &body body)
  (let ((gcwd (gensym))
	(gwd (gensym)))
    `(let ((,gcwd (sb-posix:getcwd))
	   (,gwd ,directory))
       (cwd ,gwd)
       ,@body
       (cwd ,gcwd))))
       

(defun run-git-command (command &optional parameters (directory gitcs:*current-directory*))
  (let ((output-string (make-array '(0) :element-type 'base-char :fill-pointer 0 :adjustable t))) 
    (with-command-run (stream
		       :program gitcs:*git-binary-location*
		       :args (cons command (or (and (null parameters)
						    parameters)
					       (and (listp parameters)
						    parameters)))
		       :directory directory)
    (with-output-to-string (s output-string)
      (loop for line = (read-line stream nil nil)
	      while line
	    do (format s "~A~%" line))))
    output-string))  
  
(defmacro run-multiple-git-commands (&body commands)
  (let ((dir (cadr (find :directory commands :key #'car :test #'eql)))
	(pure-commands (select-items commands 
				:key #'car 
				:test #'(lambda(n)
					  (not (eql n :directory)))))
	(gdir (gensym))
	(gout (gensym))
	(gstream (gensym))
	(gstream2 (gensym)))
    `(let ((,gout (make-array '(0) :element-type 'base-char :fill-pointer 0 :adjustable t))
	   (,gdir ,dir))
       (with-in-directory (,gdir)
	 ,@(mapcar #'(lambda(cmd)
		       `(with-command-run (,gstream
					   :program gitcs:*git-binary-location*
					   :args ',cmd)
			  (with-output-to-string (,gstream2 ,gout)
			    (loop for line = (read-line ,gstream nil nil)
				  while line
				  do (format ,gstream2 "~A~%" line)))))
		   pure-commands))
       ,gout)))
