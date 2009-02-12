;;; -*- Mode: Lisp -*-

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

;;; Useful functions

(defun asdl (system)
  (asdf:oos 'asdf:load-op system))

(defun safe-code ()
  (proclaim '(optimize (speed 0) (safety 3) (debug 3))))

(defun fast-code ()
  (proclaim '(optimize (speed 3) (safety 0) (debug 1))))

(defun normal-code ()
  (proclaim '(optimize (speed 1) (safety 1) (debug 1))))

(defun ~ (path)
  (truename (merge-pathnames path (user-homedir-pathname))))
