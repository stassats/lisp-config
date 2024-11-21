;;; -*- Mode: Lisp -*-

(in-package #:cl-user)

(setf *compile-verbose* nil
      *compile-print* nil
      *load-verbose* nil
      *load-print* nil)

(defun ~ (path)
  (#+cmu truename #-cmu or
   (merge-pathnames path (user-homedir-pathname))))

#-asdf
(progn
  #+(or clisp lispworks scl allegro)
  (load (~ "lisp/site/asdf/asdf.lisp"))
  #+(or ccl sbcl abcl cmu ecl mkcl)
  (require :asdf))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
        ,(~ "lisp/systems/"))
      asdf:*compile-file-failure-behaviour* :warn
      asdf::*uninteresting-conditions* nil)

#+asdf3
(setf asdf:*warnings-file-type* nil)

(defvar *fasl-dir*
  (ensure-directories-exist
   (~ "lisp/fasls/")))

#+asdf3
(setf uiop/configuration:*user-cache*
      `(,*fasl-dir* :implementation))
#-asdf3
(asdf:enable-asdf-binary-locations-compatibility
 :centralize-lisp-binaries t
 :default-toplevel-directory *fasl-dir*)

;;; Useful functions
#-lispworks
(progn
  (defun :l (&rest systems)
    (loop for system in systems
          do
          (format t "Loading system: ~a~%" system)
          (asdf:oos 'asdf:load-op system :verbose nil)))
  (defun dbg (tag &rest results)
    (declare (dynamic-extent results))
    (let ((*print-right-margin* 155)
          (*print-readably* nil))
     (format *debug-io* "~&~@[~a ~]~:[; no values~;~:*~{~s~^, ~}~]~%" tag results))
    (finish-output *debug-io*)
    (apply #'values results))
  (defmacro :dbg (x &optional tag)
    `(multiple-value-call #'dbg ,tag ,x))
  #+sbcl
  (defun dbgs (tag &rest results)
    (declare (dynamic-extent results))
    (let ((*print-right-margin* 155))
     (format sb-sys:*stdout* "~&~@[~a ~]~:[; no values~;~:*~{~s~^, ~}~]~%" tag results))
    (finish-output sb-sys:*stdout*)
    (apply #'values results))
  #+sbcl
  (defmacro :dbgs (x &optional tag)
    `(multiple-value-call #'dbgs ,tag ,x))

  (defun :preload ()
    (mapcar :l '(closer-mop cl-ppcre cxml cxml-stp closure-html
                   drakma named-readtables iterate cffi trivial-garbage bordeaux-threads
                   chipz trivial-gray-streams conium prepl osicat command-line-arguments
                   cl-pdf cl-typesetting postmodern alexandria csv-parser ironclad cl-json
                   ht-simple-ajax hunchentoot local-time vecto simple-date cl-who cl-jpeg
                   salza2 qt iolib))))

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

(let ((private-file (merge-pathnames "private" #.*load-pathname*)))
  (load private-file :if-does-not-exist nil))
