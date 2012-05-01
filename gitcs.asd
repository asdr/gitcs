;;;; gitcs.asd

(asdf:defsystem #:gitcs
  :serial t
  :components ((:file "package")
	       (:file "util")
               (:file "gitcs")
	       (:file "settings")
	       (:file "cmd")
	       (:file "git")))

