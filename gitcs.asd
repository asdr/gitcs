;;;; gitcs.asd

(asdf:defsystem #:gitcs
  :serial t
  :components ((:file "package")
               (:file "gitcs")
	       (:file "cmd")
	       (:file "git")))

