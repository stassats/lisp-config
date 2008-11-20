;;; -*- Mode: Lisp -*-

(declaim (optimize (debug 3) (safety 3)))

#-asdf
(progn
  #+(or clisp cmu lispworks scl)
  (load (merge-pathnames "lisp/site/asdf/asdf" (user-homedir-pathname)))
  #+(or sbcl ccl acl ecl)
  (require :asdf))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
	,(merge-pathnames "lisp/systems/" (user-homedir-pathname))))

(asdf:oos 'asdf:load-op '#:asdf-binary-locations :verbose nil)

(setf asdf:*centralize-lisp-binaries* t
      asdf:*default-toplevel-directory*
      (merge-pathnames "lisp/fasls/"
                       #-scl (user-homedir-pathname)
                       #+scl "/home/stas/"))

(defun asdl (system)
  (asdf:oos 'asdf:load-op system))
