#| -----------------------------------------------------------------
#| file: command-runner.lisp
#| author: sg
#| created: April 29, 2012
#|
#| purpose of code is running system executables from common lisp.
#| Note: works well only with sbcl
---------------------------------------------------- |#|#|#|#|#|#|#


(defparameter *current-directory* (sb-posix:getcwd))


;; Author: Kevin M. Rosenberg
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
    
(defmacro with-command-run ((stream &key program args working-directory) &body body)
  (let ((gprocess (gensym))
	(gcwd (gensym))
	(pprog (gensym))
	(pargs (gensym))
	(pwd (gensym)))
    `(let ((,gcwd (sb-posix:getcwd))
	   (,pprog ,program)
	   (,pargs ,args)
	   (,pwd ,working-directory))
       (cwd ,pwd)
       (let ((,gprocess 
	       (sb-ext:run-program ,pprog ,pargs
				   :output :stream 
				   :error :output
				   :wait t)))
	 (let ((,stream (sb-ext:process-output ,gprocess)))
	   ,@body)
	 (cwd ,gcwd)
	 (sb-ext:process-close ,gprocess)
	 (sb-ext:process-exit-code ,gprocess)))))

(defun run-git-command (command &optional parameters (directory *current-directory*))
  (let ((output-string (make-array '(0) :element-type 'base-char :fill-pointer 0 :adjustable t)))
    (with-command-run (stream
		       :program "/usr/bin/git" ;;hardcoded olmasin
		       :args (cons command (or (and (null parameters)
						    parameters)
					       (and (listp parameters)
						     parameters)))
		       :working-directory directory)
      (with-output-to-string (s output-string)
	(loop for line = (read-line stream nil nil)
	      while line
	      do (format s "~A~%" line))))
    output-string))