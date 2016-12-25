;;; -*- Mode: Lisp -*-

(setf *compile-verbose* nil
      *compile-print* nil
      *load-verbose* nil
      *load-print* nil)

(load (merge-pathnames "lisp/configs/share.lisp" (user-homedir-pathname)))
