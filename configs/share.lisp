;;; -*- Mode: Lisp -*-

(in-package #:cl-user)

(setf *compile-verbose* nil
      *compile-print* nil)

(defun ~ (path)
  (#+cmu truename #-cmu or
         (merge-pathnames path (user-homedir-pathname))))

#-asdf
(progn
  #+(or clisp cmu lispworks scl allegro )
  (load (~ "lisp/site/asdf/asdf.lisp"))
  #+(or sbcl ccl ecl abcl)
  (require :asdf))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
	,(~ "lisp/systems/"))
      asdf:*compile-file-failure-behaviour* :warn)

(asdf:oos 'asdf:load-op '#:asdf-binary-locations
          #-abcl :verbose #-abcl nil)

(setf asdf:*centralize-lisp-binaries* t
      asdf:*default-toplevel-directory*
      (~ "lisp/fasls/"))

;;; Useful functions
#-lispworks
(progn
  (defun :asd (system)
    (format t "Loading system: ~a~%" system)
    (asdf:oos 'asdf:load-op system :verbose nil))

  (defun :safe-code ()
    (proclaim '(optimize (speed 0) (safety 3) (debug 3))))

  (defun :fast-code ()
    (proclaim '(optimize (speed 3) (safety 0) (debug 1))))

  (defun :normal-code ()
    (proclaim '(optimize (speed 1) (safety 1) (debug 1)))))

;;;

(defun eval-code (code)
  (let (result)
    (values (with-output-to-string (*standard-output*)
              (setf result (multiple-value-list
                            (handler-case (eval (read-from-string code))
                              (error (error) error)))))
            result)))

(defun format-error (stream object &rest rest)
  (declare (ignore rest))
  (format stream (if (typep object 'error) "~a" "~s")
          object))

(defun test-code (code)
  (multiple-value-bind (output result) (eval-code code)
   (format t "~a - ~a:~%~a => ~{~/format-error/~^; ~}~%Output:~%\"~a\"~%~%"
           (lisp-implementation-type) (lisp-implementation-version)
           code result output)))
