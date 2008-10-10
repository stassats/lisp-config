;;; -*- Mode: Lisp -*-

(setf
 (ext:search-list "target:") '("/usr/share/cmucl/src/")
 *compile-verbose* nil
 *compile-print* nil
 ext:*gc-verbose* nil)

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))

(in-package #:asdf)

(defun module-provide-asdf (name)
  (handler-bind ((style-warning #'muffle-warning))
    (let* ((*verbose-out* (make-broadcast-stream))
           (name (string-downcase name))
           (system (asdf:find-system name nil)))
      (when system
        (asdf:operate 'asdf:load-op name)
        t))))

(nconc ext:*module-provider-functions* '(module-provide-asdf))
