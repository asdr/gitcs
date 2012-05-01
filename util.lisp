
(in-package :gitcs)

(defun select-items (alist &key test key)
	   (let ((el (funcall key (car alist))))
	     (if (null alist)
		 nil
		 (if (funcall test el)
		     (cons (car alist)
			   (select-items (cdr alist) :test test :key key))
		     (select-items (cdr alist) :test test :key key)))))

