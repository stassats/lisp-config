;;; -*- Mode: Lisp -*-

(defun ~ (path)
  (#+cmu truename #-cmu or
         (merge-pathnames path (user-homedir-pathname))))

#-asdf
(progn
  #+(or clisp cmu lispworks scl)
  (load (~ "lisp/site/asdf/asdf"))
  #+(or sbcl ccl acl ecl)
  (require :asdf))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
	,(~ "lisp/systems/")))

(asdf:oos 'asdf:load-op '#:asdf-binary-locations :verbose nil)

(setf asdf:*centralize-lisp-binaries* t
      asdf:*default-toplevel-directory*
      (~ "lisp/fasls/"))

;;; Useful functions

(defun asdl (system)
  (asdf:oos 'asdf:load-op system))

(defun safe-code ()
  (proclaim '(optimize (speed 0) (safety 3) (debug 3))))

(defun fast-code ()
  (proclaim '(optimize (speed 3) (safety 0) (debug 1))))

(defun normal-code ()
  (proclaim '(optimize (speed 1) (safety 1) (debug 1))))

