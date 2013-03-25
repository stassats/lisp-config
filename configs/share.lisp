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
  #+(or ccl sbcl ecl abcl cmu)
  (load (~ "lisp/site/asdf/asdf.lisp")))

(setf asdf:*central-registry*
      `(*default-pathname-defaults*
        ,(~ "lisp/systems/"))
      asdf:*compile-file-failure-behaviour* :warn
      asdf::*uninteresting-conditions* nil)

#+asdf3
(setf asdf:*warnings-file-type* nil)

(defvar *fasl-dir*
  (ensure-directories-exist
   (if (equal (asdf:hostname) "debian")
       "/tmp/fasls/"
       (~ "lisp/fasls/"))))

#+asdf3
(setf asdf/configuration::*user-cache*
      `(,*fasl-dir* :implementation))
#-asdf3
(asdf:enable-asdf-binary-locations-compatibility
 :centralize-lisp-binaries t
 :default-toplevel-directory *fasl-dir*)

;;; Useful functions
#-lispworks
(progn
  (defun :asd (system)
    (format t "Loading system: ~a~%" system)
    (and (asdf:oos 'asdf:load-op system :verbose nil)
         t))

  (defmacro :dbg (x &optional tag)
    `(let ((results (multiple-value-list ,x)))
       (format *debug-io* "~&~@[~a ~]~:[; no values~;~:*~{~s~^, ~}~]~%" ,tag results)
       (finish-output *debug-io*)
       (values-list results)))

  (defun :preload ()
    (mapcar :asd '(closer-mop cl-ppcre cxml cxml-stp closure-html
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
